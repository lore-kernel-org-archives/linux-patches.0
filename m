Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24FD442FC1;
	Thu, 30 Jul 2026 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421189; cv=none; b=b/hnXClOGrzw38kMkq11nkI4zyT2cdp6HQmTRTP7DQ0R+eVkPDc5NBxqGYgiLFuCHBK3lUO2485CQjfo9BmfznRF1wmetLxFHqIED3541555iiMz0p4rAXWvXp+iFq92BcICqGAdeHR2EqlUwI5sPaYKaocEKRihY1Y5eEiJ5oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421189; c=relaxed/simple;
	bh=IeQg0KaD4QVYD2schdhsxPML87zC0210PT67s24KA2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYTgHxurGjCSHYwXsD5eqZd1bNONalX2m+91KlsJ1S3K+K9xX3/VUaYZzOIselL7YBvpAwwNU0ZGoRsUVlPjZB7dyk0mD5SfpyzjUuMQAOiRRswFTjrrmGKHkReddSEAeSSkmFdRs545hF334jHKM8sxHzdnm6QOexJvoo3quB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDTkqx5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDTkqx5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78B41F00A3D;
	Thu, 30 Jul 2026 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421188;
	bh=cAc1QIykoR3zuEX/z/RmlY+XVwvOfBm6f+tOaMqeDB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDTkqx5f8oUlzcvA73ZdshFE7aH4c33r9xrBMMA+tkSLMIluRPqVlC6J0h32M1Gti
	 8tmcPb3LHzniQ3ZuUvLuyxlWDCFo2LuAQYdPqAioCuWy6D07u8HVaUGoaLMdq8g6Cr
	 n4vsPTTVkzcfhBN8LV4KOi7ugeyyAfW/ci10awfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 021/744] mtd: virt_concat: fix use-after-free in mtd_virt_concat_destroy()
Date: Thu, 30 Jul 2026 16:04:54 +0200
Message-ID: <20260730141444.734199857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 4b45d7836b9526b8776af5f29219615be9417230 ]

mtd_concat_destroy() frees item->concat so calling
mtd_virt_concat_put_mtd_devices(item->concat) after that leads to a
use-after-free.

Fix it by moving mtd_virt_concat_put_mtd_devices() before
mtd_concat_destroy().

Fixes: 43db6366fc2d ("mtd: Add driver for concatenating devices")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtd_virt_concat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtd_virt_concat.c b/drivers/mtd/mtd_virt_concat.c
index 5761816e7f4dca..da4277ced4d63b 100644
--- a/drivers/mtd/mtd_virt_concat.c
+++ b/drivers/mtd/mtd_virt_concat.c
@@ -126,8 +126,8 @@ int mtd_virt_concat_destroy(struct mtd_info *mtd)
 		if (concat->mtd.name) {
 			del_mtd_device(&concat->mtd);
 			kfree(concat->mtd.name);
-			mtd_concat_destroy(&concat->mtd);
 			mtd_virt_concat_put_mtd_devices(item->concat);
+			mtd_concat_destroy(&concat->mtd);
 		}
 
 		for (idx = 0; idx < item->count; idx++)
-- 
2.53.0



