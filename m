Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE9E37702A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301632; cv=none; b=sCZwr4idpl2aUPZ4wmW8WjNUbPGpXZNXRcYaAm53bfybcZ8KUoUHePADMX44p+8WaGjofcnvpg5RB/CANDMkBxku/TZn3uVtNQXx/nmD8itl3ey3a29cITjXIcDFy4+q3tyu4xKow/R08Q2GXXWPVaYgPUfgzjZ4CvBmnXxUfqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301632; c=relaxed/simple;
	bh=RFtpnhPunX2DUQZ4/rRyUHxGsw05eMJrizjF0XTaL6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXbRFH8SIKTBf8ij9/nW1C1wgZtZs3NFD1WeJpICVrR747x3jYvteuIsZszclp0RM+pt7aYbakN4sGJ8U4pZgTRvPzKj54/PgcDQoAT/w4dNVXEz+CDtW/tSm5SBKDlDHkctze03NBAcnLh9y5FSi5cceHZ9DtbQaBVh1q4M2WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrST/ZZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrST/ZZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6430AC116D0;
	Sat, 28 Feb 2026 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301632;
	bh=RFtpnhPunX2DUQZ4/rRyUHxGsw05eMJrizjF0XTaL6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrST/ZZGBrLGUhtAdp1df2yzqkuoZzuHWJvVIa3S4XJDEtOBfFuC9vIDeo9J4XDSw
	 W9cKxWT/TjeWXR4IzfcUPwUXilo2BTSUfLx96hc1kkebaZhTLILWrfOiRjUWiTiqzo
	 d1/P3AbHdZsrHGXYQGvMQSZJHPCaw813XugHSpCvnxyhnvUaTOUSmQcU1OPVv7fx8+
	 rEyrlAE/TEnwsc8ohTPE0deW7cprieyqcUCOtEsLNDk68nQuDz5TcKkyRXJN5pxKHl
	 7hMkrn0LCQNNqkBFYlAYnKMUMoiIbJ7HzL2S6e6Sq842X8KspRo54yz/SynV1YvdvD
	 Xxe5M/Ivr/yLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/385] block: add a bio_add_virt_nofail helper
Date: Sat, 28 Feb 2026 12:54:06 -0500
Message-ID: <20260228180011.1568201-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 850e210d5ad21b94b55b97d4d82b4cdeb0bb05df ]

Add a helper to add a directly mapped kernel virtual address to a
bio so that callers don't have to convert to pages or folios.

For now only the _nofail variant is provided as that is what all the
obvious callers want.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20250507120451.4000627-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 4ac9690d4b94 ("rnbd-srv: Fix server side setting of bi_size for special IOs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c         | 16 ++++++++++++++++
 include/linux/bio.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 094a5adf79d23..b919f3fa2f2d4 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1119,6 +1119,22 @@ void __bio_add_page(struct bio *bio, struct page *page,
 }
 EXPORT_SYMBOL_GPL(__bio_add_page);
 
+/**
+ * bio_add_virt_nofail - add data in the direct kernel mapping to a bio
+ * @bio: destination bio
+ * @vaddr: data to add
+ * @len: length of the data to add, may cross pages
+ *
+ * Add the data at @vaddr to @bio.  The caller must have ensure a segment
+ * is available for the added data.  No merging into an existing segment
+ * will be performed.
+ */
+void bio_add_virt_nofail(struct bio *bio, void *vaddr, unsigned len)
+{
+	__bio_add_page(bio, virt_to_page(vaddr), len, offset_in_page(vaddr));
+}
+EXPORT_SYMBOL_GPL(bio_add_virt_nofail);
+
 /**
  *	bio_add_page	-	attempt to add page(s) to bio
  *	@bio: destination bio
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1289b8e487801..80ca2fb879504 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -425,6 +425,8 @@ void __bio_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off);
 void bio_add_folio_nofail(struct bio *bio, struct folio *folio, size_t len,
 			  size_t off);
+void bio_add_virt_nofail(struct bio *bio, void *vaddr, unsigned len);
+
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 void bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
-- 
2.51.0

