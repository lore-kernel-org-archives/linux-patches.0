Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035032;
	b=vzpfqwuE6i+rFJKoRgn5x17lIMeDL87+Rj2EAmyNgnCNqw76mr+1s05epU++/dkvmOmh
	 UivQSzuCaZbrUkZEoZd4+5xNR3qmaFzeuX00CvRCUm4b+8S8HiEg5I7EzCtgwoLIU+7jO
	 3yi9UB4bLrEG+m0zI/F3vKEMSNKPJqiw3uuIOX85EGOTFPvQp9H7z1LrIzHqMZIkaq7Zq
	 dXEJz6wxyIyQqRD1VW0kdHmnXjNlKJQXr80pI0lIBlQPwca0CZPVLUnSX65knXZ6h1MiZ
	 PD/Xfnnt3Tu8yqdV6GNBBFPgmrmie5LQubhxX5bjcossIgSqz0khT9U7pntMOH0vPZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WkEulzdvKzz1kqj2jZtnbc2LfY081uGJebnhzv73DLY=;
	b=hdED8CBz84HtieviJGymDstNtKnML2bUgJsndDMgDMY/cEefpmucT+H5LvqPW9K9vdeF
	 PMI7c/ruQNqXe+/u2FAJs91H26y0DU6+F3UwQvWQDXLsAxMRqqxppMJS/TaYzKAahmGLo
	 vNOJ7FbQp+4BmSru+m68H1yp9XYkcT26iKjGRi0wJcg3mL3ZvmIF1W/4RRS5DaYkZCE0W
	 XNYGcR4BVbJQOOtMp/wrFLghB6q4uGw4/E56QN4SvIHuiICHxWW8RkqrZ2lyPUSY4WfSG
	 7tvWPcfE6HhGKolswATJz06/YTnFDTYqSDCyVU0hIOXT4kOBoaj8FCHNc3NrUHN92uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JbJ/vKwx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C06606A31C;
	Wed, 18 Nov 2026 20:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbJ/vKwx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7589F1F000C4;
	Wed, 18 Nov 2026 20:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035032;
	bh=WkEulzdvKzz1kqj2jZtnbc2LfY081uGJebnhzv73DLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbJ/vKwxTVXWN+0SB1OjwM1XqlFWZ0Y6v0tgz+bTHy3qZALOmFZ8f+MO3GvH7Cl+D
	 vBQ+7W79UwXp9nyGy/zuNvGcmAxIwCg/Hp3lNg0byU3MTBJCyU3wTiHHYuGk3CUpza
	 4+Ad2WDj1rC3PhvhEmRzlNgdo6jrM7c+jeWVDscw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0579/3318] tcp: Fix potential UAF in reqsk_timer_handler().
Date: Wed, 18 Nov 2026 15:20:01 +0100
Message-ID: <20261118150334.877879151@linuxfoundation.org>
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
@@ -1101,7 +1101,7 @@ static void reqsk_timer_handler(struct t
 
 		if (!inet_ehash_insert(req_to_sk(nreq), req_to_sk(oreq), NULL)) {
 			/* delete timer */
-			__inet_csk_reqsk_queue_drop(sk_listener, nreq, true);
+			__inet_csk_reqsk_queue_drop(sk_listener, nreq, false);
 			goto no_ownership;
 		}
 


