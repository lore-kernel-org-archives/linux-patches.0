Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BAC7082A;
	Mon,  6 Jan 2025 15:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178214; cv=none; b=hee+UC+l3FjecW7kHg3Dx2LlkVNhxYmbm4HuZrEZbaM/bKyBGGXnZIk7y5/1+fSybMhVWaA1SJ9J8X13lfbSABPWBk+GK+rB0Bfym49xFo6KA0vdkMZmFGJSwqivTnYs7zTGfUnjBHUvRtax7NaWpSZdyoUlEKCwBs5rREq1PUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178214; c=relaxed/simple;
	bh=+kcneY8FNo3tjJBpoVkDLh/1jURDGmu4JF2MtZZJsUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTh5WVJUw7+wEBGPiDUAuk+J3k/+DSF0bzrrIMNxrxuefGL8OUbNZ4WAD3DE1JdG1RlNrheJ6jcXCqGJ3Ep/MT1kXE7aF2Pm3wf11UGXySW9On5toNlShE7saTBkQM4PT86WbU3/WjACW60V/zfWRrth434Fgh0H589/yIV3F24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeZfaCZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeZfaCZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAC3C4CED2;
	Mon,  6 Jan 2025 15:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178214;
	bh=+kcneY8FNo3tjJBpoVkDLh/1jURDGmu4JF2MtZZJsUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeZfaCZR5EKK2VHcTiwiYBhU/mYkNoWB1KtgKB4Dnnb1C6bFGeNJvfPBT1jlhAM82
	 /6rzaKuFtDVjozFlR4O06FMya+nTyDIipTELDs8aE09ANC2NjYg8xCfhsKR3y+f5D8
	 /tQFJpJZsKOc9uBW7UDbGyQ+jojNQUCx69kz03w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Xia <jing.xia@unisoc.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	Brian Geffon <bgeffon@google.com>,
	Benoit Lize <lizeb@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 043/138] epoll: Add synchronous wakeup support for ep_poll_callback
Date: Mon,  6 Jan 2025 16:16:07 +0100
Message-ID: <20250106151134.868891493@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1276,7 +1276,10 @@ static int ep_poll_callback(wait_queue_e
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
@@ -214,6 +214,7 @@ void __wake_up_pollfree(struct wait_queu
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
 #define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
 #define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
+#define wake_up_sync(x)			__wake_up_sync(x, TASK_NORMAL)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)


