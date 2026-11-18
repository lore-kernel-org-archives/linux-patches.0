Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036207;
	b=lEJ0qbGgDPXAG+AOXncAb/V27JN6HdgQzPXCmkqt0U9Ye23YZ4T1eAHFNEbB7Y2CqJ97
	 6SYkL4QudHOgaTm5zgBefvco4PiKLQ5lfCc1JncCLZHfHcJoE+IBiAOh727SGy2JBL0pL
	 2B/mfIY+VTInJshv/hYTe/p9fNTcYKQ2CrifkAnmzvwuYtjd0qiv5g6M5/P39wDGa9WIo
	 EZyo9KdOhMdURTkK8gkq9vinEUfjkPC7cSq07lhvPTGXumLzy/mf9XdKA5vTubcGfcbUo
	 cwdZm/bQQgIKFRtiq6Yxz8zZ72bc4huY8BVKe0afcq4s+19YZ5BNdcujqemqamxDNsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LSIlPUQAZKTv4oD2F0Ixaf3Bf28bDI4+w+MlOEbB67c=;
	b=VfMB7qrn+EBkRNUcKkX7JeQV6toFqkt2xGqlkDIHM8dxI46Vl247ssarcOVxQ0zHpdmM
	 E0SMweehRnmcP/P7HCL8Ce3bzO/k6iIO4/ezuw30KjDQEjEYx4UPq6bK7pLFfklpHRvsK
	 tKUNWlwLKGcqlwx01LgeZLz7qvYXsaUsk5AZrhJ8mbbNSrAI22jJWEP0a+5SkHhSR2fen
	 4aqBK74BP0eFWhbi8TtCBCRxVMhbItKNT3ZXbIbFkaOHmGW5JNpTklDGsoi/1pGkuvY6T
	 bxeIzcU3iY/gZBunHqVSMtNeXeHEe7vOckowsxsHle9scGTJq6VRlh7f9+Bf/kw8AqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thI8ZEd8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40610606A320;
	Wed, 18 Nov 2026 21:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thI8ZEd8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979361F000C4;
	Wed, 18 Nov 2026 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036207;
	bh=LSIlPUQAZKTv4oD2F0Ixaf3Bf28bDI4+w+MlOEbB67c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thI8ZEd87iFhmlmA3DkDGrMk8x6t/b30BFXi0M+C1etbmPsU1ywFan0cGLs0nM4Vz
	 iX5bpeqlSYfofo9gLaDMw1msoAFrBxbTNCXp/O79ua3Vrn8a4e9nJwoft9WlG5b16A
	 mmghund2w1F490f5JdABwbOGCnK2Fl+rjQnGoogc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0978/3318] dm: fix a bug in dm_accept_partial_bio
Date: Wed, 18 Nov 2026 15:26:40 +0100
Message-ID: <20261118150349.073326763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0512d8bdf7e06..e4ebdd3d56d47 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1340,7 +1340,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
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



