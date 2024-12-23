Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86780188006;
	Mon, 23 Dec 2024 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970149; cv=none; b=hXJP1x+1NAgNSbzi9zSOySLo2UTZyjeI1NYONH2HOWPi3MArrFx9zRcVgu66uQzar7TgCZ2/LYTLPCOXfLApuaD8EE+2oGjTmIQRj8EnYr/JwX9uB2u2YMnMwMfstpaqGFTBVE+WEKK+/rceIXvRxgW4hiNJSfVy9uzWYhQ/hDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970149; c=relaxed/simple;
	bh=eAJsyhHuz2jH1TJ4HhKEX+apdVjQvC9T0nmhPsNqBAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCZZF/k010LRo8oeXHM4w4x0g5tVBAr9LHhPzhT3/Ij2GdqZNYTyXEAEcD4TaXQYn+fTVLw4VjFTzUnhmBTOiuxm/gP9CEi2YPpCzF0M8M9ipn4XtwyEBb2g+KzefjLIZ7kXql4ZKmeqU6Kxi9dB7CqRZKU64YyHdvEpu8sr/sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ed2V022E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ed2V022E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D252BC4CED3;
	Mon, 23 Dec 2024 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970149;
	bh=eAJsyhHuz2jH1TJ4HhKEX+apdVjQvC9T0nmhPsNqBAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ed2V022EqoCGJprSTdPzVd82KNDh8SVAtq/MKanA7JikiIRYgDR1/TVXlPS5Xxaot
	 uuCEi399DbJZ6W8hSqpk7CY4nqZAUOTLhQpDQqb+e2sYyVBN3BZPaDzuxwXnK1PJbO
	 Bh9M0I5HIvDnPNMkigJT1pn/ht0pL37T6ZAN289U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Xia <jing.xia@unisoc.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	Brian Geffon <bgeffon@google.com>,
	Benoit Lize <lizeb@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 160/160] epoll: Add synchronous wakeup support for ep_poll_callback
Date: Mon, 23 Dec 2024 16:59:31 +0100
Message-ID: <20241223155414.998436496@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Yan <xuewen.yan@unisoc.com>

commit 900bbaae67e980945dec74d36f8afe0de7556d5a upstream.

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
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c       |    5 ++++-
 include/linux/wait.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1373,7 +1373,10 @@ static int ep_poll_callback(wait_queue_e
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
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -221,6 +221,7 @@ void __wake_up_pollfree(struct wait_queu
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
 #define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
 #define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
+#define wake_up_sync(x)			__wake_up_sync(x, TASK_NORMAL)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)


