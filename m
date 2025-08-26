Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341661F560B;
	Tue, 26 Aug 2025 11:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208282; cv=none; b=JTput+LB577DksC22lphEkFWvpEt10M5VlONm3UO8v4lIwZyVzy/NapmQq9Km1vgKs/rXjP7SGqd4rJHJqFWlX2bXC2CrdcPnSD0+2uwBYluY5WEJSsCXyJjs0Wv94cKgQz0KdFQ3pJlOArOSxUZh/EpgKDUrkBKihz2b6VuvC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208282; c=relaxed/simple;
	bh=4oHaJp5+hzRQFMECK3TYCfFfp5vC7w/3t4EFOpiahHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfT6sHMxVwoVc3ZLam9isPpAOxATpw2BmpOzVx0IWiNevnSkcO/WiDVgSRBaCTnR64ZHinI4Ho0/YjJmAz8gnoNXfe/wAL2MZvE8VdVGnOLOpYLuvbq5axorrnEeKcOV5adqEOXuHL5X1AHeHPIyesVx3tzsaYGzRjGzt/Dr9iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdKbWX+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdKbWX+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C47C4CEF1;
	Tue, 26 Aug 2025 11:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208282;
	bh=4oHaJp5+hzRQFMECK3TYCfFfp5vC7w/3t4EFOpiahHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdKbWX+GpNrwAHf/FaXpM4l0ERu8eCyep5T6SdwIMcQj2xBGJwo0a1T+xeiAzaoRW
	 08Sev//CSouvdFSlcBTVcd2xUb/HYVJnualR8NICQJX+5uvFMeKVJRwJRN54LbE1a9
	 VmnCch4yF/6+id4m97MHX3cGa8JM8T2R+GSN9tvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 052/322] scsi: ufs: ufs-pci: Fix default runtime and system PM levels
Date: Tue, 26 Aug 2025 13:07:47 +0200
Message-ID: <20250826110916.686136579@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

commit 6de7435e6b81fe52c0ab4c7e181f6b5decd18eb1 upstream.

Intel MTL-like host controllers support auto-hibernate.  Using
auto-hibernate with manual (driver initiated) hibernate produces more
complex operation.  For example, the host controller will have to exit
auto-hibernate simply to allow the driver to enter hibernate state
manually.  That is not recommended.

The default rpm_lvl and spm_lvl is 3, which includes manual hibernate.

Change the default values to 2, which does not.

Note, to be simpler to backport to stable kernels, utilize the UFS PCI
driver's ->late_init() call back.  Recent commits have made it possible
to set up a controller-specific default in the regular ->init() call
back, but not all stable kernels have those changes.

Fixes: 4049f7acef3e ("scsi: ufs: ufs-pci: Add support for Intel MTL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250723165856.145750-3-adrian.hunter@intel.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufshcd-pci.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -468,10 +468,23 @@ static int ufs_intel_adl_init(struct ufs
 	return ufs_intel_common_init(hba);
 }
 
+static void ufs_intel_mtl_late_init(struct ufs_hba *hba)
+{
+	hba->rpm_lvl = UFS_PM_LVL_2;
+	hba->spm_lvl = UFS_PM_LVL_2;
+}
+
 static int ufs_intel_mtl_init(struct ufs_hba *hba)
 {
+	struct ufs_host *ufs_host;
+	int err;
+
 	hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
-	return ufs_intel_common_init(hba);
+	err = ufs_intel_common_init(hba);
+	/* Get variant after it is set in ufs_intel_common_init() */
+	ufs_host = ufshcd_get_variant(hba);
+	ufs_host->late_init = ufs_intel_mtl_late_init;
+	return err;
 }
 
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)


