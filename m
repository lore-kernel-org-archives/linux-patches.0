Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E076FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D98C433C7;
	Sun, 17 Sep 2023 19:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979448;
	bh=xxfQCAlqZC1Pop/J1WZVRKIBwDGgv8R60zpSX0n7y8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+fjtEVcby3Os7P8JXVmhR+Q1QKFjveeBBon8Y5KZK3zdd8UdnEJb6aIVJzfAkkQg
	 S1CpfftZgutHYB3U4m5i9SBQFF9+e9gw70C8Qa5a+/dTU6Svj/AQXIrXMNKh2CYxFJ
	 9Jp1wmuQDLFH00XCluEeddr1ZA/voXZAg3EfzGYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 316/406] io_uring: break iopolling on signal
Date: Sun, 17 Sep 2023 21:12:50 +0200
Message-ID: <20230917191109.643232691@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2665,6 +2665,11 @@ static int io_iopoll_check(struct io_rin
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


