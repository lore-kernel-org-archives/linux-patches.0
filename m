Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207154;
	b=jGBoiyGj0L5xmR9afX16j0op3KRVoft94bqCm4wmhSRxrLVYC5WZwfO5MtiIJmPliGY8
	 zwbm+FhPCiY63HXO53sx47TTEccXQPng0wecMmQfsOv4Hkrh9e8lKaWM6u5e7du8Rz/6B
	 J6tUaEXkee5d9nC+ixE7cmDp0j3bkoZSnirzn532DOF+wvlGX/xBKMjIZxiKqTJZrN3Og
	 Vzun0veiCN8D4DBzcVM74C4qgKHskRyogFPYsimMzdPA1mKaedFZOpSsI3I0eOoiBPRGr
	 yoEWhjWfke2BwMlSZ2embAULDMdbGSOiKXPg5O/DIKHYHeRpS989O5Ix55qE7dcIXhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcNckhyBkqx2ZymkBjyKPc6HVkzxkSolO6Ut8Vcyfog=;
	b=zUcpnBVytWRGFY6tZk5PR7koOA2c+wYhM/JZXWxMwmj8GylNT+7fz+DIGtj3Bdzr/2Uv
	 GnFXYHYwGukFYNPbDPe0R0wqZCVc6d40G+QpVtMtG25/AVnmhPkFjjP+FQROR/MzTP3PS
	 43pVWTWx699aQZ0puWTfonFI1M36GrdgoaNmQbPPLR3ONVs5dln4Uxvk9HjBv5wde5+P5
	 c+Vpq3gsbzccROBIiKTFKrlMbUPSROWq1y8Fl6QrtF4mC91zAnsgf5F5g7Q+oEaj2O1w8
	 RXHpm2abhevNwHh5nuXkN21CwJIODKOuJ9Z/9PS6uEXU68GSPNKN9oP/8E8i22Bb+pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRMBWcXA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE26606A31C;
	Wed, 28 Oct 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRMBWcXA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE91C1F01825;
	Wed, 28 Oct 2026 17:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207153;
	bh=fcNckhyBkqx2ZymkBjyKPc6HVkzxkSolO6Ut8Vcyfog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRMBWcXAREhTbj8qMHV5sVAIdxvl/t2JjFz8g5LlpfFjVsiwDhp8w4wMdbrX+AfTb
	 AGd4env/0EOl3q19fDcMBZffkoNXq5d+VM25Yw7+7B9KKZ4ge8/jYN1z74KuPGJdrY
	 s6lCMRBjoMFLgpeihdLRtQLpYLL28I0X5se0x/Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 37/38] pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper
Date: Wed, 28 Oct 2026 18:00:24 +0100
Message-ID: <20261028165941.335037989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 


