Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECC11170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3537C433C7;
	Mon, 11 Sep 2023 14:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442139;
	bh=KHOx9Dd2c/wiFxa7GJlfcGoxUSZLechfLR7PvFjbdrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqXIHKAihH/MiqI61v8JlEQ2V7lXAY3kMGL3yAX5d8OX+5ooTabYVGsjLKrVQ1ZYb
	 s6SFSFYrJJF1jvzGFNrJy794KDx+m90d9tR1cWafZ5oO3QnLPedFyt6OkvgF516DEE
	 1mXIGGcLo+tUocZPL98FRrOzHWcFfDshF4KI/RUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 659/739] io_uring: break iopolling on signal
Date: Mon, 11 Sep 2023 15:47:38 +0200
Message-ID: <20230911134709.516294110@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit dc314886cb3d0e4ab2858003e8de2917f8a3ccbd upstream.

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
 io_uring/io_uring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1673,6 +1673,9 @@ static int io_iopoll_check(struct io_rin
 			break;
 		nr_events += ret;
 		ret = 0;
+
+		if (task_sigpending(current))
+			return -EINTR;
 	} while (nr_events < min && !need_resched());
 
 	return ret;


