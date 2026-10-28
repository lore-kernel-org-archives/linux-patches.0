Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212729;
	b=UxcgVKdHFkyMs6Bsjy2n03kMYZCRfAD1lvmCXnoFcZxZrGpaKxzxXKDmpd2yJpmZ5ZaH
	 DG77SJqi3Z4JFwffb4y2FuVWYLxFPLslAjXmBGCOrx6ATvfx67EaU+aDavlwl4VTM7a+N
	 KATiKk4GV6npIyQo8iErnuuOi87yE4EcPjKxND0vCuS7Y7C32i1bnFZLRl41YFYE4td3o
	 fLOjgwNTiZPutrYhebziNdDcrEVxHXA2Gve5+iCJiN439uzzFBBU4/cOPcopJcNCYnC0a
	 z+A3SxZNyH6unqz9Fbmb4XH/tggv9L6L8k1Q92Tlobq3vZ3tiqZBHF7tJ8s8fsZi5ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bqE9WI/fe9061zfzodDDOPuM3LipPz38cQRReDPOBrI=;
	b=L/3lZoiP2OOnY3JLwsBISnW3eJpIkQ2FWVLvOvJBqDADlnvAhlqAWKvcUoP/yW48i4eN
	 dferNnLSDS3JGaOS+JYpLYQcSejQTBpz/xraj50g0qVu4zyXr51M7q20bZFm42eEjEo1d
	 1bUp5r2n/y2thOLsjxH4eaykjvzRsUf0UFz9TdWM1CtTWKC2NF1maF5dJDFyQdkBsZSxX
	 4MToOgp66n+nG9JMFXKr8uUQb/e3ejJYJzmeDsVvwAunH31f0eQ285ti/ADwvY1NF0d9I
	 taZyHaep4KN+NzDyPPKBfRL+LQiXXeyRMeEaZlVgmhunswydDKphPI/dbqM+tsuwzpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZR8+gC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4758C606A324;
	Wed, 28 Oct 2026 18:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZR8+gC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2F81F01825;
	Wed, 28 Oct 2026 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212729;
	bh=bqE9WI/fe9061zfzodDDOPuM3LipPz38cQRReDPOBrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZR8+gC2hyLd/izb/dUJ+QPIdxxzKaS/dIhM/G6C7t/UUl1PgOFbTteVL7p0eojW6
	 +5PzfnDxx34p5DqUdNnSxASI5HD+bMXIURycp8URPgX/NizRTiW2reGd7oT3zSaPoz
	 UXCt7/uIDNZIkPFZGNg/xuvm8MTr5Z4IYKB9C6zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0249/1887] perf: Fix race between perf_event_exit_task() and perf_pending_task()
Date: Wed, 28 Oct 2026 17:39:05 +0100
Message-ID: <20261028170504.897512394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun2@huawei.com>

[ Upstream commit ffb684f2aa141eeb0caa6308422e7e05d1ded7c4 ]

A race condition exists between perf_event_exit_task() and
perf_pending_task() during begin_new_exec().

During begin_new_exec(), perf_event_exit_task() may be called, and the
PF_EXITING flag is not set on task. So perf_sigtrap() continues to execute
and triggers WARN_ON_ONCE(event->ctx->task != current).

Since both task exit and exec paths can call perf_event_exit_task() which
sets ctx->task to TASK_TOMBSTONE, fix this by explicitly checking if
event->ctx->task equals TASK_TOMBSTONE and dropping the redundant
PF_EXITING check.

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Signed-off-by: Luo Gengkun <luogengkun2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260920075026.990582-1-luogengkun2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e5c79c55ce48e..013c3a4afb8a3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6596,9 +6596,11 @@ static void perf_sigtrap(struct perf_event *event)
 {
 	/*
 	 * Both perf_pending_task() and perf_pending_irq() can race with the
-	 * task exiting.
+	 * task exiting or exec-ing. We can determine if such a race has
+	 * occurred by checking if perf_event_exit_task(), which will set
+	 * ctx->task to TASK_TOMBSTONE, has already been called.
 	 */
-	if (current->flags & PF_EXITING)
+	if (event->ctx->task == TASK_TOMBSTONE)
 		return;
 
 	/*
-- 
2.53.0



