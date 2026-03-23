Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41C723EA97;
	Mon, 23 Mar 2026 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277464; cv=none; b=g3IzrwmwsnjeItwKfcEqQgVIc+6faz6w/4EflGnoyggT03A96y/CjjQ8KSZpyj9/nlDMI5RYPAYXFSzai5XZq9tbWNGoOxpQBO9xSIrc37eq4LFH2kaoJ+r32f3Q5Blrvk6xJxfsNzUabqFwujYNNHLW7Er2ZsCQVyLFVWxy4XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277464; c=relaxed/simple;
	bh=OqODp/m/vyAHURzkgtRn6AWmt/zMaO2XkVad/udX8Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftpkKq7LVtV1rrbn3lr5PH740WibFhdEP3Jc03M7kbrtsm8m08fiXwupfHB+R4Y7UMWimZH9Pn6SP7y7duOLF5zLp/XIEjfhpe5X89sFFqMpI7Za0NNfQZhAxlk8/3PAD+l2XLOyqFtummFSimOceMfht0l4oYg9eIETnJV56ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN7FBgYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN7FBgYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788F5C4CEF7;
	Mon, 23 Mar 2026 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277463;
	bh=OqODp/m/vyAHURzkgtRn6AWmt/zMaO2XkVad/udX8Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VN7FBgYjhFnYlZY57MlH9IyFCLiBcqf9Q0aCLdiBM5bD2iSy4N8uZSlKKBSKRZqhZ
	 I2wMw4fE4crhczUACCfyxfg/0x+LcsS3dy/dxuEoA8fAbmuU8FwlQo0+SCLLEh/aH/
	 gySwASC3Yr10zz/87JoExbsBmdnNRrxFi7z0FHpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	William Zhang <william.zhang@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 449/460] mtd: rawnand: serialize lock/unlock against other NAND operations
Date: Mon, 23 Mar 2026 14:47:25 +0100
Message-ID: <20260323134537.620182744@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index 3e1844bfb8089..d654e5f52ee09 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -4868,11 +4868,16 @@ static void nand_shutdown(struct mtd_info *mtd)
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
@@ -4884,11 +4889,16 @@ static int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
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



