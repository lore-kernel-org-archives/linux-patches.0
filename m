Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217180;
	b=aoJtzPDNfU6a8ZetuuVK1p5uz7OqvN9YyLyLJNhhAXGdwM49PHB4DzfdiS0AWkoW+E5L
	 VJHWScofjm/r81LCsHkKFz7KP+zy9xkLlpuZn2u2byETrit1gSBcqALuZ1yUHP+UK0W/L
	 3NUIq68CQtYHwU5TbujPvB6mJzvvtFiiruCtAisb+FZagOdq6qjVhHF+nhpj0HgtbIYlQ
	 bjsJm6sAf4FEfPUfWxQ3doL5sc2g0z+q5HYX9CW20YxJYsq9D3TDhxq61vHDwGIHC3XT4
	 8QQHJyMcE9gC4gFL/jzJgmNfSj4nbk4Zp/+Ic5rG7dFxJkgumSPZFnA4wND+GGoDc8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yzsDCie4a6q5WWw8K5qZefKDEeCw1+LJ8moAi93uItY=;
	b=hNxWxzyxPkltNamYE2tXfjYuCM2K+GO5bfz/lUNYtMp1i/0HV+OGxthZpZkGhZBFdqFQ
	 H4aeH3RjmObWHViKZ84HTBLxrLdkJbY1nBqpCXvBl2QQMqoU4IbjQv00WZ8hfJzDplGbS
	 YTEnXjjVAmeghyPkligqIeJ8xUvm092rDV45B9CmU8MmePrbhsUoNanZ8glhAc9malJ2R
	 zgkpTrG4/mt/IwRfTg48parFj5JS5BWlmJbFtumd5LlfIeV1pJnERAzLrHeaiN17ovVTX
	 jDzyBuQYzR3puw25rcINMYopHTfMO13zc0q27SnuZun+5UPWlx+p7o2OFAgAAL0k4Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dwlvqVrh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C341606A31A;
	Wed, 28 Oct 2026 19:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dwlvqVrh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6027E1F01825;
	Wed, 28 Oct 2026 19:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217179;
	bh=yzsDCie4a6q5WWw8K5qZefKDEeCw1+LJ8moAi93uItY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwlvqVrh4kOCyVKTw3QPhHMQ/KuEzeZj6orMzhDAH1sH1+GyMwBnkrGGWcH+61zTY
	 b7cvkJhVQbHfs0TVVvVUiKehpYsSsrzHAEoFydIbFTkKMWKTn28GHvnbljTfCoHFu0
	 xosTwy1mcwe26EONRM+iBYFKn389Ez481efjqfm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 1815/1887] coredump: hold RCU while releasing parked threads
Date: Wed, 28 Oct 2026 18:05:11 +0100
Message-ID: <20261028170540.748038083@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 61d58591aa0188bf2463e263962256316ff8b576 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -460,6 +460,8 @@ static void coredump_finish(bool core_du
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* A released thread may exit and be freed before it is woken. */
+	guard(rcu)();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -468,6 +470,7 @@ static void coredump_finish(bool core_du
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
+		/* Any wakeup now lets the thread exit, rcu keeps it alive. */
 		curr->task = NULL;
 		wake_up_process(task);
 	}


