Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E514612CDA5;
	Tue, 26 Aug 2025 13:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213478; cv=none; b=OblJ+xvML2LypRBm/hY12CrQAhYweMCvk82AMskA9D9fHOETRAMWSyDoGZIBUVt2bFSnTihEkmaV1K/SMZkMo3c06rFkfQAe+ioi5jYQi7jczLxzrx19dc6wKyoaAtN6qaQFSue4wl5hhl+TIygs5Vppl/6Q+bujx0VpQvpj+dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213478; c=relaxed/simple;
	bh=eN/KaEspI7bIe9UCfam5BQOyULhQ5O3EfwSJeqPRpVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBpFsdEsJ11bGLIjRkaZQq/P3m2auhMDhcYq4NEmtL9DFMLr7ZFTMwJHepJAF0CkaanAtOfozvRWmpy+4/3WK2XKKzYOSdcNuMkfFVseWPSn2QtRuqgbli/5w51T3WZDuhGhHt6BMqaPCIrMFaYBPNfJDTAB9D+FAoAEH8xyewM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmGsTOZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmGsTOZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F579C4CEF1;
	Tue, 26 Aug 2025 13:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213477;
	bh=eN/KaEspI7bIe9UCfam5BQOyULhQ5O3EfwSJeqPRpVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmGsTOZbbkKHArbkfxz4gTFeGZwlKg7nMkL6N1goS+ekW4XR1S7U4FdJXBXGEnWuh
	 2plpmxZjkFMNWTHVr1WscNdIWVAsy8R2nEY0uoUB10g7YbHz2OF5x2utGCCX02sCZ/
	 NdPJKwyt68CpUdHTE9eTvckvuMwv3WVPVkJgSLo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archana Patni <archana.patni@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 362/587] scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers
Date: Tue, 26 Aug 2025 13:08:31 +0200
Message-ID: <20250826111002.120112693@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -213,6 +213,32 @@ out:
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
 
@@ -487,6 +513,7 @@ static struct ufs_hba_variant_ops ufs_in
 	.init			= ufs_intel_mtl_init,
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
+	.hibern8_notify		= ufs_intel_mtl_h8_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,


