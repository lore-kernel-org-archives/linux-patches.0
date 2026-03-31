Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87083016EE;
	Tue, 31 Mar 2026 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976820; cv=none; b=VZDpYfC+W/Rfknp2dK4HmzZjKgc5JysK/g59VPLPMUTasCCV3fQnqXnO6OMOe4jJOhv42EJjXuIfzA6n2Y1KU1QxBqgT6GFhpEtOIhWJNIBbWhpFKctuNdNLBRCU5rsYGthHQVw/g35eOoKJZ4ZX/RSYzVSllzc5Fr5WpEfzZ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976820; c=relaxed/simple;
	bh=ewmBQ9gGBt27Fuk/U7ilyzhrU+1KmOqyPT3eqpnpdTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2272J4UAfDJCyViuzCbGo7VEnopv9XH98cEOl0Fq/tyFbiFTpMm8VHvlop6bNFHUXLLDmELnKFjeC7Tz1QAnyhAvYKlLlQ9mysV97ASmO7Jejn4CFmHbQVk05P7t5bDfPg5wXQmk2vuu7cXsdjUEu3I5xJBcOExhqBqLREyEHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DV8kX/f0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DV8kX/f0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BC1C19423;
	Tue, 31 Mar 2026 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976820;
	bh=ewmBQ9gGBt27Fuk/U7ilyzhrU+1KmOqyPT3eqpnpdTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DV8kX/f06nEY8qV5NwldEhOzx/u9P5dCws4VnvSmDauKeqaQsu2aP+GBQvkygu5Hb
	 ueeubEGkweOQs7+TkMrnXtgECOejF8ecICj63Jtzoca2nN0wRxfL9bmqOdhjWtOLvO
	 pmfmIVO1qtEty03U4LqpMxJlB4D8nHEi+UY2NCC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.18 208/309] erofs: add GFP_NOIO in the bio completion if needed
Date: Tue, 31 Mar 2026 18:21:51 +0200
Message-ID: <20260331161801.105297713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1445,6 +1445,7 @@ static void z_erofs_decompress_kickoff(s
 				       int bios)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(io->sb);
+	int gfp_flag;
 
 	/* wake up the caller thread for sync decompression */
 	if (io->sync) {
@@ -1477,7 +1478,9 @@ static void z_erofs_decompress_kickoff(s
 			sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 		return;
 	}
+	gfp_flag = memalloc_noio_save();
 	z_erofs_decompressqueue_work(&io->u.work);
+	memalloc_noio_restore(gfp_flag);
 }
 
 static void z_erofs_fill_bio_vec(struct bio_vec *bvec,


