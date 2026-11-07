Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065557;
	b=0oigWWC31xFC5meg59icLaRxFikeglfz/y+g07agP0pUCZvgoCEXvFcW0D3pZi8cEkMk
	 sVkA9FgNIFwECPPT0KUllwhp+LTAv3MdoD1j7diVTveD2zQDkyw6hte+0AQTjffV6HDZ2
	 rwln1+6odR9OtPfRexqG3uoSyZ6aoXPK1Zepcg70ZGUlJFwtDAbcgsI+schbribwt3dG3
	 Hq+y/2fMJIZKuap11xBCVKMN57evrK8OcK5lqNffQ8z+DGY71eKtp9hJEEZbWxBds/eIV
	 gCy8NT8BAWkl3zl7GhcjVhZiSNGMM8t1WkCud0ptL6/aYIxOi8AE3jhbOyl8lD5bztQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vniFeLcO1lj6INhRxoIJULGCSdNxyWPHaW83b8U7A6I=;
	b=5LPOeK/uZkfr4XHawvbxYIu4+uKakAn0eiyJxciBXbxcycrGzdSwGutj37g1hU+JD7Uv
	 ZV5fU5ghrhPySNq9HW/f3eoWtVDHg9kHq4YYL3UALFWTjFhJim//uoWA3CTrL83fsEt6n
	 cLOPmLN50FQw2ameEERz660+JAddkX+c3MfTt/eNTdfDBQfa9K5ccFxRj0C3vJz/546DJ
	 IDHjyXdHPCO+7BIOTFrSdT8DG5sRyLG0IRzjlOTzasuSCPeLQ7eLJyZVHyX553pLRo3wV
	 XyukTNcmR7c8oUGOf0AW7cMUJPFyMsep7NVAnp0/dP9vCEi9SOjazcl7xRndC6PsXhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYmsHVYd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3A5606D814;
	Sat,  7 Nov 2026 15:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYmsHVYd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743AF1F0089F;
	Sat,  7 Nov 2026 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065556;
	bh=vniFeLcO1lj6INhRxoIJULGCSdNxyWPHaW83b8U7A6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYmsHVYds+kBn/GyLaBPud3CDuKGrdKGw25jDEhEkuvkI82wOxPirRL59+styyT6c
	 /QTfaephbSW+BhffdgwhezpG7kiwX5aqGf+BLS1+jF2yDs41rBZr3Tzu9DA3y0HBcU
	 DbTX7qObs0zsw3P5jWxYYNgSbv6URzhm8en7UbrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1228/1257] iomap: keep large chunks from defeating the bio cap
Date: Sat,  7 Nov 2026 08:58:44 -0500
Message-ID: <20261107135013.259953725@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit eb8ab8c23e71c6ae77dedc45de2a57a61558e5d5 ]

For integrity I/O a bio must not grow beyond max_integrity_io_size()
because the integrity buffer is a single allocation of at most 2 MiB.
Writeback and buffered reads check that before adding to a bio:

        bio->bi_iter.bi_size > iomap_max_bio_size(iomap) - len

The subtraction is done in size_t and wraps if len alone is above the
limit. The check then never fires and the bio grows until it runs out
of bio_vecs.

That's easy to hit. The limit is also capped by the maximum segment size
which is 64 KiB for SCSI hosts that don't set it, such as lpfc and
qla2xxx, and XFS uses folios of up to 2 MiB. Writeback of a preallocated
300 MiB file then builds a single bio that needs 4.7 MiB of PI with 512
byte sectors and 8 byte tuples. That's more than kmalloc() can do, so
bio_integrity_alloc_buf() falls back to a 2 MiB mempool element and
generating the PI writes 2.7 MiB past its end.

Check the length on its own first. A chunk above the limit still gets a
bio of its own which is never larger than a folio.

Fixes: 0b10a370529c ("iomap: support T10 protection information")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261029-work-iomap-ai-fixes-v1-2-7eda63bc1b13@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/bio.c      | 2 +-
 fs/iomap/internal.h | 9 +++++++++
 fs/iomap/ioend.c    | 3 +--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 48100c614431c..ee85b009c5c13 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -151,7 +151,7 @@ int iomap_bio_read_folio_range(const struct iomap_iter *iter,
 
 	if (!bio ||
 	    bio_end_sector(bio) != iomap_sector(&iter->iomap, iter->pos) ||
-	    bio->bi_iter.bi_size > iomap_max_bio_size(&iter->iomap) - plen ||
+	    !iomap_bio_has_room(&iter->iomap, bio, plen) ||
 	    !bio_add_folio(bio, folio, plen, offset_in_folio(folio, iter->pos)))
 		iomap_read_alloc_bio(iter, ctx, plen);
 	return 0;
diff --git a/fs/iomap/internal.h b/fs/iomap/internal.h
index 74e898b196dc1..e69b3ac02cc22 100644
--- a/fs/iomap/internal.h
+++ b/fs/iomap/internal.h
@@ -17,6 +17,15 @@ static inline size_t iomap_max_bio_size(const struct iomap *iomap)
 	return BIO_MAX_SIZE;
 }
 
+/* Can @len more bytes go into @bio? */
+static inline bool iomap_bio_has_room(const struct iomap *iomap,
+		const struct bio *bio, size_t len)
+{
+	size_t max_size = iomap_max_bio_size(iomap);
+
+	return len <= max_size && bio->bi_iter.bi_size <= max_size - len;
+}
+
 u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend);
 u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend);
 
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 32ae292a84cbe..c2891d640e827 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -176,8 +176,7 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
 {
 	struct iomap_ioend *ioend = wpc->wb_ctx;
 
-	if (ioend->io_bio.bi_iter.bi_size >
-	    iomap_max_bio_size(&wpc->iomap) - map_len)
+	if (!iomap_bio_has_room(&wpc->iomap, &ioend->io_bio, map_len))
 		return false;
 	if (ioend_flags & IOMAP_IOEND_BOUNDARY)
 		return false;
-- 
2.53.0



