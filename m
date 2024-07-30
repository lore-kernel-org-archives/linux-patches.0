Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4E518E044;
	Tue, 30 Jul 2024 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355856; cv=none; b=B08rjTD2xQS9Mkcym9EI6rYYUmpQQAt4kUhIBMdPFmDQJlc8YDshAhNR3bQre/TgaWwaJWBzLe+XxvP6GHwa4DPNGQky6zuwIaelTT+WJePrSNVevYvOwwjHXkhdprMa2jPPqMp6kTzR2ymWJaI8+4fYyjeeOby8MSHrCXjQEnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355856; c=relaxed/simple;
	bh=YIIJK/2eRuXgpGQhOsVCXfsptjV/950vqufbaKioJmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aggiAmMQudXzNUDzQoEuQXC3dfNCWBlhvrkHrlQIBQyJVEiC7koSTOX7nVkjEBawNQo6r1RV0+tUtTtNZYYeNgfjonFDyQRN+gpxQzxbNm+2ovkmTkDCSKDUg6DEeP5zDTh7iBCE8GWgMq5g/pha0e2VjV1EKRuTbGiYL20pmBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFcSsoa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFcSsoa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBD4C32782;
	Tue, 30 Jul 2024 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355856;
	bh=YIIJK/2eRuXgpGQhOsVCXfsptjV/950vqufbaKioJmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFcSsoa13DWTLyPDXaVovhnqaWfihyUY8ZQfHN+7fn+i62XAZ5GluokpQMpCur3wZ
	 jAXh/UwIeflZfI2SeOkOjG1Tx6A1UVPbUXB6E4dqIJTUTps6u2JOBX8epBxn4MHPqD
	 lIZ9/QRlPQfnEeqeR7N8+xRI5Z3MKu5eCSGzqg+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Murray <timmurray@google.com>,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/440] locking/rwsem: Add __always_inline annotation to __down_write_common() and inlined callers
Date: Tue, 30 Jul 2024 17:45:51 +0200
Message-ID: <20240730151620.498552956@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 92d8e2c4edda0..ffc2bbe391879 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1308,7 +1308,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 /*
  * lock for writing
  */
-static inline int __down_write_common(struct rw_semaphore *sem, int state)
+static __always_inline int __down_write_common(struct rw_semaphore *sem, int state)
 {
 	if (unlikely(!rwsem_write_trylock(sem))) {
 		if (IS_ERR(rwsem_down_write_slowpath(sem, state)))
@@ -1318,12 +1318,12 @@ static inline int __down_write_common(struct rw_semaphore *sem, int state)
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



