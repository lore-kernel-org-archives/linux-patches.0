Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F93E2080C0;
	Tue, 12 Aug 2025 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021704; cv=none; b=fd8tmZmkyJs25Mvl6oDreZVW93TeXeSKqQzNRo3qN4e1XXKRL5ipqhIwlxGoE6BlulU5nUKALbV5bsBkRliIm1AAaEGrKwdmRvy48Yi7yJZ7f0XpWb/9BmoKtMs5cX4uAElX/KrUlCIvv1goWOp71A7Q4Gfq8wAPPAb/M5+uG+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021704; c=relaxed/simple;
	bh=GbGK+9HrE0ny58NHLmx0IOz2DhHIevVrMDOiYPF0LfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5py6AyNiv0Nzn30Fu7YeVimu7YmimUhewkNeaieTE9N5DNrYIJjJTHIGbkmhYxaVGQz0mYtWLB5/JgfGIe/IzobvJ2MmhY+suilL0D9jjS+OXjnosCnSiX3/LSZTPYIF0bEgb9XkfpOaVegyD1KscRjgGbHfC01dWsv8sFMYn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMgN2+Zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMgN2+Zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B107EC4CEF0;
	Tue, 12 Aug 2025 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021704;
	bh=GbGK+9HrE0ny58NHLmx0IOz2DhHIevVrMDOiYPF0LfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMgN2+ZmPYOaRP+dm7WTHHswpNPhEj7mdrxb+klHdgp7ww5ueCmkqkAtHoYshYMU5
	 g+3qKRHK8ArRQtQlAnsHoTRS468kudFeldZCY+Vd3UQiHhXa0r8cgqPcrDf2WxUTl3
	 UpdLIqRPWvZrtGo+Y256WU3mmXopf4Ptxb8buKNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/262] NFS: Fixup allocation flags for nfsiods __GFP_NORETRY
Date: Tue, 12 Aug 2025 19:29:49 +0200
Message-ID: <20250812173001.719538935@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 99765233ab42bf7a4950377ad7894dce8a5c0e60 ]

If the NFS client is doing writeback from a workqueue context, avoid using
__GFP_NORETRY for allocations if the task has set PF_MEMALLOC_NOIO or
PF_MEMALLOC_NOFS.  The combination of these flags makes memory allocation
failures much more likely.

We've seen those allocation failures show up when the loopback driver is
doing writeback from a workqueue to a file on NFS, where memory allocation
failure results in errors or corruption within the loopback device's
filesystem.

Suggested-by: Trond Myklebust <trondmy@kernel.org>
Fixes: 0bae835b63c5 ("NFS: Avoid writeback threads getting stuck in mempool_alloc()")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/f83ac1155a4bc670f2663959a7a068571e06afd9.1752111622.git.bcodding@redhat.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index c29ad2e1d416..8870c72416ac 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -613,9 +613,12 @@ nfs_write_match_verf(const struct nfs_writeverf *verf,
 
 static inline gfp_t nfs_io_gfp_mask(void)
 {
-	if (current->flags & PF_WQ_WORKER)
-		return GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
-	return GFP_KERNEL;
+	gfp_t ret = current_gfp_context(GFP_KERNEL);
+
+	/* For workers __GFP_NORETRY only with __GFP_IO or __GFP_FS */
+	if ((current->flags & PF_WQ_WORKER) && ret == GFP_KERNEL)
+		ret |= __GFP_NORETRY | __GFP_NOWARN;
+	return ret;
 }
 
 /*
-- 
2.39.5



