Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059294;
	b=jkaU3Uh79G7SXY28foEyHND68P6P3gnIDLdBw0r8xvoxx7hR5PT5g+tVLOQDI5iOK4sx
	 O3nHgemybag6oUN8WmbHA4/jB5MteCEZmquh75HXsCqJN9Y47LuGm6IdliEX6dzH1wbSQ
	 4Pxy0aQiuljFoMF0Z9fFkUnpmQzo7l4qr/UFdDEyQFoFkWHS+VDFdwiREi9CA+DeCTyVV
	 f+HmBfRELzVe7Tjk8XirYN+tpezR5aLukicGLgPozjObi2QiXIiSi+Tz9b6lwRkYKF9du
	 AwTkIWjywfJmz2l0z1m2plA2LV6QbV6BzLbSHTpTx0Q+1su+3joPiTuUecNbnBLYczg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cGO6QULzN/PJ5FDJiaxlQ0OnBQ2bFugonSStsSQdm4A=;
	b=u8vjUjjWwoc7DTMeHdrXb7JX4wcCwyaoKAJB+PQ+GyxpzJNpVk3vaRaBz3QHRll8e0jK
	 Ig+g6VIzSRUyMfkzRfZv5uxjiomwdhaIXR5bdNg0we4lmAf9rCLpkKDazF/hTzomwQ0Wz
	 wqFT9mXJw0CCiXk8R0xgpFJi0Pq53H7atO+iuk1bUPHUsZV5tmFXXpkNW1t1EBXsC5mqI
	 ujX3rEu1CkWNLbuvp9W2vV3xj/1pg2R/h7+u3TLkvkrGEkkMb0MRzhiHGjHx/CV2Yr+T+
	 vYH1edfFx63aJBcuqCxAajTJd6VGxw+dYakxZV/pcW2MApTf0sBjUtgLd5TfW68l21Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjBJVRRW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21D4606A325;
	Thu, 19 Nov 2026 03:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjBJVRRW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199141F000C4;
	Thu, 19 Nov 2026 03:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059294;
	bh=cGO6QULzN/PJ5FDJiaxlQ0OnBQ2bFugonSStsSQdm4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjBJVRRWSX9aX4HmWjIaHNkXkHsseqe4CDxB6iK5/L1hb/xlPMOqHcBLcNqMJpdWe
	 gpb6TEurvPEjQ1rEm5cd2bLcMIdKM5SuPWfVwGT+XqbOPLuyFNqhjZAy6g49ZqIowE
	 5Yek6bjPfLml04XgEOIXY0Y5NFmhbAk0/cQu9Now=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0789/1848] aio: prevent eventfd/epoll recursion on poll
Date: Wed, 18 Nov 2026 15:47:07 +0100
Message-ID: <20261118145949.465627718@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 398e3fa789aa5ffddc8689d8cbc7b31e1824130c ]

aio_poll_wake() can complete a keyed poll request inline while the
provider waitqueue lock is held.  If the polled file is an epoll instance
and the AIO result eventfd is watched by that same instance, signaling the
result can feed back into epoll and try to take the provider waitqueue lock
again.

For example, a timerfd wake can follow this path:

  timerfd -> ep_poll_callback -> aio_poll_wake -> aio_complete
          -> eventfd_signal -> ep_poll_callback -> ep_poll_safewake

The second ep_poll_safewake() recursively acquires ep->poll_wait.lock.
eventfd_signal_allowed() does not prevent this because the wake chain did
not begin in eventfd, so the task's eventfd recursion bit is still clear
when aio_poll_wake() decides to complete inline.

An unprivileged process can construct this graph and make a CPU spin on the
recursive lock.  DEBUG_SPINLOCK reports "BUG: spinlock recursion", and
lockdep reports the same epoll waitqueue lock as both held and requested.

Always defer eventfd-backed poll completions through the existing
aio_poll_put_work() path.  At this point the request has already been
detached from the waitqueue and active request list, so the work item can
publish the completion after the provider callback releases its lock.
Poll completions without a result eventfd remain inline.

Fixes: e8693bcfa0b4 ("aio: allow direct aio poll comletions for keyed wakeups")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20260813133843.2933127-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Removed the existing eventfd_signal_count() check instead of upstream's !eventfd_signal_allowed() check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/aio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 22b6e20322741..16ceed755b7e5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1777,7 +1777,12 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		list_del_init(&req->wait.entry);
 		list_del(&iocb->ki_list);
 		iocb->ki_res.res = mangle_poll(mask);
-		if (iocb->ki_eventfd && eventfd_signal_count()) {
+		/*
+		 * We hold an arbitrary provider waitqueue lock here.  Signaling a
+		 * result eventfd can feed back through epoll and try to take the same
+		 * lock again.  Defer all eventfd-backed poll completions.
+		 */
+		if (iocb->ki_eventfd) {
 			iocb = NULL;
 			INIT_WORK(&req->work, aio_poll_put_work);
 			schedule_work(&req->work);
-- 
2.53.0



