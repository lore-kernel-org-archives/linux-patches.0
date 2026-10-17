Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F6E355F49;
	Sat, 17 Oct 2026 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253487; cv=none; b=nqsS8VAyERVOZIJPuYO0+tgIGRXJCjAeCYsbBStRDjZKsSm5le3YnOz7mGdXD/BXedsFOA2biAr4cg2hfIgSvQdTNps1s7f9n1IsDTMnYQt6QVWhVbWK+jExmqf3BccNh62EBz48j1l2tvZ/M+TD1fw2LTGZk2cFdFmCE/9srsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253487; c=relaxed/simple;
	bh=ReRe9qkwJLTgVnsgLiY97C/HQZpcmEiTQ7YwslqfFLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ln3Uhnnkr8oWbetrKKxdVoWPZnkM5tSnSE2VUJoJ9omAVJZ7ds4ryXeSKf93y3sMxQx4vVHILlOp98D9L3HVC/Us8grHKVahQoHSDAATu1Cfve5B0eOUfUEa+9y0rar0flDEzU65w+YjEi3bp2K3AgzqXMCMaks9KuaUkx7Bq6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+QUzVQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+QUzVQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C351F000C5;
	Sat, 17 Oct 2026 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253486;
	bh=mY+UTp6JfsgsrOyAq71qMz5Tbj1Ko69OciFW9vujJmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+QUzVQaX2ytzuMsReJ7gFRT4SodZlC3y3v4QNWkNWT04ImLpwanRrCQU7xTrdp8N
	 kDHgjJhkrnir+IzcAlR/MKtCr3xHdOwtoLAQNnuxEWn7IHdTRTUJfUNcKpxealcVNO
	 rOer5KJFmN1wND5gHa6cynO4P8Dcex2lM6HnaiJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/869] remoteproc: qcom: pas: Shutdown lite ADSP DTB on X1E
Date: Sat, 17 Oct 2026 17:49:35 +0200
Message-ID: <20261017160040.481375909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 142964960c7c35de5c5f7bdd61c32699de693630 ]

The ADSP firmware on X1E has separate firmware binaries for the main
firmware and the DTB. The same applies for the "lite" firmware loaded by
the boot firmware.

When preparing to load the new ADSP firmware we shutdown the lite_pas_id
for the main firmware, but we don't shutdown the corresponding lite pas_id
for the DTB. The fact that we're leaving it "running" forever becomes
obvious if you try to reuse (or just access) the memory region used by the
"lite" firmware: The &adsp_boot_mem is accessible, but accessing the
&adsp_boot_dtb_mem results in a crash.

We don't support reusing the memory regions currently, but nevertheless we
should not keep part of the lite firmware running. Fix this by adding the
lite_dtb_pas_id and shutting it down as well.

We don't have a way to detect if the lite firmware is actually running yet,
so ignore the return status of qcom_scm_pas_shutdown() for now. This was
already the case before, the assignment to "ret" is not used anywhere.

Fixes: 62210f7509e1 ("remoteproc: qcom_q6v5_pas: Unload lite firmware on ADSP")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250820-rproc-qcom-q6v5-fixes-v2-3-910b1a3aff71@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 001ac642c63b1..bf4f242f1995e 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -42,6 +42,7 @@ struct qcom_pas_data {
 	int pas_id;
 	int dtb_pas_id;
 	int lite_pas_id;
+	int lite_dtb_pas_id;
 	unsigned int minidump_id;
 	bool auto_boot;
 	bool decrypt_shutdown;
@@ -80,6 +81,7 @@ struct qcom_pas {
 	int pas_id;
 	int dtb_pas_id;
 	int lite_pas_id;
+	int lite_dtb_pas_id;
 	unsigned int minidump_id;
 	int crash_reason_smem;
 	unsigned int smem_host_id;
@@ -226,6 +228,8 @@ static int qcom_pas_load(struct rproc *rproc, const struct firmware *fw)
 
 	if (pas->lite_pas_id)
 		ret = qcom_scm_pas_shutdown(pas->lite_pas_id);
+	if (pas->lite_dtb_pas_id)
+		qcom_scm_pas_shutdown(pas->lite_dtb_pas_id);
 
 	if (pas->dtb_pas_id) {
 		ret = request_firmware(&pas->dtb_firmware, pas->dtb_firmware_name, pas->dev);
@@ -720,6 +724,7 @@ static int qcom_pas_probe(struct platform_device *pdev)
 	pas->minidump_id = desc->minidump_id;
 	pas->pas_id = desc->pas_id;
 	pas->lite_pas_id = desc->lite_pas_id;
+	pas->lite_dtb_pas_id = desc->lite_dtb_pas_id;
 	pas->info_name = desc->sysmon_name;
 	pas->smem_host_id = desc->smem_host_id;
 	pas->decrypt_shutdown = desc->decrypt_shutdown;
@@ -1104,6 +1109,7 @@ static const struct qcom_pas_data x1e80100_adsp_resource = {
 	.pas_id = 1,
 	.dtb_pas_id = 0x24,
 	.lite_pas_id = 0x1f,
+	.lite_dtb_pas_id = 0x29,
 	.minidump_id = 5,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
-- 
2.53.0



