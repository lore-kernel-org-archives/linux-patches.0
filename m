Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064331;
	b=RK4b59S42/npgB1IwMSL1Y7rPGylc+CoWRCSE4hdrYc1U4dycGGgeJ76ZsXtcqjvpCOf
	 JxiDaez+dzam1hZDNR34B/hd2flDt6N61CqUN9WPuOjtrFqb+LjUy4I5wQ3Ygvlu/nhkk
	 ddDWYuDU+x3tuIWyoexsfRB0lazDFq84NoE3ggFujBaktc4LiTAkGVkqG0sN9dnHUTN5/
	 2OG0dmi4Krsz4fd7KtiH7CUJU4tzCmlvkCTKydq+EZTmIoNDF/fd8gh+MBFWtEFinRLIO
	 pajSWETUuStzG1qM6e4oo7SZzl5NpKTI/n+bj1Phf0EsNVlQhuNf0hxmPneDllpxYJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ijZ1SUVeenSv/mFdh6xUzQCREqufZXeaBOCZGNgxUE=;
	b=rLlki9dQifYUcFUu3zN/5SAeoehigvuSOlh/sql5b7+j7S9MXqADyyYaT6MFkmB0CwjI
	 GNxK2OY6D4vhlUEvgXhJsA+glX/3hCg4HbQsBYiGQsDVn+aphsqArWO+kznH41f45G1Ou
	 +0XXS7hokkTBtJNYG0Qv/MZW8ypChdgqyvKINgD3uRf8G+76UkkW5yFuidicf3iH/3kLg
	 m+22rLxeXBHRyCNhrr1FIPMSm9M1KG5l3TUREEozbB61H7DnYY5J0cQjWhAATICajrAdh
	 jHvhwVvV/a234xxyrrIu8QQ9+a3wSpldQXrCH03SypIsS4Nn8MK/GSHzLdo1kWaxc6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXQYILzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB54606A336;
	Sat,  7 Nov 2026 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXQYILzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB4B1F0089F;
	Sat,  7 Nov 2026 15:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064331;
	bh=4ijZ1SUVeenSv/mFdh6xUzQCREqufZXeaBOCZGNgxUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXQYILzvg2b0NXl773uFOWPrGPFFdQYZRfBABJG8x7G4LM0o088XanKY1QbCAsoe+
	 VrRpwPb4nqhPHDbbNAA9OLHUsaHRF7E7tfgm+vG3Y0yfNWA5QOEn0r3opRSRPP3N76
	 jd8ahkpxC+FHXFLXO3K5EaUOtcVOSJeCWE5gb6RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0416/1257] dm: fix a bug in dm_accept_partial_bio
Date: Sat,  7 Nov 2026 08:45:12 -0500
Message-ID: <20261107134951.000908204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit a279804752e6c767b7f9ecbb32a15bdfd2b80aea ]

dm-writecache doesn't work in pmem mode - mkfs.ext4 and the following
fsck.ext4 fail with data corruption reported.

The commit 7dd76d1feec7 ("dm: improve bio splitting and associated IO
accounting") introduced a latent bug in dm_accept_partial_bio - it set
tio->io->sectors = n_sectors;. This is incorrect, according to the
diagram in the source code at dm_accept_partial_bio, it should be the
size of regions 1+2, not the region 2 alone.

The latent bug become real bug with the commit 8b211aaccb91 ("dm: add two
stage requeue mechanism").

dm-writecache in pmem mode is the only target that actually advances bio
with bio_advance and then calls dm_accept_partial_bio (so, the region 1
is non-empty). All the other targets call dm_accept_partial_bio with
region 1 empty, so bug went unnoticed for so long.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 8b211aaccb91 ("dm: add two stage requeue mechanism")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index eb9e32995b79c..1881d86111fb2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1350,7 +1350,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
 	 * for accounting but it is being reduced so update accordingly.
 	 */
 	dm_io_set_flag(io, DM_IO_WAS_SPLIT);
-	io->sectors = n_sectors;
+	io->sectors = *tio->len_ptr;
 	io->sector_offset = bio_sectors(io->orig_bio);
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
-- 
2.53.0



