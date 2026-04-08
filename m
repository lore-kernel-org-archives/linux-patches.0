Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4850B3D4134;
	Wed,  8 Apr 2026 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671869; cv=none; b=Nsmajkb5AcbKX5DApkJdAez8cRoMCFxJ/wUvjh5pRMDO6qB9ZsW02qWaLeBntjTSfHM/2huaQSQKGzcKtMUWylhE6p/KIA6IFlqvxeKFMCmGSxYhh77wu3Agc/u1ZxVEWlqNBF7sP3eKKiiguWuG6gK0HXsoZjCvhuTanL1Wzgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671869; c=relaxed/simple;
	bh=5GUarcnRb6NntIH3rcVHMoARE1x+pG/BzFUXYnbG9i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uL0+/xRFSSYkuzgXUqQuCfH/3ln9WyujNp7AsF7hRbu7mCtZpuPRmzunGVAKfHrwlXUjs86OT387tqAU7otbyZfevM3ZDMiJhEFkBmQXbNjgN+V8gSYIH7gQUWMtjYF0b/ynrRF6fjXY/R0Jvwx7snvp09kYc+A1EI1ohzBjgQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrtzS/A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrtzS/A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA1EC19425;
	Wed,  8 Apr 2026 18:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671869;
	bh=5GUarcnRb6NntIH3rcVHMoARE1x+pG/BzFUXYnbG9i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrtzS/A5xbUq+3Vbzj1YGFK/SaSvodzKiVRTEdnPkPiWS5bdChH7PDLUhk1e8MfHZ
	 LTaGaKuOMIh06/jETTRkwznG85Nn8WCQ/xGhtMpLE++XSRJgysD/polVb0OFQm5sPa
	 IcVqRZOhDB7nkdseFOu9HXIGjG6lQhjqOCKJtPTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.1 100/312] erofs: add GFP_NOIO in the bio completion if needed
Date: Wed,  8 Apr 2026 20:00:17 +0200
Message-ID: <20260408175937.500591859@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1259,6 +1259,7 @@ static void z_erofs_decompress_kickoff(s
 				       int bios)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(io->sb);
+	int gfp_flag;
 
 	/* wake up the caller thread for sync decompression */
 	if (io->sync) {
@@ -1277,7 +1278,9 @@ static void z_erofs_decompress_kickoff(s
 			sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 		return;
 	}
+	gfp_flag = memalloc_noio_save();
 	z_erofs_decompressqueue_work(&io->u.work);
+	memalloc_noio_restore(gfp_flag);
 }
 
 static struct page *pickup_page_for_submission(struct z_erofs_pcluster *pcl,


