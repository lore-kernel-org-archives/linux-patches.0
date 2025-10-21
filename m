Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4A272E7C;
	Tue, 21 Oct 2025 19:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076443; cv=none; b=mOjcCL5/M3MMgUODrPIccsiHA7emEJkjBa/yGUh2soIrKucBbu4hG8thnnq3nxgJuL9GYmSKiDSO4eNVKbpZ8PZnD6tttMt2EjE4yjMTsVTDAea6yV1iwdwdpXmreFPgN+YSXYhVRogBfKxebaDX+yg6wbajXcNVulZLWtSZP5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076443; c=relaxed/simple;
	bh=REbb3oDmQUByAepH++HGUCoNKM6QK4G8L5mXdQv/DOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZulSUIQp8j0NCDWWlydOsaFsMxfP7LS/fg/qWrMLRXcmZdzb1OAb1q/3VomTCTGwG++R8FmxE6bnyij54w3tgbkgXfJwwAkPsr4k1q+iIrCxEd0qd79Tp/2crKW7HBk1CGgJp3clS2UcCGIU+gfUSCV5lZIhREt5p7REs0mzBRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fs2sjphP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fs2sjphP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E568C4CEF5;
	Tue, 21 Oct 2025 19:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076440;
	bh=REbb3oDmQUByAepH++HGUCoNKM6QK4G8L5mXdQv/DOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fs2sjphPPrm0aS34GlcKNwAwYTihZs/tnhxXGcoYbtbIl9Ps5pfNqAAlS7PBmnq+X
	 TPkC6Zba7a4HIjCO8ponkK4N/Fyq95b/CHpwgPv78FbpRcLUMJ8gNvVuB75VU+MW8z
	 p//XSKlV5B6nFOhRlR4WrbJCjMRU1tM5J0i+dhns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 008/105] btrfs: fix clearing of BTRFS_FS_RELOC_RUNNING if relocation already running
Date: Tue, 21 Oct 2025 21:50:17 +0200
Message-ID: <20251021195021.689783065@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 7e5a5983edda664e8e4bb20af17b80f5135c655c upstream.

When starting relocation, at reloc_chunk_start(), if we happen to find
the flag BTRFS_FS_RELOC_RUNNING is already set we return an error
(-EINPROGRESS) to the callers, however the callers call reloc_chunk_end()
which will clear the flag BTRFS_FS_RELOC_RUNNING, which is wrong since
relocation was started by another task and still running.

Finding the BTRFS_FS_RELOC_RUNNING flag already set is an unexpected
scenario, but still our current behaviour is not correct.

Fix this by never calling reloc_chunk_end() if reloc_chunk_start() has
returned an error, which is what logically makes sense, since the general
widespread pattern is to have end functions called only if the counterpart
start functions succeeded. This requires changing reloc_chunk_start() to
clear BTRFS_FS_RELOC_RUNNING if there's a pending cancel request.

Fixes: 907d2710d727 ("btrfs: add cancellable chunk relocation support")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3877,6 +3877,7 @@ out:
 /*
  * Mark start of chunk relocation that is cancellable. Check if the cancellation
  * has been requested meanwhile and don't start in that case.
+ * NOTE: if this returns an error, reloc_chunk_end() must not be called.
  *
  * Return:
  *   0             success
@@ -3893,10 +3894,8 @@ static int reloc_chunk_start(struct btrf
 
 	if (atomic_read(&fs_info->reloc_cancel_req) > 0) {
 		btrfs_info(fs_info, "chunk relocation canceled on start");
-		/*
-		 * On cancel, clear all requests but let the caller mark
-		 * the end after cleanup operations.
-		 */
+		/* On cancel, clear all requests. */
+		clear_and_wake_up_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags);
 		atomic_set(&fs_info->reloc_cancel_req, 0);
 		return -ECANCELED;
 	}
@@ -3905,9 +3904,11 @@ static int reloc_chunk_start(struct btrf
 
 /*
  * Mark end of chunk relocation that is cancellable and wake any waiters.
+ * NOTE: call only if a previous call to reloc_chunk_start() succeeded.
  */
 static void reloc_chunk_end(struct btrfs_fs_info *fs_info)
 {
+	ASSERT(test_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags));
 	/* Requested after start, clear bit first so any waiters can continue */
 	if (atomic_read(&fs_info->reloc_cancel_req) > 0)
 		btrfs_info(fs_info, "chunk relocation canceled during operation");
@@ -4119,9 +4120,9 @@ out:
 	if (err && rw)
 		btrfs_dec_block_group_ro(rc->block_group);
 	iput(rc->data_inode);
+	reloc_chunk_end(fs_info);
 out_put_bg:
 	btrfs_put_block_group(bg);
-	reloc_chunk_end(fs_info);
 	free_reloc_control(rc);
 	return err;
 }
@@ -4311,8 +4312,8 @@ out_clean:
 		err = ret;
 out_unset:
 	unset_reloc_control(rc);
-out_end:
 	reloc_chunk_end(fs_info);
+out_end:
 	free_reloc_control(rc);
 out:
 	free_reloc_roots(&reloc_roots);


