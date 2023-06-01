Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26353E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9065CC433D2;
	Thu,  1 Jun 2023 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625730;
	bh=f9Et4M50uKf6GLWUTPLno7qV2NtMUXyawKfOni93a0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmVAHfWFpFRr6ARI8eJvBomu3BSqcSPFTKjDKcrNSw8Sn0ebkuQtP9tpmOphpnU6v
	 OtE6zk9fx+vgi3usH9IfxN4UkBGAB9Loz0px21YCeoBJhng2K6ZN16Veycrtny/RFJ
	 EkUpW4aBzSzxTAi+j+jkmRCrXEeKSy1Lc9iTJz2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.4 11/16] io_uring: dont drop completion lock before timer is fully initialized
Date: Thu,  1 Jun 2023 14:21:06 +0100
Message-Id: <20230601131932.484137917@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131931.947241286@linuxfoundation.org>
References: <20230601131931.947241286@linuxfoundation.org>
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

No upstream commit exists for this patch.

If we drop the lock right after adding it to the timeout list, then
someone attempting to kill timeouts will find it in an indeterminate
state. That means that cancelation could attempt to cancel and remove
a timeout, and then io_timeout() proceeds to init and add the timer
afterwards.

Ensure the timeout request is fully setup before we drop the
completion lock, which guards cancelation as well.

Reported-and-tested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2079,12 +2079,12 @@ static int io_timeout(struct io_kiocb *r
 	req->sequence -= span;
 add:
 	list_add(&req->list, entry);
-	spin_unlock_irq(&ctx->completion_lock);
 
 	hrtimer_init(&req->timeout.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	req->timeout.timer.function = io_timeout_fn;
 	hrtimer_start(&req->timeout.timer, timespec64_to_ktime(ts),
 			HRTIMER_MODE_REL);
+	spin_unlock_irq(&ctx->completion_lock);
 	return 0;
 }
 


