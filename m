Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2C830DEC5;
	Mon, 13 Oct 2025 15:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370032; cv=none; b=pfmahc8asFusn/UAhUgqezC8q4v/dCi2FgHYqSXtbwTGGb0Q6ZBnVjVvJL53UomLLbhGrglxVWkclNc6nIItkf86RMDUpTPo1HyJlYDXOa/vBn0aJd06M07JSyIFZh22uanU1IfF0j6kpQkBUqTpBDVngLV7VLfs9jg7B2q0WyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370032; c=relaxed/simple;
	bh=ZCzNjKdk246XFXR74q/V0z1wOiosCz2ZizO6aJU/P+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wfi731duXs5H4UW//s9btRmpJ9wpthWSX2rj2cJBf8mRCzSn0wPNOxn/psvO6i4izdS6KKIrjkpJclu7I9R3PfO1y+4ACdxnV/+dlJVJQM6qmy/A5sLHsOpPp5Sj2msXLTy/iA8vZAdGAE5M+Z5FKhegNQiLbbh5TCUS6ANvKYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcpfjfLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcpfjfLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274E4C4CEE7;
	Mon, 13 Oct 2025 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370032;
	bh=ZCzNjKdk246XFXR74q/V0z1wOiosCz2ZizO6aJU/P+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcpfjfLV1fKZwCT+4G93ce1wOwlFXV8IlIzqMqgHloF4aXGXJJlgJC4n9aMpcMXVA
	 /kdhsN4FTjjL/yEjyRDklpy3Yoxafpc3yRdiIBy51hNDrFNVqft8pV46y3vxLX3IB0
	 TJ9slCdJfFykT19stkFrlJX+cMxCVMFTbQAKu374=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Luca Weiss <luca@lucaweiss.eu>
Subject: [PATCH 6.17 411/563] remoteproc: qcom_q6v5_mss: support loading MBN file on msm8974
Date: Mon, 13 Oct 2025 16:44:32 +0200
Message-ID: <20251013144426.176514850@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 581e3dea0ece4b59cf714c9dfe195a178d3ae13b ]

On MSM8974 / APQ8074, MSM8226 and MSM8926 the MSS requires loading raw
MBA image instead of the ELF file. Skip the ELF headers if mba.mbn was
specified as the firmware image.

Fixes: a5a4e02d083d ("remoteproc: qcom: Add support for parsing fw dt bindings")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Tested-by: Luca Weiss <luca@lucaweiss.eu> # msm8974pro-fairphone-fp2
Link: https://lore.kernel.org/r/20250706-msm8974-fix-mss-v4-1-630907dbd898@oss.qualcomm.com
[bjorn: Unwrapped the long memcpy line, to taste]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 0c0199fb0e68d..3087d895b87f4 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -498,6 +498,8 @@ static void q6v5_debug_policy_load(struct q6v5 *qproc, void *mba_region)
 	release_firmware(dp_fw);
 }
 
+#define MSM8974_B00_OFFSET 0x1000
+
 static int q6v5_load(struct rproc *rproc, const struct firmware *fw)
 {
 	struct q6v5 *qproc = rproc->priv;
@@ -516,7 +518,14 @@ static int q6v5_load(struct rproc *rproc, const struct firmware *fw)
 		return -EBUSY;
 	}
 
-	memcpy(mba_region, fw->data, fw->size);
+	if ((qproc->version == MSS_MSM8974 ||
+	     qproc->version == MSS_MSM8226 ||
+	     qproc->version == MSS_MSM8926) &&
+	    fw->size > MSM8974_B00_OFFSET &&
+	    !memcmp(fw->data, ELFMAG, SELFMAG))
+		memcpy(mba_region, fw->data + MSM8974_B00_OFFSET, fw->size - MSM8974_B00_OFFSET);
+	else
+		memcpy(mba_region, fw->data, fw->size);
 	q6v5_debug_policy_load(qproc, mba_region);
 	memunmap(mba_region);
 
-- 
2.51.0



