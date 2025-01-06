Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAF6145A03;
	Mon,  6 Jan 2025 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179271; cv=none; b=HzomfEZ97KUs54wQ/evhv8zcXy+6/S+2SealPKWpgDonGsTBNS2mTLSqC7gEbFI7dlsfTNR51WHxEizT+HzKxnA0sK1wDJKsD6Nw1urCuykbMzMcFoHvcf6EUpLgksYq7VSLaP14NqUYH21aIc0g+9SXxh20jWjJ248z/S60Q1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179271; c=relaxed/simple;
	bh=ZAGO//mKrutHZTyD2FD9td5XCTnZ5TIGvcOLFYIGsQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBu8NTRWzSlgTYRgXsUqQp9OLmPSg7j7B1thSW6zywFinhvC9P2rKavLg+QAYSyMF/wSwFV1GIYUNpUjF0Qn2sYBK7MMJ1ejk3thsovcj8x5S2llMMOfGzTa/NUAwP+dofC3LioCNO6rUkgQ4/ZU8r1yGVZMDunrkUKw2PDeTN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hq0DzcqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hq0DzcqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0D4C4CED2;
	Mon,  6 Jan 2025 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179270;
	bh=ZAGO//mKrutHZTyD2FD9td5XCTnZ5TIGvcOLFYIGsQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hq0DzcqZhqzhEGlKHFUdBdmfl4U45r7IubVO8K1QQbsPQheaI2tZzZks/8pAWMOIS
	 dLQYuCKlpDwk8EdsU7obCaYqLmXEVPw7fOqjxwMtPguqsmz+qMQqPbeu93/O4N9N8a
	 6DNdsLfRoJ9/foaRGbKp8r4ArLr7LE0WIsSQbIPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Xia <jing.xia@unisoc.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	Brian Geffon <bgeffon@google.com>,
	Benoit Lize <lizeb@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/93] epoll: Add synchronous wakeup support for ep_poll_callback
Date: Mon,  6 Jan 2025 16:17:27 +0100
Message-ID: <20250106151130.629862442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit 900bbaae67e980945dec74d36f8afe0de7556d5a ]

Now, the epoll only use wake_up() interface to wake up task.
However, sometimes, there are epoll users which want to use
the synchronous wakeup flag to hint the scheduler, such as
Android binder driver.
So add a wake_up_sync() define, and use the wake_up_sync()
when the sync is true in ep_poll_callback().

Co-developed-by: Jing Xia <jing.xia@unisoc.com>
Signed-off-by: Jing Xia <jing.xia@unisoc.com>
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Link: https://lore.kernel.org/r/20240426080548.8203-1-xuewen.yan@unisoc.com
Tested-by: Brian Geffon <bgeffon@google.com>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Reported-by: Benoit Lize <lizeb@google.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Redefine wake_up_sync(x) as __wake_up_sync(x, TASK_NORMAL, 1) to
  make it work on 5.4.y ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c       | 5 ++++-
 include/linux/wait.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8c0e94183186..569bfff280e4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1273,7 +1273,10 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
 				break;
 			}
 		}
-		wake_up(&ep->wq);
+		if (sync)
+			wake_up_sync(&ep->wq);
+		else
+			wake_up(&ep->wq);
 	}
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 03bff85e365f..5b65f720261a 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -213,6 +213,7 @@ void __wake_up_pollfree(struct wait_queue_head *wq_head);
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
 #define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
 #define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
+#define wake_up_sync(x)			__wake_up_sync(x, TASK_NORMAL, 1)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
-- 
2.39.5



