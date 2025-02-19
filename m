Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AAA1DED45;
	Wed, 19 Feb 2025 09:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957212; cv=none; b=EktKZzDJJzO70p1X+RsyGfiSTPkrB5JTglgkjfNwlM79Lxt7dqluxAq8V+svUSPxdGL2Cx06imuIuzkt+CBEmxFQQSFyklSrx1cHwCvPvZ6lbPdNaebRQi5PF6VP7Cc1rlyVfGQRPprZtjMkWRrUdaSzvQKEyWRfF9rvUJQf064=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957212; c=relaxed/simple;
	bh=i+z3IHMlNqVW4M5nSgTfc2F5DcoDt1lcgghMAH0Pcm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsNyvSfu/Wgm5Y2TqBbosZPzLoYmgZTEx8bERma3lMAXBbJXMJ69jw0aGl19aPpDVKA1CFDTOaTE7CQ3nHCyPKXFcmemjvV5hHbyaY2010P7rbLY44meFr/bgJyiiSXP35w3IrI1mdQvqv6wGhxFOakTorwqxtk1J7s/1ui8K8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHj1SUwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHj1SUwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E105C4CEE6;
	Wed, 19 Feb 2025 09:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957212;
	bh=i+z3IHMlNqVW4M5nSgTfc2F5DcoDt1lcgghMAH0Pcm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHj1SUwUUEVDNij8GopOxr1cFCh1sdqmlyrAWlllOJsyKab3Apa0JWMmcvcPh6A/y
	 5yNOpWV6AjDoVXUxUUyxUr4iifXKZNE4IDPj0B+dpT8i/HYSVnjrFb3cA3A9Yh9ZZp
	 SMft8zHKwU9tIWfLsYKFsa2IhCW2Ci5Zhqgc5HOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jacob Soo <jacob.soo@starlabs.sg>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 446/578] io_uring: fix multishots with selected buffers
Date: Wed, 19 Feb 2025 09:27:30 +0100
Message-ID: <20250219082710.540588323@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit d63b0e8a628e62ca85a0f7915230186bb92f8bb4 ]

We do io_kbuf_recycle() when arming a poll but every iteration of a
multishot can grab more buffers, which is why we need to flush the kbuf
ring state before continuing with waiting.

Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55c ("io_uring: multishot recv")
Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Jacob Soo <jacob.soo@starlabs.sg>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1bfc9990fe435f1fc6152ca9efeba5eb3e68339c.1738025570.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -307,6 +307,8 @@ static int io_poll_check_events(struct i
 			}
 		} else {
 			int ret = io_poll_issue(req, locked);
+			io_kbuf_recycle(req, 0);
+
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			if (ret < 0)


