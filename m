Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6197C746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F61C433C8;
	Sun, 17 Sep 2023 20:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982990;
	bh=QeSncU3ZBMuRN5pVqIjwOFIFuEV/cUE5X6MGkLSZ4QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oam+J6Ly2FRW5HWWyJSpMATjx4xXPKJ/LM+bQy/jYlt6ZtfAcNGA6Thyc3FoZPxAa
	 BH9V3urKgFcRXfexmPRQNk9ro7KZi00/5JYs3GI9nvVrYXP1uf6WuzN96fnXpYtBR2
	 rXvUMLl8D2v4wtNOJ5/Tebq4kpXXQ6ZZik2cMu+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 375/511] io_uring: break iopolling on signal
Date: Sun, 17 Sep 2023 21:13:22 +0200
Message-ID: <20230917191122.859107509@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit dc314886cb3d0e4ab2858003e8de2917f8a3ccbd ]

Don't keep spinning iopoll with a signal set. It'll eventually return
back, e.g. by virtue of need_resched(), but it's not a nice user
experience.

Cc: stable@vger.kernel.org
Fixes: def596e9557c9 ("io_uring: support for IO polling")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2668,6 +2668,11 @@ static int io_iopoll_check(struct io_rin
 				break;
 		}
 		ret = io_do_iopoll(ctx, &nr_events, min);
+
+		if (task_sigpending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
 	} while (!ret && nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);


