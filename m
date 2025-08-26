Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CFB352FDA;
	Tue, 26 Aug 2025 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217601; cv=none; b=lKzvPHa/qxZI79PZiJI5OvtXmSIuEAG77l1Rfktj2pyR4WBgcyX1tJAzxWLega0U4o1hfx24qDJKKBHpKWY/oIetrVZlNu7hdo5LpmvTEmTMUt02898uP21CVjdj1nZ/BPJt3ZSH4NmwRdA+MWNklqH+oQYSkEBYVWSnFA6RZM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217601; c=relaxed/simple;
	bh=tt0MHI3i+FpcP7JRbKk7gftxqgfWM1zxXBf8jF7xPio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsLfTe85CHf7aDZbuQHO2cMmtrOON4lEMNzTYjIZBCrG/89OqN+88NVfnn/wOfuZzLPsDePuYcYvHJaJoL/yWfYXsZhYS6rE3xaYm0vOPBh9gzMGtNhfpP6UpALryD0pJcd4DoS6jNMbcR/DguYMkJGcG5S67N/l2+LZagw3OM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1O+C69F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1O+C69F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97B6C113CF;
	Tue, 26 Aug 2025 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217601;
	bh=tt0MHI3i+FpcP7JRbKk7gftxqgfWM1zxXBf8jF7xPio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1O+C69F8xmxB5Ms6ZkTC9p3/+B/1WMo0nviJAAvOva/U5FEPzyCeFdMyqAxatzLA
	 GsHzSVvoTEvKkRC5WyEPhB0bD0kBBnGrZq4iNte8qZRKKDKAlPa83B8oRTdpVvXmb8
	 7C40oQrM371PViSvpRrpahcNFbLudnERen3sZnWM=
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
Subject: [PATCH 5.10 173/523] NFS: Fixup allocation flags for nfsiods __GFP_NORETRY
Date: Tue, 26 Aug 2025 13:06:23 +0200
Message-ID: <20250826110928.730967898@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2fdc7c2a17fe..8af263a30fc0 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -588,9 +588,12 @@ nfs_write_match_verf(const struct nfs_writeverf *verf,
 
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
 
 /* unlink.c */
-- 
2.39.5



