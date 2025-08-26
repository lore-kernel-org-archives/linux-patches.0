Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17422B2DA;
	Tue, 26 Aug 2025 13:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214925; cv=none; b=dPerZKrbG2XQggutLYntbbbeacCMpJZ2kPLUaXdrwD/J1EmfL3rGHsr/fqUJvNc8g7GqXPXGT4gs7Z8eKhaf+Sn04JZAsmi36OvYnXPeRpfoGJpMzJY8SrmlDHxXzPfTE7517C+zzcK+WSDJsMuqFaCRykhFJidYXRdVPNtYmM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214925; c=relaxed/simple;
	bh=8qJUt9KzKYPDMOqFms0NDBpO+7NVhy0AfoUu9AhzZ7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQXhgYREQY++8IvIc1r0wEXWNta6yh9VuvfNeKypZaXzwx+VmznfJpjI0N7+sw7+T09ncqXZrzYub9z1Fq0qGmfox5sy+TAQX1S9NDT8UzH+pP0NoU8FfLisrEUJZ9Hf81aIr5CDgvJDgM2iq1ITztpwDjrhK7Wu76Is8rLdQOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWbHe52F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWbHe52F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCD0C4CEF1;
	Tue, 26 Aug 2025 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214924;
	bh=8qJUt9KzKYPDMOqFms0NDBpO+7NVhy0AfoUu9AhzZ7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWbHe52FjEuqrjjnU+UMBtW0DV+pS2UqxGQHm7Pb5gGkb7k3Ery54eY57XclBRUe+
	 kjDl8OWMLDT8Gal4sBxUa/cdLGnwz8R/WZNv8hSNHqIC4VqU076uHX0sd4yKK3tRuK
	 9shsyPcnkdSLKx2mS9vU5tKyTfNEvmoDLSvCSTZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archana Patni <archana.patni@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 290/482] scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers
Date: Tue, 26 Aug 2025 13:09:03 +0200
Message-ID: <20250826110937.955400190@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


