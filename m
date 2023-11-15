Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFD73DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RavQ76Yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF35AC433C7;
	Wed, 15 Nov 2023 19:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078184;
	bh=LoOsZO7kiJj3CfheIMNGqINKAhquKSxH67kqJOJ/GQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RavQ76YoHOrlE+BSzIP6thh185OCei4VKSuw+rBX6xYeID+8M0Qd983kmw8klZpOT
	 iH0XTlaa223afo/PW8YBkJ+2HFKMJ1wRSH1Z90Xnu3VUIMLhfBFg3r2dRqVbIrUhMI
	 QocHO8rU1LNqYzoMNrevRUeQFUnZ4LX2JEhd+Yfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/379] io_uring/kbuf: Fix check of BID wrapping in provided buffers
Date: Wed, 15 Nov 2023 14:23:34 -0500
Message-ID: <20231115192653.346676307@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit ab69838e7c75b0edb699c1a8f42752b30333c46f ]

Commit 3851d25c75ed0 ("io_uring: check for rollover of buffer ID when
providing buffers") introduced a check to prevent wrapping the BID
counter when sqe->off is provided, but it's off-by-one too
restrictive, rejecting the last possible BID (65534).

i.e., the following fails with -EINVAL.

     io_uring_prep_provide_buffers(sqe, addr, size, 0xFFFF, 0, 0);

Fixes: 3851d25c75ed ("io_uring: check for rollover of buffer ID when providing buffers")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20231005000531.30800-2-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index acc37e5a6d4e1..e45602b02a9f1 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -347,7 +347,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	tmp = READ_ONCE(sqe->off);
 	if (tmp > USHRT_MAX)
 		return -E2BIG;
-	if (tmp + p->nbufs >= USHRT_MAX)
+	if (tmp + p->nbufs > USHRT_MAX)
 		return -EINVAL;
 	p->bid = tmp;
 	return 0;
-- 
2.42.0



