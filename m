Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5101D3B7B7F;
	Thu, 17 Sep 2026 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667549; cv=none; b=lkN21Ob7h6EcMoH0WMz+FGurRM7foalxNfxDKNB8IMQb0tnzd0UO/yQrVzsK/OFtoKLZBzcMqoLvFJhlaW9YecFfNMDHIH8w8gnhg5WYh//X3Bng2EsbR5SjY04+0NzcxfaIdvCWzujuZLGOB/SK1q3SMSg0ToIfiQWoV0Bto6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667549; c=relaxed/simple;
	bh=WjBB0yH3oF/SPUn9NXdfPR5QPCr9rARjvydsW4O8i5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rucvtb3em6Bv3Arc61lz1LysSOYawczG3pFCdT1WxVO7qQTGmHOZ91qvgMzHj+cYuSpcrXEkCyXxDdUJdgdU34Od1kHEjdjnVLRbMgPFORDPZbFdzBLzZNf1dSRVg5qIVo0j39Owr0w0QW1i2wRWTx+ORpeSSe1WV3RiYm90qzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijrcsNOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijrcsNOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012EA1F000FF;
	Thu, 17 Sep 2026 17:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667546;
	bh=7i/T0VitiZwHgMvcBQCv1NFIzeK1KEHN1mFTZw2hn+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijrcsNODsGQ9AwtqzET48kMD8F1YyJBzvcDnvLVyffjrNavScLH4nR7/1xlKM7GFx
	 6uGGngKIjNBlmsJ1A2O5wybzlFD1J2QcQIZFjoK/xsWiZCuKnisz0JFfhGLPiNY9vp
	 XEUyiMyTn5ztaKhfcp/zvW/G77eaaf8+yh98lfgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0091/1102] iomap: dont make REQ_POLLED imply REQ_NOWAIT
Date: Thu, 17 Sep 2026 16:00:34 +0100
Message-ID: <20260917151541.770349360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 47f28b493daf9049307494689e515205f1c377af ]

As described in commit 2bc057692599 ("block: don't make REQ_POLLED imply
REQ_NOWAIT"), which fixed the same issue for the block device node, there
are valid cases to poll for I/O completion without REQ_NOWAIT.

Additionally, sing REQ_NOWAIT for file system writes is currently not
supported as file systems writes are not idempotent and would need a
retry of just the bio and not the entire operation to be fully supported.

Switch iomap to set REQ_POLLED and remove the now unused bio_set_polled
helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260518062917.506483-1-hch@lst.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c |  2 +-
 include/linux/bio.h  | 14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 5ccf215f932db..c81cfcbb1bb6d 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -77,7 +77,7 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 
 	/* Sync dio can't be polled reliably */
 	if ((iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(iocb)) {
-		bio_set_polled(bio, iocb);
+		bio->bi_opf |= REQ_POLLED;
 		WRITE_ONCE(iocb->private, bio);
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 80ca2fb879504..d4f58a2d15b69 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -661,20 +661,6 @@ static inline bool bioset_initialized(struct bio_set *bs)
 	return bs->bio_slab != NULL;
 }
 
-/*
- * Mark a bio as polled. Note that for async polled IO, the caller must
- * expect -EWOULDBLOCK if we cannot allocate a request (or other resources).
- * We cannot block waiting for requests on polled IO, as those completions
- * must be found by the caller. This is different than IRQ driven IO, where
- * it's safe to wait for IO to complete.
- */
-static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
-{
-	bio->bi_opf |= REQ_POLLED;
-	if (kiocb->ki_flags & IOCB_NOWAIT)
-		bio->bi_opf |= REQ_NOWAIT;
-}
-
 static inline void bio_clear_polled(struct bio *bio)
 {
 	bio->bi_opf &= ~REQ_POLLED;
-- 
2.53.0



