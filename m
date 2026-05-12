Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AE933ADBA;
	Tue, 12 May 2026 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609411; cv=none; b=TWhQwiyQIl40Pf8hm6AJYjo13xR9f9pJkibEOTUuZ2e3DovJmIy4ESgayZ1fWSt+KYGeiyR11kuh9GGcwyrObMG5pF82VMIoJcvnKSVhSLbXVl/wf4LgtPkNNBDVlPscXBBVYNKjKzZt+oNM/3ekwfp2f7XwnLU3PuwAseYNq20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609411; c=relaxed/simple;
	bh=kzziHcdO6BGWcG8yrsFEiwvHvFtbHNvtnCmUeTnk+Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cy00uy7ic9wNFN5MrREP6E5+uQmR/oPVIFe+4mUdIajqX8ogsEKsnFpCoa62bJy0QY0McIUQXHvy7TPKALqLtzwVyAf2OxhGemMJUltjmM7H/XOw0y+rfX4ZvP7d7ZwakkiDnpiGlg/5fapNZuANRPbKIYLKaXcrMZHB56/TvDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x7R80wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x7R80wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F07EC2BCB0;
	Tue, 12 May 2026 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609411;
	bh=kzziHcdO6BGWcG8yrsFEiwvHvFtbHNvtnCmUeTnk+Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1x7R80wtCVEJw7xMMjv8CLLure1ZIm++AdV2ldLNgChyeqbVdyuH4Fhttwry54Uot
	 QppNsEoy8hnr/1ZJL2/fdBD/HTksKB32pKLrsytE12MaAuMe4w3yo0rZXPN4ZBa/Xj
	 A/bc4j9NBFLH0JZWiX6BP1QgkqSTHo+vTHWK8RTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.0 185/307] dm-verity-fec: correctly reject too-small hash devices
Date: Tue, 12 May 2026 19:39:40 +0200
Message-ID: <20260512173944.020837761@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 4355142245f7e55336dcc005ec03592df4d546f8 upstream.

Fix verity_fec_ctr() to reject too-small hash devices by correctly
taking hash_start into account.

Note that this is necessary because dm-verity doesn't call
dm_bufio_set_sector_offset() on the hash device's bufio client
(v->bufio).  Thus, dm_bufio_get_device_size(v->bufio) returns a size
relative to 0 rather than hash_start.  An alternative fix would be to
call dm_bufio_set_sector_offset() on v->bufio, but then all the code
that reads from the hash device would have to be adjusted accordingly.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -688,7 +688,8 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * it to be large enough.
 	 */
 	f->hash_blocks = f->blocks - v->data_blocks;
-	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
+	if (dm_bufio_get_device_size(v->bufio) <
+	    v->hash_start + f->hash_blocks) {
 		ti->error = "Hash device is too small for "
 			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;


