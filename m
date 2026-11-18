Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052095;
	b=PMUpJXzCFt7j3CrFqeJAoM51Y6ObQXc1/0Gdz1Mu1Dzk/sE+h0KRpCKXTpUL9aZ3uyde
	 8wk0zm5CAX361gbX5LfiU3HdcIZwKlNcN1CBWka5kNKbHPl2cbzuiR3C0Yar3oZTQV0ZK
	 IpXzEhAMHvowcfHdwzEuzD7G4C84b62FIfLbGL3kntAtRZe+ohg6beiIFxYZrnPEKUj+S
	 uv+4WcPQ/k58Sc1C482Kyr4O7YLIXW43Nf1jCcQcy/U1zjParUWzmM2TgDj6bOSmRviNm
	 8ILe80+LCBLkwQIZQjgaGqMB+FxkUulQKgIbjyqarFgm2OYd3CfEGoRz2ReEGMYZJ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wgT7MpctSaND5vziz1O9jlUnc4lrbvaL+FxPYRTNwiA=;
	b=vA1MSrMB02+0B82jAF9w6qT+/Ym+lUGoBDVOvmYAAze+hAMjZmY30RFbNMfVQIcGsP5C
	 ZA8XKNQ2SlKGrSd2C0i/rhbdt3YhxMeF5aRppD6vnYwdN2axrsX4zwuHEQneE49p2QYsv
	 Ao9tKD5X/NDxJ1J5biVCfNb3Qu44rXuQTFLAU3/whEzwOpJ5y5eW1cNTXj8UtZ/VzfUIf
	 5326KNDw9OAsdEJ6IklIM+mP7HNJmTRimgk9qEfw9h39glv/DnPFdGySExWHVRKqAjn2W
	 BvBGnnSR78l/y7peCKALE2aCI1FXsPCEz0Hpu3HlTyKFmHUxER6KOIY3sJKdKX5yiHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBa4jnkm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378C2606A31C;
	Thu, 19 Nov 2026 01:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBa4jnkm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917861F000C4;
	Thu, 19 Nov 2026 01:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052095;
	bh=wgT7MpctSaND5vziz1O9jlUnc4lrbvaL+FxPYRTNwiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBa4jnkmdAE4ae44WAhgCaRm9FedHdZ9GbBdSgmipawSUFkKdest9oD55cH45vEHM
	 qdvs0JOk/T9+6Qg/4nrUiJjCTwR4GpWLwTIjOot8JPeWmmzkhGaxK/cW0liYDBlzP5
	 EYGykUFs8Jz+iHTm8mvVA4/Agi9fTjitTQ/dldnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0442/2214] aio: prevent eventfd/epoll recursion on poll
Date: Wed, 18 Nov 2026 15:35:18 +0100
Message-ID: <20261118150028.768503487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f502a7c841909..865c94fe4a0c8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1776,7 +1776,12 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
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



