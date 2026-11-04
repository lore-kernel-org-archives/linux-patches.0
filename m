Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831352;
	b=IeP9/ykDFkiMtXSsiaA/JB4kROmf/7zy00EW5ddVXWbTuXZdX//BO7aoTUx124tufcOw
	 m7TcpO+ynbGNUMzjfTNsXoBAXkJQT76b07ztqfLBRQciN0KfQTO6aWbRAvUddngnS0rH5
	 0SNni2+0mCozu3mPcI5+Q2QW9TbrlSy7OYmY6uwsIF+3taZzqhtzSJDIz55OVHm/yO4pC
	 xRKkmEBJYS6b+ThN9Z4ny8R43RqF/gqt744tQcjYACbJb9r0G8F+wzfXNObJjfsv2w+Ab
	 zZxOXt+v7qrXFINEQZHiwfrA4lYijRsqiNOD4A0JTOrHOYJhEl7j4UltYzcTlddhZAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HXCo1ML5cZacKf0dpL9P/xmZ2EmLM4cESu8yFjYwFN0=;
	b=gy/m0YCkk1f+RK97SChd17hfd1q9tvt8OugmbhGQcO4yXG240SeNnrVDGYIJri3lj/Ka
	 XvvSf0xWI/Rph4gChcgMy83nOY8OgPx0oGVbmzJ53+KcPTL0z75U4aPB5CSGJ52v58XRR
	 +iCZ8JyO23h8pi9wGNjQoQZzxphe3MU/K6mXfF+ZFXEivVI7od+BS4a8Om7QCMUpntd1l
	 tiIBOKC3yXXJARV0zpaCw4zLcbRXun5mc4pRpBwNIDrG5H+xEdST/Ziic02WymGrwd+f9
	 rbRwT/VrV2N0y/efW0RHyx2sEvZ1Qzq2iS+RgrJ6/Gqo0X9t3WADMvqZeqmcYeOysbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hj8mFWwH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593F4606A33D;
	Wed,  4 Nov 2026 22:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hj8mFWwH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E791F000C1;
	Wed,  4 Nov 2026 22:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831352;
	bh=HXCo1ML5cZacKf0dpL9P/xmZ2EmLM4cESu8yFjYwFN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hj8mFWwHc4sjoGDgH2kUGu2amnW+ub9OAm1Cd0Hqked0lOCabmfb9kiNV7mZYT/Hc
	 SwW6o7TxtiScjY70du43mb/nKS7zLCQ6yMU38uq7YtxFn5NA9ykUthrBNjkRl/Y6hR
	 lB6rAoctuYxsaW5DOZfklDj86d3RS+HN0wsSO3Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0652/1005] tcp: Fix potential UAF in reqsk_timer_handler().
Date: Wed,  4 Nov 2026 16:06:25 -0500
Message-ID: <20261104211101.978977578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1135,7 +1135,7 @@ static void reqsk_timer_handler(struct t
 
 		if (!inet_ehash_insert(req_to_sk(nreq), req_to_sk(oreq), NULL)) {
 			/* delete timer */
-			__inet_csk_reqsk_queue_drop(sk_listener, nreq, true);
+			__inet_csk_reqsk_queue_drop(sk_listener, nreq, false);
 			goto no_ownership;
 		}
 


