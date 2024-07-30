Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94288BE8;
	Tue, 30 Jul 2024 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357265; cv=none; b=RAgqUlDMD7qsh6caFKreFhR9l5nYWf050G2UC4qvIAWYHFScMkdMBCkoSZFzcuANXcV/8FGLi8K9YdKEiC4HERFaCBhza91J+hDQcBhN2s7BZvWuz5b05i+KVPLuKYgw9ZbzoUKNPQJRTQYTSu48hXczPd2I8gSSc5UrTMprnDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357265; c=relaxed/simple;
	bh=6mDRfeDNG5e02xz+8vys4yzxMuq+w7laV85U9mVsGjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyq0moOUU6MVRylzkUbh++ZT7RwjE/+W+xYLfezK38p7XWZ7NC2VpaRC/zV1gN7FKN/BCyXw5mrTXqX9SIalK0mfdtVtPyLj+/CFeZUAhCbcZYVDlD5/2IKpkfEsLSqTJVq2WwlpPEHbExE8w0HpGlOjc2JWsyQkTrs/gPQOux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMPWLhfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMPWLhfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36463C4AF0F;
	Tue, 30 Jul 2024 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357265;
	bh=6mDRfeDNG5e02xz+8vys4yzxMuq+w7laV85U9mVsGjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMPWLhfmtWwb49kvBqtNJh7qA2PMTdLdj1vjL5xjv4IF5pNemuCL21nhEIvkq6qmu
	 45Ycpex90MY/vpeo8IMZPjf+fILDyM0BtkjUMeVVcjVfzJCFOn7K31vrp9t+LfDgk2
	 ijyb6FnxUk6v4dGiNoJMYCoOlf2RyhS1ZYJ1j95s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Murray <timmurray@google.com>,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 238/809] locking/rwsem: Add __always_inline annotation to __down_write_common() and inlined callers
Date: Tue, 30 Jul 2024 17:41:54 +0200
Message-ID: <20240730151734.004298591@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c6d17aee4209b..33cac79e39946 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1297,7 +1297,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 /*
  * lock for writing
  */
-static inline int __down_write_common(struct rw_semaphore *sem, int state)
+static __always_inline int __down_write_common(struct rw_semaphore *sem, int state)
 {
 	int ret = 0;
 
@@ -1310,12 +1310,12 @@ static inline int __down_write_common(struct rw_semaphore *sem, int state)
 	return ret;
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



