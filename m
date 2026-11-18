Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057196;
	b=NLkrepLGdCd97geV7Zx/uhiIcf9gctEfvGkwMyN0q3mq4kwVSOMHEpCflki327KBlmAQ
	 cGBTYzJ1GObA2f7OIeqhXmn8tz0eNBXfFN04euoejTEJChlHZNRaaBkHGdyltg3dsIvAX
	 efT24iKE7+hjOvghCIU8+AAL7sIfvnh4w6oblwVIxr82Mtw7auO2ZB6ftjVLyMPcVyiVm
	 3U26et9JdH56zKx+Stt2ZAfZiQ73IKO9sRSHhWItLhYkg4G3/y0kzYGyqBJpORgRLq3g/
	 YZqF3t/xkG/Hz9DdFvwqONIsiw/uWx3zSy8toLfskBBuUaDc7MKbzOzMgTctQGVROmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fBjxW6UyVoMbfXJWFTjSguZcPm6ISpkYaNPJH4g2hTU=;
	b=QNjI8ycwWVmA5OSnH/1crwpxd0Y7CKJZqxVKuyW38m4DDaxGYSV/ZfF6gtrkTHUFVvqb
	 +YB7tkwnLjYsT1eo3FWBS/kgqqDjvGlxU5nDyYhqZW40Xsm1Rv5Ox1skZMDciYK5tTcg8
	 Go2DD2VbKCeY3OBm0IFc4TjOkBTFKNigd8danplkZmXxVfD8NlMRBWVwWnmkRdhdB+Eq1
	 5Wbk/12kPsP2BhrS3mJz/4B97Hbi5gnsGGRybnEIpIFaJVtYc/LT2LAybjTqsi0vngEkG
	 VdW8Smdj9V5ENwht/b08GVremEE78b1kdPUwT97yWOgoQRQkkxmDCke4B0P5T4t6Iww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3XfPQsL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C8E606A32C;
	Thu, 19 Nov 2026 02:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3XfPQsL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA421F000CD;
	Thu, 19 Nov 2026 02:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057196;
	bh=fBjxW6UyVoMbfXJWFTjSguZcPm6ISpkYaNPJH4g2hTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3XfPQsLXKu849OML4tVQwH8nXhBTZsbNOLf5eKTHpHAcgw55uIk2yrK2NOQhUpH4
	 9ClC4QNgkoD2OIy9i4+p0SQYZeYRxitNnyXwRuWNpodRRXPQdCvOgSNhvSt6ZuHfZ+
	 rStVDt1D6e/BJr99WOta/mOqghzyRtsmlwbMIqnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0008/1848] coredump: hold RCU while releasing parked threads
Date: Wed, 18 Nov 2026 15:34:06 +0100
Message-ID: <20261118145911.565482889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7e5ac34112bd5..23afc126d4ea6 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -529,6 +529,8 @@ static void coredump_finish(struct mm_struct *mm, bool core_dumped)
 	spin_unlock_irq(&current->sighand->siglock);
 
 	next = mm->core_state->dumper.next;
+	/* A released thread may exit and be freed before it is woken. */
+	rcu_read_lock();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -537,9 +539,11 @@ static void coredump_finish(struct mm_struct *mm, bool core_dumped)
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



