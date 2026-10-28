Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208012;
	b=zywFM6yQt5XlMRzAmKuA4Tcq3V4NJgbW/EfgAlGF32ngQeqig/VqqFTyGS3TP8RzuSEH
	 m0DA9wGItrxPoB0sG1w6fid9AYJmODuLeOrHR9FKPY15olooeP0Z4BMka4TRTSUMjZYXw
	 Eak+OTM1/MnUP6RDAINfDGDAvX1ZGDjy9LKSzf6Kgf7jPUXwW0LKfqgW1sL0GM4lCGhDN
	 l+BUS0NMbK8wOFJPxARzyHrgToy+OLpEmQRfKr8VzRnf0/6YTdkJcPfPJRrmbRW1yNMvD
	 7r7R7HkF3GcLiJ++lurPQ/7FkltMSXkjuOVzc1Rmb9sa4Y43htxd1IgqgQpobt9L77Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TuIjGwv7nHQac7yQpBgKqohXR31fqxkiyehu4z+R1Dc=;
	b=0RvXBKthn3iGyYTBjH9SZwvN2unEzV0PxPv3Lqn5JJ2XGteZEwAXnR9edyA7oz7A5Al7
	 DpI0rLDwKDL1oB9WIvAL21z6SUngtMgcgc+rslXvQIEgJ+MXNhA4cDc1fS+qA3A+08zEG
	 F8EjAsyT0yUW5nRQB3vMI3lzLHvtSPJUAzto36kxordhxpzb+watK2YVJxcRIKn/YkFil
	 ipgbzIR7UZZRW0u5SQqxYmNYuY83eP7EZ9COgGtPI28xCSuLu/E54JuUgb4atekmv5D8V
	 DFLA2OhKPYS4wZ/FddQjAJNI7729bosueITy6s5Oj+in6Ra9Zxdk0oXEzJcyFUAnwlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hqr77CaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4FC606A31C;
	Wed, 28 Oct 2026 17:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hqr77CaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776481F031E2;
	Wed, 28 Oct 2026 17:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208012;
	bh=TuIjGwv7nHQac7yQpBgKqohXR31fqxkiyehu4z+R1Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hqr77CaW4I/bOkKzKmFgbHxySXfmMEoGJr1rxWPlphisN0Krai6YMEhfexBWwmrzy
	 rcOJ2QJNUE7dRnIK8WKUXR0981TfmnUzRwPQmb5UTCpWFd+w+GCy2jWM6bHMb1mfXD
	 9I0YZlyzd1VoWbQrij9KE397y/kFogSCuhb6BLVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 216/247] io_uring/sqpoll: let the thread sleep on disabled rings
Date: Wed, 28 Oct 2026 18:00:19 +0100
Message-ID: <20261028165952.536772855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit d492dcbb3b81c1c2d0aabef41fa1307093f3a556 upstream.

__io_sq_thread() doesn't submit anything as long as the ring has
IORING_SETUP_R_DISABLED set. The check that keeps the SQPOLL thread from
going to sleep while the SQ ring holds entries doesn't know about that.
If an application fills in SQEs first and enables the ring later, the
thread finds that there is work each time it is about to sleep, goes
around, doesn't submit it, and so on. It uses up a CPU until the ring
gets enabled.

Entries in the SQ ring of a disabled ring are no reason to stay awake.
io_register_enable_rings() clears the flag and then wakes the thread, and
the flag is looked at after prepare_to_wait(), so the thread can't miss
that.

Fixes: 0298ef969a11 ("io_uring: clean R_DISABLED startup mess")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-37-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -387,6 +387,13 @@ static int io_sq_thread(void *data)
 				 */
 				smp_mb__after_atomic();
 
+				/*
+				 * Nothing gets submitted before the ring is
+				 * enabled, which comes with a wake up.
+				 */
+				if (READ_ONCE(ctx->flags) & IORING_SETUP_R_DISABLED)
+					continue;
+
 				if (io_sqring_entries(ctx)) {
 					needs_sched = false;
 					break;


