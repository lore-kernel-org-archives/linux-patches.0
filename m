Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D9E31CA5E;
	Mon, 18 Aug 2025 12:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521761; cv=none; b=kfqqVu41+4TzD3KXMtGtIGEQfXYncUqV4pH9iM2icBnRWHyaIGxsvJLpV/lBcLXaka+iVdb1LD4VJqbP2V4PprSK1XJWw5+nBIL3F2reii1UMVdjkc+OCcI3eNvFqABZpfHU8cN0MkHH9j7JUl+OIg5CHc5rTdfTbNqP2QCx0cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521761; c=relaxed/simple;
	bh=TS/gF3d71nZNKD75teGxRpzDKEV4tMa3v/k7VZvO8Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE3BXRLcKDgXRl9dnk8oKSWvN3JTTZJyq5TE4pSbSPd9oVnfii3EOi3KOWchv4qEWADGGAnL4TA16Ca2Wwx7nqqyN7QcjswPDddblXjxCmUHqmEskSObrSkmIGFeIYDVXeHb0dqSes8CJLJS7Zm1CNkSR2T+hbQ6OH4OVWnvajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDXLSw5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDXLSw5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BFCC4CEEB;
	Mon, 18 Aug 2025 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521761;
	bh=TS/gF3d71nZNKD75teGxRpzDKEV4tMa3v/k7VZvO8Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDXLSw5rZr6zmetqDk42aFmKCBNjkz6LiEIxqcEOZgud0eZ8uzqFnMwcjnoMpyyV8
	 WWXP1zf0Dkkx+y2VXJ0bn5iBB3I1kfuEurOLIxqPlVPJGbu5fmzIijdZI4kcV7W9GK
	 Ok5orKvcinbNJyXYPyjRBylhn5jYtflsqODMZ5KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/444] hfs: fix not erasing deleted b-tree node issue
Date: Mon, 18 Aug 2025 14:41:48 +0200
Message-ID: <20250818124452.028886711@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit d3ed6d6981f4756f145766753c872482bc3b28d3 ]

The generic/001 test of xfstests suite fails and corrupts
the HFS volume:

sudo ./check generic/001
FSTYP         -- hfs
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 6.15.0-rc2+ #3 SMP PREEMPT_DYNAMIC Fri Apr 25 17:13:00 PDT 2>
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/001 32s ... _check_generic_filesystem: filesystem on /dev/loop50 is inconsistent
(see /home/slavad/XFSTESTS-2/xfstests-dev/results//generic/001.full for details)

Ran: generic/001
Failures: generic/001
Failed 1 of 1 tests

fsck.hfs -d -n ./test-image.bin
** ./test-image.bin (NO WRITE)
	Using cacheBlockSize=32K cacheTotalBlock=1024 cacheSize=32768K.
   Executing fsck_hfs (version 540.1-Linux).
** Checking HFS volume.
   The volume name is untitled
** Checking extents overflow file.
** Checking catalog file.
   Unused node is not erased (node = 2)
   Unused node is not erased (node = 4)
<skipped>
   Unused node is not erased (node = 253)
   Unused node is not erased (node = 254)
   Unused node is not erased (node = 255)
   Unused node is not erased (node = 256)
** Checking catalog hierarchy.
** Checking volume bitmap.
** Checking volume information.
   Verify Status: VIStat = 0x0000, ABTStat = 0x0000 EBTStat = 0x0000
                  CBTStat = 0x0004 CatStat = 0x00000000
** The volume untitled was found corrupt and needs to be repaired.
	volume type is HFS
	primary MDB is at block 2 0x02
	alternate MDB is at block 20971518 0x13ffffe
	primary VHB is at block 0 0x00
	alternate VHB is at block 0 0x00
	sector size = 512 0x200
	VolumeObject flags = 0x19
	total sectors for volume = 20971520 0x1400000
	total sectors for embedded volume = 0 0x00

This patch adds logic of clearing the deleted b-tree node.

sudo ./check generic/001
FSTYP         -- hfs
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 6.15.0-rc2+ #3 SMP PREEMPT_DYNAMIC Fri Apr 25 17:13:00 PDT 2025
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/001 9s ...  32s
Ran: generic/001
Passed all 1 tests

fsck.hfs -d -n ./test-image.bin
** ./test-image.bin (NO WRITE)
	Using cacheBlockSize=32K cacheTotalBlock=1024 cacheSize=32768K.
   Executing fsck_hfs (version 540.1-Linux).
** Checking HFS volume.
   The volume name is untitled
** Checking extents overflow file.
** Checking catalog file.
** Checking catalog hierarchy.
** Checking volume bitmap.
** Checking volume information.
** The volume untitled appears to be OK.

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20250430001211.1912533-1-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/bnode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index 1dac5d9c055f..e8cd1a31f247 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -574,6 +574,7 @@ void hfs_bnode_put(struct hfs_bnode *node)
 		if (test_bit(HFS_BNODE_DELETED, &node->flags)) {
 			hfs_bnode_unhash(node);
 			spin_unlock(&tree->hash_lock);
+			hfs_bnode_clear(node, 0, tree->node_size);
 			hfs_bmap_free(node);
 			hfs_bnode_free(node);
 			return;
-- 
2.39.5



