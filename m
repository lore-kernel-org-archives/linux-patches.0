Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620303;
	b=EXQEDFE8aMMyIXR3RIAA8Ts6PtWDP4eY+Ax3zi4D4/UipdcLYqdaxZUDaCw1n2AOrCeN
	 BKEhisKhC/crvzDKYbT0hJr6SqHvJR868uyh0fM3/xdHyjqsslYEmpYsq4DdlPpgPW/2W
	 vrnCk5dPU85B4zugVg5MOv4OPhQWr/AdIF/I1us4FGVa+iSRImT0vTZgbnWfy3AOdgWNs
	 TeP8l6Z6UhetfuYQYRa03xy9h16Vkp2N/zyT4PeSu0Ks9zVKDcRa1UNjTovsO6EN+k8i8
	 UnOh2GA7YNRd/1v+319nglU8XCzuFvAwssWFOnFzUloVSytGnkVAlgSOt4xxqLjHEug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pzimdoajeLshpbcSAFTsTu+ybYbWDV/YL3/riGs/Zqk=;
	b=D8UjUGNizIDzGVe2qu9NLOFm/uPs/kV/c399xt21KCIXPrgu0L26T7xby0GjSMgYVHn1
	 746jQv1r8k8eukr8Nr21wSPHwUxzFtVGa3FdAEqwhVlnVeJFSzyX6W0QZLGGXoLrg9vA1
	 VZNLjQLhVnHXA2namhWMhis6f+k0ho7H0szExcJi7jiUTxpXsN+zwYzg0G4O9qgcxZ9Vi
	 SQ2U7aWlGgwy7849d8uwhIOsAH5XBAKFtY3lqyAPz/6qMtxWpvu6hqj7W4aB9o2htQski
	 d4LDQb9gUuYCzxF7qmyu+NRvopQexdrMWwr41g9nNjY7OZOcn1emejmshvKvLe2Z6zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uIDjfV/4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B26606A31E;
	Wed, 25 Nov 2026 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uIDjfV/4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CD21F000C0;
	Wed, 25 Nov 2026 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620302;
	bh=pzimdoajeLshpbcSAFTsTu+ybYbWDV/YL3/riGs/Zqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIDjfV/4l6AelLc4zxag/Nmd7jyUAaKBoPMwqgDEZa7sOrGsjvtGEc1KDYiMG50e0
	 AtZg/TL5k41Eop4OgcSgVY8QXve+Xn7EQts3g6VT14UgUx0MxtKt91EHkUuUV6/x2X
	 o9JPhsGPqqvX7GmXMfe3p7uGY7RyVRPFHeZnLq3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0872/1005] dm snapshot: fix discard writing into the next COW chunk
Date: Wed, 25 Nov 2026 15:36:50 +0100
Message-ID: <20261125143842.132801899@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

commit 73174b4bb6fcd0e6cf973c9402a0fae2e567ad9f upstream.

zero_exception() zeroes one chunk of the COW device and takes the start
sector from bio->bi_iter.bi_sector.  remap_exception() has already set
that to the COW chunk start plus the offset inside the chunk.  That
offset is needed for reads and writes, but for a discard it is wrong:
the zeroing window is shifted, so the head of the target chunk keeps
its old data and the tail lands in the next COW chunk, which holds a
different exception.

io_overlaps_chunk() should have caught this, but it only compares the
length.  "maps to entire chunks" in snapshot.rst also means the discard
has to start on a chunk boundary.

A discard that is not a full chunk has a second problem: after
remap_exception() it is sent to the COW device, where it hits a chunk
that still backs a live exception.  After a discard the contents are
undefined, but the exception stays in the table and keeps pointing at
that chunk, so a later read returns whatever the discard left instead
of the snapshot's data.

Reproducer:

	truncate -s 4M o.img c.img
	o=$(losetup -f --show o.img)
	c=$(losetup -f --show c.img)
	dmsetup create snap --table \
		"0 8192 snapshot $o $c P 512 1 discard_zeroes_cow"

	# write two chunks, this creates two exceptions
	head -c 256K /dev/zero | tr '\000' '\252' > pat
	dd if=pat of=/dev/mapper/snap bs=256K seek=1 count=1 conv=notrunc
	dd if=pat of=/dev/mapper/snap bs=256K seek=2 count=1 conv=notrunc

	# shift the snapshot by 8 sectors, so a discard that is aligned on
	# top is unaligned inside the snapshot
	dmsetup create top --table "0 8184 linear /dev/mapper/snap 8"
	blkdiscard -o 262144 -l 262144 /dev/mapper/top
	sync
	echo 3 > /proc/sys/vm/drop_caches

	# chunk 1
	dd if=/dev/mapper/snap bs=512 skip=512 count=8 | od -An -tx1 -N1
	# chunk 2
	dd if=/dev/mapper/snap bs=512 skip=1024 count=8 | od -An -tx1 -N1

Before: aa 00  <- chunk 2 was zeroed although it was not discarded
After:  aa aa  <- nothing written, a discard is only a hint

Fix it by requiring the discard to start on a chunk boundary in
io_overlaps_chunk(), and by finishing a discard that is not a full
chunk with bio_endio() instead of passing it down to the COW device.

Fixes: 2e6023850e17 ("dm snapshot: add optional discard support features")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1948,8 +1948,8 @@ static void zero_exception(struct dm_sna
 
 static bool io_overlaps_chunk(struct dm_snapshot *s, struct bio *bio)
 {
-	return bio->bi_iter.bi_size ==
-		(s->store->chunk_size << SECTOR_SHIFT);
+	return bio->bi_iter.bi_size == (s->store->chunk_size << SECTOR_SHIFT) &&
+	       !(bio->bi_iter.bi_sector & s->store->chunk_mask);
 }
 
 static int snapshot_map(struct dm_target *ti, struct bio *bio)
@@ -2009,11 +2009,13 @@ static int snapshot_map(struct dm_target
 	e = dm_lookup_exception(&s->complete, chunk);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
-		if (unlikely(bio_op(bio) == REQ_OP_DISCARD) &&
-		    io_overlaps_chunk(s, bio)) {
+		if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
 			dm_exception_table_unlock(&lock);
 			up_read(&s->lock);
-			zero_exception(s, e, bio, chunk);
+			if (io_overlaps_chunk(s, bio))
+				zero_exception(s, e, bio, chunk);
+			else
+				bio_endio(bio);
 			r = DM_MAPIO_SUBMITTED; /* discard is not issued */
 			goto out;
 		}


