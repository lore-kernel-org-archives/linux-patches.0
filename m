Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207386;
	b=aC+6Htr/g3DmsJfzJ8iMiFunlP/U4TcBwBzNKkPte9io6yyt1/cS9ZOHS3Qnzd3PeW3x
	 /GVdBuoyikGg4h4we0KfTf3gJY/N7NTGORQtzVD6k/0jDpdXAnKhvoJAzreKuc+/ZUqTT
	 vtC9CsAkcSeKyEX9VR2XGouAq2MmIkC4jSPKg8a+kxD8EuLVyv1Fw7CzYcdphDjkXT8pG
	 cpk13FgkPfZm3tMX5DG/krhaBXRXSyIcOcALpauzWxXUtzpX/8zQpLU6kfn2fTKckQpTj
	 x7UsHXGeWX7EAsnL5MYb/jw4glhmW9XFzlZxNkvxhqRnUUn3/mhRyYQkwg5pbT3P0eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h8+5LXDKj7xkNPbVqSUcvzmv1WPmS7h7ur3iJsaLrQE=;
	b=Cj9JaQOhcgJ+ESABP5L4uffIqzrwCuvRYwpR1xCeJC66ecI7LXYPt7njMEZk1aNxUOo3
	 D0ngRd3wywKMop2Beby8/7nrgdrbisfv8IElRwa9AN5s8VJq8TPO08px4k0Lpvl/Zbm6T
	 UuMZGjKhzdvfBekRp1jTdEXUex/SD43+Gbfw6lrK4eZr5C7D8mney8nn33ebWVLdPDP2x
	 b8qJ4qJyhXyK622Lc66bfakz/J+hhSLcbCWOUi2pSh92RYlQKJTtdvM6IAAj7XGqtxc8r
	 uWzIEuaNTtrMzcNtxDwX2YwBPYy3Ec1N71Um/URJYINISkdp1xTyy7Fsvhm/KPuN8qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irwKtn0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB290606A31D;
	Wed, 28 Oct 2026 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irwKtn0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DAF1F01828;
	Wed, 28 Oct 2026 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207385;
	bh=h8+5LXDKj7xkNPbVqSUcvzmv1WPmS7h7ur3iJsaLrQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irwKtn0gRpqK5nptHNROlu1o6g+Z8Sd0C29bjWI7MRRRNFkFcVL+P5MNPTdzhhsdF
	 Anp+lVHAqJ0HFW7JlLMwGyqMx5JtbOtlF+s8WqKO+RTHA+LuHLop6pfcKvIB2lQGnb
	 KEm5eC+rZ6hRiyO1WNfATdXUenyGQnfQ2hrQqxgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 87/88] pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper
Date: Wed, 28 Oct 2026 18:00:35 +0100
Message-ID: <20261028165944.160852755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 5c0985dd3c32fc2bbd0e8beaf13cf52cd97376a2 upstream.

Since commit 7fea700e04bd ("zap_pid_ns_processes: clear
TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING") zap_pid_ns_processes()
clears TIF_NOTIFY_SIGNAL before every kernel_wait4() call. Otherwise
kernel_wait4() doesn't sleep and returns -ERESTARTSYS if
signal_pending() is true and the reaper busy-waits.

But clearing TIF_NOTIFY_SIGNAL doesn't fix it. It can get raised again.
For example, klp_send_signals() sets it raw against any task that hasn't
transitioned yet. And it keeps sending it until the livepatch finishes.

The sleep loop waiting for pid_allocated to drop has the same problem
and it doesn't even clear anything. So a schedule() in
TASK_INTERRUPTIBLE returns immediately.

Use a no_notify_signal guard. signal_pending() will ignore
TIF_NOTIFY_SIGNAL and the pid namespace reaper sleeps until a child
exits or free_pid() wakes it.

Link: https://patch.msgid.link/20260824-work-tif_notify_signal-v2-5-6609e42b3157@kernel.org
Fixes: 7fea700e04bd ("zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING")
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/pid_namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -238,9 +238,10 @@ void zap_pid_ns_processes(struct pid_nam
 	 * kernel_wait4() will also block until our children traced from the
 	 * parent namespace are detached and become EXIT_DEAD.
 	 */
+	/* Task work must not busy-loop the reaper, see signal_pending(). */
+	guard(no_notify_signal)();
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
-		clear_thread_flag(TIF_NOTIFY_SIGNAL);
 		rc = kernel_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 


