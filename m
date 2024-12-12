Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB0321766D;
	Thu, 12 Dec 2024 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024060; cv=none; b=rrue+TJfTPp9T4cs+rC2WKJXYUxH/MFdGvY7Fvr+9u3zvMfdMEgzCHLdl7M6+7UClR0kuV6BB2H3QU7YWUvjNquxI9iPgA/OXhmB7bjfuogaXbXrK2OjEM0OIPzR4ZI4EBiZqQviH3+bSrrdRLSVz7GgzUxHsvcHUGmhp8G+1cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024060; c=relaxed/simple;
	bh=ur+M9Mgkh0lmXeDGh0m8LRFgFMFqe+tLNGdtwwoK5Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAYgio7l7ETPn2DKpO6Qqpm3mu/N76e/wBW2vv/Ij+7IfinPWws/8d3qb9OqiNq5AvPSPQuuZJ1Zo8Z+HfkUA/dw9frKU5b83VGLaNCthHdXrLo0T0IGSHa4l6r7ERgobfoyXcMTYvAxXk7+QwxA177aRy2YXhCxUg2p0cFc4n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oqmu+z8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oqmu+z8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEE2C4CECE;
	Thu, 12 Dec 2024 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024060;
	bh=ur+M9Mgkh0lmXeDGh0m8LRFgFMFqe+tLNGdtwwoK5Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oqmu+z8A465AESNHMm0B5RYXmMAcJ0T4UCvcC4X1dlBQOmxl61lcvVSG89bLsKpyy
	 S9xnsHhfuQDpyyU6HPREIGUWSWDnEiIEkR/i7NFQXo1Jkm6qUAvnqtZmaoyunKoJs2
	 Flc/pzytyG2bmVStvOZr/ApbQW/GwHyfmhQ0Pkro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/459] mtd: rawnand: atmel: Fix possible memory leak
Date: Thu, 12 Dec 2024 15:58:30 +0100
Message-ID: <20241212144300.306438489@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 6d734f1bfc336aaea91313a5632f2f197608fadd ]

The pmecc "user" structure is allocated in atmel_pmecc_create_user() and
was supposed to be freed with atmel_pmecc_destroy_user(), but this other
helper is never called. One solution would be to find the proper
location to call the destructor, but the trend today is to switch to
device managed allocations, which in this case fits pretty well.

Replace kzalloc() by devm_kzalloc() and drop the destructor entirely.

Reported-by: "Dr. David Alan Gilbert" <linux@treblig.org>
Closes: https://lore.kernel.org/all/ZvmIvRJCf6VhHvpo@gallifrey/
Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20241001203149.387655-1-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/pmecc.c | 8 +-------
 drivers/mtd/nand/raw/atmel/pmecc.h | 2 --
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/raw/atmel/pmecc.c b/drivers/mtd/nand/raw/atmel/pmecc.c
index cbb023bf00f72..09848d13802d8 100644
--- a/drivers/mtd/nand/raw/atmel/pmecc.c
+++ b/drivers/mtd/nand/raw/atmel/pmecc.c
@@ -362,7 +362,7 @@ atmel_pmecc_create_user(struct atmel_pmecc *pmecc,
 	size = ALIGN(size, sizeof(s32));
 	size += (req->ecc.strength + 1) * sizeof(s32) * 3;
 
-	user = kzalloc(size, GFP_KERNEL);
+	user = devm_kzalloc(pmecc->dev, size, GFP_KERNEL);
 	if (!user)
 		return ERR_PTR(-ENOMEM);
 
@@ -408,12 +408,6 @@ atmel_pmecc_create_user(struct atmel_pmecc *pmecc,
 }
 EXPORT_SYMBOL_GPL(atmel_pmecc_create_user);
 
-void atmel_pmecc_destroy_user(struct atmel_pmecc_user *user)
-{
-	kfree(user);
-}
-EXPORT_SYMBOL_GPL(atmel_pmecc_destroy_user);
-
 static int get_strength(struct atmel_pmecc_user *user)
 {
 	const int *strengths = user->pmecc->caps->strengths;
diff --git a/drivers/mtd/nand/raw/atmel/pmecc.h b/drivers/mtd/nand/raw/atmel/pmecc.h
index 7851c05126cf1..cc0c5af1f4f1a 100644
--- a/drivers/mtd/nand/raw/atmel/pmecc.h
+++ b/drivers/mtd/nand/raw/atmel/pmecc.h
@@ -55,8 +55,6 @@ struct atmel_pmecc *devm_atmel_pmecc_get(struct device *dev);
 struct atmel_pmecc_user *
 atmel_pmecc_create_user(struct atmel_pmecc *pmecc,
 			struct atmel_pmecc_user_req *req);
-void atmel_pmecc_destroy_user(struct atmel_pmecc_user *user);
-
 void atmel_pmecc_reset(struct atmel_pmecc *pmecc);
 int atmel_pmecc_enable(struct atmel_pmecc_user *user, int op);
 void atmel_pmecc_disable(struct atmel_pmecc_user *user);
-- 
2.43.0



