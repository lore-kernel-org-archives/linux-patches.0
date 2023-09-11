Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088DF1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFA3C433C8;
	Mon, 11 Sep 2023 14:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442339;
	bh=61D1kthUek0IR9XnPkew+uROd+QNdjlkoqdNRbO3uS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgDwPqilJn3nCqwuVbCDWXEPt9FKdfMapKNARR6idGjtTy/HPJBCVTRHHvFXZBN47
	 iNqg0//7DVHKVKGQ9KqA7G8uX1j2mJcmL/UPQZt9CSrllIWrXRqLpA2OU1Z+iW4zY3
	 HxGg0jwU+6oVV34m+CkWSyCdlFHVzD1ylKBam86w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.5 702/739] r8169: fix ASPM-related issues on a number of systems with NIC version from RTL8168h
Date: Mon, 11 Sep 2023 15:48:21 +0200
Message-ID: <20230911134710.696285694@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

commit 90ca51e8c654699b672ba61aeaa418dfb3252e5e upstream.

This effectively reverts 4b5f82f6aaef. On a number of systems ASPM L1
causes tx timeouts with RTL8168h, see referenced bug report.

Fixes: 4b5f82f6aaef ("r8169: enable ASPM L1/L1.1 from RTL8168h")
Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217814
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5239,13 +5239,9 @@ static int rtl_init_one(struct pci_dev *
 
 	/* Disable ASPM L1 as that cause random device stop working
 	 * problems as well as full system hangs for some PCIe devices users.
-	 * Chips from RTL8168h partially have issues with L1.2, but seem
-	 * to work fine with L1 and L1.1.
 	 */
 	if (rtl_aspm_is_safe(tp))
 		rc = 0;
-	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
-		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
 	else
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
 	tp->aspm_manageable = !rc;


