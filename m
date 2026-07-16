Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B0642B30E;
	Thu, 16 Jul 2026 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209853; cv=none; b=tj2Cf1HcL0vNFM4zMs3T27VsR8Ol9jaMoNp6WPDRQJTMKys3lCCRzR2reBRG3u7w16/qL67vuEXc6V9ebuWBGCxXg/iiGFeAHOUXCerXRCucLh/1ei9HPuyk3eKIh3u9hs/CC8xJGD22tp4nPQcSr4lFpGeFQlBDxLtTYqilY7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209853; c=relaxed/simple;
	bh=20tSEv7UVKVOoYRMmON2gYuUKITyaCvIwBrRZ/wbQJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxjtq5wHADr7ZtQrJAgZ1JZNl4Ne5FthfQIzDDHLBpd8QgDwGgbi61SdnIqBQv4Wt4WXaEWAIG4lo6aTzPxD2NZVy4hUX7+0wLP63nT5FgtuxhNSjVkAuoKgNvZqmIcdF+Jsljf5Cnjewt+MvYIPWLR68tFGUCn2cvwNohWjFDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZ/eLH9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZ/eLH9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857671F000E9;
	Thu, 16 Jul 2026 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209852;
	bh=fu8uCOEd5hcTaAH9TqvnrmBukXZeGSx/cyY8gsD9OmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZ/eLH9A/uvMh+0Nkg7oUFaDYoHpAuhl8jyXzIiLbo3z3Hhptlh/w6FRr+09CPbrM
	 qmM+GQcwSRpQlOA31nx4BrqjOEvLYtLj+6tExXVkKtqzrCih72+Souhduo/pQdaHBJ
	 HrG8mO0mUO07FaMoltYwoGwlusGAtL2vm4oY27ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7.1 342/518] udf: validate free block extents against the partition length
Date: Thu, 16 Jul 2026 15:30:10 +0200
Message-ID: <20260716133055.300355759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -82,8 +82,9 @@ static int load_block_bitmap(struct supe
 	int nr_groups = bitmap->s_nr_groups;
 
 	if (block_group >= nr_groups) {
-		udf_debug("block_group (%u) > nr_groups (%d)\n",
+		udf_debug("block_group (%u) >= nr_groups (%d)\n",
 			  block_group, nr_groups);
+		return -EFSCORRUPTED;
 	}
 
 	if (bitmap->s_block_bitmap[block_group]) {
@@ -662,7 +663,7 @@ void udf_free_blocks(struct super_block
 
 	if (check_add_overflow(bloc->logicalBlockNum, offset, &blk) ||
 	    check_add_overflow(blk, count, &blk) ||
-	    bloc->logicalBlockNum + count > map->s_partition_len) {
+	    blk > map->s_partition_len) {
 		udf_debug("Invalid request to free blocks: (%d, %u), off %u, "
 			  "len %u, partition len %u\n",
 			  partition, bloc->logicalBlockNum, offset, count,


