Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926D3408000;
	Wed, 20 May 2026 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303008; cv=none; b=NS4GBoZ+5FqIfnHgRJVA+rY99TjIXlnBk/2zlNBjalnDihsDNBp7e9SQkwYeX0OimI/KMsUX8yhBiQKZrXXM9eJ+P99BqcPyEY38SHMHGqFUk8jTgywSKvKkU1HicdKfM6py/QPrPMp9bVWMbMXxMPZJm4zRAYsNqcrzRd4kAjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303008; c=relaxed/simple;
	bh=Jg8aXeLR5b7ucsME0mKdJIFhQlvcv0axkii8sddCbJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6VlXBwWfZnLzT1zI2lvK793SvzpaTvYnWPgGhv01FCWo3k7woDWCni4HisnpdLWS0jKp57YqNAIR4VdDO0PIu4NmlKmt6zhgwLsxZyA4JhV0AnLSY0pf+vcpTD7rcHrztumUmOgLi9/FLMh1h0Pd95ziNqoq7QOIsg04nl/ikk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITEC8VlA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITEC8VlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD13F1F00899;
	Wed, 20 May 2026 18:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303001;
	bh=g2Fb5oGUMNBuCb+Lk7/xS+j0EdcAEBaXnKYnJ+tXpuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITEC8VlAS2hdWfPAQz7REUSifmscMs7iodp/9mUeqgECBgiqog6YVv+zSafqYj5AI
	 oMxP3Mz62MyHtqDgmMxFMvBFkz9EmebBb1k02IAO/pozSISidcnP5+ZgziVEac1zgm
	 dhih/g+vbRH50nEZXi2/8hHdPic76tn6wo1gYesY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 439/508] Revert "crypto: nx - fix context leak in nx842_crypto_free_ctx"
Date: Wed, 20 May 2026 18:24:22 +0200
Message-ID: <20260520162108.112361389@linuxfoundation.org>
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

This reverts commit b94588f5a69718be2c942f4a851125f655e4e819.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 8b1dc05df8c8d..1f5005fcd69a9 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -115,7 +115,10 @@ void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
 	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
-		nx842_crypto_free_ctx(ctx);
+		kfree(ctx->wmem);
+		free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
+		free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
+		kfree(ctx);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -130,7 +133,6 @@ void nx842_crypto_free_ctx(void *p)
 	kfree(ctx->wmem);
 	free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
 	free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
-	kfree(ctx);
 }
 EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
 
-- 
2.53.0



