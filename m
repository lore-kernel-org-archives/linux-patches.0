Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035731;
	b=HMpb0KrqN60WCk4ooAe48Bry5T7Vzb9Vx9/Y1taLH+5HgnxvwjQnwvFprSN80gy22lFh
	 6HPuvhSq0RAA9WoD3kOAJ64XKM0bL20UEyutMT+rIvgVn411/hyTfACvW+Ale4ucKOeP7
	 BiKYd6Ke0cLMdCVBFfyR8wkFy4eHZdrRGHH1LMqEg5uexyg2bibnQUEj9n8aRseyKXc/q
	 rubHNJMXFdEj6Fsz4bLSUOEXbX3LdWpHJVd+QEaMejs2GrY92mutAzbT5+VDCpe3F4sAq
	 aJKUXcCCFZ4w9Bnr5P2fBKwibHa4d+XLuSafzAjh3mRYg+vzIXQfuA6dX6j9zcqng5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SeDfl2sXxYY1CV6IyxjcQtKeLIx8zlBKPc0pfVItPkU=;
	b=qBw7FM/nLbjPiwbrwQox2nLMfrtlgRM5ZfmKiVU2idp9EKdhQ4UgV38dh4+a6FWCC5HG
	 tyowgLhibW1il7K7UZ5KzP0tIaSfQ+mkU7Y1AQjDJqkfZvnzMb9cpyvgCYTq05oXd/62O
	 +bm7D+kQtBJLkWArx4RX6yP0ZGgW5RBpZAOfJd3/PKrtzbCB7Gkad8AqcIpH93++jdj+m
	 2gWjfkneCjJipWIi4yqxwVDZU0ITNxjsE0piGw4c9KblZfec76tmR/4lY+fEU+JkAq6lP
	 tfjnQ7ndb5/OopK9bYaDfubC7cDQpcyRYTzJltd4QbYAYmcjengb72jAwBWN+C2YEsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEihLtK3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12296606A31C;
	Wed, 18 Nov 2026 21:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEihLtK3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334A61F000C4;
	Wed, 18 Nov 2026 21:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035730;
	bh=SeDfl2sXxYY1CV6IyxjcQtKeLIx8zlBKPc0pfVItPkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEihLtK3WT+2P0Na7RVq6MHnEceq8BN3elELw4OskNrh0tZ9q/4yaWiJBer22mQlQ
	 vCKSR4lCzAyAigrhWfDQIj4s6Bkb8fOSVf5YzGKkuTdCuPDFOiWyasWmZBfVGUqwbp
	 yMfuU+LdnrKKfs0XxLO+cRiaXi18amOA8dA909/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0807/3318] aio: prevent eventfd/epoll recursion on poll
Date: Wed, 18 Nov 2026 15:23:49 +0100
Message-ID: <20261118150343.190706308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index be12d7c049eff..918ef4fea8531 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1775,7 +1775,12 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
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



