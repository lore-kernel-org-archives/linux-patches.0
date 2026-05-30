Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77B526F288;
	Sat, 30 May 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160487; cv=none; b=FtpBzBHEbCug0Apo0+WAtNL/hCBscLjRYUY2IrTzlh7vovRTROyncoeOv/xatXyhmmHVe6E/z8VHBQtr1PkQjmmtuYsa/NjwHNbNdZixZ6ufbdU3jBe4d/Fq49NekJb2khUm/3BvygcA23NqEQ+pT4AOcIGY2/PwV+nWo/W9rUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160487; c=relaxed/simple;
	bh=S3Td6dr7PhSP6/letKGAUP442E/urtbGL1octtQDBWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sece843vuEi+dWyNl9z0Woiiz4LWA1/49Ye0cP5u97pcfR/8RcndCt2SktlrpO06fBVEBATucqPmLqbfnVg3Mzd+VaIPPYouFDWUKbTd/uCTMjTL6szC9SfhvJbwLQkgzDUjO0Pre0uqO2BRWsXWTUlcFuMqC04GgHFiqVA+zAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4uFcoGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4uFcoGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECCE1F00893;
	Sat, 30 May 2026 17:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160486;
	bh=jmIO39QxuLSvWHamBTahfV1NReo4cM57yYowT8M02M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4uFcoGdemLT2PFdVBmuT//ZVFll7dpVYqr6byuLNNtZbkxqgvsMR+ujtc5ZE8uWj
	 KJNNWNxDyFk0E7DFCTBnv0c+B7H3vl9QRK6/1wDwOaJWFCxBN5DVn2h9/40U22av6T
	 8ZcbovWvpKrF2GrlOTRXimLmh/uTNoRzrzxR0PGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 352/969] dm-verity-fec: correctly reject too-small FEC devices
Date: Sat, 30 May 2026 17:57:56 +0200
Message-ID: <20260530160310.071936118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -684,7 +684,7 @@ int verity_fec_ctr(struct dm_verity *v)
 {
 	struct dm_verity_fec *f = v->fec;
 	struct dm_target *ti = v->ti;
-	u64 hash_blocks, fec_blocks;
+	u64 hash_blocks;
 	int ret;
 
 	if (!verity_fec_is_enabled(v)) {
@@ -765,8 +765,7 @@ int verity_fec_ctr(struct dm_verity *v)
 
 	dm_bufio_set_sector_offset(f->bufio, f->start << (v->data_dev_block_bits - SECTOR_SHIFT));
 
-	fec_blocks = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
-	if (dm_bufio_get_device_size(f->bufio) < fec_blocks) {
+	if (dm_bufio_get_device_size(f->bufio) < f->rounds * f->roots) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}


