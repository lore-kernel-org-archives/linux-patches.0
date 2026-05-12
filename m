Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5543DC871;
	Tue, 12 May 2026 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608003; cv=none; b=oV5pD2/SpTbyF2F2O40mp3KkED9DahKRQBUSUaP1myf46Hikk8gm4wKLBacIzOtqqEOmBq/mMguTblyRfQWpY9dSDh6uXfZAo7UmM9gpvqpFF/LgaiBQD+NYU/GRKJwxNfZWEO2d8SoOaWKXNBwUlocDhaeWgpFCsMptEi0UFqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608003; c=relaxed/simple;
	bh=MQLewFvvyh08mW2OlswtSftJMoeEoaZXiC1DZJ1XNx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEsLEZkxEnuJ5P6r+IMo8OHtbivtqZWJ7vXnNdyQLi7w40ic3GcOKRlV+n7RrBx8MVKHSaP5Dc8Sc2cJ79pFY5CSShY+3mX/I5HlZ901ahNISuuvTUom2DfcTaC8p8TkXO6LpbxqKYSX/l3Z2AdwipNyI/4E/ggQ6Msypa/Dhco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWbsciGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWbsciGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E16C2BCB0;
	Tue, 12 May 2026 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608003;
	bh=MQLewFvvyh08mW2OlswtSftJMoeEoaZXiC1DZJ1XNx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWbsciGtMV4FZGoB4WhmQUK/3NJGfnl5943Rc6s3EjF9GQYLjuaV5C47cNHe74aJ/
	 T5klnRjSkUkZmJIUP0bUlnxkf1VchqdNuQgNsNsURRwyHSi+gpOtdVehp6nZuNPjbq
	 +DFCg+/uNs0IUJB61lxMGaVEh2CpvceQCQDFAp3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 120/206] dm-verity-fec: correctly reject too-small hash devices
Date: Tue, 12 May 2026 19:39:32 +0200
Message-ID: <20260512173935.398181728@linuxfoundation.org>
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
@@ -731,7 +731,8 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * it to be large enough.
 	 */
 	f->hash_blocks = f->blocks - v->data_blocks;
-	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
+	if (dm_bufio_get_device_size(v->bufio) <
+	    v->hash_start + f->hash_blocks) {
 		ti->error = "Hash device is too small for "
 			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;


