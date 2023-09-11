Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFEF1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1075C433C7;
	Mon, 11 Sep 2023 14:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442181;
	bh=9Jz+6T1Hw8pETNs2dNALOUyItSK5H5Kw0WgCYzMfXZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjRpuavysfTEhIeZsODMQRLfd4j3x+O+3vgWr0ZUO4YDTPJw7ajyRF8T1DRBmqno3
	 hdkuKS/0fS+ww1TV431vtg5hXKoX7Pspv+Sr+ZVkxfpI5AeYVBvlICxB/YJxjhreY5
	 vROVyDfwH7e+5RcSP85mFL4Bg7PXTiBTuZ8fiS9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serguei Ivantsov <manowar@gsc-game.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 637/739] drbd: swap bvec_set_page len and offset
Date: Mon, 11 Sep 2023 15:47:16 +0200
Message-ID: <20230911134708.886626982@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

commit 4b9c2edaf7282d60e069551b4b28abc2932cd3e3 upstream.

bvec_set_page has the following signature:

static inline void bvec_set_page(struct bio_vec *bv, struct page *page,
		unsigned int len, unsigned int offset)

However, the usage in DRBD swaps the len and offset parameters. This
leads to a bvec with length=0 instead of the intended length=4096, which
causes sock_sendmsg to return -EIO.

This leaves DRBD unable to transmit any pages and thus completely
broken.

Swapping the parameters fixes the regression.

Fixes: eeac7405c735 ("drbd: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()")
Reported-by: Serguei Ivantsov <manowar@gsc-game.com>
Link: https://lore.kernel.org/regressions/CAKH+VT3YLmAn0Y8=q37UTDShqxDLsqPcQ4hBMzY7HPn7zNx+RQ@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/20230906133034.948817-1-christoph.boehmwalder@linbit.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 79ab532aabaf..6bc86106c7b2 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1557,7 +1557,7 @@ static int _drbd_send_page(struct drbd_peer_device *peer_device, struct page *pa
 	do {
 		int sent;
 
-		bvec_set_page(&bvec, page, offset, len);
+		bvec_set_page(&bvec, page, len, offset);
 		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, len);
 
 		sent = sock_sendmsg(socket, &msg);
-- 
2.42.0



