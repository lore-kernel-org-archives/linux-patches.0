Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8AA1714A8;
	Thu, 15 Aug 2024 13:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729361; cv=none; b=tXL2iOAEFl/M1WvEjMVYTqxAbuiNiz28Sdv4JUM9dBQ67uTamCWWmS+wuYLlEIzTJoXeHcUcsVSKAUHotPQFhHSEv4m0f9+XchJ/p2T28PZxF/k61EkumrBggIvflEWCev5uAGuDHoOBAheohbFCiAyuuENkq/6SvhhRrClGduY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729361; c=relaxed/simple;
	bh=9MdWd0wq9rT3ugdEjBimjWQXaoIC1vLItGT+N1UFWfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFZ57/5doNOKZ1AUcFq8pucxtrNzgq2Fat5gWOX3nksGATY1/RRzYmzpsTdsD9kT5kP23SqXpUeGP1LSA7n1oi20zh/Ix89rB1oMMTnfYZHAkP3M+V5NhxX1LX+JDZcRQ7bRz4IOBDr5PA2YlSKbCwtT2ni0ozDBsvRKVg1Tsdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzJjL7zE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzJjL7zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23732C32786;
	Thu, 15 Aug 2024 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729361;
	bh=9MdWd0wq9rT3ugdEjBimjWQXaoIC1vLItGT+N1UFWfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzJjL7zE0i5b11UlFVx6mv6T6lE5lR/e3ZZdHkg/ZvsT6AqNOdhsvk21eBTsFP4d0
	 RTYlzHR/kjar14cS4p7qwteWuA6C6PKhq8GVOOfHNX7e5VJEzVJ493oqST2Hve5jhm
	 TZsQ7NmU95jpj12GB9aV1yE+xgn8X1R7ZSv2cIu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Murray <timmurray@google.com>,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/484] locking/rwsem: Add __always_inline annotation to __down_write_common() and inlined callers
Date: Thu, 15 Aug 2024 15:18:52 +0200
Message-ID: <20240815131944.143208335@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: John Stultz <jstultz@google.com>

[ Upstream commit e81859fe64ad42dccefe134d1696e0635f78d763 ]

Apparently despite it being marked inline, the compiler
may not inline __down_write_common() which makes it difficult
to identify the cause of lock contention, as the wchan of the
blocked function will always be listed as __down_write_common().

So add __always_inline annotation to the common function (as
well as the inlined helper callers) to force it to be inlined
so a more useful blocking function will be listed (via wchan).

This mirrors commit 92cc5d00a431 ("locking/rwsem: Add
__always_inline annotation to __down_read_common() and inlined
callers") which did the same for __down_read_common.

I sort of worry that I'm playing wack-a-mole here, and talking
with compiler people, they tell me inline means nothing, which
makes me want to cry a little. So I'm wondering if we need to
replace all the inlines with __always_inline, or remove them
because either we mean something by it, or not.

Fixes: c995e638ccbb ("locking/rwsem: Fold __down_{read,write}*()")
Reported-by: Tim Murray <timmurray@google.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lkml.kernel.org/r/20240709060831.495366-1-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/rwsem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 4a38d32b89fa3..eca42c14ec09a 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1286,7 +1286,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 /*
  * lock for writing
  */
-static inline int __down_write_common(struct rw_semaphore *sem, int state)
+static __always_inline int __down_write_common(struct rw_semaphore *sem, int state)
 {
 	if (unlikely(!rwsem_write_trylock(sem))) {
 		if (IS_ERR(rwsem_down_write_slowpath(sem, state)))
@@ -1296,12 +1296,12 @@ static inline int __down_write_common(struct rw_semaphore *sem, int state)
 	return 0;
 }
 
-static inline void __down_write(struct rw_semaphore *sem)
+static __always_inline void __down_write(struct rw_semaphore *sem)
 {
 	__down_write_common(sem, TASK_UNINTERRUPTIBLE);
 }
 
-static inline int __down_write_killable(struct rw_semaphore *sem)
+static __always_inline int __down_write_killable(struct rw_semaphore *sem)
 {
 	return __down_write_common(sem, TASK_KILLABLE);
 }
-- 
2.43.0



