Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3369685270;
	Wed,  7 Aug 2024 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043197; cv=none; b=GZAWSoXnBYfa+ikm+Y/X8og5rDv0rk0ffopN5zCcXx/RQTjR2pNYd+7UVXC1yg6KO/KfRA25cZgRjz0nb2X1L1FN4Lee+GcsqsZQR1hOuHUlX4QYvRa0BS5aD7Y0fMkFZuWSr6QwTqmpX+10ZA7fLnW2DkZLsg4ewbTFWH8lPVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043197; c=relaxed/simple;
	bh=Xoe6nLD57TYWN5Bx0P9bsVTeltsjQKYlTREMPAhU41I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0bGN6Lpvq9dAkL54ihMB+6bNSgNu2faRgISPYhWWjP/3fkmi7WrWA8ubzSwEHI6LufXh9u9+O2hO0Lwa84wpcakKur+tjToe1bn7OnsOSZgqZu8bCqZEuLMiIsCNw+hT0+UzUaWk/Q+26hCIOEqLNRatOc6+s0jNnxH9lL9QFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhI+GxPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhI+GxPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3B0C32781;
	Wed,  7 Aug 2024 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043197;
	bh=Xoe6nLD57TYWN5Bx0P9bsVTeltsjQKYlTREMPAhU41I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhI+GxPoTfavqrj781Hj2pCpnX2duBDXLzZkGfr5d5zTAZvJpmCfHtgVIlAZGaD22
	 5JF4057NYMzy4+AcdWK+vn34SjObWNMQv1RSLLEfhTawJF+o9gM2yTnnrqAbhPaazS
	 Os5Y9/LOZ6pRzoarSXpFQYMYaw7qY1bmObyaUBcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Langlois <olivier@trillion01.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 107/123] io_uring: keep multishot request NAPI timeout current
Date: Wed,  7 Aug 2024 17:00:26 +0200
Message-ID: <20240807150024.316902125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

From: Olivier Langlois <olivier@trillion01.com>

commit 2c762be5b798c443612c1bb9b011de4fdaebd1c5 upstream.

This refresh statement was originally present in the original patch:
https://lore.kernel.org/netdev/20221121191437.996297-2-shr@devkernel.io/

It has been removed with no explanation in v6:
https://lore.kernel.org/netdev/20230201222254.744422-2-shr@devkernel.io/

It is important to make the refresh for multishot requests, because if no
new requests using the same NAPI device are added to the ring, the entry
will become stale and be removed silently. The unsuspecting user will
not know that their ring had busy polling for only 60 seconds before
being pruned.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: 8d0c12a80cdeb ("io-uring: add napi busy poll support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/0fe61a019ec61e5708cd117cb42ed0dab95e1617.1722294646.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0a8e02944689..1f63b60e85e7 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -347,6 +347,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 		v &= IO_POLL_REF_MASK;
 	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
 
+	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;
 }
 
-- 
2.46.0



