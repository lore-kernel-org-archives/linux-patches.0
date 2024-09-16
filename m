Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B92155CA5;
	Mon, 16 Sep 2024 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488276; cv=none; b=ulGdAw/pRy7x0m8nT65/5Hi4WG2I4pagBusS/ig16sruYzF042Nsv9jI3Quo67beQ+a92lJoqMW1DfJGaYoPW+vr5tcH00RDCeCwEc8Os2KlmjqaxDlsXg9GGrT5h1m5f74AuMEk3ET9kfHhq/CYrIgYfCl9dyHCf7V08TqKGG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488276; c=relaxed/simple;
	bh=mHO1IkWQ9vkKz1NQCYocYQOiBoz3Am07kyPggsSZwpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRLmYaFEr3ds/+Ff1m2i9Mo+5iucFFpPmhT8hLVK8tHTEYf9LDmB5nD4qm4zTcmERtMF85HxE1a9wXIe4OtxfMxR9DhAmW0h3jX1uH3Vxx6bMPJ1xiKt7r6TAJgkpCKvQp2VqpoAwW6amOzc1cLO3V1FB5hFgd/StutA+iY8oc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/p48qoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/p48qoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B71C4CEC4;
	Mon, 16 Sep 2024 12:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488276;
	bh=mHO1IkWQ9vkKz1NQCYocYQOiBoz3Am07kyPggsSZwpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/p48qocjp4zIbnmSfhql8/vzzgxRD/qeBwa9yo48Xy/tlWVVxEY5MvzLD/WlPmdc
	 Vf7plQJ5hG4Y5gNQ+lM3UktP8m564zhvt6ORMwxKcQQqn+5pOgYxbHgjFs4BsLpZeD
	 9fu9VJycV8bBMqxq9GX7V/ecZBJ4WNS9GR51SZlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.10 056/121] bcachefs: Fix bch2_extents_match() false positive
Date: Mon, 16 Sep 2024 13:43:50 +0200
Message-ID: <20240916114231.002644946@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit  d26935690c03fe8159d42358bed1c56252700cd1 ]

This was caught as a very rare nonce inconsistency, on systems with
encryption and replication (and tiering, or some form of rebalance
operation running):

[Wed Jul 17 13:30:03 2024] about to insert invalid key in data update path
[Wed Jul 17 13:30:03 2024] old: u64s 10 type extent 671283510:6392:U32_MAX len 16 ver 106595503: durability: 2 crc: c_size 8 size 16 offset 0 nonce 0 csum chacha20_poly1305_80 compress zstd ptr: 3:355968:104 gen 7 ptr: 4:513244:48 gen 6 rebalance: target hdd compression zstd
[Wed Jul 17 13:30:03 2024] k:   u64s 10 type extent 671283510:6400:U32_MAX len 16 ver 106595508: durability: 2 crc: c_size 8 size 16 offset 0 nonce 0 csum chacha20_poly1305_80 compress zstd ptr: 3:355968:112 gen 7 ptr: 4:513244:56 gen 6 rebalance: target hdd compression zstd
[Wed Jul 17 13:30:03 2024] new: u64s 14 type extent 671283510:6392:U32_MAX len 8 ver 106595508: durability: 2 crc: c_size 8 size 16 offset 0 nonce 0 csum chacha20_poly1305_80 compress zstd ptr: 3:355968:112 gen 7 cached ptr: 4:513244:56 gen 6 cached rebalance: target hdd compression zstd crc: c_size 8 size 16 offset 8 nonce 0 csum chacha20_poly1305_80 compress zstd ptr: 1:10860085:32 gen 0 ptr: 0:17285918:408 gen 0
[Wed Jul 17 13:30:03 2024] bcachefs (cca5bc65-fe77-409d-a9fa-465a6e7f4eae): fatal error - emergency read only

bch2_extents_match() was reporting true for extents that did not
actually point to the same data.

bch2_extent_match() iterates over pairs of pointers, looking for
pointers that point to the same location on disk (with matching
generation numbers). However one or both extents may have been trimmed
(or merged) and they might not have the same disk offset: it corrects
for this by subtracting the key offset and the checksum entry offset.

However, this failed when an extent was immediately partially
overwritten, and the new overwrite was allocated the next adjacent disk
space.

Normally, with compression off, this would never cause a bug, since the
new extent would have to be immediately after the old extent for the
pointer offsets to match, and the rebalance index update path is not
looking for an extent outside the range of the extent it moved.

However with compression enabled, extents take up less space on disk
than they do in the btree index space - and spuriously matching after
partial overwrite is possible.

To fix this, add a secondary check, that strictly checks that the
regions pointed to on disk overlap.

https://github.com/koverstreet/bcachefs/issues/717

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/extents.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -932,8 +932,29 @@ bool bch2_extents_match(struct bkey_s_c
 			bkey_for_each_ptr_decode(k2.k, ptrs2, p2, entry2)
 				if (p1.ptr.dev		== p2.ptr.dev &&
 				    p1.ptr.gen		== p2.ptr.gen &&
+
+				    /*
+				     * This checks that the two pointers point
+				     * to the same region on disk - adjusting
+				     * for the difference in where the extents
+				     * start, since one may have been trimmed:
+				     */
 				    (s64) p1.ptr.offset + p1.crc.offset - bkey_start_offset(k1.k) ==
-				    (s64) p2.ptr.offset + p2.crc.offset - bkey_start_offset(k2.k))
+				    (s64) p2.ptr.offset + p2.crc.offset - bkey_start_offset(k2.k) &&
+
+				    /*
+				     * This additionally checks that the
+				     * extents overlap on disk, since the
+				     * previous check may trigger spuriously
+				     * when one extent is immediately partially
+				     * overwritten with another extent (so that
+				     * on disk they are adjacent) and
+				     * compression is in use:
+				     */
+				    ((p1.ptr.offset >= p2.ptr.offset &&
+				      p1.ptr.offset  < p2.ptr.offset + p2.crc.compressed_size) ||
+				     (p2.ptr.offset >= p1.ptr.offset &&
+				      p2.ptr.offset  < p1.ptr.offset + p1.crc.compressed_size)))
 					return true;
 
 		return false;


