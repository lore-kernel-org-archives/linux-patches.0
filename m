Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897EF435A96;
	Tue, 21 Jul 2026 20:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665213; cv=none; b=VfKWcZnRI+dn8Q190vIspMytSOIv0i0lu6jEFLp67JlEiIABbGV/CVt17Sc7OEdAuBHOKNAEoAbcahzG0SBMuPnLSjoK07xJD5bHgpCHRk5aTcP0fVT5Ccxev2EipeedDy9EseRsMT+y+rwvd+G9LyPXgEI6x5JJqbE5tfh1fUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665213; c=relaxed/simple;
	bh=RzwaLP+4WoQOrixveEgN7BcUpo/9sNa5Gqw5+RVhI48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qj52nocebuVbJjxZX0YgpC4mCUHPa4MSpImmJL1jIUVPQIpzK5pWnyzPEBRtFh/zJ41BmqB+I+akxfNJ1buHtzpX0Qlfm37lXpmpY054xhmBozNUWyw6ERR6qrSyejc2BMbRZRrp8Y0xk/TgGJfE+N5qDxA6U2dZsuk6j6zKQa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYMfyy2u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYMfyy2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47221F000E9;
	Tue, 21 Jul 2026 20:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665212;
	bh=1EsnxWfUupauL4DEInihh3Ab0awvc6ZOw6ztklBe9W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYMfyy2uoSQziwJPEiQzapm/LnMOPVj3/F0/wRER2REOoCoEVJ16H4jrtTy8m1Xv1
	 L/v1S3Yy446p87T2CTgLqRb+sk/vFPy4UrbVsl3y21Q+ulC1Rkyy5p3zHGBaRlqPP9
	 VlscGKVGScyzPq6fkEt7svgwhcqESByT2UgYnQLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 6.6 0218/1266] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range segment numbers
Date: Tue, 21 Jul 2026 17:10:55 +0200
Message-ID: <20260721152446.697309623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 0e7a690fe435f8d5ea3feb7c1d8d73ba7e8b8aa9 upstream.

Syzbot reported a hung task in nilfs_transaction_begin() where multiple
tasks performing chmod() on a nilfs2 mount blocked for over 143 seconds
waiting to acquire ns_segctor_sem for read:

  INFO: task syz.0.17:5918 blocked for more than 143 seconds.
  Call Trace:
   schedule+0x164/0x360
   rwsem_down_read_slowpath+0x6d9/0x940
   down_read+0x99/0x2e0
   nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
   nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
   notify_change+0xc1a/0xf40
   chmod_common+0x273/0x4a0
   do_fchmodat+0x12d/0x230

The writer holding ns_segctor_sem was a concurrent
NILFS_IOCTL_CLEAN_SEGMENTS caller, stuck inside printk while emitting
per-element warnings from nilfs_sufile_updatev():

   __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
   nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
   nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
   nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
   nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
   nilfs_segctor_do_construct+0x1f55/0x76c0
   nilfs_clean_segments+0x3bd/0xa50
   nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
   nilfs_ioctl+0x261f/0x2780

The root cause is that user-supplied segment numbers are not validated
before nilfs_clean_segments() begins doing work; the range check on
each segnum is performed deep inside the call chain by
nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
while still holding the segctor lock and the sufile mi_sem.  Under load
(repeated invocations across multiple mounts saturating the global
printk path), the cumulative printk latency keeps ns_segctor_sem held
long enough to trip the hung_task watchdog, blocking concurrent
operations such as chmod() that need ns_segctor_sem for read.

Fix by validating the contents of kbufs[4] in nilfs_clean_segments()
immediately after acquiring ns_segctor_sem via nilfs_transaction_lock().
Holding ns_segctor_sem serializes the check against
nilfs_ioctl_resize(), which can modify ns_nsegments, so the validation
uses a consistent value.  Out-of-range segment numbers are rejected
with -EINVAL before any segment-cleaning work begins, so the bad
entries never reach the per-element diagnostic path inside
nilfs_sufile_updatev().

Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=62f0f99d2f2bb8e3bbd7
Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Fixes: 071cb4b81987 ("nilfs2: eliminate removal list of segments")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2504,12 +2504,33 @@ int nilfs_clean_segments(struct super_bl
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info ti;
 	int err;
+	size_t i, nfreesegs = argv[4].v_nmembs;
+	__u64 *segnumv = kbufs[4];
 
 	if (unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 1);
 
+	/*
+	 * Validate segment numbers under ns_segctor_sem (held for write
+	 * by nilfs_transaction_lock above) so the check is serialized
+	 * against nilfs_ioctl_resize(), which can modify ns_nsegments.
+	 * Rejecting bad input here, before any segment-cleaning work
+	 * begins, avoids the per-element diagnostic path inside
+	 * nilfs_sufile_updatev() that would otherwise run under this
+	 * same lock and stall concurrent readers.
+	 */
+	for (i = 0; i < nfreesegs; i++) {
+		if (segnumv[i] >= nilfs->ns_nsegments) {
+			nilfs_err(sb,
+				 "Segment number %llu to be freed is out of range",
+				 (unsigned long long)segnumv[i]);
+			err = -EINVAL;
+			goto bail_unlock;
+		}
+	}
+
 	err = nilfs_mdt_save_to_shadow_map(nilfs->ns_dat);
 	if (unlikely(err))
 		goto out_unlock;
@@ -2550,6 +2571,7 @@ int nilfs_clean_segments(struct super_bl
 	sci->sc_freesegs = NULL;
 	sci->sc_nfreesegs = 0;
 	nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
+ bail_unlock:
 	nilfs_transaction_unlock(sb);
 	return err;
 }


