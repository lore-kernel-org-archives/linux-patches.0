Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F4435B158;
	Fri,  9 Jan 2026 12:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961575; cv=none; b=LjY2om37io/SHIBNCgy7LlrBZKUeuYP857cSBdSHJw18nypg70OB50OLKoTh++TcvfUDT8sgXdh1Mplk2D9NFPeLhCaKjdQlxL2ErdTVeqTjVXwcYoTuSfJFYrHjKU6MSCclpuf0HvhKM0RBGC8a5Ks88+L78v27M/l669Z7xOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961575; c=relaxed/simple;
	bh=ytAoGJpU4SpwKtDHxhoZy3sXRYXe+NomoPGhF6hHIUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCliGJhsQNZCaQsUcAeO8Umw4TiSU0JUoZhjdcAuBPXoWbTQqzEJ+edzm2xEb7b3LNaDIvL961IZMwbd0obxjj31FZGnKtuKO7BfkMsjieCiMyvBAyk3mDvje+FSNixRZWVFI2VMJp/ZmjVPtgLG0evSPK8MaCews3AGIqPOezw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipZog/ZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipZog/ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F332DC4CEF1;
	Fri,  9 Jan 2026 12:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961575;
	bh=ytAoGJpU4SpwKtDHxhoZy3sXRYXe+NomoPGhF6hHIUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipZog/ZGxTcYfD+g310m8VUZG7HS/cV9OfxRCY7jqL6B3D6hGEQ9/1Md6VdK4fN0r
	 h5BXFxPUZmcyx4ErSNei7PQbdx5ZR/rwtgzUy42QSFD5w7/qfCIQyJTlq7lWAEl3lP
	 NRxkq34DKMkB152n6gOqJrbz7P7lQBDASA8kUXY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nieweiqiang <nieweiqiang@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/634] crypto: hisilicon/qm - restore original qos values
Date: Fri,  9 Jan 2026 12:35:39 +0100
Message-ID: <20260109112119.739251929@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 42f1e7d0023e1..23fff5de3325a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3450,6 +3450,7 @@ static int qm_clear_vft_config(struct hisi_qm *qm)
 static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 {
 	struct device *dev = &qm->pdev->dev;
+	struct qm_shaper_factor t_factor;
 	u32 ir = qos * QM_QOS_RATE;
 	int ret, total_vfs, i;
 
@@ -3457,6 +3458,7 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 	if (fun_index > total_vfs)
 		return -EINVAL;
 
+	memcpy(&t_factor, &qm->factor[fun_index], sizeof(t_factor));
 	qm->factor[fun_index].func_qos = qos;
 
 	ret = qm_get_shaper_para(ir, &qm->factor[fun_index]);
@@ -3470,11 +3472,21 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
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



