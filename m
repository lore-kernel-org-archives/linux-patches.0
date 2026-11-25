Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617860;
	b=5BlQroogf6PybvceBg3h0TbCxQwDZD23utgCXm5KPWYOsNpvBIuN41zxK2OBASjUD7Zu
	 MjTPdN3tw+HiicDnhR6c8gLainoudCSui/twHEbSPzgphUZljac8t06uC7qkZP5Rt0vxQ
	 85HDyDnYvV7Ni7T6m3sIzcDTUZBGCr5fb5KsWvvl7oGYYbSRQSmgmvOYjuz+T6fQhyZ+x
	 tTMVxc9ziaYnnvwE4Sj1atAyPdp1qzEg1vzRCPhYoAQcY1JtHBuBleTvNlGghorGBTM6Z
	 iHnlpefX56Tc+2PK+hYnJHoaGtBINeilWH48Oa735lXNnMtwb5WDIE1JG9WP4TALAcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K4mJ1n0BJTbM3fCMJfLgXloQ4aVNSY8icHqAcruLSQo=;
	b=CtAQorgHfcAeD3eUzwOB/1Pppmmu4uVzqgl0UyS+E23gspHwDo8vrY4OW5tVk5QjAnfo
	 Pe5oV3Du3twTlWaKqwyPtnvpODCVu7vpvT/JowQwZbxLDQbtBsWvNplEnXMQwbGm0u1jQ
	 tf5gn94P4oqRQYa3lCH3QnxZV4537EIwj93xRiRWKG1hqEk2tasbhVgAGy6ufhBsQYgDG
	 IJDRVYgScB7Jxa8isOD3IBH+VWiY32P7yFgg2QrATguBIhYwmUfsKIhnRRLD4U7w1T143
	 kefV8zPP4fabu8uCfzaO5JeobEdTEvVUs9WcVvkVUFD7NGG7r8OguiAU2/BdB+EiJNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK4fhCZR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CA7606A31E;
	Wed, 25 Nov 2026 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK4fhCZR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED0B1F000C0;
	Wed, 25 Nov 2026 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617860;
	bh=K4mJ1n0BJTbM3fCMJfLgXloQ4aVNSY8icHqAcruLSQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EK4fhCZRo2JsNXQm0gLOuiMjKMDdr0ULrr9GQcUqHefGyH3mDJvWdaL7jwjC0QBTt
	 pVa5eurqbNThhW8qcK9sEkpdnls4ywWz7sQm1uepMaNA4B6o762fdRvYuOaM8NY1wH
	 WPZ5SR+saiv8I/LnxC/37Gam0f2tma71fg4azjmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0071/1005] btrfs: fix fiemap merging compressed extents
Date: Wed, 25 Nov 2026 15:23:29 +0100
Message-ID: <20261125143823.405966334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7a2a971800993..817171028413c 100644
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



