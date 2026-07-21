Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C43635C68D;
	Tue, 21 Jul 2026 21:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668620; cv=none; b=KBEP1TEQNmm4GtEwnigwtCmyqsioTHMkABQ0HWZGkQreDsEKEpKN01g8UZ65TnK5q+9caSfD/178VGEV4/FLJXTX/nhczerCRGnW/mU3cgQySw5wPAPlrhip+hI8ovSCioO3CxZkwuw4EpthtOFOUTAjvMZKeBo/YHDwG5pz/KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668620; c=relaxed/simple;
	bh=cbs0NI+hk+gxf8naA7BzVfHQuuZSxMguwF5ZSO3AThE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVfPhi6WW5YtEbby8JSC3z6ipilC+SA/jUWhAfDFieSAI5cpcx+ub3a8dy74zYRMRq789GCDoy2JfWs3rl3xRNEG9CjacV7G/EDXiSek2de6Ye4BURQorR2NGY2gTMygTEX36+gm4If8jPVZUJaMkamdfYjett6baGeC5AccetY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdMLXunL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdMLXunL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DE01F000E9;
	Tue, 21 Jul 2026 21:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668618;
	bh=Ym74trkzykcdN1yTm+fnuPMeQOBkvpdC03z8YbkvdB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdMLXunLSBKOFT7oZL2qADedsyCOpCNtlmLH8YisBkJ4QefM5Px0A/cTKSkfM8API
	 GkOPJrCFmfvOXFxk9BBlDgDmUTSogXqqwuYWeJyb6CBU4LxPI1lq0YPxAQjN7lnvHJ
	 NUq8Ezx3H8wmc36CSV5jhY3Xu/yZO+1+qT0ByW8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 0200/1067] udf: validate free block extents against the partition length
Date: Tue, 21 Jul 2026 17:13:21 +0200
Message-ID: <20260721152429.067233639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 5f0419457f89dce1a3f1c8e62a3adf2f39ab8168 upstream.

udf_free_blocks() checks the logical block number and count against the
partition length, but drops the extent offset from that final bound.  A
crafted extent can pass the guard while logicalBlockNum + offset + count
points past the partition, which later indexes past the space bitmap
array.

A single ftruncate(2) on a file backed by such an extent reliably
panics the kernel.  This is a local availability issue.  On desktop
systems where UDisks/polkit allows the active user to mount removable
UDF media without CAP_SYS_ADMIN, an unprivileged local user can supply
the crafted filesystem and trigger the panic by truncating a writable
file on it.  Systems that require root or CAP_SYS_ADMIN to mount the
image have a higher prerequisite.

No confidentiality or integrity impact is claimed: the reproduced
primitive is an out-of-bounds read of a bitmap pointer slot followed by
a kernel panic.

Use the already computed logicalBlockNum + offset + count value for the
partition length check.  Also make load_block_bitmap() reject an
out-of-range block group before indexing s_block_bitmap[], so corrupted
callers cannot walk past the flexible array.

Fixes: 56e69e59751d ("udf: prevent integer overflow in udf_bitmap_free_blocks()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260515142327.1120767-1-michael.bommarito@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/balloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -86,8 +86,9 @@ static int __load_block_bitmap(struct su
 	int nr_groups = bitmap->s_nr_groups;
 
 	if (block_group >= nr_groups) {
-		udf_debug("block_group (%u) > nr_groups (%d)\n",
+		udf_debug("block_group (%u) >= nr_groups (%d)\n",
 			  block_group, nr_groups);
+		return -EFSCORRUPTED;
 	}
 
 	if (bitmap->s_block_bitmap[block_group]) {
@@ -671,7 +672,7 @@ void udf_free_blocks(struct super_block
 
 	if (check_add_overflow(bloc->logicalBlockNum, offset, &blk) ||
 	    check_add_overflow(blk, count, &blk) ||
-	    bloc->logicalBlockNum + count > map->s_partition_len) {
+	    blk > map->s_partition_len) {
 		udf_debug("Invalid request to free blocks: (%d, %u), off %u, "
 			  "len %u, partition len %u\n",
 			  partition, bloc->logicalBlockNum, offset, count,


