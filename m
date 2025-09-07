Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3D64315A;
	Sun,  7 Sep 2025 20:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277632; cv=none; b=KI2027uiC1MM1t1jKsY2WM7VzbtNjo0Vkx54Y8hAiMLXpCkWaqtUZKB7uheE77S2tmWjPz7/jJ0k6xLqi/+388JcD/GXSqwns3KtwpoSTNbyFmzfh11nHmFO37K/FCVZXAZaPZiyLVTBd7M2b5HYL5QcFM5APJnQAwa80N/SVyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277632; c=relaxed/simple;
	bh=tvRKgfKvmpvB97TGNLN/VaoHj91UqLWc73HxXu6jf7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGtlb5vortkiIlOCIFuVVfbqu6ZAoVkzBv9mUQ1QBkYw6K/hNZdUwzCg3qL2LvjDCo8/qUUPKmI5Q9BOvxnauy46xFaDWt5T3+Ve2FXPvoPnhgqx7j5bI8F5oRueOu7xQ2Nw3P7ekEpIwpwGbaB5+dYmz7pTn7J5ZaunWGPtBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soWQtFsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soWQtFsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6511AC4CEF0;
	Sun,  7 Sep 2025 20:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277631;
	bh=tvRKgfKvmpvB97TGNLN/VaoHj91UqLWc73HxXu6jf7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soWQtFsJEc1boThY47pjvTYy5YfunnBCs/3eDVDqBJ6X8a8gsbdTCb4gdSYSKIKK9
	 2OleDirzzB5Fz+u9CnBOMMqyH9tTpDpHguY4XeJcltDW4n12iKS7YIp9I6LeYMRkJr
	 ChxuWIvHOyjOhrw++qypsvL7PNNudOdbJpnEhDKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 020/183] tee: fix memory leak in tee_dyn_shm_alloc_helper
Date: Sun,  7 Sep 2025 21:57:27 +0200
Message-ID: <20250907195616.261915005@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 50a74d0095cd23d2012133e208df45a298868870 ]

When shm_register() fails in tee_dyn_shm_alloc_helper(), the pre-allocated
pages array is not freed, resulting in a memory leak.

Fixes: cf4441503e20 ("tee: optee: Move pool_op helper functions")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_shm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 915239b033f5f..2a7d253d9c554 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -230,7 +230,7 @@ int tee_dyn_shm_alloc_helper(struct tee_shm *shm, size_t size, size_t align,
 	pages = kcalloc(nr_pages, sizeof(*pages), GFP_KERNEL);
 	if (!pages) {
 		rc = -ENOMEM;
-		goto err;
+		goto err_pages;
 	}
 
 	for (i = 0; i < nr_pages; i++)
@@ -243,11 +243,13 @@ int tee_dyn_shm_alloc_helper(struct tee_shm *shm, size_t size, size_t align,
 		rc = shm_register(shm->ctx, shm, pages, nr_pages,
 				  (unsigned long)shm->kaddr);
 		if (rc)
-			goto err;
+			goto err_kfree;
 	}
 
 	return 0;
-err:
+err_kfree:
+	kfree(pages);
+err_pages:
 	free_pages_exact(shm->kaddr, shm->size);
 	shm->kaddr = NULL;
 	return rc;
-- 
2.50.1



