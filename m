Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209854;
	b=IU56+N27z7plL9kXAn9kZPxQN8cqdnE215xP3AM+0tZjzP4/bnAxz0pAAMzBwRtycNS2
	 cdXsndIBY/pVJSwRwbt6NQZlyrg5Izpd8//Tdmhm25fxCHXczQnIU11dKNMCLbqa+8FGp
	 YWd6iMCl4R1grHlzfkxN9B6mvMRu80LZ6OrQTZqDjUScRWyQDmTJJjszSB58gCMFLqzCr
	 OG2RGghp9j3cPzk9gG1pwNalPeEcSggLiPfeEMt7OJifxSHw6MWFCgN/eD22v+3ppyGIp
	 wkH/BUnB/zw7M4H8cWJIpo1pSgGAHyT3OyvEAsP+7VQi/PzqktbYMXpedn9gzEWhCaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NP1U3QvIoWmFzfGP15MQWwoLdo+gpCbGjXVuovDFNYA=;
	b=0YTYCwRC8q7FI3xehpTV6p4HCMLlttngWAZGKK5ZCPzGjkRHYD0aPwLBOn6YAAFgnTr8
	 TEg6q4jLvTsMxz5fywT7wGLnLS23MzBdL7Ot2ilB9/VQAOJQTNkCzEEcbDgHyRoAOuaQD
	 kgQQ7By2hHzDvVQ/7SO8jG0VA2No6j5n+vvGdI6hfJAXHue+viObu3iDWZboDvN9yz0WF
	 MBZDCMLVegPUXuAArKw1QMacu/35cnvM+uBWYScaY7FJgEpBYyMUTH8GGxDICJX+NcQch
	 ZrVbT5sKyudmOL4tKs/fubwhZ5aHHtThoD8JMb2FJo351kdlwGXzdTvC/+1uB2NOnTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPiLPc6Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A28606A31D;
	Wed, 28 Oct 2026 17:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPiLPc6Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3B61F01825;
	Wed, 28 Oct 2026 17:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209853;
	bh=NP1U3QvIoWmFzfGP15MQWwoLdo+gpCbGjXVuovDFNYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPiLPc6ZOE5PMOjhW3ORiY1KjPewZ2NCpZwKXYgzId3sm5vLvPCLkF9hWXQi2Ik9Y
	 yNB72rv+pbEBo1Kg6I6VHlixCMsKVSFPtaHIhL11vErQwZD+U/1onEic0BwdxpBnXi
	 Y4hDLUmM6Yg7xJ8aCOOonfE+3VmMc9ltAZzWpvu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 101/109] coredump: hold RCU while releasing parked threads
Date: Wed, 28 Oct 2026 18:01:25 +0100
Message-ID: <20261028165944.734031911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -560,6 +560,8 @@ static void coredump_finish(bool core_du
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* A released thread may exit and be freed before it is woken. */
+	guard(rcu)();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -568,6 +570,7 @@ static void coredump_finish(bool core_du
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
+		/* Any wakeup now lets the thread exit, rcu keeps it alive. */
 		curr->task = NULL;
 		wake_up_process(task);
 	}


