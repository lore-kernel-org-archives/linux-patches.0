Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBC915C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5806C433C1;
	Mon,  5 Dec 2022 19:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268998;
	bh=Se/BmbcmrsFAzMis/ybys+Z+KOmd3ACZmPNIYhYEA9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHNuNeR4wQzC1DeM1rAicC30Bl/1TrLVnNbT9XfLiM/U4spdjx8SST+vxLtuOjx/i
	 KQeteb42QENPYMq6f5IoAKvyahVH2deL2Aa5bNp91gBylD5l96tuOmbko1t/QgOoSU
	 +RuvCzU7JevCmIKEKTi8amC7ywWWArRw6YcCramU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 089/120] io_uring: fix tw losing poll events
Date: Mon,  5 Dec 2022 20:10:29 +0100
Message-Id: <20221205190809.254634889@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit 539bcb57da2f58886d7d5c17134236b0ec9cd15d ]

We may never try to process a poll wake and its mask if there was
multiple wake ups racing for queueing up a tw. Force
io_poll_check_events() to update the mask by vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/00344d60f8b18907171178d7cf598de71d127b0b.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5440,6 +5440,13 @@ static int io_poll_check_events(struct i
 			return 0;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->result = 0;
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = poll->events };


