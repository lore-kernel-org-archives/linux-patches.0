Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624057;
	b=oWtjoYzgTczmV93xQ2iXZxmZgrrtvAZyOioDKc69uuRwIBoWJYezgisvZt0l3sZePkFe
	 uvAsBQqiK7zQjpOXKPfSMgMOfH/FCjGXdQaguPB1fEQKne7PhHYhNw0giZt1ZwRUbtokG
	 sgfuSxAr62KbqzveKroS7DAoH05LOPJd6cAY2GgrUmkSicg0Nt9WOm0bclEp/FB7PAo6W
	 IttJcYbi9tXm6OpXM/ECFFFtZoFQYDDV5If8PunP8OgvH58t1XY9xO/+TFQPHDz4fEtgi
	 PzKwNEHghsDEXwsZfAr0EQidEMVQs22cY4RjpMrLaynnNxfaoF7scQY6Jls0EPLwQ4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XnUZ+QNca7xQLC7QrXi9lNWPRFs3b1aX9kehzx8G/Pc=;
	b=OoJzougYNiLDm2Hq+gSlmP0yd/2j57HAz+zkXjSbDS1Bz93sOteKgjjmOchAyYomVvth
	 9wOoWTkNrZH51Q5K1B0xGwHTYBNdfEoVPzjAn5/71EPIsSiPmGzhBmcXP0xzz/BATbtET
	 fdpw9hClSOvdpEbVLQ1Fj5Y9oC04nlRqc9+3wlo8BiJ6aqNEbVzl264abKVMn0XvitTLW
	 goBa9qmJFubPKgZ76SlH1ERdwLd3zMxsHQTlYSHDsjv54boXGlXm+1ktilx1HH1mQG/lq
	 OSFreR+o549NCapfZStt5ZQJ+Sluh7lARBwyR96tEBJUKhYDBiRelL75Rwj4YtCKo9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEq9pDmy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E1C606A321;
	Wed, 25 Nov 2026 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEq9pDmy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011F71F000C6;
	Wed, 25 Nov 2026 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624057;
	bh=XnUZ+QNca7xQLC7QrXi9lNWPRFs3b1aX9kehzx8G/Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEq9pDmyY7XBb4wrr2n0KKntlxILf6/RUh05+e4qs/AOTKPjnRPCV/ky/pKd8qRvS
	 9sMRypKSog4qqiACCXZsyHlmesqXNbl/KdBTdhr4KSLTwC8nPu3NzSGFVZDDRMyWhb
	 MhSywp5m9K7+FZmJ6ERRdNj2Dc9vJd+VMs8+DpkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/816] btrfs: fix fiemap merging compressed extents
Date: Wed, 25 Nov 2026 15:26:58 +0100
Message-ID: <20261125143850.842194336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 980fbbd041ac2538fdbe7cfda4253dfc28fdcad1 ]

Compressed extents are never supposed to be merged by the fiemap code and
reported as a single extent, as each extent's content comes from a
different compression stream and has its own header and context.

We currently rely on checking the logical and physical address adjacency
to prevent merging compressed extents but that is broken. Consider the
following reproducer which explains why the merging happens:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -s 4K -f $DEV
  mount -o compress $DEV $MNT

  # Do a write that compresses to a single 4K extent and represents the
  # maximum compressed chunk size (128K).
  xfs_io -f -c "pwrite 0 128K" $MNT/foo

  # Sync to flush delalloc and allocate the 4K extent.
  sync -f $MNT

  # Now allocate a 124K extent in some other file, which will be adjacent
  # (to the right) of the 4K extent previously allocated.
  xfs_io -f -c "falloc 0 124K" $MNT/filler

  # Do another write to the main file at its current EOF that is
  # compressible and fits in a 4K extent.
  xfs_io -c "pwrite 128K 128K" $MNT/foo
  # Sync to flush delalloc and allocate the 4K extent.
  sync -f $MNT

  # Run fiemap which should report 2 encoded extents, each with a
  # logical size of 128K.
  xfs_io -c "fiemap -v" $MNT/foo

  umount $MNT

Running this, fiemap will report a single extent:

  $ ./test.sh
  (...)
  /mnt/sdi/foo:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..511]:        26624..27135       512   0x9

Fix this by never attempting to merge extents if the flags contain
FIEMAP_EXTENT_ENCODED.

Fixes: 4751832da990 ("btrfs: fiemap: Cache and merge fiemap extent before submit it to user")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/fiemap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index 7364bae6b1720..cf93318d14080 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -228,7 +228,8 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
 	 *
 	 * 3) Share same flags
 	 */
-	if (cache->offset + cache->len  == offset &&
+	if (!(flags & FIEMAP_EXTENT_ENCODED) &&
+	    cache->offset + cache->len == offset &&
 	    cache->phys + cache->len == phys  &&
 	    cache->flags == flags) {
 		cache->len += len;
-- 
2.53.0



