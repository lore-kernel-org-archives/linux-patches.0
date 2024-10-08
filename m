Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E3B165F08;
	Tue,  8 Oct 2024 12:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389758; cv=none; b=j3OeD4QF7X2fLl07zJQBIbx61AsQZY8uxS50zf5WTQ+VXFCqCYJPuIiYIdtGr37Kx7EPi7XpYyg6sQ2D8UhAHctlwEFrs41kN2jSr/nXiGZJXkobmOAclWzsnp+gMF/RkcLczPaNCum/AzMlVV2Nf8QmHCiUl0knUI6KDiNs+rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389758; c=relaxed/simple;
	bh=Yhzj+bp7VIa0EAAk9UY/24C/tIMgfxYuFdXlQgmSSvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWiGQ0ToAE2UbmKMR8HPyTGeK0IwYQwRdKdje0jYZaRTOwUjqU4uTshjQyep6Ch9l2KDlHLwm7kHMAGTqJBFHwjfV4TeqE/+01luVQqJDa0TFMwGVYZPYzkC0akvL2/KXUr6UNBZlzbKtiJELAT+z0zx2nLmuHf3sKbL06IS4Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHUOs1TA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHUOs1TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2B6C4CEC7;
	Tue,  8 Oct 2024 12:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389758;
	bh=Yhzj+bp7VIa0EAAk9UY/24C/tIMgfxYuFdXlQgmSSvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHUOs1TA4fDvGUiLamVi/MyPzKdP3fwWe72Vb69Yi5VtIQnW6OLlyytQl2TPvvxnv
	 BBWKCYeP+tKNbPJ994Aeq6LLpJ/yhzadR8TMsfHrfhSSp2XX7SnrsALUKNCruROlg3
	 WTP+faDlB4ZCBmhIzViKgF7akUhH4Dq1wdQgvh8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 056/482] io_uring: fix memory leak when cache init fail
Date: Tue,  8 Oct 2024 14:01:59 +0200
Message-ID: <20241008115650.511617294@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 3a87e264290d71ec86a210ab3e8d23b715ad266d ]

Exit the percpu ref when cache init fails to free the data memory with
in struct percpu_ref.

Fixes: 206aefde4f88 ("io_uring: reduce/pack size of io_ring_ctx")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20240923100512.64638-1-kanie@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c0d8ee0c9786d..ff243f6b51199 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -316,7 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct uring_cache));
 	ret |= io_futex_cache_init(ctx);
 	if (ret)
-		goto err;
+		goto free_ref;
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -344,6 +344,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_napi_init(ctx);
 
 	return ctx;
+
+free_ref:
+	percpu_ref_exit(&ctx->refs);
 err:
 	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
-- 
2.43.0



