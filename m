Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B366A59E34E;
	Thu, 17 Sep 2026 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658865; cv=none; b=necOE4c5d8LmaC0YJ2sE9PGY0Xu5MJr9L/WtSPOfY2OQzqSvsmZGtNaDSSdIhRuf5qt8X+a4kYlrIJhoBPjUoVF25oTW2mjqcLhX9y1RDtYTzcUxzhJvmBBtrluUyUUWULWkfcOq/teqnkfOf+zwvM5LdTDRcQ6oYw25CTisKhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658865; c=relaxed/simple;
	bh=tvaL9YigsCvYNBJpxyqU8v3Pf2HYai6OYGfViduYEtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjIGJ5Z9WlBM6ovacCfvrnXQHxNgyr9whfBU5Hnoac51/I1SHg3u88kHYZ+7vhiTVSMBsSPYZIDeiwX3Vx1gGXa85dXJlQ0tr6562bCRYb1lj6LA0pU7TlLtawYylYPfza7dGz5xutNWLv2OPu/RHLLV32424frjQaq9Q6JrZxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibDcMYF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibDcMYF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1A61F000FF;
	Thu, 17 Sep 2026 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658856;
	bh=WwguYoSTZK2RTSZhqK+9EM0Iim0zkXivzYwTaR0XAmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibDcMYF0+ed3rUr9XN5SGx2/6nFpmIhobnCK61nz/nt77JCGs0qIdGN1Wtz4I+tyg
	 /au8f2Msj0tJDgvq3XwvSQC6dU6gKhoeL79q4Aq2kg4IQuz5Ut1sP4gOzM8qmaLS4C
	 gDDZ3hG+ppEN3+cpzPW6wCsKGVonUaWjoMNwrhDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sangram kumar yerra <sangram.k.y@intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 062/733] scsi: ufs: ufs-pci: Add support for Intel UFS 4.0 HS-Gear5
Date: Thu, 17 Sep 2026 16:06:10 +0100
Message-ID: <20260917151352.374125366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sangram kumar yerra <sangram.k.y@intel.com>

[ Upstream commit ef675ea168453a9b3e635b8ac543f92938bdd03b ]

Reliable HS-Gear5 operation on Intel UFS 4.0 controllers requires
configuring PA_INITIAL_ADAPT before changing the power mode. Without
this setting, the link fails to train reliably at Gear5.

Add a pwr_change_notify() hook to configure the adaptation mode before
the power mode transition. Enable this only for UFS 4.0 and later
controllers by checking hba->ufs_version.

Wire the hook into the existing Meteor Lake family variant operations
table (ufs_intel_mtl_hba_vops) instead of introducing a separate table,
since the Intel UFS 4.0 PCI variant (PCI ID 8086:D335) already uses this
vops table and the hook is internally gated on UFS version >= 4.0.

Use PA_INITIAL_ADAPT when the negotiated TX power mode is FAST_MODE or
FASTAUTO_MODE. Otherwise, reset the adaptation mode to PA_NO_ADAPT,
which is the default setting.

Fixes: 096cd6b7adf2 ("scsi: ufs: ufs-pci: Add support for Intel Nova Lake")
Signed-off-by: sangram kumar yerra <sangram.k.y@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260818112830.453402-2-sangram.k.y@intel.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufshcd-pci.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index f2433879b0eba..93bfafc25018b 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -181,6 +181,25 @@ static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_nvl_pwr_change_notify(struct ufs_hba *hba,
+					   enum ufs_notify_change_status stage,
+					   struct ufs_pa_layer_attr *dev_req_params)
+{
+	int adapt_val;
+
+	if (stage != PRE_CHANGE || hba->ufs_version < ufshci_version(4, 0))
+		return 0;
+
+	if (dev_req_params->pwr_tx == FAST_MODE || dev_req_params->pwr_tx == FASTAUTO_MODE)
+		adapt_val = PA_INITIAL_ADAPT;
+	else
+		adapt_val = PA_NO_ADAPT;
+
+	ufshcd_dme_configure_adapt(hba, dev_req_params->gear_tx, adapt_val);
+
+	return 0;
+}
+
 static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
 {
 	u32 granularity, peer_granularity;
@@ -527,6 +546,7 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.pwr_change_notify	= ufs_intel_nvl_pwr_change_notify,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
 };
-- 
2.53.0



