Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622862;
	b=kYKbSLmp5yGLr42CGxNjJ7XTqLhGLZX3w+S/cQU/IDn5ZUKRrUn/b2lDvM9hTItauMKO
	 7FaoaZITI/J82T4s/Cg9cTeouCrFom7WjSIorHwbcTyDC+jfCCfb1frB/spIiGCfJY4Ds
	 ed1yI2ptUDTz1XaBAHX7DDa2ezVkjdbL0dJiKUteuSdRdt3nj9XCCTqTS9/LkjFp2++UO
	 dJPYZBJJW+dOM542ezDGSIvJtTORlyLM5sNufDn4AQsjv72U9g87P2o2PjuYb9aDxbCxh
	 ehYiwRWthLWmQtbJ4ui3rjDEzcZAiOLbLgPO4IxjxHQ4TnfXf/QhlaetlTF0CJPJlSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ENqo7mM2tCA6uauw4YMYDHFSV8wab42jFd1zJ7db/I4=;
	b=rf0PnSYWF9gA+vFCOMi6BOkSxtlZ/haZVndck2sSDKPhxY1xQLzX4go6xn1zQzUgxDBx
	 DJF/CP/SiyRuzdiuVw02sKMGJN91w99J3c10ifTHh81i6PnjzI//cGIBRXmfygU+IVdpX
	 daMeCPe1En9byroMCMieCspXPdtyonfoSyXSk4BF97jArCxlQsRpxGjx8Zo0E+7WqjXLY
	 5HDkLipNJiA2vhaACb6N46xWKDp7qw4iCBuSR9UBpOLNJhkuHdNoOVGvVk1ZJoslfBxbj
	 Z37gF5njMQWDeBP1F90DCISMIV3L83Pg1BLmVUg3FNJX0zmwN/HYsBz1HaTkjYWnG8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1xYVQUE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FAB606A321;
	Wed, 25 Nov 2026 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1xYVQUE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AC31F000C0;
	Wed, 25 Nov 2026 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622862;
	bh=ENqo7mM2tCA6uauw4YMYDHFSV8wab42jFd1zJ7db/I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1xYVQUE0Ez3QGomYHYO0R0stvIj2540Cg4yIUJ0+hV0FELLJMHdB014xewADLuLV
	 53ZbRmwD6anGxLOygYVupAt4tjdSKJolFCK998HdBlZy1fkdBugRxT+g5jTEQOnD+F
	 HGWX5XQpCkDA8bpFPzWoBDAUIm5/vFFSnQTrPK1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Tofigh <mt4022@columbia.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 672/990] eventpoll: wake the next waiter when a woken waiter is killed
Date: Wed, 25 Nov 2026 15:33:59 +0100
Message-ID: <20261125143837.828939876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Mani Tofigh <mt4022@columbia.edu>

commit 9f4413e522faed76f4cf610098b2369eb3ba1f1c upstream.

Processes sharing an epoll instance can sleep forever while an event is
ready.  An event wakes only one waiter, which then wakes the next one in
ep_done_scan() if events are still ready.  Since commit c257a340ede0
("fs, epoll: short circuit fetching events if thread has been killed"),
ep_send_events() returns before the scan when the waiter has a fatal
signal.  If the woken waiter is killed before it runs, nobody wakes the
next one:

  Task A                     Task B                 Task C
  epoll_wait(ep, -1)         epoll_wait(ep, -1)
                                                    write(efd)
                                                      /* wakes A only */
                                                    kill(A, SIGKILL)
  ep_send_events()
    return -EINTR
      /* skips ep_done_scan() */
                             /* still asleep */

B then sleeps until another file on the instance becomes ready, if ever.
This can hit eg a pre-fork server whose worker gets OOM killed.  Commit
7fab29e35630 ("fs/epoll: restore waking from ep_done_scan()") fixed the
same kind of hang when the wakeup in ep_done_scan() was removed.

Keep the early return so that a dying task still doesn't take events
nobody will see, but wake the next waiter there if events are ready, as
ep_done_scan() would have.  With the fix, B gets the event.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 2s.

Fixes: c257a340ede0 ("fs, epoll: short circuit fetching events if thread has been killed")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Link: https://patch.msgid.link/20261103-epoll-killed-waiter-v1-1-36e08c16b8a2@columbia.edu
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2088,10 +2088,17 @@ static int ep_send_events(struct eventpo
 	/*
 	 * Always short-circuit for fatal signals to allow threads to make a
 	 * timely exit without the chance of finding more events available and
-	 * fetching repeatedly.
+	 * fetching repeatedly. The wakeup that got us here may have been the
+	 * only one for the events on ->rdllist, so pass it on to the next
+	 * waiter, as ep_done_scan() would have.
 	 */
-	if (fatal_signal_pending(current))
+	if (fatal_signal_pending(current)) {
+		spin_lock_irq(&ep->lock);
+		if (!list_empty(&ep->rdllist))
+			wake_up(&ep->wq);
+		spin_unlock_irq(&ep->lock);
 		return -EINTR;
+	}
 
 	init_poll_funcptr(&pt, NULL);
 


