Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305893307D;
	Fri, 24 Nov 2023 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFknQN8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857F0C433C7;
	Fri, 24 Nov 2023 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852809;
	bh=bhSYyZZxywwVW9XkQLMuU0yyuYzlRvyohUyrcjtivgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFknQN8qoTcsMhDIXjR7wGCB6bJn931Czriou8YTYiNu7asd0SfxjsyS4e/DJLqZX
	 0YY55KPwQoIX7j/84OUPeqLlEYPq/LI49XbG3DLOXturdudVmMzH6F8C6Oc9ux56yo
	 9rjnTDs1An7LBWsc90/a0uYtom8odHR1X+razFtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 114/193] PCI/ASPM: Fix L1 substate handling in aspm_attr_store_common()
Date: Fri, 24 Nov 2023 17:54:01 +0000
Message-ID: <20231124171951.796414667@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1250,6 +1250,8 @@ static ssize_t aspm_attr_store_common(st
 			link->aspm_disable &= ~ASPM_STATE_L1;
 	} else {
 		link->aspm_disable |= state;
+		if (state & ASPM_STATE_L1)
+			link->aspm_disable |= ASPM_STATE_L1SS;
 	}
 
 	pcie_config_aspm_link(link, policy_to_aspm_state(link));


