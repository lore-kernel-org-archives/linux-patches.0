Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEA11C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9694EC433EF;
	Mon, 20 Mar 2023 15:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325499;
	bh=yXkIvordsG0FbWFwnoOrwH3060OH0Ok0UgCYxJpM5ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+nOvz8P4qo1+8I1k12C9NIfBUch89CVBRwdjWtmZr/9ioAL/nANRq5o23JiC7lzd
	 Tv6Mvx2Lkr5+V8ZFCeUi20XcoTs5pZ9SEqkRbJRNk3uKF8Or65R/mVvpBvmDZr+uHb
	 rM8+SM+Rp6Z6xocwCN7G6Y99iS4VPMN12jRnlQpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.15 111/115] io_uring: avoid null-ptr-deref in io_arm_poll_handler
Date: Mon, 20 Mar 2023 15:55:23 +0100
Message-Id: <20230320145454.109386310@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

No upstream commit exists for this commit.

The issue was introduced with backporting upstream commit c16bda37594f
("io_uring/poll: allow some retries for poll triggering spuriously").

Memory allocation can possibly fail causing invalid pointer be
dereferenced just before comparing it to NULL value.

Move the pointer check in proper place (upstream has the similar location
of the check). In case the request has REQ_F_POLLED flag up, apoll can't
be NULL so no need to check there.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5937,10 +5937,10 @@ static int io_arm_poll_handler(struct io
 		}
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (unlikely(!apoll))
+			return IO_APOLL_ABORTED;
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
-	if (unlikely(!apoll))
-		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;


