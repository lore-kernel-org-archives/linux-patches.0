Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BB94A207F;
	Thu, 17 Sep 2026 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661239; cv=none; b=L8jiFhEvii96049ifHhhC2pMhrmIOMfRpKcnMX/mWM2LZ+pK2uOuu3L+Hjz6BNALDKDwhOwg72gtzm6So24OgQw6WO3f4fu15+4O/iS0ua1KdWpXLnUzFt7OCjSUQYrKz1Esyq4LV24V9RWsX2OfTBMBIzB3iVB5NBC2ZniiG0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661239; c=relaxed/simple;
	bh=tFtBNwNHnBo8xy4Mkx0eBmM4LrBcopt2Ev8RzrzX2rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ske96JVP8b+2tJzHXcss2gmYRMDYEEfSYlsQvn+JBX1ULNe6fn58O5ylkkK/jbXLIoMalgtuWkIIOM++lWQwULeuvyJOw8ctQ3Ph+yNkl7Ek2Q+KAcCjUyMq2VUQrKxCREo0vVaDGFpp0YDJPN+lMlvWVPKWZ3QV7eVkZF44e+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOOT4O0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOOT4O0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD9E1F000FF;
	Thu, 17 Sep 2026 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661238;
	bh=9NLDMvXPql46HCv6wkmHHsWZlkbuw8sGsLZA+09Z6TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOOT4O0sAeTbh2AsNhx74trTgs1Vv1DAjwVvr13vn7xFfH8SKq1eDWYQGKYcOwuBA
	 w8va1pCzwWqA5YuuM4i7C8mXFzQ8/eZVrWPbm3q1VyoI+tul+yeG+wFoVCQCQvmsgk
	 kYjULAuYroGhWIgcEH9i0f6aeG/G4nYnJ/ioHtbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0130/1250] iomap: dont make REQ_POLLED imply REQ_NOWAIT
Date: Thu, 17 Sep 2026 15:58:45 +0100
Message-ID: <20260917151555.564490006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e73c71f39bd45..92f32e02f77f4 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -74,7 +74,7 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 
 	/* Sync dio can't be polled reliably */
 	if ((iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(iocb)) {
-		bio_set_polled(bio, iocb);
+		bio->bi_opf |= REQ_POLLED;
 		WRITE_ONCE(iocb->private, bio);
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 3a9dd300b5eef..fb747b053b98c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -690,20 +690,6 @@ static inline bool bioset_initialized(struct bio_set *bs)
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



