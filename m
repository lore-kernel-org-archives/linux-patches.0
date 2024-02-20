Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164462DF9F;
	Tue, 20 Feb 2024 21:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465315; cv=none; b=cjgcGT8BSBTGkx56FzrdJKrkEj3lHr0XsYY5q5+L9n5TbAM0Q4gpY50npA/+B9dUNwAsd2RHtwtNKBTKp7IDX110O8SMLOVTl3VtelJgw8Hd/LJusQ0ysCz0sCE8HqEeD6d4/mG9wJPp7k0QoEl98Sv5z29oT+czakM05+4ro7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465315; c=relaxed/simple;
	bh=CNMgyYBCZZWdC2bRjRv3xGlc+U4Y12u1yXcn4gqCPRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiMbf2m3121S0ASNSAgftDnBNLcMgg5k6wRcyFUVvCwPupfO/DDhBbMI5+a4Yevej7xDQVNegl77RXoRNhnypapoY0xfXaCvdBy3xvsur3tbJxOCy54iQOkDtVIlo4b9q0eZiiMGnu73BVAuD8fVoWpKFp6Rixs0pn0j1+V08xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmftaE2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmftaE2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C1FC433F1;
	Tue, 20 Feb 2024 21:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465315;
	bh=CNMgyYBCZZWdC2bRjRv3xGlc+U4Y12u1yXcn4gqCPRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmftaE2rbsVU3uypTuTtduXuMjennzypw4108cb7YbM6S3kCc/9d5Cqknd9C05wiC
	 fEuTvWh73hmmDXdxLh5SIAj1b03qq4t+Jh8eO7vu94aZnP4Dc7bXX9wSwN52cjRcfc
	 qRIk0AwzwONOvlSBLgyZL+1xtWZQtIgee+W7E7As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.vger.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 305/309] block: fix partial zone append completion handling in req_bio_endio()
Date: Tue, 20 Feb 2024 21:57:44 +0100
Message-ID: <20240220205642.637663438@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 748dc0b65ec2b4b7b3dbd7befcc4a54fdcac7988 ]

Partial completions of zone append request is not allowed but if a zone
append completion indicates a number of completed bytes different from
the original BIO size, only the BIO status is set to error. This leads
to bio_advance() not setting the BIO size to 0 and thus to not call
bio_endio() at the end of req_bio_endio().

Make sure a partially completed zone append is failed and completed
immediately by forcing the completed number of bytes (nbytes) to be
equal to the BIO size, thus ensuring that bio_endio() is called.

Fixes: 297db731847e ("block: fix req_bio_endio append error handling")
Cc: stable@kernel.vger.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20240110092942.442334-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a71974a5e57c..a02d3d922c58 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -772,11 +772,16 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		/*
 		 * Partial zone append completions cannot be supported as the
 		 * BIO fragments may end up not being written sequentially.
+		 * For such case, force the completed nbytes to be equal to
+		 * the BIO size so that bio_advance() sets the BIO remaining
+		 * size to 0 and we end up calling bio_endio() before returning.
 		 */
-		if (bio->bi_iter.bi_size != nbytes)
+		if (bio->bi_iter.bi_size != nbytes) {
 			bio->bi_status = BLK_STS_IOERR;
-		else
+			nbytes = bio->bi_iter.bi_size;
+		} else {
 			bio->bi_iter.bi_sector = rq->__sector;
+		}
 	}
 
 	bio_advance(bio, nbytes);
-- 
2.43.0



