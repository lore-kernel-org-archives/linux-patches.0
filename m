Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74445218592;
	Thu, 12 Dec 2024 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022384; cv=none; b=mYUNa5+0gZi61WveslfBhU+Qtp9SIVwxPNKc/o+CYtV6Ovqzc5jxT27UjObJfRL5/+xq/hLHh2HJbIRaQWI0fuqw9PrRu3Vuex77GKB0V3Qmz+Ag3iGijW15LoxMDasfLKIEsCsF5F6F+CYL9hTyD2Bkf/JDRkN4H1siEG6ViJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022384; c=relaxed/simple;
	bh=dkeboVhAn4agD+vMI+4SHDVUBAXgZ+KYpRB2Z1uG9Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k68P+l+InNriGYSnNXo48uWLuXtczm4aLMcJ0K25FDjNa8775yzy/waADpkCfXINz/AXelbVRHQmZHCS0pndkgF1u9kXPqkBB4Y4cNnwbo6yw5ddJA2gc/Vdp4nEkv6FkfLhsGzCXDU6mJfsx8oLCaRYDVshm+pCINr1EY7NwbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzj+g7se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzj+g7se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC29FC4CECE;
	Thu, 12 Dec 2024 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022384;
	bh=dkeboVhAn4agD+vMI+4SHDVUBAXgZ+KYpRB2Z1uG9Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzj+g7se8XWwi+m8WghQqohbsnGlkjc/oHy38fw5VCRrX3tMrLU78i+QqXVTu1sVe
	 h8ucZqmGcsq4kNR1mM0Fb9H4Gn95IFjl5eGkknfaGC9v4qusBDqq+XwaKsCxHyzp/H
	 EZ3WRqjr2Z9wZszaxEwT0Rn58AwK1SmngdFN9Rjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/565] mtd: rawnand: atmel: Fix possible memory leak
Date: Thu, 12 Dec 2024 15:56:54 +0100
Message-ID: <20241212144320.149284387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



