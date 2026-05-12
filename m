Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE0542982D;
	Tue, 12 May 2026 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608001; cv=none; b=tBFiXfgyAXwO1g/7RMvyFP9zlpVxEcG4k8ueF5BEvf8XG0cB1zUNltQ0k8O7uP2L514HKfKBVOa672aNStTVf4iwH8twU+PWXMHoINcofAZz/B4ElvG21BtdSf6L3rK3Sb5Cksf3p8kcGW28E65dIQq8KIZyV5FYIVtxEOSaE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608001; c=relaxed/simple;
	bh=+oh8owfe8Zh1mXSPy0vGwlCEbNo2SDe+4aIjdWWIIv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjMFrD/w6zlQTEMve69JcnI+H0QHNojsU+JaNimxCjcybH3aHDXr3UGylkYN0sh98vh3A3gX88ZYfbwYAGScHS0VJx4BnLSvcagdiOzR2yy7kpLIBps3K4TJCuIZt0iH110WKtZq+5/Pw3tnAQ3zWHPz+jwGxgadU0FVdBLHDCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9aXKffA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9aXKffA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E2BC2BCB0;
	Tue, 12 May 2026 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608000;
	bh=+oh8owfe8Zh1mXSPy0vGwlCEbNo2SDe+4aIjdWWIIv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9aXKffAxOkc/kP7vfTIxD8mS7JThBj9xNw8yBns1shARc/kQ2i3VubmkvDn51RFT
	 sG8zqI/XPaSGBA6OXs9eYkk+L6yFQn0f5hRMiSGoVLH954UMNaA/yhjytd2SJIoT6L
	 Wgg5pQf2pK3K17y16jEo3hnYGGcgeCaPfMHsLUNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 119/206] dm-verity-fec: correctly reject too-small FEC devices
Date: Tue, 12 May 2026 19:39:31 +0200
Message-ID: <20260512173935.376209539@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -749,8 +749,7 @@ int verity_fec_ctr(struct dm_verity *v)
 
 	dm_bufio_set_sector_offset(f->bufio, f->start << (v->data_dev_block_bits - SECTOR_SHIFT));
 
-	fec_blocks = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
-	if (dm_bufio_get_device_size(f->bufio) < fec_blocks) {
+	if (dm_bufio_get_device_size(f->bufio) < f->rounds * f->roots) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}


