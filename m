Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C482F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33C2C433D2;
	Wed, 12 Apr 2023 08:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289011;
	bh=NLgz+D4bbyC18ML98+qX7tzxBiWxKwin3TFzVfdIlzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPefooODCwaE+H10OPyn5ZK42Lx5qhZIZcFSxYzoPeTwJ8YOHZkwtVyTp/IYrPpbP
	 nlA0J06sXXhsGS2tD5r42I6Ecu8UQocWpDgNYjWCrp6dL8A+TWqv6Kcd1NUvM0vTQy
	 g/p0s3TngGkowvsbM3elR/ROWH9eQcAK9QpFnPOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Lukowicz <wlukowicz01@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/164] io_uring: fix return value when removing provided buffers
Date: Wed, 12 Apr 2023 10:33:44 +0200
Message-Id: <20230412082840.964589801@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wojciech Lukowicz <wlukowicz01@gmail.com>

[ Upstream commit c0921e51dab767ef5adf6175c4a0ba3c6e1074a3 ]

When a request to remove buffers is submitted, and the given number to be
removed is larger than available in the specified buffer group, the
resulting CQE result will be the number of removed buffers + 1, which is
1 more than it should be.

Previously, the head was part of the list and it got removed after the
loop, so the increment was needed. Now, the head is not an element of
the list, so the increment shouldn't be there anymore.

Fixes: dbc7d452e7cf ("io_uring: manage provided buffers strictly ordered")
Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
Link: https://lore.kernel.org/r/20230401195039.404909-2-wlukowicz01@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 746b137b96e9b..9a9db1fcdc14d 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -228,7 +228,6 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		return i;
 	}
 
-	/* the head kbuf is the list itself */
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
 
@@ -238,7 +237,6 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			return i;
 		cond_resched();
 	}
-	i++;
 
 	return i;
 }
-- 
2.39.2



