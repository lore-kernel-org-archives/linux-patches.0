Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B232590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E66C433EF;
	Sun, 22 Jan 2023 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401151;
	bh=2tIXl+r78TxBro8H69vzKfdMt3V0RHfnwM1ExV95BgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjSi/9SQMWF4TLyTK2BjbMoOIIvPb/fFIqzi1ZMpT3U1OOMFGHqIPQyevFwBfiOIQ
	 Hz9CYDyI40UMR6hH8+CLCO/M+HWtF4wEFyNvYFrg2Z+6IAD87Ppw0Z1P2zZ5judl8U
	 RKnwoNvNNRouFu/qBBn1ey2k68QWyP6WmmC9O1y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 099/193] pktcdvd: check for NULL returna fter calling bio_split_to_limits()
Date: Sun, 22 Jan 2023 16:03:48 +0100
Message-Id: <20230122150250.854855315@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 3e9900f3bd7ba30d60f82b162b70a1dffe4e8e24 upstream.

The revert of the removal of this driver happened after we fixed up
the split limits for NOWAIT issue, hence it got missed. Ensure that
we check for a NULL bio after splitting, in case it should be retried.

Marking this as fixing both commits, so that stable backport will do
this correctly.

Cc: stable@vger.kernel.org
Fixes: 9cea62b2cbab ("block: don't allow splitting of a REQ_NOWAIT bio")
Fixes: 4b83e99ee709 ("Revert "pktcdvd: remove driver."")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/pktcdvd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2400,6 +2400,8 @@ static void pkt_submit_bio(struct bio *b
 	struct bio *split;
 
 	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
 
 	pkt_dbg(2, pd, "start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_iter.bi_sector,


