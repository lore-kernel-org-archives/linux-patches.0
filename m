Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053B13D75D3;
	Wed, 20 May 2026 17:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298634; cv=none; b=QyAZJmgryjJrR8LPKHWeYKqZpp8H3N4GCPpZZmuG6dxGvRXvVsBTQhsIqQNL6WCz9+QT9qgypL1z+LFPInJqqsXq4wxAYjZh1RgtksR/+nyrBAOvOhlpywC7EW/VUhhQOaBIRILbzrO6LD927dlcBglGkLvgs8YANVmp+/SGN88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298634; c=relaxed/simple;
	bh=TXs0R0Y0JKI7aAMGAKCCiqNhXxcg/nAvOLeuH4GeBu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIFzouCXeFQvlwzBpXrM/HmkNs7iKGjGiCQo30BaE3IeMBvpJVuegSv4BtxUo7i3mZiGzmQmmGtkMrMKA7WHGVpWCJghz6F2hZAx5X0K8pKvzUOgwsB2QqElBxNqew+fIqJx3+RLv8i38CTwbpoAYY2N/TTIr3UNERZLn5Z7j6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFmu5dJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFmu5dJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747171F000E9;
	Wed, 20 May 2026 17:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298632;
	bh=Vi3ExwNN7L8XWcxQ4Q45amVLjpnLP3qnT8l2/2s6qFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFmu5dJGwraG3jXRWZfZ2rtIb7LSumv2dSOAimHUiEAc0QNRu6WTGrDXdOw2i0no9
	 Eaz9ZCyehVN8ucBqbSRcdTWlMhrYouJW1TudKdMOwxq4rWCJ5pUGfs2o3n9mW1u6P6
	 wS3ZM4tn5WD2i6ZUSu1G4NneVl1vm7jn3/zG2WyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 444/957] ocfs2: validate bg_bits during freefrag scan
Date: Wed, 20 May 2026 18:15:27 +0200
Message-ID: <20260520162144.149983291@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit 8f687eeed3da3012152b0f9473f578869de0cd7b ]

[BUG]
A crafted filesystem can trigger an out-of-bounds bitmap walk when
OCFS2_IOC_INFO is issued with OCFS2_INFO_FL_NON_COHERENT.

BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: use-after-free in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: use-after-free in test_bit_le include/asm-generic/bitops/le.h:21 [inline]
BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
BUG: KASAN: use-after-free in ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
BUG: KASAN: use-after-free in ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
Read of size 8 at addr ffff888031bce000 by task syz.0.636/1435
Call Trace:
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xd1/0x650 mm/kasan/report.c:482
 kasan_report+0xfb/0x140 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186 [inline]
 kasan_check_range+0x11c/0x200 mm/kasan/generic.c:200
 __kasan_check_read+0x11/0x20 mm/kasan/shadow.c:31
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 test_bit_le include/asm-generic/bitops/le.h:21 [inline]
 ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
 ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
 ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
 ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
 ocfs2_info_handle+0x18d/0x2a0 fs/ocfs2/ioctl.c:828
 ocfs2_ioctl+0x632/0x6e0 fs/ocfs2/ioctl.c:913
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 ...

[CAUSE]
ocfs2_info_freefrag_scan_chain() uses on-disk bg_bits directly as the
bitmap scan limit. The coherent path reads group descriptors through
ocfs2_read_group_descriptor(), which validates the descriptor before
use. The non-coherent path uses ocfs2_read_blocks_sync() instead and
skips that validation, so an impossible bg_bits value can drive the
bitmap walk past the end of the block.

[FIX]
Compute the bitmap capacity from the filesystem format with
ocfs2_group_bitmap_size(), report descriptors whose bg_bits exceeds
that limit, and clamp the scan to the computed capacity. This keeps the
freefrag report going while avoiding reads beyond the buffer.

Link: https://lkml.kernel.org/r/20260410034220.3825769-1-gality369@gmail.com
Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/ioctl.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index b6864602814c4..b004e7117a5f3 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -441,13 +441,16 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 	struct buffer_head *bh = NULL;
 	struct ocfs2_group_desc *bg = NULL;
 
-	unsigned int max_bits, num_clusters;
+	unsigned int max_bits, max_bitmap_bits, num_clusters;
 	unsigned int offset = 0, cluster, chunk;
 	unsigned int chunk_free, last_chunksize = 0;
 
 	if (!le32_to_cpu(rec->c_free))
 		goto bail;
 
+	max_bitmap_bits = 8 * ocfs2_group_bitmap_size(osb->sb, 0,
+					      osb->s_feature_incompat);
+
 	do {
 		if (!bg)
 			blkno = le64_to_cpu(rec->c_blkno);
@@ -479,6 +482,19 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 			continue;
 
 		max_bits = le16_to_cpu(bg->bg_bits);
+
+		/*
+		 * Non-coherent scans read raw blocks and do not get the
+		 * bg_bits validation from
+		 * ocfs2_read_group_descriptor().
+		 */
+		if (max_bits > max_bitmap_bits) {
+			mlog(ML_ERROR,
+			     "Group desc #%llu has %u bits, max bitmap bits %u\n",
+			     (unsigned long long)blkno, max_bits, max_bitmap_bits);
+			max_bits = max_bitmap_bits;
+		}
+
 		offset = 0;
 
 		for (chunk = 0; chunk < chunks_in_group; chunk++) {
-- 
2.53.0



