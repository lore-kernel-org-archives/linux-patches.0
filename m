Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E76280037;
	Tue, 12 Aug 2025 18:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022993; cv=none; b=egUhZ69zhGxf4IutIsO/8Zb1pyLV+00E2ydDB9jBsetxe0b8LDV18/oSK2fetNz7I/PpC+loXpEfKn2BLPDW7V1m7nB2M2nRDkbttjd+BF2Vi7f57k8qhTngYxdGL2bkZx0iV01TAzC64VAAn1WniXqc2X7b3l9fV5BB/1iYXL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022993; c=relaxed/simple;
	bh=R4XMtiUBmd+f/3rXn+b6vPn1rtOhWyhjUp1KQrxtsfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJItCuFKdYbNommgvgajj0jfuvN/Gl/FWqkxteP9bifDL30GnMrN4hlLlrb2PhiRsq3fYWXPE3e1M1ENdpej3oKkcxqHt1KN0JfnII3RxZqO+bFB4SSgEbbP+E5Bd6RKSXjSAT9psoJxxqlMnjIekbn2hO9h28/SfZV7Ma5+o1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bH4SWIzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bH4SWIzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EA6C4CEF6;
	Tue, 12 Aug 2025 18:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022993;
	bh=R4XMtiUBmd+f/3rXn+b6vPn1rtOhWyhjUp1KQrxtsfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bH4SWIzlHsHtcdkbCBRkb6FE47G7KI5fBewrqfHG3RuBf6FispwF83btRNo+1pMh+
	 hwq4QKKGq8EzcllPo46rihiNl9DoMRY4WNjb2hYJbuSA09VKNQaI30yFcpzCFGJntW
	 Q1koZQSiWneIJ1Le5jMJlKJ2LJk1gIuIB+7m4DRA=
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
Subject: [PATCH 6.12 285/369] NFS: Fixup allocation flags for nfsiods __GFP_NORETRY
Date: Tue, 12 Aug 2025 19:29:42 +0200
Message-ID: <20250812173027.443917666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1be4be3d4a2b..9840b779f0df 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -668,9 +668,12 @@ nfs_write_match_verf(const struct nfs_writeverf *verf,
 
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



