Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29321A8F80;
	Mon, 23 Dec 2024 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970816; cv=none; b=ZrDe/9/xDwKtWlYTb7UWwZu5rERwvPcPESkvWpafyS518ZO5NiSEd+tnRmoJLlS/YBwGkxeQcfQW2jx4485SqLfY+PK9yETIacq1xPKlEERVxBf/80YCdjBIGOlbqRVdlNFIJ/OGjY1QCSnC+JMBL7NHr/0vLV3Xgo+yX2yjNvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970816; c=relaxed/simple;
	bh=NabjLuffXMoyjUN4I56XkkodVVX1OC+DdUuAX2jxPsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECTyWYeZHLMDtJaGyNAXkJKIx8q6JO9hUYm2NJUh7avtZC5C0aSLUWI5GwP7jnWZfgYri5zLKdJVvYti4JjUUezt9MravBvT8cXpJUCcnzG7xzVKxq6r/BYrwJnilBm5hFkEMVjxk6uZwL9oV3cGhnQW2iL3JvTHbBnL2qGS9wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+ZkWVn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+ZkWVn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32894C4CED3;
	Mon, 23 Dec 2024 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970816;
	bh=NabjLuffXMoyjUN4I56XkkodVVX1OC+DdUuAX2jxPsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+ZkWVn4zLwGlfofh8dDBdZ7rR+xFQIRUOkCTZ5DjlP+dkJIHb5rR4c5ZMiZVXOxD
	 8G7JoqqGPiOdShvqPWC3luNoVYGSaHwUgQvJbyzKsaGrEUTrBbWhEzjHEF0PSfMGgq
	 hYTAP+htnfyZS3pSH3qBaeZXk2jX4IyAXfbCo520=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Xia <jing.xia@unisoc.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	Brian Geffon <bgeffon@google.com>,
	Benoit Lize <lizeb@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 78/83] epoll: Add synchronous wakeup support for ep_poll_callback
Date: Mon, 23 Dec 2024 16:59:57 +0100
Message-ID: <20241223155356.669493159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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
@@ -1237,7 +1237,10 @@ static int ep_poll_callback(wait_queue_e
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
@@ -224,6 +224,7 @@ void __wake_up_pollfree(struct wait_queu
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
 #define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
 #define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
+#define wake_up_sync(x)			__wake_up_sync(x, TASK_NORMAL)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)


