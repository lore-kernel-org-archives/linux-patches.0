Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868FF267386;
	Tue, 26 Aug 2025 11:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208279; cv=none; b=h0mq8d84XSMmO96bB2hHndUgQoReqULY61TRqrdmSF1Nld/btZMS3tJRM3kJY7wcA6xbrjGkEEhM7TcQK00fJ/ily6DUPR0rlUGMNiYPC/HoSxQ+Na/G8ZH+zbrAwYu/jZXVZgJvTUENIHH2xdBul+mmIBpcn19wldN6gva1t58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208279; c=relaxed/simple;
	bh=6uSE7aGo0lY/NsHmpC1G/eK5dF4He2PqAByld7GDUnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndc7XIfp2h9xhCCpDGSo+VZzi5PmhiXklfqc66o7XRYkJ+aAfwQGmnB+9gbl9OaeKpZ3nnRMM4UojMh9Rvfqat8dhlQxu8Ob181/F0/mY/HC4d8xJ8cFUIfJjxeN+TEezDgmWnYcWQEavin/PUR5Go6ovSGcqHOKmNa37+ZaG4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7tGftZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7tGftZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182ECC4CEF1;
	Tue, 26 Aug 2025 11:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208279;
	bh=6uSE7aGo0lY/NsHmpC1G/eK5dF4He2PqAByld7GDUnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7tGftZujio7R4VBI1vWtXVodM7Asxkvm/kdWeDktU23hUO9gFzFPoPJT8r6/9XKV
	 nTKQ6DOaTGT459HgY9qOVHCcbeDCiy6+aPYZJ6u1GRoMo93xOl9DxhavD7RTDui7tO
	 lkZ++7rOs+v5j00EGaQIg0IUHtJdidqohmzs0RCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archana Patni <archana.patni@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 051/322] scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers
Date: Tue, 26 Aug 2025 13:07:46 +0200
Message-ID: <20250826110916.660742961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Archana Patni <archana.patni@intel.com>

commit 4428ddea832cfdb63e476eb2e5c8feb5d36057fe upstream.

UFSHCD core disables the UIC completion interrupt when issuing UIC
hibernation commands, and re-enables it afterwards if it was enabled to
start with, refer ufshcd_uic_pwr_ctrl(). For Intel MTL-like host
controllers, accessing the register to re-enable the interrupt disrupts
the state transition.

Use hibern8_notify variant operation to disable the interrupt during the
entire hibernation, thereby preventing the disruption.

Fixes: 4049f7acef3e ("scsi: ufs: ufs-pci: Add support for Intel MTL")
Cc: stable@vger.kernel.org
Signed-off-by: Archana Patni <archana.patni@intel.com>
Link: https://lore.kernel.org/r/20250723165856.145750-2-adrian.hunter@intel.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufshcd-pci.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -216,6 +216,32 @@ out:
 	return ret;
 }
 
+static void ufs_intel_ctrl_uic_compl(struct ufs_hba *hba, bool enable)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	if (enable)
+		set |= UIC_COMMAND_COMPL;
+	else
+		set &= ~UIC_COMMAND_COMPL;
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
+static void ufs_intel_mtl_h8_notify(struct ufs_hba *hba,
+				    enum uic_cmd_dme cmd,
+				    enum ufs_notify_change_status status)
+{
+	/*
+	 * Disable UIC COMPL INTR to prevent access to UFSHCI after
+	 * checking HCS.UPMCRS
+	 */
+	if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER)
+		ufs_intel_ctrl_uic_compl(hba, false);
+
+	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT)
+		ufs_intel_ctrl_uic_compl(hba, true);
+}
+
 #define INTEL_ACTIVELTR		0x804
 #define INTEL_IDLELTR		0x808
 
@@ -533,6 +559,7 @@ static struct ufs_hba_variant_ops ufs_in
 	.init			= ufs_intel_mtl_init,
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
+	.hibern8_notify		= ufs_intel_mtl_h8_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,


