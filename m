Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063124;
	b=Z0V1W+FtuCwRxTKPCpx7Xr5NcXHkUZ8oDuYkJl9uGCHmW6wnFuMmjSJuJbiMBiKChnLg
	 kfCrjTK9cYGpqMcULaKGr68PDrw6WDYZYw3U+HYRt0TBenJjm8eO8IV7xEtx3XfxAe5le
	 XSiRNYjRAqNHwck71IRWch2FcyGlwaJHjBR2aA3qAWrJXDRjC5B/5r9D6l9U7H213NBhR
	 NXBUvpSA9M72Tzeky6g4o0BKiM/fLeqzeEinnjnSks8odzD6xoy8mIvXe+fmXlQeKDZLB
	 pI1Dt4qe2mV+GwtL50ATSglguJ8kpuQUi0sQieZa8NC01ixXZApOjHv0+IB4MDM5eXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9aGtfobb+D8kfAilU700M6E/h4yVp0scNwQ6mU95xnI=;
	b=tlZRXQf2vWxf/STsdKoWZQR/DuUW4Bma3+WeAmsi1CGqIr752xogjn0zkjoCPTBUhs91
	 TbWyg7VXSITfepEgfAY5p4qCg/8XB6RsNuWfpLJ77/SoVeCcHrqN1N4uOBOg1xikSBcpX
	 hmPtm136tTshhBvdgIJs8HAmqQl2DQVXtYM2zInnAnGEN6yIoEtI7dZ1SPX0LglK1S+Np
	 YXn2NRSyJ+6bWU1dyFDItEgEFGexWZJwd46MTnKja9GbvMyRee4VPsCbWQz0PQXYeRE5Y
	 hsuX+0wv0HfvDnqiwA2IeQiuQjaHhbReK0ItACCh6irGtVF+iyIh5ruK4cs/AfxNrPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0UFIgPU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3742606A33B;
	Sat,  7 Nov 2026 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0UFIgPU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882631F0089F;
	Sat,  7 Nov 2026 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063123;
	bh=9aGtfobb+D8kfAilU700M6E/h4yVp0scNwQ6mU95xnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0UFIgPUY+z1E5eBQiTu1BOZ3i0nscPlOcoJanPrlG06cWPfgYeHb62Gemv6Y4Vt/
	 fl8EK1O1a/em83r4RCcCNgIkEkn4KgeRXBoxnO6GqCnIeHhScAoQARrK/yOZSHpWe4
	 GLWZvEsZlU6mwZndZRpSkstZe2cJHbsPSJxEi+Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 315/869] dm: fix a bug in dm_accept_partial_bio
Date: Sat,  7 Nov 2026 08:49:57 -0500
Message-ID: <20261107134903.177609886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f587b7229ce89..077bf8b16a0bd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1349,7 +1349,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
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



