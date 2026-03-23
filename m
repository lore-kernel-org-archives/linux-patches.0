Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1514739A055;
	Mon, 23 Mar 2026 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275023; cv=none; b=cmSNyzj0FdpsQLpK7DHG2gbidUqVDVvkzbqJ7nqpZ4STKIOvTOJQUgSYOyJE/rYV7ZNqdA5sx8Um/PW4ANcjVTbBI/klKrL4rHAu8kzIcvcmbjbBMMyT9PTJHQTEsE00zF7PLHndG96j54VZXRZM+WaXic10JUvh/PzLfwE4kRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275023; c=relaxed/simple;
	bh=7mx4Hvoh8pdyuuGXefqa9+cwgOUfvuKd1O7V8LaT3TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aq20zisyXlb/qzdpSNwS0+3J38JXmGyGycFEOpq7V2sNLysaaSS3v1yCbTztSkBgI0ncgYVq60si+Kj04K5i17YayqlhUmbdTa9HrbWFBm+hwGqPjHseB8LDg/K+NQvNwEQv2ZnVqcyUXDElFojow9I7ddpEdn4HkPQCOwu7yfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygaPGhgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygaPGhgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C69C4CEF7;
	Mon, 23 Mar 2026 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275023;
	bh=7mx4Hvoh8pdyuuGXefqa9+cwgOUfvuKd1O7V8LaT3TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygaPGhgVbf/3u35LF1K2z/GvrRQThC49nMqNoijluG4K/HkaxgfUPP9X4PSf15lpv
	 BMDQdXSNI10PipcibTCudH6SUF0t9kV34JjJaqKIOzCkhNr+J74frmj3VrxtFIzTGu
	 B0D3P7T4JCxd48Wd4ljSWKGGBZNYHA/YdaYuWYUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	William Zhang <william.zhang@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/212] mtd: rawnand: serialize lock/unlock against other NAND operations
Date: Mon, 23 Mar 2026 14:46:57 +0100
Message-ID: <20260323134509.987522481@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Dasu <kamal.dasu@broadcom.com>

[ Upstream commit bab2bc6e850a697a23b9e5f0e21bb8c187615e95 ]

nand_lock() and nand_unlock() call into chip->ops.lock_area/unlock_area
without holding the NAND device lock. On controllers that implement
SET_FEATURES via multiple low-level PIO commands, these can race with
concurrent UBI/UBIFS background erase/write operations that hold the
device lock, resulting in cmd_pending conflicts on the NAND controller.

Add nand_get_device()/nand_release_device() around the lock/unlock
operations to serialize them against all other NAND controller access.

Fixes: 92270086b7e5 ("mtd: rawnand: Add support for manufacturer specific lock/unlock operation")
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Reviewed-by: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index ad6d66309597b..b4bd73d7cd05c 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -4737,11 +4737,16 @@ static void nand_shutdown(struct mtd_info *mtd)
 static int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
 	struct nand_chip *chip = mtd_to_nand(mtd);
+	int ret;
 
 	if (!chip->ops.lock_area)
 		return -ENOTSUPP;
 
-	return chip->ops.lock_area(chip, ofs, len);
+	nand_get_device(chip);
+	ret = chip->ops.lock_area(chip, ofs, len);
+	nand_release_device(chip);
+
+	return ret;
 }
 
 /**
@@ -4753,11 +4758,16 @@ static int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 static int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
 	struct nand_chip *chip = mtd_to_nand(mtd);
+	int ret;
 
 	if (!chip->ops.unlock_area)
 		return -ENOTSUPP;
 
-	return chip->ops.unlock_area(chip, ofs, len);
+	nand_get_device(chip);
+	ret = chip->ops.unlock_area(chip, ofs, len);
+	nand_release_device(chip);
+
+	return ret;
 }
 
 /* Set default functions */
-- 
2.51.0



