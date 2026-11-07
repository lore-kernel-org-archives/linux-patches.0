Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061895;
	b=TI4LvOufKQFEOjBR5A3XvSbtrN0VQf20amCMlPdcL5s6f3JoShwA6eQ+QEk7/ZKefYBb
	 Q9LHsWtcuLHV5F8W4RqabPGSxwsL18iEQAW04DWbYai+H8tzxemrbxEFmKLMfqQVcUlCy
	 nwyn1PnKIiXzeLZIR45ovPlWt69JKcwFwDE17xXZgbw0RoT8ITHDRMcTpWzFfkKAiBkk9
	 FEX/u2p6kLl83GOi1Hpvt78PlXeH2JwqeJSg41/5T/tpZoc6BJ2aszcnZq7h05jEHGUhL
	 CCENAQ8+sskimp7e/czxmpnKd58ecFJ5EMYrxJIn7aekA9f9YnYVQyeRYy1HjVB1cFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TzbcDb3TweN4OEXqxauWYpuZhuLTHlhTB+TURTS3PCM=;
	b=1UjKCe6OluCE6TYU/rk8scsZkZw7cDeegfp8FcalyzN8L+G4GAeb8gdhKSsEJsNTrBxz
	 tNJndZ/sb2DhZGg3QDNXs54u2wzvsjG3wLqcYHpZpyuhEnJoP504wKfoY5+Wm54bl96GE
	 3B+LCqADjeCFOS3nfA5pyzGG0qUy7FeIM6cS+kjfRhSOUfPIaQC2UrX4pMHgfHwxhPlNh
	 BkQw1GHhZ/3/iPmjFDk+F/nHxOeY/H4GwiG2IjyossBsnXkGz2ffOPtH/xFOjaKVTwd3C
	 1DxbINdQ8mUW2edC7g50/Grra673MkrleUxKV39xkiqlWzo3OX8IVmIkAw8xkcxirxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nBaiXeib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF22606A32C;
	Sat,  7 Nov 2026 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nBaiXeib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F5C1F0089F;
	Sat,  7 Nov 2026 14:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061895;
	bh=TzbcDb3TweN4OEXqxauWYpuZhuLTHlhTB+TURTS3PCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBaiXeibJ266U7fdnn7OI3GA0YXBIYO70OlDxUI0HCZ78ehoB8Qn2VOP1rYYPwJfS
	 OlHtoCx0C/rcX3GRvMSDYYT1j1TSLzQxfGWvGYF+/Bqukd8VjCY16vOm5cmNadIuC3
	 ITXWUNoJC4bUgQBAv7pdADewNyp1xBM8iePXTCdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0904/1536] aio: prevent eventfd/epoll recursion on poll
Date: Sat,  7 Nov 2026 08:48:40 -0500
Message-ID: <20261107135023.025739729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/aio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index e8920178b50f7..59620eb01df49 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1815,7 +1815,12 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		list_del_init(&req->wait.entry);
 		list_del(&iocb->ki_list);
 		iocb->ki_res.res = mangle_poll(mask);
-		if (iocb->ki_eventfd && !eventfd_signal_allowed()) {
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



