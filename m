Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927C6408002;
	Wed, 20 May 2026 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303007; cv=none; b=LKxoFJlPVF1PdHgIn7HlTwSF9EbUIkUCjFRhvOcyYcoxiaNQWMGwEWLSHLNTG9dV0LWP1l2EFKlOaxytfs/UmCu+QU8DjI8RtW1KJkESM/Eybq1QNE3WAkvmjdYN5gKm2kY5xYR8orGsTyd06VKzQc6H9vXQhGetZUq2PAYMdMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303007; c=relaxed/simple;
	bh=/Mc90qvgpH4tvg1lWKzOWivhJZh9Z3JPpyQncuMh79s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stoJZrqdDOA5lx6az4VQnbTHYrqKcPqLuq7KsBQHg0FSiHB889lBSJIQG9VNY/7DvNEvp7pk351m5w7e+VIcDncgJINwbgCjsvzq/+MfSI7h+p6dqRZgC8g2QnHUVtCygMmFQEW3Zn/ClCOHet/0WJML/7+fUQ5XPIMXhxAbhIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P44NE0PD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P44NE0PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608F21F00896;
	Wed, 20 May 2026 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303003;
	bh=1Adl+seLpqNBDQYzOhUuF7WDB95RJMCyz6wiA2Ahwq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P44NE0PDvQbfH2LAUN0Wa5hO5w1IblNJJJMVDyXToSk2vy1F7+arVjgWSsjcuZy5K
	 5tw79GBZPGaA6WKsoxBAWquCUmJb2FQBNRgmyNXwOZUuLXS3s7Ot/vdwv0Tc8DHm1+
	 rZLJQvmV2C3oksSc/KXG+QO+a//HTkfxNQNWkiuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 440/508] Revert "crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx"
Date: Wed, 20 May 2026 18:24:23 +0200
Message-ID: <20260520162108.133047457@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 6923cde8dc1d501e79b312139819c88b54463803.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 1f5005fcd69a9..b950fcce8a9be 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -116,8 +116,8 @@ void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
 		kfree(ctx->wmem);
-		free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
-		free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
+		free_page((unsigned long)ctx->sbounce);
+		free_page((unsigned long)ctx->dbounce);
 		kfree(ctx);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -131,8 +131,8 @@ void nx842_crypto_free_ctx(void *p)
 	struct nx842_crypto_ctx *ctx = p;
 
 	kfree(ctx->wmem);
-	free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
-	free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
+	free_page((unsigned long)ctx->sbounce);
+	free_page((unsigned long)ctx->dbounce);
 }
 EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
 
-- 
2.53.0



