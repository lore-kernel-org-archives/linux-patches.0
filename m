Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7476B1CA8F;
	Mon,  1 Apr 2024 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987535; cv=none; b=cZPPoh4XM+jxa0jGyJE4m5BWIWt2E9aH4w4xo51Qc6XGjMOgF0rv+p/+TjnJ6tDadn83RTkXzkb0TnS2PdiVgWh1o+aayRTvi3o5tUQlJ7L2aP6sSV+HhNUFZ+UwbKhdEDJIeskiPH59bhCyZ8iq24UOtOSB4rIo3cTiWi99Usg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987535; c=relaxed/simple;
	bh=DGN7cQOgdW0wvg8lJ8LY3AuvYfMhTQ6ZBsP3bKwzgcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoziRPAqGNfne2HW+tp63JWesQcnWli3hI9t6V5XsjsolIG5u62ZLt2GIKvep3wsW/R3fdyzplN7RXkjjChHULppgq5SOBN3S5B+VbUTwBzx2KRnOYy0cUnuxre5c8XwpzMStUemux3k7wac374aY7oqC8H3uVK37KU2NOcKcp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxd6RElW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxd6RElW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FFEC433F1;
	Mon,  1 Apr 2024 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987535;
	bh=DGN7cQOgdW0wvg8lJ8LY3AuvYfMhTQ6ZBsP3bKwzgcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxd6RElW3CmVVdavoDbC1LbtK2bvWaCxJguqx/fo8ukbGIHGFx3jRaeFpWGVDXhmC
	 ImebNVyfuHK1P5K72O2c9LWEBicA9SoM3DUeGb6gLV2TtVG4SB07WNHQ5msOfXkbci
	 CiQVbmbp7HvAy1/4v35iU1MHRFGQsjTRaLbABndY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.8 316/399] block: Do not force full zone append completion in req_bio_endio()
Date: Mon,  1 Apr 2024 17:44:42 +0200
Message-ID: <20240401152558.616641709@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 55251fbdf0146c252ceff146a1bb145546f3e034 upstream.

This reverts commit 748dc0b65ec2b4b7b3dbd7befcc4a54fdcac7988.

Partial zone append completions cannot be supported as there is no
guarantees that the fragmented data will be written sequentially in the
same manner as with a full command. Commit 748dc0b65ec2 ("block: fix
partial zone append completion handling in req_bio_endio()") changed
req_bio_endio() to always advance a partially failed BIO by its full
length, but this can lead to incorrect accounting. So revert this
change and let low level device drivers handle this case by always
failing completely zone append operations. With this revert, users will
still see an IO error for a partially completed zone append BIO.

Fixes: 748dc0b65ec2 ("block: fix partial zone append completion handling in req_bio_endio()")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240328004409.594888-2-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -771,16 +771,11 @@ static void req_bio_endio(struct request
 		/*
 		 * Partial zone append completions cannot be supported as the
 		 * BIO fragments may end up not being written sequentially.
-		 * For such case, force the completed nbytes to be equal to
-		 * the BIO size so that bio_advance() sets the BIO remaining
-		 * size to 0 and we end up calling bio_endio() before returning.
 		 */
-		if (bio->bi_iter.bi_size != nbytes) {
+		if (bio->bi_iter.bi_size != nbytes)
 			bio->bi_status = BLK_STS_IOERR;
-			nbytes = bio->bi_iter.bi_size;
-		} else {
+		else
 			bio->bi_iter.bi_sector = rq->__sector;
-		}
 	}
 
 	bio_advance(bio, nbytes);


