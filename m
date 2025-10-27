Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3917C32E72F;
	Mon, 27 Oct 2025 19:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591863; cv=none; b=ujmWXIWN5AW39zCRtzXb19KUvLnUaiaOe5Iv4N4xuP7Pv5ZPrvMeVg2qBdgvyhx6nyGQOK27S7JdqCadc1neFwIBeY8PcP5C+VBfoWH1a1DG5CAL8zCNWTfrDaXS6937LL/NeT3sZMnt8J8LB5IbL7S0QcJSghBY9IHLKPzTH4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591863; c=relaxed/simple;
	bh=eRnOXPbwLGgsjLxpnm/jl61Qp0IgIdd2AMrlImhl2zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJmfjV74FReGPfwYSvJhEH1LEYZH4PfHFn3M9nAGci6YFDf5U3XjMp0t1d5OH/O2TRKSBq7VnGb9MbL7thnJp3IfEL5GRzohPpcZV7jMGGp3qNFeH2EpCpcUFBMY8XJH/5MImAIR1AcFcFKfMFCy6INYcxqNgrNFT/oDgzVpyDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4gMekmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4gMekmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA70C4CEF1;
	Mon, 27 Oct 2025 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591862;
	bh=eRnOXPbwLGgsjLxpnm/jl61Qp0IgIdd2AMrlImhl2zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4gMekmZcduNMl3B5ureJuFnZ/D3KB6tvjPIChSFg3SZ/28OpE9EYOU6OtqyC8Xc9
	 9XwTdePRMFEDd2rGpNUxVtsj0uhxsm5mzHlmIW8HyDtmeeJdU+8qhm3zLq4MslxgLI
	 PkYUmCCJRwPXSORv2lE6Auopy0B2mi4DKxDcHaIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 004/123] btrfs: fix clearing of BTRFS_FS_RELOC_RUNNING if relocation already running
Date: Mon, 27 Oct 2025 19:34:44 +0100
Message-ID: <20251027183446.507216637@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3915,6 +3915,7 @@ out:
 /*
  * Mark start of chunk relocation that is cancellable. Check if the cancellation
  * has been requested meanwhile and don't start in that case.
+ * NOTE: if this returns an error, reloc_chunk_end() must not be called.
  *
  * Return:
  *   0             success
@@ -3931,10 +3932,8 @@ static int reloc_chunk_start(struct btrf
 
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
@@ -3943,9 +3942,11 @@ static int reloc_chunk_start(struct btrf
 
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
@@ -4144,9 +4145,9 @@ out:
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
@@ -4337,8 +4338,8 @@ out_clean:
 		err = ret;
 out_unset:
 	unset_reloc_control(rc);
-out_end:
 	reloc_chunk_end(fs_info);
+out_end:
 	free_reloc_control(rc);
 out:
 	free_reloc_roots(&reloc_roots);


