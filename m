Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062744;
	b=MOwA4wPd6eJ7iILvVHLlaSboPjoiwSAgY8qrn8IJodtzlDecUj2oGdIovkxACtwj1dLG
	 L/K0tTlpnH8hlAlIZhGDrTjNBQjNXnsrosJGYuNt5RXErCQyVyuM05yfU1NrNPxWOwLnA
	 3DPRWDa198IQ9LeARjD6ezpRLKmabO8Gc/BUT0ufl+jYF14esmD6wpXwXgQu6gPeM8Mch
	 lcfIcgQGqetdOIEZVAqv4I93xC1xObGmc8wkQQc+5yI2gGawFc+8aDKSbrJ1z8XillFqY
	 7W9l7GlF5XlPJH1/Rz42xEPdFCAG8Ye7MGgyF5Si4PSsA3o21CRAu5OE0hRUj3bCpzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M5BZMfDwkK2jjuRjGCa4V9NafrKeFfEWPi+JLm8Ikxc=;
	b=CZMy9ArVSj4Dd42tyE4BfljDfuzfpDCQLPuuBWZ0TNfQA2911qqy0MHazto0JNngdtJe
	 x97mlU21h3gJxcJJhV7YvKPqCBTfAn9/fbQkSFvtDrikbG1NQMdcg69afNHbk3W5PjkHb
	 N6HXcyFonbRBvL8jz9vvjT88f7IHLfIUj5Rtmjq/nkJAhCsgytV4hb/7cUXlo8Sq3WRK3
	 v8FKMbCMfVR7ObLj3CGer8WXaX8KCgAxrwYY2RssG00g/M+Jn+z1irF2uIdDrTdMYHovb
	 905VNGNM/nTuYNY4UvWr+5I2i81n9sojrQqIXZYXxCA+mC1ojCsRyOH//Ahx7Z6hqkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHwXOpWq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22A8606A32E;
	Sat,  7 Nov 2026 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHwXOpWq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBC31F0089F;
	Sat,  7 Nov 2026 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062744;
	bh=M5BZMfDwkK2jjuRjGCa4V9NafrKeFfEWPi+JLm8Ikxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHwXOpWqHHSQ3zdP4sEsjuWqlxYl00uKmpCHL7jGjzlanrKqDHGKhWHTvCqEHR1uf
	 IU+YmBw2Xvkn7fbRkVVGEjmwy1JGmQ1vQXQwNSLDMsAAXx0CMxY2OL1huiaDbqZGzC
	 0J1jvTpQWy+/QavGfL/1NSsmPgvULPYHrKZ2Loo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/869] aio: prevent eventfd/epoll recursion on poll
Date: Sat,  7 Nov 2026 08:45:24 -0500
Message-ID: <20261107134853.570316844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 5bc1333864078..bd92bd3e13408 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1816,7 +1816,12 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
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



