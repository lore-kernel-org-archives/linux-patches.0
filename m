Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121F71F4276;
	Tue,  3 Dec 2024 14:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236738; cv=none; b=sAyZXjy+KB4BzBE5ZBCdjya3LmkhXG3/MvHIX2AVnPKdrmQz7Eq3gdKhaDMmT2XD6hylN6aAYepQopVqNfsae4ylB+VfTDfdcL3Dyi6dE8taTGagXj0QIqwHmO9ZxCMkNUZC9+tpgmPi8RvAfCmuMendp0FnmxRAsgSTg6Ig84w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236738; c=relaxed/simple;
	bh=8b//6Yha7eJUmmZOgJoZH2QOeQkGaevJUdU/pKB2GJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGqqm0P6L0wn5UJe04FNPDisZP2QNLwlZPWQHysfA0bgwBR/7T0JLNzB887NJWXtgjl2+cUggfem7zQpyeGTfyZsSyHLehLiN4ilAql+J510IT/jeYXYFcUKbriETBjw3u9648Aj6Xzv9wpviB7vGe97HwiKUbCShFVhtf8wQaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2hJ+uYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2hJ+uYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D758C4CECF;
	Tue,  3 Dec 2024 14:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236737;
	bh=8b//6Yha7eJUmmZOgJoZH2QOeQkGaevJUdU/pKB2GJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2hJ+uYX/1fBTvOKk9FyfaG0khkOmeO4W5bDKmdv6UFnY2UBBjR+ij+xFEW8GVH8q
	 L02ZEJpAl3hvLgEVn7s59J2ADNo+0JIs4FCmBtxCLSShpiX/zoPsTBoWeffU/MiLaX
	 LQxkQmmll9BVvyi7UzAMIsFy5HhfWZeAI3wyWvwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/138] mtd: rawnand: atmel: Fix possible memory leak
Date: Tue,  3 Dec 2024 15:31:31 +0100
Message-ID: <20241203141925.931368727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9d3997840889b..8880e0401e6c4 100644
--- a/drivers/mtd/nand/raw/atmel/pmecc.c
+++ b/drivers/mtd/nand/raw/atmel/pmecc.c
@@ -365,7 +365,7 @@ atmel_pmecc_create_user(struct atmel_pmecc *pmecc,
 	size = ALIGN(size, sizeof(s32));
 	size += (req->ecc.strength + 1) * sizeof(s32) * 3;
 
-	user = kzalloc(size, GFP_KERNEL);
+	user = devm_kzalloc(pmecc->dev, size, GFP_KERNEL);
 	if (!user)
 		return ERR_PTR(-ENOMEM);
 
@@ -411,12 +411,6 @@ atmel_pmecc_create_user(struct atmel_pmecc *pmecc,
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
index 808f1be0d6ad7..1b6ac2ce73f49 100644
--- a/drivers/mtd/nand/raw/atmel/pmecc.h
+++ b/drivers/mtd/nand/raw/atmel/pmecc.h
@@ -59,8 +59,6 @@ struct atmel_pmecc *devm_atmel_pmecc_get(struct device *dev);
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



