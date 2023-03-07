Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22307BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD8DC433EF;
	Tue,  7 Mar 2023 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211169;
	bh=4pf5IBGyLue0wQb/eNIEYnSoxwNh2FO7mEpvofoi6/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rycr5sC+Vh2vwTYa7r4Id+Eqj4Q7c7fO6SFQgqpqjrC/q4KnlhWaWs5gTIUQqOR1v
	 d2CAMnY55z/+mAFKskSh9lSz0bpiG1k9B0C3hYf6OzDegZ4WX0CERG3plYvGEzjfOF
	 1AkVjhpgFRdhKzkah+YbTC5B9V4471H2vyoBSUO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0758/1001] io_uring: add reschedule point to handle_tw_list()
Date: Tue,  7 Mar 2023 17:58:50 +0100
Message-Id: <20230307170054.624974474@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

commit f58680085478dd292435727210122960d38e8014 upstream.

If CONFIG_PREEMPT_NONE is set and the task_work chains are long, we
could be running into issues blocking others for too long. Add a
reschedule check in handle_tw_list(), and flush the ctx if we need to
reschedule.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1143,10 +1143,16 @@ static unsigned int handle_tw_list(struc
 			/* if not contended, grab and improve batching */
 			*locked = mutex_trylock(&(*ctx)->uring_lock);
 			percpu_ref_get(&(*ctx)->refs);
-		}
+		} else if (!*locked)
+			*locked = mutex_trylock(&(*ctx)->uring_lock);
 		req->io_task_work.func(req, locked);
 		node = next;
 		count++;
+		if (unlikely(need_resched())) {
+			ctx_flush_and_put(*ctx, locked);
+			*ctx = NULL;
+			cond_resched();
+		}
 	}
 
 	return count;


