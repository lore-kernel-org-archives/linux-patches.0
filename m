Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044350;
	b=pUTAJ2IXAbb0rbVKSHlDdIsNkKCI1z24j9Xoo80hyeR5v89rtYiMeghb26hPKWCeMsCC
	 lC4ua3CS9C4eUHw2NDkWQQJR2SsWryaKHAzlQBzphle0LKXpmt80WQmwZ0845ACin1jv7
	 LdvFe9OqeXWRzDPxqadSneKvtbwlrIoaClOeH1nfc4fjxhaAB/JbM0B3QGqffqQxdoJ4K
	 OGXWyFSP8eIK/CBQGAl2gyKyM3uQhNoE8L0h26B0qX+guwMA2jkki46f4FBUFjybQFsDu
	 1YGtyhu7vDyzRUHXACfZk6j9/SjTRkRI+tTGt+lR7jpxUSHskwOkRXYdISwpXLDPX2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9DujwoBLUnYIaqrL5V1qvNDWNcSkMe4vXfNv5gT2uiY=;
	b=ZeyM3f1Pw/0KPDYSdACAWLOQGAquL7bTDP4z0XVNP7bWJ9AE0O7P0GVC3IwSVFOYDRCJ
	 FGZv8i8wMG2Q4C4yoyGoxb0n42uSQTsK5+5VJVOX+go/t0xm7Itnd0ugjb0BcUDESMfKd
	 4kOtwCMvlDTduvxX7Rp5t1ueW5bEEswou+BhXY43WpWJcX35+POAWcGbQ/cUVyW5cp/JK
	 XdZDvgi0y3Pea7igSbRXCkvIFus4YvYN6U9raKkdU19iSkEq9m6qXIFSxyno3Aj2fmyQz
	 qVCJ+PLCZeyG03zuCB/TSTfXILmfVk0stL2Vh3B8uWKiLrpXO9zXh9PnzSVRhVCqRFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJmSs34B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E60606A31C;
	Wed, 18 Nov 2026 23:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJmSs34B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0624C1F000C4;
	Wed, 18 Nov 2026 23:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044350;
	bh=9DujwoBLUnYIaqrL5V1qvNDWNcSkMe4vXfNv5gT2uiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJmSs34BPQ5p/vCD4zWDYbVW95Bx5yinP07UnKd0nAowe5xbH7ocag92kyJ3K0J8M
	 Ew0Cxh0cHDxymo8eKcBlGz/q165V4aNyQ8WxtuPy/LvgqO/ln4TcgTI33Az0vFZ63O
	 8yL9560o8d41cn13EGOX1UdOlNuQ2T/bXm6jmM0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0519/2857] tcp: Fix potential UAF in reqsk_timer_handler().
Date: Wed, 18 Nov 2026 15:25:53 +0100
Message-ID: <20261118150220.156626839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 97c8a3c1f73d828de43a5a88e8a9a143efb2b661 upstream.

When TCP socket migration fails at inet_ehash_insert() in
reqsk_timer_handler(), we jump to the no_ownership: label
and free the new reqsk immediately with __reqsk_free().

Thus, we must stop the new reqsk's timer before jumping to the
label, but the timer might be missed since the cited commit,
resulting in UAF.

As we are in the original reqsk's timer context, we can safely
call timer_delete_sync() for the new reqsk.

Let's pass false to __inet_csk_reqsk_queue_drop() to stop
the new reqsk's timer.

Fixes: 83fccfc3940c ("inet: fix potential deadlock in reqsk_queue_unlink()")
Reported-by: Damiano Melotti <melotti@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260506035954.1563147-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1098,7 +1098,7 @@ static void reqsk_timer_handler(struct t
 
 		if (!inet_ehash_insert(req_to_sk(nreq), req_to_sk(oreq), NULL)) {
 			/* delete timer */
-			__inet_csk_reqsk_queue_drop(sk_listener, nreq, true);
+			__inet_csk_reqsk_queue_drop(sk_listener, nreq, false);
 			goto no_ownership;
 		}
 


