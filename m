Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FD0320CAD;
	Sat, 30 May 2026 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163786; cv=none; b=GP+Qf3497I1HghOk0OUHWx1uvE7kxhJj5DYExXIF+I09oEF4PVOOIXTfMwbDlEFLIujZGcpxXc4S1FQScHvLwtDXHlHR88ZgpUab6zZYa+3XqAFzi3hqT3URIgc7nEK8T1O4O3v7vmadOUyEEGyH+mqhfuitBjIeF3Mq7CEglLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163786; c=relaxed/simple;
	bh=XYOFHTUq/qkwluI4BpL0RHORU31EKm4Xn6lyB5X+65k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qK96fMulI50B+ufZ6dJY9zFausTuTa/jIXSOPCYZN6H8Svqhp/KDm7SiOHXMa7NY/RroocgFmd/Hxle26L/vUS/8KdZSD0AN2x4P3e6xzehZu1ttSqlKJtwn4ksuWTy3A2iqXqWzYLeBXwrNOIkwBJNJ0xz7h0IDR99Mfyfdni0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7zf8Oil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7zf8Oil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A7E1F00893;
	Sat, 30 May 2026 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163785;
	bh=VlCNjI0Kha9JZlOD6cOgFWuJm71oZb1U4Bik9AE5hco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7zf8Oilw4P3Lp0jqC5STG7+xIpmMvp2M+JUNOjT39wOY6HPidW+lgdtdCqxJG+0L
	 Z3t/yu7aFKbNV+3C2/f7UUzN83mCJszJ/KffDPsjLsM4pSck9OLo8AsyPAh3pWWz3Q
	 t73DE06i8ZX52sEMJCqNcP//1x+xxPbELywT8vUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 330/776] dm-verity-fec: correctly reject too-small FEC devices
Date: Sat, 30 May 2026 18:00:44 +0200
Message-ID: <20260530160249.101817849@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 2b14e0bb63cc671120e7791658f5c494fc66d072 upstream.

Fix verity_fec_ctr() to reject too-small FEC devices by correctly
computing the number of parity blocks as 'f->rounds * f->roots'.
Previously it incorrectly used 'div64_u64(f->rounds * f->roots,
v->fec->roots << SECTOR_SHIFT)' which is a much smaller value.

Note that the units of 'rounds' are blocks, not bytes.  This matches the
units of the value returned by dm_bufio_get_device_size(), which are
also blocks.  A later commit will give 'rounds' a clearer name.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -668,7 +668,7 @@ int verity_fec_ctr(struct dm_verity *v)
 {
 	struct dm_verity_fec *f = v->fec;
 	struct dm_target *ti = v->ti;
-	u64 hash_blocks, fec_blocks;
+	u64 hash_blocks;
 	int ret;
 
 	if (!verity_fec_is_enabled(v)) {
@@ -752,8 +752,7 @@ int verity_fec_ctr(struct dm_verity *v)
 
 	dm_bufio_set_sector_offset(f->bufio, f->start << (v->data_dev_block_bits - SECTOR_SHIFT));
 
-	fec_blocks = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
-	if (dm_bufio_get_device_size(f->bufio) < fec_blocks) {
+	if (dm_bufio_get_device_size(f->bufio) < f->rounds * f->roots) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}


