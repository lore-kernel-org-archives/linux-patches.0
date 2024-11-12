Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1542E213120;
	Tue, 12 Nov 2024 10:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408123; cv=none; b=d6zf1+j/aa9olTNgiuw0WfqEe7x5HOgdRQao+1A7qJf4vGLXqbWTrGOc6izheHztGzOu/QMI2ahoFM26Hq3Sqf3waLXzYfo+55XfQ0PVQHdG5SBclEpQgPU5ygTZCzFhjXgsyr6mUogJUTXXNirnswmVwgJClVHxvJZO5b41Nlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408123; c=relaxed/simple;
	bh=V90/5f0vM2WVnzWRMOczzYxGmJFmpzxybS/HsCY1m24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+oeH1VoxLM9VlWI30Zp5ZF5u2ibVq8PNhf4hF1vPZANTe79fJoc41Hj/iI9dZnkDrzXbMMCG4XNO4FULMrlniSdJSz/WQjo2thSnZa53Z/vimkO2BIo8pUXMCzIS0Zxl7ETYe/ZtvIIPoyv/5BbMKV9E2L77Ki3NIF3y78cP6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtDLtBgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtDLtBgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6C7C4CED6;
	Tue, 12 Nov 2024 10:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408123;
	bh=V90/5f0vM2WVnzWRMOczzYxGmJFmpzxybS/HsCY1m24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtDLtBgbp0OG0Q6d0z7C+jJ23+NuVRxYMRyrdIzMTKlVrOC/6wuJmztmq6r6YyOeM
	 UE0N1uOwVqx2EXC2XbKOlSwCOyH4AOJ4/mw/ELNTnSh8uF7TbrXzafKX1SOD3e8Zsa
	 adodS0yFC8oSzbsuxRApSmgbv7LXNg6FeQ6qLE6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingqing Zhou <quic_qqzhou@quicinc.com>,
	Kuldeep Singh <quic_kuldsing@quicinc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 025/184] firmware: qcom: scm: Return -EOPNOTSUPP for unsupported SHM bridge enabling
Date: Tue, 12 Nov 2024 11:19:43 +0100
Message-ID: <20241112101901.833194343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingqing Zhou <quic_qqzhou@quicinc.com>

[ Upstream commit f489f6c6eb26482010470d77bad3901a3de1b166 ]

When enabling SHM bridge, QTEE returns 0 and sets error 4 in result to
qcom_scm for unsupported platforms. Currently, tzmem interprets this as
an unknown error rather than recognizing it as an unsupported platform.

Error log:
[    0.177224] qcom_scm firmware:scm: error (____ptrval____): Failed to enable the TrustZone memory allocator
[    0.177244] qcom_scm firmware:scm: probe with driver qcom_scm failed with error 4

To address this, modify the function call qcom_scm_shm_bridge_enable()
to remap result to indicate an unsupported error. This way, tzmem will
correctly identify it as an unsupported platform case instead of
reporting it as an error.

Fixes: 178e19c0df1b ("firmware: qcom: scm: add support for SHM bridge operations")
Signed-off-by: Qingqing Zhou <quic_qqzhou@quicinc.com>
Co-developed-by: Kuldeep Singh <quic_kuldsing@quicinc.com>
Signed-off-by: Kuldeep Singh <quic_kuldsing@quicinc.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/20241022192148.1626633-1-quic_kuldsing@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index a50d8e8d0f1b8..6436bd09587a5 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -112,6 +112,7 @@ enum qcom_scm_qseecom_tz_cmd_info {
 };
 
 #define QSEECOM_MAX_APP_NAME_SIZE		64
+#define SHMBRIDGE_RESULT_NOTSUPP		4
 
 /* Each bit configures cold/warm boot address for one of the 4 CPUs */
 static const u8 qcom_scm_cpu_cold_bits[QCOM_SCM_BOOT_MAX_CPUS] = {
@@ -1353,6 +1354,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_lmh_dcvsh_available);
 
 int qcom_scm_shm_bridge_enable(void)
 {
+	int ret;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_SHM_BRIDGE_ENABLE,
@@ -1365,7 +1368,15 @@ int qcom_scm_shm_bridge_enable(void)
 					  QCOM_SCM_MP_SHM_BRIDGE_ENABLE))
 		return -EOPNOTSUPP;
 
-	return qcom_scm_call(__scm->dev, &desc, &res) ?: res.result[0];
+	ret = qcom_scm_call(__scm->dev, &desc, &res);
+
+	if (ret)
+		return ret;
+
+	if (res.result[0] == SHMBRIDGE_RESULT_NOTSUPP)
+		return -EOPNOTSUPP;
+
+	return res.result[0];
 }
 EXPORT_SYMBOL_GPL(qcom_scm_shm_bridge_enable);
 
-- 
2.43.0



