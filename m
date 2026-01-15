Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB4E3A7F5D;
	Thu, 15 Jan 2026 17:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497353; cv=none; b=Cwr9Rca+BCmQ4NWPBJdJf/wfrQ5Ctm8WeeH3/fZ854yaNIXO92pbQl2MSSUHGs/n2Z8H5l85lMrH6EpOmHUuRZwxk/jCRzaDKQJWHUz8U8OZ+bVH96rWw2I6sFnszTziGZ6uhE/mN7OexpDYh2Wgw8s1n8TqbErbQO5xo/AfDZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497353; c=relaxed/simple;
	bh=yvBuPCShDzpd1NTFLPTL4N6Bwtuea5+fUdnz4gbQsn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXN+J9/jkE4sVdxmHfNJ5JTDfJAY4ajIBDVKM+32fq6damYBy35FpTAzG9cGEwrw5rePU087mbcuEozinE6rV5B3e3VLrdHcZ9+yegvb8Vd2hLH9ODqJzUMz5WqlDdO7vz/otoRK66j4wZGSmtFB9QNO0VroZmrRIP96ABA/96o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErOplK/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErOplK/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF395C19423;
	Thu, 15 Jan 2026 17:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497353;
	bh=yvBuPCShDzpd1NTFLPTL4N6Bwtuea5+fUdnz4gbQsn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErOplK/kSxlSc4qJ2lkdMEtEOrwGt/SZCXnAUSKO/Nwuir2ZcIKG5PZquLFDBzY3e
	 PR/rsTRy5vaOSB39biDLumUGhZitJryiTtZPGTGuy9kHeufjoISWFUMqdXoXZBAJlM
	 jITe97olNcXAhFHb2aJn4GARRgLUeVvNhwOhJOl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nieweiqiang <nieweiqiang@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/554] crypto: hisilicon/qm - restore original qos values
Date: Thu, 15 Jan 2026 17:41:57 +0100
Message-ID: <20260115164248.092678102@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 58e995db37838..a48c6306a8cb2 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4010,6 +4010,7 @@ static int qm_clear_vft_config(struct hisi_qm *qm)
 static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 {
 	struct device *dev = &qm->pdev->dev;
+	struct qm_shaper_factor t_factor;
 	u32 ir = qos * QM_QOS_RATE;
 	int ret, total_vfs, i;
 
@@ -4017,6 +4018,7 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 	if (fun_index > total_vfs)
 		return -EINVAL;
 
+	memcpy(&t_factor, &qm->factor[fun_index], sizeof(t_factor));
 	qm->factor[fun_index].func_qos = qos;
 
 	ret = qm_get_shaper_para(ir, &qm->factor[fun_index]);
@@ -4030,11 +4032,21 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
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



