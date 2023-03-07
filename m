Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F97BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DE3C433EF;
	Tue,  7 Mar 2023 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211083;
	bh=F0LrYIngtzAxJQJLg0IX9ZZ7/P4HSgoJskolKaaB5UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MksvjnBd4Qk+/x692iwA6A7ECM18Ts1L3OtlB+RUJfVCLEf6w/mURj88m4RX94/YM
	 hV+HW34xqpCi0qms6UvRW8b2//vYcFRrnFoHRxtMp3teRxBlYS0BtMIXTGPMymGL67
	 zu+xcaL2H+rTG+091FvxRw17XA5pYJvS6HFSXNF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0747/1001] block: clear bio->bi_bdev when putting a bio back in the cache
Date: Tue,  7 Mar 2023 17:58:39 +0100
Message-Id: <20230307170054.141856076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

commit 11eb695feb636fa5211067189cad25ac073e7fe5 upstream.

This isn't strictly needed in terms of correctness, but it does allow
polling to know if the bio has been put already by a different task
and hence avoid polling something that we don't need to.

Cc: stable@vger.kernel.org
Fixes: be4d234d7aeb ("bio: add allocation cache abstraction")
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/bio.c
+++ b/block/bio.c
@@ -773,6 +773,7 @@ static inline void bio_put_percpu_cache(
 
 	if ((bio->bi_opf & REQ_POLLED) && !WARN_ON_ONCE(in_interrupt())) {
 		bio->bi_next = cache->free_list;
+		bio->bi_bdev = NULL;
 		cache->free_list = bio;
 		cache->nr++;
 	} else {


