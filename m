Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0104E1E487;
	Mon, 23 Jun 2025 13:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684515; cv=none; b=MuWPv+iQ/86sh6X+bu9annY0lpySr511LGgrM8+/QmHmtYdyiWR7b4tINzWlOSav8bFNqdgbpP8DZjUj5ZlfRGKck+uDi2St/N1UBUJhbNTdg0xQn5PRhVFA6XQkL2QN+35HUv+5RLkqtl5rvyEmGj9epajBmE3qDjtHyejcJyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684515; c=relaxed/simple;
	bh=ziDLXIbWAXOZE0tn2IhuFQDf1Ho5tZ4LRzAACAs/fLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqTQ250/ugVoXQCTgiss53KlP3071iECt9AZRlBBn5g/RWPxIS1nvQtXVqZSHzkhSxqR9CqvZ8M2mRaUveJBIg68/xWrULgN0PLImIIOgBOncCsazYmgyKuNyhgbTByrHYbuYkkFTR11UJ+JrZi23bCGUHTclG68Fbr7/GAC3AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/Hf3D1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/Hf3D1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879EBC4CEEA;
	Mon, 23 Jun 2025 13:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684514;
	bh=ziDLXIbWAXOZE0tn2IhuFQDf1Ho5tZ4LRzAACAs/fLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/Hf3D1zUu06mur9UbfaA0eU7fEa69Q10mV8qijuPY8hQ91NJsAgp/QE4r6xnHr68
	 aRy/Od293ydP6IIu7KM6dCzBtBaBrlJF5DTM5lc73O9fKYvJUjmZycQnYOzpTJlISM
	 GcGsMH2KWYHuKMKyxavDFpe4UlgtLLBtuzrZvoxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 098/592] block: Clear BIO_EMULATES_ZONE_APPEND flag on BIO completion
Date: Mon, 23 Jun 2025 15:00:56 +0200
Message-ID: <20250623130702.608252826@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit f705d33c2f0353039d03e5d6f18f70467d86080e upstream.

When blk_zone_write_plug_bio_endio() is called for a regular write BIO
used to emulate a zone append operation, that is, a BIO flagged with
BIO_EMULATES_ZONE_APPEND, the BIO operation code is restored to the
original REQ_OP_ZONE_APPEND but the BIO_EMULATES_ZONE_APPEND flag is not
cleared. Clear it to fully return the BIO to its orginal definition.

Fixes: 9b1ce7f0c6f8 ("block: Implement zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250611005915.89843-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1225,6 +1225,7 @@ void blk_zone_write_plug_bio_endio(struc
 	if (bio_flagged(bio, BIO_EMULATES_ZONE_APPEND)) {
 		bio->bi_opf &= ~REQ_OP_MASK;
 		bio->bi_opf |= REQ_OP_ZONE_APPEND;
+		bio_clear_flag(bio, BIO_EMULATES_ZONE_APPEND);
 	}
 
 	/*


