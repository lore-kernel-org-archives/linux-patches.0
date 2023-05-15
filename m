Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6008BFBFE
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13BFC433EF;
	Mon, 15 May 2023 17:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170715;
	bh=M/copmAjhGeQYpsI5ttyFcJzqH1oBN5vjwjcsRJY2Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFgF7FrUqj18MIJT4fw/966W871G9GnBVg+jWUCNxJj0eLAtCJTl3jZSjVe82AQpt
	 mTm/C0VSCZnZks8Z0vVG7Xu2Vwpwkix9xjSz/ut8f603zXcAbqYIvrnaqPKnVXKVrE
	 Gba/zwxFspqIE3DxW6ZbgiP3bV8EbUT4B1kEVwcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Murray <timmurray@google.com>,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.1 219/239] locking/rwsem: Add __always_inline annotation to __down_read_common() and inlined callers
Date: Mon, 15 May 2023 18:28:02 +0200
Message-Id: <20230515161728.295674057@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Stultz <jstultz@google.com>

commit 92cc5d00a431e96e5a49c0b97e5ad4fa7536bd4b upstream.

Apparently despite it being marked inline, the compiler
may not inline __down_read_common() which makes it difficult
to identify the cause of lock contention, as the blocked
function in traceevents will always be listed as
__down_read_common().

So this patch adds __always_inline annotation to the common
function (as well as the inlined helper callers) to force it to
be inlined so the blocking function will be listed (via Wchan)
in traceevents.

Fixes: c995e638ccbb ("locking/rwsem: Fold __down_{read,write}*()")
Reported-by: Tim Murray <timmurray@google.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20230503023351.2832796-1-jstultz@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rwsem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1251,7 +1251,7 @@ static struct rw_semaphore *rwsem_downgr
 /*
  * lock for reading
  */
-static inline int __down_read_common(struct rw_semaphore *sem, int state)
+static __always_inline int __down_read_common(struct rw_semaphore *sem, int state)
 {
 	int ret = 0;
 	long count;
@@ -1269,17 +1269,17 @@ out:
 	return ret;
 }
 
-static inline void __down_read(struct rw_semaphore *sem)
+static __always_inline void __down_read(struct rw_semaphore *sem)
 {
 	__down_read_common(sem, TASK_UNINTERRUPTIBLE);
 }
 
-static inline int __down_read_interruptible(struct rw_semaphore *sem)
+static __always_inline int __down_read_interruptible(struct rw_semaphore *sem)
 {
 	return __down_read_common(sem, TASK_INTERRUPTIBLE);
 }
 
-static inline int __down_read_killable(struct rw_semaphore *sem)
+static __always_inline int __down_read_killable(struct rw_semaphore *sem)
 {
 	return __down_read_common(sem, TASK_KILLABLE);
 }


