Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B275F423A61;
	Tue, 31 Mar 2026 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974602; cv=none; b=JOQEJBHvw+ENon8Z3/0IdE7SFGkjwgJkwHCwoMcJgkNcsNrRqf+WZzXQg26us74Zbk5X2CdAr4+TmhbsK8r27jlbjg2kFkZrB8GjZiIQJcVV1NSCgUMT36WFzrg4oml2YEOOigVBwQbMDd3E+20vkqLDeVF26GT8Ta3CSAui3r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974602; c=relaxed/simple;
	bh=lNym5ItBn+8Y7tGRvXcD5aaO7S8YzVEg+nws2WiBPmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gju8/VK0esIAs3JINZOfYQGxyQ/aJoHRgpRKDII6mqsQi10XOoZpN/I6wsbyQ0VEJbHbAhIp7tdY7K6OBujhr9wLGn8KFdqdJD3IG9BynnYm3vjhy8okrBtGkbWUym1n1YiKZjgWlgsX3o4x+J22hZJT7XH+rLTeyAswLsyhE9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBcvekHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBcvekHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80E7C19424;
	Tue, 31 Mar 2026 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974602;
	bh=lNym5ItBn+8Y7tGRvXcD5aaO7S8YzVEg+nws2WiBPmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBcvekHFjrgpNXNpev0nxj8uOBPgEBv8nzNBuOyeLNfLv+ZL6QetcEx9sNndR6/nn
	 Fs5O+DQX8gZZnM31F4Fpzzjs0GOtLb9sj663oK3MD+P2mLVUbc2xFKI0ciVENQ/Mx7
	 sY7pfSJCdv2CwzHtJwGKDQRj+835jp8fniGb78C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.6 116/175] erofs: add GFP_NOIO in the bio completion if needed
Date: Tue, 31 Mar 2026 18:21:40 +0200
Message-ID: <20260331161734.043763834@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Jiucheng Xu <jiucheng.xu@amlogic.com>

commit c23df30915f83e7257c8625b690a1cece94142a0 upstream.

The bio completion path in the process context (e.g. dm-verity)
will directly call into decompression rather than trigger another
workqueue context for minimal scheduling latencies, which can
then call vm_map_ram() with GFP_KERNEL.

Due to insufficient memory, vm_map_ram() may generate memory
swapping I/O, which can cause submit_bio_wait to deadlock
in some scenarios.

Trimmed down the call stack, as follows:

f2fs_submit_read_io
  submit_bio                      //bio_list is initialized.
    mmc_blk_mq_recovery
      z_erofs_endio
        vm_map_ram
          __pte_alloc_kernel
            __alloc_pages_direct_reclaim
              shrink_folio_list
                __swap_writepage
                  submit_bio_wait  //bio_list is non-NULL, hang!!!

Use memalloc_noio_{save,restore}() to wrap up this path.

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zdata.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1415,6 +1415,7 @@ static void z_erofs_decompress_kickoff(s
 				       int bios)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(io->sb);
+	int gfp_flag;
 
 	/* wake up the caller thread for sync decompression */
 	if (io->sync) {
@@ -1447,7 +1448,9 @@ static void z_erofs_decompress_kickoff(s
 			sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 		return;
 	}
+	gfp_flag = memalloc_noio_save();
 	z_erofs_decompressqueue_work(&io->u.work);
+	memalloc_noio_restore(gfp_flag);
 }
 
 static struct page *pickup_page_for_submission(struct z_erofs_pcluster *pcl,


