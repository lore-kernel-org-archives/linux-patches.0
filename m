Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061336;
	b=0vVcEA3TW/WM/OnBlFA+krSd8yiqsTmm5vISLlLIdAzhqNr8Je/v/Gojf/m17IrdTgYk
	 W4A4Sc2EvY2tmbh/SJ3tmBj2JylRR6XIsXuJxAISKyZZKjjajmAfM5an5IYjAf8QIc4DK
	 5Yd9cAAH580yezUR6HhM9MO0QvML7WcgWQ+rFLlan/Q6Um7uSZXOPfiiEvwAGpG1JKSvv
	 IN9D5qstbEF8jqheQASMVeReL82BOSUE10/s7bVOG2CM0VyQxMFPtMqlgef6rIM7pIbvF
	 f9cYRupl/GGI12opuj8Y9gdmNM0b3BRSQq9PWnaz6cFoiDInVvESvt5sYbYUJMVeyVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+CoC8oav+NCuakVXtVQSzu+eYCcLs0O1p16WJD+DgVk=;
	b=lLrpkOFcv4JUAbOG7wYRaANMYpMjZryEqRFmpIeiCXLinCdLJnaoIY1lobtppfg4uzKW
	 zwrfEJMjlkyyWQLPAMIwHRx8cMJ4XX00G0HwIsVO7YSo8UYryr+siRdGfoFDlTlwXUQBn
	 /lRAU3wc4U2XWyU54uSUuU8kNXifv0D8Flt7TwTCB/ejAbXZVCDQV/p0qwElutVGojPCt
	 sYIUhFba7zbLWf9ltxQf2fEwGsMrhlmIcP9/t5q78QoODCRQoX96GPkkX9fP4DCLmwJDQ
	 LtN/1U2jdqRterJihvIlfegj8GmRwmiyWn9vImN6g8/EJvLGa1DPbqKj5z+qa+XhFiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoZ6Y54U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267DC606A320;
	Thu, 19 Nov 2026 04:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoZ6Y54U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D581F000C4;
	Thu, 19 Nov 2026 04:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061336;
	bh=+CoC8oav+NCuakVXtVQSzu+eYCcLs0O1p16WJD+DgVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zoZ6Y54UlLG35JawsWIXjVqDNZWVLwpZTyvwcJt86ND+T2hzODGY7x9UeStNti+jD
	 KtWSxeAUfyfwxAjAGthrk3nD3Ay3WaEXbCZ6X+nCctrLA1cBJXu3fBtj7+iq/3y8hf
	 jgHjWid8NknOBwL/UrNURTBOp9Di6QczfRx8ehwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Schmaus <florian.schmaus@codasip.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiher <r@hev.cc>,
	Roman Penyaev <rpenyaev@suse.de>,
	Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1517/1848] selftests/epoll: fix race condition in multi-waiter wakeup tests
Date: Wed, 18 Nov 2026 15:59:15 +0100
Message-ID: <20261118150022.786680054@linuxfoundation.org>
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

From: Florian Schmaus <florian.schmaus@codasip.com>

[ Upstream commit 4238e66c82b6ee888a768cb298c85083b4566726 ]

In tests with multiple concurrent waiters on edge-triggered epoll
instances where an emitter writes to multiple sockets (epoll16, epoll56,
epoll58):

When the emitter performs its first write(), ep_poll_callback() fires and
wakes up both waiters because one waiter uses epoll_wait() and the other
one uses poll().  This translates to different wait queues, ep->wq for
epoll and ep->poll_wait for poll/select, which are both awoken by the
kernel because of that single write.  Next, both waiter threads invoke
epoll_wait(), but since there is only one event, only one epoll_wait()
will return non-zero because of the edge-triggered mode being used (in
level-triggered mode, the kernel would re-queue the event because of
remaining unread data).

Since the second waiter sees an empty ready list, it does not increment
ctx.count and the test fails spuriously with ctx.count == 1 instead of 2.

  Emitter (CPU 0)      Thread 0 (CPU 1)        Thread 1 (CPU 2)
  ===============      ================        ================
                       epoll_wait(e0, -1)      poll(e0, -1)
                       [on e0->wq]             [on e0->poll_wait]

  write(sfd[1])
       |
       +--(Kernel wakes BOTH e0->wq and e0->poll_wait via callback)--+
       |                                                             |
       |               wakes up                wakes up              |
       |               epoll_wait() reaps e1   poll() returns 1      |
       |               (e1 removed via ET)     (wants event)         |
       |               e0->rdllist is EMPTY          |               |
       |               count++ (count = 1)           v               |
       |                                       epoll_wait(e0, 0)     |
       |                                       sees EMPTY list!      |
       |                                       returns 0!            |
       |                                       thread exits          |
       v                                                             |
  write(sfd[3])                                                      |
  (event arrives too late!)                                          v
                           EXPECT_EQ(count, 2)  <-- SPURIOUS FAILURE!

Introduce waiter_entry1ap_loop() to retry poll() if the initial
epoll_wait(..., 0) yielded no events.  This ensures the thread waits for
the subsequent write rather than failing immediately.  Apply this helper
in epoll16, epoll56, and for both waiter threads in epoll58.

Link: https://lore.kernel.org/20260828-selftest-epoll-fix-race-v2-1-953ab57fd60a@codasip.com
Fixes: f2728fe80cef ("selftests: add epoll selftests")
Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiher <r@hev.cc>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../filesystems/epoll/epoll_wakeup_test.c     | 32 +++++++++++++------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c b/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
index 8f82f99f7748a..3f8ed92c26454 100644
--- a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
+++ b/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
@@ -59,6 +59,24 @@ static void *waiter_entry1ap(void *data)
 	return NULL;
 }
 
+static void *waiter_entry1ap_loop(void *data)
+{
+	struct pollfd pfd;
+	struct epoll_event e;
+	struct epoll_mtcontext *ctx = data;
+
+	pfd.fd = ctx->efd[0];
+	pfd.events = POLLIN;
+	while (poll(&pfd, 1, 2000) > 0) {
+		if (epoll_wait(ctx->efd[0], &e, 1, 0) > 0) {
+			__sync_fetch_and_add(&ctx->count, 1);
+			break;
+		}
+	}
+
+	return NULL;
+}
+
 static void *waiter_entry1o(void *data)
 {
 	struct epoll_event e;
@@ -794,7 +812,7 @@ TEST(epoll16)
 	ASSERT_EQ(epoll_ctl(ctx.efd[0], EPOLL_CTL_ADD, ctx.sfd[2], events), 0);
 
 	ctx.main = pthread_self();
-	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap, &ctx), 0);
+	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap_loop, &ctx), 0);
 	ASSERT_EQ(pthread_create(&emitter, NULL, emitter_entry2, &ctx), 0);
 
 	if (epoll_wait(ctx.efd[0], events, 1, -1) > 0)
@@ -2910,7 +2928,7 @@ TEST(epoll56)
 	ASSERT_EQ(epoll_ctl(ctx.efd[0], EPOLL_CTL_ADD, ctx.efd[2], &e), 0);
 
 	ctx.main = pthread_self();
-	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap, &ctx), 0);
+	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap_loop, &ctx), 0);
 	ASSERT_EQ(pthread_create(&emitter, NULL, emitter_entry2, &ctx), 0);
 
 	if (epoll_wait(ctx.efd[0], &e, 1, -1) > 0)
@@ -3015,7 +3033,6 @@ TEST(epoll57)
 TEST(epoll58)
 {
 	pthread_t emitter;
-	struct pollfd pfd;
 	struct epoll_event e;
 	struct epoll_mtcontext ctx = { 0 };
 
@@ -3046,15 +3063,10 @@ TEST(epoll58)
 	ASSERT_EQ(epoll_ctl(ctx.efd[0], EPOLL_CTL_ADD, ctx.efd[2], &e), 0);
 
 	ctx.main = pthread_self();
-	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap, &ctx), 0);
+	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap_loop, &ctx), 0);
 	ASSERT_EQ(pthread_create(&emitter, NULL, emitter_entry2, &ctx), 0);
 
-	pfd.fd = ctx.efd[0];
-	pfd.events = POLLIN;
-	if (poll(&pfd, 1, -1) > 0) {
-		if (epoll_wait(ctx.efd[0], &e, 1, 0) > 0)
-			__sync_fetch_and_add(&ctx.count, 1);
-	}
+	waiter_entry1ap_loop(&ctx);
 
 	ASSERT_EQ(pthread_join(ctx.waiter, NULL), 0);
 	EXPECT_EQ(ctx.count, 2);
-- 
2.53.0



