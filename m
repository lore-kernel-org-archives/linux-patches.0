Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D69517FD;
	Mon,  1 Apr 2024 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989030; cv=none; b=NZpnl8EhkU3m2plL/cVVdoYSjizfQHWl4ojU0BgBgHGvkxMfdcp/MQ9goukY3QXsTyjEY87QGYxZelkAdS9z2j3Bj7hACG0cd4J2uQPKZdqc9FBfhnlx0l48YSUeLnW4vJV6JxK/KWLbpZgq/qlIgzlydayNeQ0VY0fA3enGW/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989030; c=relaxed/simple;
	bh=Nld9IgLRx81dBnt5tvwa4R8slsi6jk6OAAXkAMqZmqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW0vVo87cgbswi6VcCuzld3jfnxIOdBnc21SwZ+dV2mId2EG1+5zzowiWmpliQtI/ML2JOZHiS1oVrnvU0bio6CjvIHuvasQyztgu6sztKtXWXp1LoxeNNHKWyzpfn48YF1bq89oZ6RFise/b8mVaM8GjJl0MKOseCeRkgqD+4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cL8fyYJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cL8fyYJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B470C433C7;
	Mon,  1 Apr 2024 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989029;
	bh=Nld9IgLRx81dBnt5tvwa4R8slsi6jk6OAAXkAMqZmqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cL8fyYJF3qEgiJ196u0FJw830sDPFs3WlAmx/EY6tybUgQR/pCWA/S00tsAJTJoz4
	 klXT0Ob68Wq+OvuEYXmT3lAak41C5wQkJMu8QKhqq7eokwSwpnoYylN0d8Y970L4AJ
	 Ejs5tonSuh/InfyGb29RP3jL2yI0W3/A1ixxXQIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 361/432] block: Do not force full zone append completion in req_bio_endio()
Date: Mon,  1 Apr 2024 17:45:48 +0200
Message-ID: <20240401152604.034503379@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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
@@ -772,16 +772,11 @@ static void req_bio_endio(struct request
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


