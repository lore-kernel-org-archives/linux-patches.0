Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C55727AC5C;
	Tue, 21 Oct 2025 20:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077183; cv=none; b=bUZVlbveCBIIYVJ8LOGRnWwHZSROGZLyp4zXecUmuTsaYuxQu+cZHP+VsBZR/M1/neWergq3uGWh470vpJcbHuEoZSlUhnaQwgzS0EnqpwxDPFgDrb8oV2BOc/jcWDj4FxI75CiX2B6rePQD16HXkbUyo+2wk2pD5PmG9idSn1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077183; c=relaxed/simple;
	bh=BaNg0Nocoj3jrfRkPs8rniEg63J2anS9hGK4v2GCy+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7GHEMOAg8NQ1eKWBfSuecc2ldyXmuOX8DCle4TZ4+oZSmXtZUlOAFtQw6dRNnQI1jlb6V8+Kc0LzLmIY69H9IPrb1NiCsc/M6IKuUB05wAQ3DxxvXN7FVzXN3cW72X6Q1LBAE/w3bVjUqIfM9R/vDENkEOiDxKjIXjgJMW1yL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfPs3THe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfPs3THe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD17C4CEF1;
	Tue, 21 Oct 2025 20:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077183;
	bh=BaNg0Nocoj3jrfRkPs8rniEg63J2anS9hGK4v2GCy+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfPs3THeE9E/kd3a6a7rlPZbKgV+GSeep8Z38tJQeyn24GpiSUR9rPCoAJHhv7omM
	 6q83FUY6uCWYgCp/Amr7zYsC82+nsJ4+pe++iDNMBZX98+I8JgDN0mIwB29Bjqh4Eb
	 UIhwHP0mEA9AvXjeqTmSj0IyLgYzQD2nA1LmUec4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 025/159] btrfs: fix clearing of BTRFS_FS_RELOC_RUNNING if relocation already running
Date: Tue, 21 Oct 2025 21:50:02 +0200
Message-ID: <20251021195043.795192936@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3795,6 +3795,7 @@ out:
 /*
  * Mark start of chunk relocation that is cancellable. Check if the cancellation
  * has been requested meanwhile and don't start in that case.
+ * NOTE: if this returns an error, reloc_chunk_end() must not be called.
  *
  * Return:
  *   0             success
@@ -3811,10 +3812,8 @@ static int reloc_chunk_start(struct btrf
 
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
@@ -3823,9 +3822,11 @@ static int reloc_chunk_start(struct btrf
 
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
@@ -4038,9 +4039,9 @@ out:
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
@@ -4223,8 +4224,8 @@ out_clean:
 		ret = ret2;
 out_unset:
 	unset_reloc_control(rc);
-out_end:
 	reloc_chunk_end(fs_info);
+out_end:
 	free_reloc_control(rc);
 out:
 	free_reloc_roots(&reloc_roots);


