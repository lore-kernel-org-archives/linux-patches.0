Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2152798F8;
	Tue, 27 May 2025 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366334; cv=none; b=eS5TYIlv5Pkv43n+JDsGDMB9fvJGncgZ92st6SuXjS4WGf6A+mnceYgtIQo+RYI72fMg8FJhxwqrMp1Xo/Qt81qNOSPL4g14GYl0/mSk4BRBb4tYKORkgFFLeu9w61jdd0+sbavKQTWppm1qc9z6M2p/C6VORb9rudvfg/nrq+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366334; c=relaxed/simple;
	bh=AlSHCNHKEep7+bz+kJqmuYwh6VQkL/DtBhL4eRruWxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZczX/cJKidVx97UJwUfxCYunMi/EEcc5SqNKqn+L2u27CoAIOpmutvEUK8XvxqGfu4ina839/pCQSLg4E1ko+X9THqlaOF6trW+oqxVaq+lq8pfWdnTB5zzU+GiN6fJ4SemJUVEAw0sc2I1SnHa/gYVfXVxFS4FfgnWviMhAf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGVJAp/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGVJAp/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25612C4CEEA;
	Tue, 27 May 2025 17:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366334;
	bh=AlSHCNHKEep7+bz+kJqmuYwh6VQkL/DtBhL4eRruWxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGVJAp/PktPQLuYsDXGGM8QED/7q4w5r2bLmOOvZHiyZ3TQSofw8N5qwjNhSBZi2U
	 QeRmu//h3qvYxSTiciQbrgeNnbrbjN+5whKUrlIPyOnKzNXGHSiQnQeBCPfL4CdOf9
	 Nkf0pRY//NxWmW83k7YQjbDi9MbzvuT53/w1Thsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Pandey <quic_mapa@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 017/783] scsi: ufs: Introduce quirk to extend PA_HIBERN8TIME for UFS devices
Date: Tue, 27 May 2025 18:16:54 +0200
Message-ID: <20250527162513.749353024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Pandey <quic_mapa@quicinc.com>

[ Upstream commit 569330a34a31a52c904239439984a59972c11d28 ]

Samsung UFS devices require additional time in hibern8 mode before
exiting, beyond the negotiated handshaking phase between the host and
device.  Introduce a quirk to increase the PA_HIBERN8TIME parameter by
100 µs, a value derived from experiments, to ensure a proper hibernation
process.

Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
Link: https://lore.kernel.org/r/20250411121630.21330-3-quic_mapa@quicinc.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++++++++++++++++
 include/ufs/ufs_quirks.h  |  6 ++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 99e7e4a570f0e..47ec4e4e4a2a0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -278,6 +278,7 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 	  .model = UFS_ANY_MODEL,
 	  .quirk = UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
 		   UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
+		   UFS_DEVICE_QUIRK_PA_HIBER8TIME |
 		   UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS },
 	{ .wmanufacturerid = UFS_VENDOR_SKHYNIX,
 	  .model = UFS_ANY_MODEL,
@@ -8384,6 +8385,31 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
 	return ret;
 }
 
+/**
+ * ufshcd_quirk_override_pa_h8time - Ensures proper adjustment of PA_HIBERN8TIME.
+ * @hba: per-adapter instance
+ *
+ * Some UFS devices require specific adjustments to the PA_HIBERN8TIME parameter
+ * to ensure proper hibernation timing. This function retrieves the current
+ * PA_HIBERN8TIME value and increments it by 100us.
+ */
+static void ufshcd_quirk_override_pa_h8time(struct ufs_hba *hba)
+{
+	u32 pa_h8time;
+	int ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_HIBERN8TIME), &pa_h8time);
+	if (ret) {
+		dev_err(hba->dev, "Failed to get PA_HIBERN8TIME: %d\n", ret);
+		return;
+	}
+
+	/* Increment by 1 to increase hibernation time by 100 µs */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME), pa_h8time + 1);
+	if (ret)
+		dev_err(hba->dev, "Failed updating PA_HIBERN8TIME: %d\n", ret);
+}
+
 static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 {
 	ufshcd_vops_apply_dev_quirks(hba);
@@ -8394,6 +8420,9 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
 		ufshcd_quirk_tune_host_pa_tactivate(hba);
+
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_HIBER8TIME)
+		ufshcd_quirk_override_pa_h8time(hba);
 }
 
 static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
index 41ff44dfa1db3..f52de5ed1b3b6 100644
--- a/include/ufs/ufs_quirks.h
+++ b/include/ufs/ufs_quirks.h
@@ -107,4 +107,10 @@ struct ufs_dev_quirk {
  */
 #define UFS_DEVICE_QUIRK_DELAY_AFTER_LPM        (1 << 11)
 
+/*
+ * Some ufs devices may need more time to be in hibern8 before exiting.
+ * Enable this quirk to give it an additional 100us.
+ */
+#define UFS_DEVICE_QUIRK_PA_HIBER8TIME          (1 << 12)
+
 #endif /* UFS_QUIRKS_H_ */
-- 
2.39.5



