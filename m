Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCD02033A;
	Sun, 10 Aug 2025 16:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844745; cv=none; b=Ob34JW6aO9ORNuHPD3UDKQw5fVth6BLufjCAGdvj0v3vXuSPMm05u9pyCwisBPfEZPlHCfMfLZGFJlJt4788TjYyJTK8nJIqa2aiLxu4vGwxxa8FzSMeXLXJTiOJAIoapDx4wVJuCB09ZBJayH7GHzVm4TpvgLYfKpQXg9/JaLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844745; c=relaxed/simple;
	bh=WIncNRBKmIsfawt8Hd774U41ThLORcfYEtJyiVe/I/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WaJ1kuSxaMBYBpXmRkNksO99IJyFlwkfBSlKpRG2E2naM1VrFr+4dd4D1oG8z9nPU3lHAtA7wOF/aslaipI7Zf+AzM68WiPxtfncbLHF87zOwrHxxHkOE8/RRZ3Ir6Mc40zUQohy3dsZF2/V6hkOrEjedrPaTsxk2WO9gtuE88k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xr7qT1Do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xr7qT1Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ADBC4CEF0;
	Sun, 10 Aug 2025 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844744;
	bh=WIncNRBKmIsfawt8Hd774U41ThLORcfYEtJyiVe/I/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr7qT1DopRjpyJ1iHSUBnk63mb2yS8Ykobl237uNsMYqrC+icOP8xJYUzd93230q/
	 fRmpjD2jci26obchRDcs4WqGvy5nDJOhOv9iiVx6n7OcW3BYle9Rp5Qyn0xqUkDk5U
	 t+7ktksqOoSF9givctNSOcbQ45R99ezKa6CysV/WqOTRf+vSbHXRTr3oaO8fmUygXb
	 aJDxAJAJvZPhDeQDwKB7KvcAo6xVw+3AUIpxVJnz53W26mgKPcNjSWG3uDSoPirbXL
	 MWHAY0dSiugUOX/TMmUqfncR2RE7qMdTFreDiUY9y8A6O5f1FYpMKkEpuab/9+jPDk
	 6IFOebDfxhenQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sergey Bashirov <sergeybashirov@gmail.com>,
	Konstantin Evtushenko <koevtushenko@yandex.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16-5.4] pNFS: Fix uninited ptr deref in block/scsi layout
Date: Sun, 10 Aug 2025 12:51:50 -0400
Message-Id: <20250810165158.1888206-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 9768797c219326699778fba9cd3b607b2f1e7950 ]

The error occurs on the third attempt to encode extents. When function
ext_tree_prepare_commit() reallocates a larger buffer to retry encoding
extents, the "layoutupdate_pages" page array is initialized only after the
retry loop. But ext_tree_free_commitdata() is called on every iteration
and tries to put pages in the array, thus dereferencing uninitialized
pointers.

An additional problem is that there is no limit on the maximum possible
buffer_size. When there are too many extents, the client may create a
layoutcommit that is larger than the maximum possible RPC size accepted
by the server.

During testing, we observed two typical scenarios. First, one memory page
for extents is enough when we work with small files, append data to the
end of the file, or preallocate extents before writing. But when we fill
a new large file without preallocating, the number of extents can be huge,
and counting the number of written extents in ext_tree_encode_commit()
does not help much. Since this number increases even more between
unlocking and locking of ext_tree, the reallocated buffer may not be
large enough again and again.

Co-developed-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250630183537.196479-2-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Critical Bug Fix - Uninitialized Pointer Dereference

The commit fixes a **critical memory safety bug** - an uninitialized
pointer dereference in the pNFS block/SCSI layout code path. According
to the commit message, when `ext_tree_prepare_commit()` needs to retry
encoding extents (on the third attempt), it dereferences uninitialized
pointers in the `layoutupdate_pages` array.

## Specific Code Analysis

Looking at the original buggy code flow:

1. **Line 571 (old code)**: Has a `retry:` label for the retry loop
2. **Line 574**: Calls `ext_tree_free_commitdata()` on every retry
   iteration
3. **Line 579-583**: The `layoutupdate_pages` array is allocated AFTER
   entering the retry path
4. **Line 591**: `goto retry` sends execution back, but now
   `ext_tree_free_commitdata()` will try to access the uninitialized
   array

The fix removes the dangerous retry loop and replaces it with a single
retry attempt:
- Removes the `goto retry` pattern (line 591 deleted)
- Limits to one retry with proper initialization order
- Changes buffer size calculation to use `NFS_SERVER(arg->inode)->wsize`
  instead of unbounded growth

## Additional Security Issue Fixed

The commit also fixes a secondary but important issue: **unbounded
buffer growth**. The old code could create layoutcommit messages larger
than the server's maximum RPC size, potentially causing:
- Memory exhaustion on the client
- Server rejection of oversized RPCs
- Potential DoS conditions

## Stable Kernel Criteria Met

1. **Fixes a real bug**: Uninitialized pointer dereference that can
   cause kernel crashes
2. **Small and contained**: Changes are limited to one function in the
   pNFS subsystem
3. **Clear fix**: The solution is straightforward - remove the retry
   loop and properly order initialization
4. **No new features**: Pure bug fix, no functionality additions
5. **Low regression risk**: The fix simplifies the code path rather than
   adding complexity
6. **User impact**: Affects NFS users with pNFS block/SCSI layouts,
   particularly when writing large files

## Return Value Documentation

The commit also adds proper documentation for the return values,
changing the function to return the actual status rather than always
returning 0, which allows proper error handling upstream.

This is a textbook example of a commit that should be backported to
stable kernels - it fixes a memory safety bug that can cause kernel
crashes, with a minimal, well-understood fix.

 fs/nfs/blocklayout/extent_tree.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/blocklayout/extent_tree.c b/fs/nfs/blocklayout/extent_tree.c
index 8f7cff7a4293..0add0f329816 100644
--- a/fs/nfs/blocklayout/extent_tree.c
+++ b/fs/nfs/blocklayout/extent_tree.c
@@ -552,6 +552,15 @@ static int ext_tree_encode_commit(struct pnfs_block_layout *bl, __be32 *p,
 	return ret;
 }
 
+/**
+ * ext_tree_prepare_commit - encode extents that need to be committed
+ * @arg: layout commit data
+ *
+ * Return values:
+ *   %0: Success, all required extents are encoded
+ *   %-ENOSPC: Some extents are encoded, but not all, due to RPC size limit
+ *   %-ENOMEM: Out of memory, extents not encoded
+ */
 int
 ext_tree_prepare_commit(struct nfs4_layoutcommit_args *arg)
 {
@@ -568,12 +577,12 @@ ext_tree_prepare_commit(struct nfs4_layoutcommit_args *arg)
 	start_p = page_address(arg->layoutupdate_page);
 	arg->layoutupdate_pages = &arg->layoutupdate_page;
 
-retry:
-	ret = ext_tree_encode_commit(bl, start_p + 1, buffer_size, &count, &arg->lastbytewritten);
+	ret = ext_tree_encode_commit(bl, start_p + 1, buffer_size,
+			&count, &arg->lastbytewritten);
 	if (unlikely(ret)) {
 		ext_tree_free_commitdata(arg, buffer_size);
 
-		buffer_size = ext_tree_layoutupdate_size(bl, count);
+		buffer_size = NFS_SERVER(arg->inode)->wsize;
 		count = 0;
 
 		arg->layoutupdate_pages =
@@ -588,7 +597,8 @@ ext_tree_prepare_commit(struct nfs4_layoutcommit_args *arg)
 			return -ENOMEM;
 		}
 
-		goto retry;
+		ret = ext_tree_encode_commit(bl, start_p + 1, buffer_size,
+				&count, &arg->lastbytewritten);
 	}
 
 	*start_p = cpu_to_be32(count);
@@ -608,7 +618,7 @@ ext_tree_prepare_commit(struct nfs4_layoutcommit_args *arg)
 	}
 
 	dprintk("%s found %zu ranges\n", __func__, count);
-	return 0;
+	return ret;
 }
 
 void
-- 
2.39.5

