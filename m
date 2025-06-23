Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7633C19C554;
	Mon, 23 Jun 2025 21:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714057; cv=none; b=WQlBymQQ9775q8lXh/pDaQRbs9/vjL7PMnBmxc3BNZ78o7Npl+0BkUXz/PWVF4gabK+40vEkFvXeuW35xDVt7kY+B2m1GWjDKa/shZv5Eo8+zV42/YEm73LJ+LTB+9BhckM8gmm688MmqxKaopCBURK1OwulG08j8h2+PH8Sfmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714057; c=relaxed/simple;
	bh=fTXZ4lEjuzwmRyy+wi/lWpeSP3N1sJxzkDXZBjiIsYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC+wvsLEmv2azPNsSJ7zhzAwqhMPgIy6qeu1gNg2arWxW6jzvSJu4brv0ea3RuTjTDWPEVEwz67x7yPl9PoY8iyAtCoaYcSD82EENcol9vMeZkvLE7Ha1E+dhZdt6oemzbjqNXGSWdgSV4HMFS3dy9ZMFkp9FzNkrW2UZXPFS/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZ7MYap0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZ7MYap0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10909C4CEEA;
	Mon, 23 Jun 2025 21:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714057;
	bh=fTXZ4lEjuzwmRyy+wi/lWpeSP3N1sJxzkDXZBjiIsYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZ7MYap0tkThgLhUV2PtTID6XSZvF0cni0tF8GkPKqs8iiVzRPcUvKmnPR4UsbwJ6
	 +4W/3TavqEyckkGGChlRN48WFgFDzULRBw7HdpKBZiJYFxXaho0gDqCwnNDd/2SH8J
	 vbubbAte/R7Rm08SAkapqLP37IF58LjX0KExA4xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 078/414] block: Clear BIO_EMULATES_ZONE_APPEND flag on BIO completion
Date: Mon, 23 Jun 2025 15:03:35 +0200
Message-ID: <20250623130644.031406009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1240,6 +1240,7 @@ void blk_zone_write_plug_bio_endio(struc
 	if (bio_flagged(bio, BIO_EMULATES_ZONE_APPEND)) {
 		bio->bi_opf &= ~REQ_OP_MASK;
 		bio->bi_opf |= REQ_OP_ZONE_APPEND;
+		bio_clear_flag(bio, BIO_EMULATES_ZONE_APPEND);
 	}
 
 	/*


