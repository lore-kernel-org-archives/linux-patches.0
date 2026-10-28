Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209782;
	b=sTsHeFgrnG2fUBUvSayg23sQ6yhaIqWts3tbc/cYjaZ7tE1kIdtf0DaJkZ7EM+EV6j6G
	 KXpi/0xl/a69HJrFJ83k/KZcAy0UL+FaYCUmn8xipmY4qqb4VqpkigcrvbqjMnOCiuAii
	 eLwz8qL60n38ag8jHXefxqkCRr7Gy/9aNXjysZr8+sBZkuAj9FsFHIUgyMDOy9GfqAd7y
	 3rWaGZcSBoorR6Qd0Z/WfPLDw3xnxcMSL2IEfi8CctdL9yDxBZcblSrsBaRZWPoZLNj9n
	 6tyA5FheKgB80N5ziruBRLAcF8sCXjFWXVjTDDLHPGV26wYSY4lf2E1A/sXjZ1HmofA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ediZX0r1HWYG3XmyJYZ1Jj5rkwr3YtkBn6pE6yuN8sg=;
	b=kg4i7rLi0dTW8YXxYA5cK1GtV2UdJXrouUSX8K34C+izjX4MYTNv1c7iKzms+YzI3OzI
	 pVnm4wdqxDsNdx6a9cqOIasuQ6SGVUVD0msIx518huTVZjBJyF22/FWMAAyRdGOCMIrFc
	 tZ1qZPphwJS+zH4ctS/o60GmGJhy7IMLwX92MdZbilL88hEU+AsuRas1WnvOK4jzCiemU
	 tZIDlStRtiKaUQLemtwZPgLuHu/wtGYvehNZ3u03indOxU2Fgc1eGRiN7zVZffUTS8EtI
	 8T2vSJNVhUDhyBsZydaDG8ykIpbrYtWB0ME53hDNYO4dWE8eQr1EyesqBKqVEsu3s0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwzBa0Pn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A475606A31C;
	Wed, 28 Oct 2026 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwzBa0Pn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892321F01825;
	Wed, 28 Oct 2026 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209782;
	bh=ediZX0r1HWYG3XmyJYZ1Jj5rkwr3YtkBn6pE6yuN8sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwzBa0PneOXAsUtJ5q4Ifi71cvEnhRF7w5F60U3VeuOCP6EL53/tzHddrRmKSSA26
	 iqapN1rn+E5oPfYAlC4/iet4bo8aCFQZ1YF45igFrjl9ywUbzz3Q/gV0qihiA5cSA2
	 VzeUq8Qbqh2Lkqzrhnguuq/+WiC71iAXyJ5GWPxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 074/109] io_uring/sqpoll: let the thread sleep on disabled rings
Date: Wed, 28 Oct 2026 18:00:58 +0100
Message-ID: <20261028165944.098607372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
@@ -390,6 +390,13 @@ static int io_sq_thread(void *data)
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


