Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050962;
	b=3POQilda7MfqT+E+qDucFtUBQCBPc3lAnZ0LqMh4krOD0dNQP6SMOwS/Sh1SLtrjB9c4
	 QFFnK8hOF0moV8nnhtbWVzfw0JFOJNoOUIIjBkILnRKrm+jN6yjK04V1gpsG77sqeJnq9
	 9WphSDnPvk9ypaKbpqadGJaxvBd1r9wdXQzdRy24IqKTBTbMvbrldD2HmO2fJHKPA99uq
	 nx0yO2JROkBQ//j0bJJeHfKzCIs80bmYIDWC6wlUDsGfU/2ehsTkLGk7Pf1JwQHQV8DNR
	 PaWXWaBizswQhg8gbRiAxMRgFWfUiMbFvagpreOf4a2isnOq92i0Hei8s6GY/2w4UhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+4QNGFI0yoOKsaww2Lu402ZIaIy4pUQxlcy+pOuoctg=;
	b=BX4G7UtXyEcmtcT9zC+lpvQduwy2g3I6qjCm1A9BSOL967E6C90MApbIuNhXLaHUsmm6
	 WdBSiqqNV8TirKEeqRL2+WQpVIZVtH9UWHwLFyO0RIjd565vL5E9yuU+k02fxhw68BbhN
	 5LGs/SkljqDPbZRmDSnYG5hbkMAy2unxjFiemA4Lqs+Wlra1WZnAoYQvbJhYtTXlK57Vq
	 DNiUD29gGxSOpVgA31tzLGPGObAbx0/T3jR+JQ5n08ovtVnRhSgBQcuTrYtLX5A8fF/w/
	 KARYjSy3KthqjgEATNW9wa6/HCa5ljHbGQAgZqtOnw8D1Xb1vVBNdKQG3Y5fJWBgCww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVD+x7FI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD5C606A31C;
	Thu, 19 Nov 2026 01:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVD+x7FI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46F61F000C4;
	Thu, 19 Nov 2026 01:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050962;
	bh=+4QNGFI0yoOKsaww2Lu402ZIaIy4pUQxlcy+pOuoctg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVD+x7FIsR9kZHbasLhgXnzTsWm4DKMbqgaOEzuLQp2b7QG8k5iQVpVzZBiOaF9CT
	 4WmvkIcRIgrITXDhYx2s8H05VKTdVVoJgbVcQN4OcmN8X3Pe0k8avOAB7nltWLYImg
	 OTUma9dbM4BEhAkvnKEL+6uYzDj4vGyULtsNvPMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0008/2214] coredump: hold RCU while releasing parked threads
Date: Wed, 18 Nov 2026 15:28:04 +0100
Message-ID: <20261118150010.490717425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 61d58591aa0188bf2463e263962256316ff8b576 ]

coredump_finish() releases the parked threads by clearing ->task in
their core_thread entry and calling wake_up_process() on each of them.
It does that without holding a reference on the task and without being
inside rcu.

But calling wake_up_process(task) without rcu here isn't safe. A parked
thread doesn't need that wakeup to leave. A spurious wakeup or a
preemption after the store is enough for the task to go away.

So if the coredump client is preempted between the store and
wake_up_process() the thread can exit and be freed in the meantime and
try_to_wake_up() takes pi_lock in freed memory.

Hold rcu across the loop.

Fixes: a94e2d408eae ("coredump: kill mm->core_done")
Cc: stable@vger.kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-1-8e4adb1619e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Replaced guard(rcu)() with explicit rcu_read_lock() and rcu_read_unlock() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 5e5c1d72d63bc..9e97756be4381 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -528,6 +528,8 @@ static void coredump_finish(struct mm_struct *mm, bool core_dumped)
 	spin_unlock_irq(&current->sighand->siglock);
 
 	next = mm->core_state->dumper.next;
+	/* A released thread may exit and be freed before it is woken. */
+	rcu_read_lock();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -536,9 +538,11 @@ static void coredump_finish(struct mm_struct *mm, bool core_dumped)
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
+		/* Any wakeup now lets the thread exit, rcu keeps it alive. */
 		curr->task = NULL;
 		wake_up_process(task);
 	}
+	rcu_read_unlock();
 
 	mm->core_state = NULL;
 }
-- 
2.53.0



