Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A9E340A64;
	Tue, 16 Dec 2025 11:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884066; cv=none; b=iaN3Vm+70CLRM+lk1x+7ds7IHYRKkge1yL93B2VgEY/f/uD9Zc8MK9N/KYedoKS1a27dHW46JYqNWA0vj6JRVV6eJofc1XQNUKCi/qn5QLDAyEJlTywfqx/CyRX1ubQ2dX/PXQosUjkEiaJWO+pWeNnGIALfYxP5Z1xJZTPYP6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884066; c=relaxed/simple;
	bh=gY5HEA+w3WnUjv5sI+JknHGwgyDAjkSeoJ2Y+wUxsjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtPEeg9MNy/P/CHXjvxUskqkdDf/hRH9YVckdJRmO6rxK/0Y2cZDCnjRb3lcUiZE/nRAYwyeFu4jYVtJuAcbLvyqMwscx/Y/90ols+dtKAIJfDt++/xLzJo1fSSqx/i07wlnl7oTyOLWkO57gcxSmzBs51YRqYu+/ksJRVKnthU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJdnJCY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJdnJCY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24DDC4CEF1;
	Tue, 16 Dec 2025 11:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884066;
	bh=gY5HEA+w3WnUjv5sI+JknHGwgyDAjkSeoJ2Y+wUxsjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJdnJCY/KzIL3aT4wmsPITSwWLh8PIZUkFXxyzRZwzVEEqYC2/QlB0opOEMtFqHiQ
	 0+d+bs/RJebHDpitIEI4cUqTtiPNN8y47e2KUJyChljB0d3nIueN8aQU89aN4ud6WN
	 emaRVfdMMSsepHOkINW6vq02882yPwk7ZhyNTl9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nieweiqiang <nieweiqiang@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/354] crypto: hisilicon/qm - restore original qos values
Date: Tue, 16 Dec 2025 12:10:32 +0100
Message-ID: <20251216111323.281268830@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: nieweiqiang <nieweiqiang@huawei.com>

[ Upstream commit e7066160f5b4187ad9869b712fa7a35d3d5be6b9 ]

When the new qos valus setting fails, restore to
the original qos values.

Fixes: 72b010dc33b9 ("crypto: hisilicon/qm - supports writing QoS int the host")
Signed-off-by: nieweiqiang <nieweiqiang@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 711c299713687..d0b154d13f445 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3493,6 +3493,7 @@ static void qm_clear_vft_config(struct hisi_qm *qm)
 static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 {
 	struct device *dev = &qm->pdev->dev;
+	struct qm_shaper_factor t_factor;
 	u32 ir = qos * QM_QOS_RATE;
 	int ret, total_vfs, i;
 
@@ -3500,6 +3501,7 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 	if (fun_index > total_vfs)
 		return -EINVAL;
 
+	memcpy(&t_factor, &qm->factor[fun_index], sizeof(t_factor));
 	qm->factor[fun_index].func_qos = qos;
 
 	ret = qm_get_shaper_para(ir, &qm->factor[fun_index]);
@@ -3513,11 +3515,21 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 		ret = qm_set_vft_common(qm, SHAPER_VFT, fun_index, i, 1);
 		if (ret) {
 			dev_err(dev, "type: %d, failed to set shaper vft!\n", i);
-			return -EINVAL;
+			goto back_func_qos;
 		}
 	}
 
 	return 0;
+
+back_func_qos:
+	memcpy(&qm->factor[fun_index], &t_factor, sizeof(t_factor));
+	for (i--; i >= ALG_TYPE_0; i--) {
+		ret = qm_set_vft_common(qm, SHAPER_VFT, fun_index, i, 1);
+		if (ret)
+			dev_err(dev, "failed to restore shaper vft during rollback!\n");
+	}
+
+	return -EINVAL;
 }
 
 static u32 qm_get_shaper_vft_qos(struct hisi_qm *qm, u32 fun_index)
-- 
2.51.0



