Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D41F19F467;
	Tue, 30 Jul 2024 15:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355173; cv=none; b=fIPf5XTz+3hDwx7fDd9pbfalP/xmJSe55Ni0tH+52/8ove3jS4SRU7ibBnpX1+2I2y+5FZMkRz0N2lyVQ2jSscGKBhZztnEeNv2+1GslAUdxoIsuL6uuGHx5nxEu1eEStzrMtyqsbK5Y4VD6scUDYFgoXvrFCFKiRMbvUfglULs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355173; c=relaxed/simple;
	bh=zWYVtdKIVa5lvmiu9kSbKW31oDj39lDE74xQFGQyYyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGxejQoc9ob6vlICmcu/7HKOqApXo45XFhyhmOBVtWSvIOgMtDYC2TGR1d6wJcrKXrVPNjR03PCv1Lo+5SprfE9EFl+4RaDEFUml8YKQVGSbxCTWzcsY/TxiLVU8Jf/RrXQcGMl07dhLI9RXWuC9Xlkow9QuZITm/L3xqG4J2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b55Jg4UM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b55Jg4UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2E0C4AF11;
	Tue, 30 Jul 2024 15:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355173;
	bh=zWYVtdKIVa5lvmiu9kSbKW31oDj39lDE74xQFGQyYyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b55Jg4UMVthr6uuJdk1x1NHGPux7/TUAQw2Hl5GAjZ55HcL6ohGcf4/YK/REYxI+S
	 eq03TCzvM7n35nh59K0ep2ickG0QNzeJFHaFz4745GgR+Q8dYTOZ14YQIaTbKktB8n
	 rYJdCwDIXxPbItIv6+p8TAYq3Pozco/zHjdUMtQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 011/809] block: initialize integrity buffer to zero before writing it to media
Date: Tue, 30 Jul 2024 17:38:07 +0200
Message-ID: <20240730151725.104095679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 899ee2c3829c5ac14bfc7d3c4a5846c0b709b78f ]

Metadata added by bio_integrity_prep is using plain kmalloc, which leads
to random kernel memory being written media.  For PI metadata this is
limited to the app tag that isn't used by kernel generated metadata,
but for non-PI metadata the entire buffer leaks kernel memory.

Fix this by adding the __GFP_ZERO flag to allocations for writes.

Fixes: 7ba1ba12eeef ("block: Block layer data integrity support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240613084839.1044015-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8b528e12136f5..741581a752c47 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -454,6 +454,7 @@ bool bio_integrity_prep(struct bio *bio)
 	unsigned long start, end;
 	unsigned int len, nr_pages;
 	unsigned int bytes, offset, i;
+	gfp_t gfp = GFP_NOIO;
 
 	if (!bi)
 		return true;
@@ -476,11 +477,19 @@ bool bio_integrity_prep(struct bio *bio)
 		if (!bi->profile->generate_fn ||
 		    !(bi->flags & BLK_INTEGRITY_GENERATE))
 			return true;
+
+		/*
+		 * Zero the memory allocated to not leak uninitialized kernel
+		 * memory to disk.  For PI this only affects the app tag, but
+		 * for non-integrity metadata it affects the entire metadata
+		 * buffer.
+		 */
+		gfp |= __GFP_ZERO;
 	}
 
 	/* Allocate kernel buffer for protection data */
 	len = bio_integrity_bytes(bi, bio_sectors(bio));
-	buf = kmalloc(len, GFP_NOIO);
+	buf = kmalloc(len, gfp);
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
 		goto err_end_io;
-- 
2.43.0



