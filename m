Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574AE1E520;
	Tue, 27 Aug 2024 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771069; cv=none; b=jnRiMXLVjaAUEg6+ilvAtKHdGU9YE6ko69C5u1JBbyrnu/mATQB8O8Zd7t9fS2Fo56zcrce6+XRoUl5xTOsy3Y75ICuxq8KHMV7mE4PSNMOYsmfwF8aPTTSpm0yY31E0I+Ye4e/tY2bx8//i0meP8mxAa7eB+LLZ1ABgweeRqMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771069; c=relaxed/simple;
	bh=5XMbVOnzvnFnjc8IUewAj+HEz2XTgcny9Y7EqFV5mCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4t0hcf8POBwbiu1fK2rYwCZTYsD9/5XPs0/lV827Cr/jb61Amb3YSp3ziRPA+ycnG1Id2muKlPXmEjWbuUETpmQ3EduH9LI4W7M5jdGG0/yXtfEBCTYiUKzRaINWfofR1sLIb5beUpTQkmKlZIJEgCeC4RnjzWRLDE/HyIecQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jwg+UwCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jwg+UwCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFA7C6105B;
	Tue, 27 Aug 2024 15:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771069;
	bh=5XMbVOnzvnFnjc8IUewAj+HEz2XTgcny9Y7EqFV5mCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jwg+UwCG2BK+KAbt+51WBL59XfBokIYJsCMJWmT+2f3PMbvfhL5fSdTMPzNSkdCTq
	 YhxpWmluRJzPSdB7tayyv4iKaBTEYVSesLzoCgjGd4CcYCljDIx2NqX8t+QwOR9q3e
	 IH2eIO2IXq2E+0cgAe0ibJ/oUHWVqpXUJGCnaro4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 078/273] netfs: Fault in smaller chunks for non-large folio mappings
Date: Tue, 27 Aug 2024 16:36:42 +0200
Message-ID: <20240827143836.382152347@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 98055bc3595500bcf2126b93b1595354bdb86a66 ]

As in commit 4e527d5841e2 ("iomap: fault in smaller chunks for non-large
folio mappings"), we can see a performance loss for filesystems
which have not yet been converted to large folios.

Fixes: c38f4e96e605 ("netfs: Provide func to copy data to pagecache for buffered write")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20240527201735.1898381-1-willy@infradead.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index ecbc99ec7d367..18055c1e01835 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -184,7 +184,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 	unsigned int bdp_flags = (iocb->ki_flags & IOCB_NOWAIT) ? BDP_ASYNC : 0;
 	ssize_t written = 0, ret, ret2;
 	loff_t i_size, pos = iocb->ki_pos, from, to;
-	size_t max_chunk = PAGE_SIZE << MAX_PAGECACHE_ORDER;
+	size_t max_chunk = mapping_max_folio_size(mapping);
 	bool maybe_trouble = false;
 
 	if (unlikely(test_bit(NETFS_ICTX_WRITETHROUGH, &ctx->flags) ||
-- 
2.43.0



