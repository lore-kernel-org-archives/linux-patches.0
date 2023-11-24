Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F229D28DC3;
	Fri, 24 Nov 2023 18:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7vrAWa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED23C433C9;
	Fri, 24 Nov 2023 18:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851135;
	bh=zxiD666jtsuuj9B1CkVVTvp3NGqFTzgnBU7UjBZBCRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7vrAWa9+4aNRQTlqv84KeBEgiINfp5LJOVG8HjtAIPT7L49TOPeu4gZi6RmBGDGk
	 uhjPidXxbbMpGGu6thzHW4jJy3pxIg3CfEcwUYyE8O/HsTxkgPmCzE+NMJsUxt7kYb
	 FzG7fFTvY1B/TjfCQGzcPzcVltxESVja+6hAiRbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.5 303/491] PCI/ASPM: Fix L1 substate handling in aspm_attr_store_common()
Date: Fri, 24 Nov 2023 17:48:59 +0000
Message-ID: <20231124172033.681442194@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 8e37372ad0bea4c9b4712d9943f6ae96cff9491f upstream.

aspm_attr_store_common(), which handles sysfs control of ASPM, has the same
problem as fb097dcd5a28 ("PCI/ASPM: Disable only ASPM_STATE_L1 when driver
disables L1"): disabling L1 adds only ASPM_L1 (but not any of the L1.x
substates) to the "aspm_disable" mask.

Enabling one substate, e.g., L1.1, via sysfs removes ASPM_L1 from the
disable mask.  Since disabling L1 via sysfs doesn't add any of the
substates to the disable mask, enabling L1.1 actually enables *all* the
substates.

In this scenario:

  - Write 0 to "l1_aspm" to disable L1
  - Write 1 to "l1_1_aspm" to enable L1.1

the intention is to disable L1 and all L1.x substates, then enable just
L1.1, but in fact, *all* L1.x substates are enabled.

Fix this by explicitly disabling all the L1.x substates when disabling L1.

Fixes: 72ea91afbfb0 ("PCI/ASPM: Add sysfs attributes for controlling ASPM link states")
Link: https://lore.kernel.org/r/6ba7dd79-9cfe-4ed0-a002-d99cb842f361@gmail.com
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aspm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1248,6 +1248,8 @@ static ssize_t aspm_attr_store_common(st
 			link->aspm_disable &= ~ASPM_STATE_L1;
 	} else {
 		link->aspm_disable |= state;
+		if (state & ASPM_STATE_L1)
+			link->aspm_disable |= ASPM_STATE_L1SS;
 	}
 
 	pcie_config_aspm_link(link, policy_to_aspm_state(link));


