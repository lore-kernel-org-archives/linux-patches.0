Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212056;
	b=zRArwQqx7TAaZJBRfNyvrNiWnReKYfyhkdLlr3jA0SE76U22dhiZWjqpTkW8pcUaki0t
	 YUkA14uJqiwZMVH82UHSbeWdAPZwy3kmZRlZqeKNR+5BiRy90hnNyebugQo25FN6DpBCk
	 32NqG8tm+jpTkFfc4keK/WJvyX5MUj20N6bHE9ECt57SACsj6H41zCtQ/nugva+pcuag8
	 QKmxOLHw13HFZd5k0K1RG/C02PK4gdN+iUv5fyZbsa2TviQnPxYAJ5sEpoQb5VITlN1mn
	 DyckUiIu4dLlEfdfSJrOQ9onTgIf7uHPnNiNwKt8voNAi4OFzMaSz8t65zxYE3S23Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1BuoUzmnBn7i5jZLJ/9JW+HGD/Vd9csKRLUZDDBwkvA=;
	b=eRmfD9uExOFEioY7QrXRYrqc0RDL59vRbWJXjySSx3ePcTwPaIUF9ul3Tf5mioqgAUuA
	 it5BpnBacN7kvwVNpfTQk0Au6Xg90nEVOJq16Zkhvevl2uAo23ne4hSLnycltxU6LcziR
	 zEl8kTPH8YE6BYnrurpKiyRovffzdbO35FYPYY63b9eTdnoiw2/6R3oGojt4+AsWaCvAk
	 VYwzxnGbWt+RX388Foe8PMegJ8INCAVNlw0Ata5iQgEZNMFd6zHsej7BbblCRKglJmHZi
	 ag3u10XPcQYHHRM0Fq2PwHlQMnha1GKdx6FfPYwB1PP5jcTWwyLo6xhxn5G5h399pJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z61SGv19;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3428B606A31C;
	Wed, 28 Oct 2026 18:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z61SGv19
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852601F01825;
	Wed, 28 Oct 2026 18:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212056;
	bh=1BuoUzmnBn7i5jZLJ/9JW+HGD/Vd9csKRLUZDDBwkvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z61SGv190Ue1b0Je5lsMzia2t7PNNm4RhdL8aWLITCDSAOafsa+0pg2BT7T6XPFIV
	 BSaltETKN0hhGxVwcx4qVb6WFFWi30iZ25PnRRFWjf6YRJBq1VlljW+XLci/GDACKo
	 mzDN/dHv2FKOWMlnwe39N/YkTVAAArFLlfKRwtJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0015/1887] io_uring/sqpoll: let the thread sleep on disabled rings
Date: Wed, 28 Oct 2026 17:35:11 +0100
Message-ID: <20261028170459.569047710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -293,6 +293,13 @@ static int io_sq_thread(void *data)
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


