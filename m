Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC21B198A27;
	Thu,  5 Sep 2024 09:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529837; cv=none; b=lrT0AUUIZSyjUM49DWudzD9Ia8FlJoO6wTDMEXR7mkQJiErDk/7rIio672AMp//v4XdK2YG+CLHUGV11a5ppdxzSNqayZMp+zltoAw7BsROUFON/naegLIZc0PNcsyKpGTV3j1rLyuBxhVCj/nd+NKYoz6E9p3KNrrDgR/AUzDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529837; c=relaxed/simple;
	bh=fiy8J7gV6Cf1dQqzapP/37i0HhGEGUHP/vAZ3LmaKSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+BV0XEiUND7JtZdPwOKvufATF6BeZh6WV5DD7gRQ04TTRPYqLldN/D+qAMN7Pt3rKf0Lhf4N/EzHLCgROHnjRI0OSs+j3gSIknCuOMocUmO3nFLR7QSpQrM2cfchKYuN4Rbg2r9hwNKKO7SmB3XmFcUo6ZsQ853Z0yOI1Bd+Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h237sqe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h237sqe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E096C4CEC3;
	Thu,  5 Sep 2024 09:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529837;
	bh=fiy8J7gV6Cf1dQqzapP/37i0HhGEGUHP/vAZ3LmaKSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h237sqe2f7FgHOmEW9yW3TVBpRuZKN7exdVSAWrvIrwp5piQqtaxYqB/hGODJ4xUE
	 0ZbsB9mwLLm4jgUVYOg9bLNwP6mFbXap6WSwN7YS+rJu+I2DAXXJqTLTp3GL51W2Dn
	 7EWi9tETDW2dNfTNv631hNzKymNjDahnzf/Ju8Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Maina <quic_rmaina@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Chris Lew <quic_clew@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 127/184] remoteproc: qcom_q6v5_pas: Add hwspinlock bust on stop
Date: Thu,  5 Sep 2024 11:40:40 +0200
Message-ID: <20240905093737.185898743@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Maina <quic_rmaina@quicinc.com>

[ Upstream commit 568b13b65078e2b557ccf47674a354cecd1db641 ]

When remoteproc goes down unexpectedly this results in a state where any
acquired hwspinlocks will remain locked possibly resulting in deadlock.
In order to ensure all locks are freed we include a call to
qcom_smem_bust_hwspin_lock_by_host() during remoteproc shutdown.

For qcom_q6v5_pas remoteprocs, each remoteproc has an assigned smem
host_id. Remoteproc can pass this id to smem to try and bust the lock on
remoteproc stop.

This edge case only occurs with q6v5_pas watchdog crashes. The error
fatal case has handling to clear the hwspinlock before the error fatal
interrupt is triggered.

Signed-off-by: Richard Maina <quic_rmaina@quicinc.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Chris Lew <quic_clew@quicinc.com>
Link: https://lore.kernel.org/r/20240529-hwspinlock-bust-v3-4-c8b924ffa5a2@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 54d8005d40a3..8458bcfe9e19 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -52,6 +52,7 @@ struct adsp_data {
 	const char *ssr_name;
 	const char *sysmon_name;
 	int ssctl_id;
+	unsigned int smem_host_id;
 
 	int region_assign_idx;
 	int region_assign_count;
@@ -81,6 +82,7 @@ struct qcom_adsp {
 	int lite_pas_id;
 	unsigned int minidump_id;
 	int crash_reason_smem;
+	unsigned int smem_host_id;
 	bool decrypt_shutdown;
 	const char *info_name;
 
@@ -399,6 +401,9 @@ static int adsp_stop(struct rproc *rproc)
 	if (handover)
 		qcom_pas_handover(&adsp->q6v5);
 
+	if (adsp->smem_host_id)
+		ret = qcom_smem_bust_hwspin_lock_by_host(adsp->smem_host_id);
+
 	return ret;
 }
 
@@ -727,6 +732,7 @@ static int adsp_probe(struct platform_device *pdev)
 	adsp->pas_id = desc->pas_id;
 	adsp->lite_pas_id = desc->lite_pas_id;
 	adsp->info_name = desc->sysmon_name;
+	adsp->smem_host_id = desc->smem_host_id;
 	adsp->decrypt_shutdown = desc->decrypt_shutdown;
 	adsp->region_assign_idx = desc->region_assign_idx;
 	adsp->region_assign_count = min_t(int, MAX_ASSIGN_COUNT, desc->region_assign_count);
@@ -1196,6 +1202,7 @@ static const struct adsp_data sm8550_adsp_resource = {
 	.ssr_name = "lpass",
 	.sysmon_name = "adsp",
 	.ssctl_id = 0x14,
+	.smem_host_id = 2,
 };
 
 static const struct adsp_data sm8550_cdsp_resource = {
@@ -1216,6 +1223,7 @@ static const struct adsp_data sm8550_cdsp_resource = {
 	.ssr_name = "cdsp",
 	.sysmon_name = "cdsp",
 	.ssctl_id = 0x17,
+	.smem_host_id = 5,
 };
 
 static const struct adsp_data sm8550_mpss_resource = {
@@ -1236,6 +1244,7 @@ static const struct adsp_data sm8550_mpss_resource = {
 	.ssr_name = "mpss",
 	.sysmon_name = "modem",
 	.ssctl_id = 0x12,
+	.smem_host_id = 1,
 	.region_assign_idx = 2,
 	.region_assign_count = 1,
 	.region_assign_vmid = QCOM_SCM_VMID_MSS_MSA,
@@ -1275,6 +1284,7 @@ static const struct adsp_data sm8650_cdsp_resource = {
 	.ssr_name = "cdsp",
 	.sysmon_name = "cdsp",
 	.ssctl_id = 0x17,
+	.smem_host_id = 5,
 	.region_assign_idx = 2,
 	.region_assign_count = 1,
 	.region_assign_shared = true,
@@ -1299,6 +1309,7 @@ static const struct adsp_data sm8650_mpss_resource = {
 	.ssr_name = "mpss",
 	.sysmon_name = "modem",
 	.ssctl_id = 0x12,
+	.smem_host_id = 1,
 	.region_assign_idx = 2,
 	.region_assign_count = 3,
 	.region_assign_vmid = QCOM_SCM_VMID_MSS_MSA,
-- 
2.43.0



