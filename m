Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D0834B1B2;
	Tue, 16 Dec 2025 11:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885242; cv=none; b=OyWcLWVdXDVB6QlPqshmYq1itMfxTytm7rUM/mBM3FqVFU4uBYqSPgloBrUqAKUcCXKBnpPyVZzqtIgyVKpkIz2a4lhIgsJfTYCnr73CMjYb4ElXq6eUpV3bJZDjOIRwn6CYoIyJyNsPN4inVPTrnaX6y/0G6VvBl+KEjdz8OoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885242; c=relaxed/simple;
	bh=VvnzqA9DllJmXIscj/wxnu9/sBN70alGWEM9LsXD1ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfw7ige2RYupqAkYRwU5u9NrwAxivphxC1F0Ba9Gf+FczCQ+vAWDtrSur97YkwuS9b8G90pZ030ZhsQbDXmTZO1Hz/scVTqsHuC7n3AC5lRe5XXNXboCgR0T/8hWkR9OIAoY1LKAjoTEvrf+PEk6C6Z++gMtrY8rNVmxS7JyiVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKiCKbFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKiCKbFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E63C4CEF1;
	Tue, 16 Dec 2025 11:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885242;
	bh=VvnzqA9DllJmXIscj/wxnu9/sBN70alGWEM9LsXD1ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKiCKbFSGtpDiJF0UTDCZKwZg2RwpFT5K8JdMnF87m2Zj0nxPKdZy1rf8xJrnA9fI
	 g4ji83bEAfXWe2JwZaYx1g/4lHvtLy9H5hyx15EReK4U5CgQQ5ngUw+W1gsMfa1245
	 smMB/WvM8QPPqYe5hPAs/RFQ7q/9agTEBBRyxp5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nieweiqiang <nieweiqiang@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 080/507] crypto: hisilicon/qm - restore original qos values
Date: Tue, 16 Dec 2025 12:08:41 +0100
Message-ID: <20251216111348.439823784@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index 60fe8cc9a7d05..dae2e4c36e53a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3664,6 +3664,7 @@ static void qm_clear_vft_config(struct hisi_qm *qm)
 static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 {
 	struct device *dev = &qm->pdev->dev;
+	struct qm_shaper_factor t_factor;
 	u32 ir = qos * QM_QOS_RATE;
 	int ret, total_vfs, i;
 
@@ -3671,6 +3672,7 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 	if (fun_index > total_vfs)
 		return -EINVAL;
 
+	memcpy(&t_factor, &qm->factor[fun_index], sizeof(t_factor));
 	qm->factor[fun_index].func_qos = qos;
 
 	ret = qm_get_shaper_para(ir, &qm->factor[fun_index]);
@@ -3684,11 +3686,21 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
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



