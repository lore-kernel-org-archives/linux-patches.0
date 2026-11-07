Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063823;
	b=nqI7kcjnmsiozSPjaS/pdcrnVC5wyVfIjRmLsCHYbCdCF+NFhbemcplHZu9INLUmngEf
	 5tpw2B1Juk5GdkvtCirT1vFzFyQY43zpkw46W9mz+0eyF9T/yD2rdR8FkHc6lpbipl8nq
	 W9lmapNbwxHok5Cz3p4LuHcI6PeAM1U6mrmjFtbAKeKa6svTWxIrbmbkE2qE9AnW2M4Hq
	 hDAfxyuSZ3btd0kadfaW16KMmZZ73eLbRrUFL8R7kvAUi7z8WUwyyTg5fD6vtfd7xJBat
	 oljMnZAPQcJyVGJub7PlHvS+0MlYkJDTKUKHQlyS6UPtAMnIq9bSUL7JuyD95nuQJ8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6R408QaHS/c8wLtj1KyUaHBhwGKee9aIGnYXrOZHyI=;
	b=atl7YpHr/1a2MqlIvFOYtqtG1WVcpCzucgBapBqUT2jZ+HSGLJila2XItusi5p17q7Hp
	 n4VE1P/BX9FWrmSb6RooFtA9f8ien5tEGgrsWhrLO7B7hVnCI/5IyCca8rtTzoezINepj
	 pJgd+Bdm+zUmOEPyWHN9U95MaTMsj3M0bdbNs9FrvHoDPvTdVP4adydJjzORh82Go5lRY
	 7ehAtUDAzgo674OiImqTDVq2jtUf9oDskGwFZsvihNm939nn+c5vbji6dSiSAGlx5LvOn
	 RCeqSiGg+O5J/0ceoJtNrShC+XuNzluygFXi7c4zUUTaWtIUtlfDbyXiCApaBYvyD+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cz/xqiW0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B414606A326;
	Sat,  7 Nov 2026 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cz/xqiW0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D361F0089F;
	Sat,  7 Nov 2026 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063823;
	bh=H6R408QaHS/c8wLtj1KyUaHBhwGKee9aIGnYXrOZHyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cz/xqiW0ZuHzioNO5Ymuil8O0cmndUwitHJeViUuErTHpF9rvRfKlo3wbPdWco/r6
	 7h6r1j9akawi+LRuUQw+DSPVjFp5cpOPCq7ZgBLbCIYl+9nWMnCYfCYdc/cprtSdXr
	 IRn98SEdgFPcrENtJmmV3Jb0ihogeLdzzsK02OI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0038/1257] aio: prevent eventfd/epoll recursion on poll
Date: Sat,  7 Nov 2026 08:38:54 -0500
Message-ID: <20261107134940.461038818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index d78acc69f4870..92241a24d9e28 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1869,7 +1869,12 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
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



