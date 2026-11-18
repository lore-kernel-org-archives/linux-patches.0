Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051658;
	b=jCgZ3JWJJ5wSiyK85l4l9d3wldyyvKRZ6nDtSrCkfhVjMzM7iINgCx6hT/vqUYA0ln0E
	 piK0eAbKgV810yIm8DThZqxPxGBCgpgs9FiGLcn+fWBVN1I5tV434ThV/t+eBHUSf+NL2
	 3FNY5n6HNlh8bN3a1j+AZzQv+AflCeVoAuh3ZUffQSc+3EZjuhI3T5Ln5V66PtQHmZyq4
	 e1cx6QLMG/tM4F1mkr+bcKnIGBgifhs2TPwk9KADsmnnGL3vnxIWf5Jy6YBqnEvujBiZ4
	 KuRAyLCLmifwizqaG4Gbv/dWB7dQvTEnv6tMHUMjbtVOOjiM8AkjOWthD8xwJdXL0iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KJ1uAb/4KcZzS39Oh1PUeJ0D7liwCMB/WEZPyRRkZe0=;
	b=rEHo4FVDC7ESt9qhANkVPaa3DvaLBjw4QiRKEvHaPQCOx/FsNmUSTMZya/RS04dM0kB6
	 3TgAsmXyOg1N9swW5lpS8EyZ28jL8+Etcmbl9/ONOrJA4dlyX6a+lmwXKFM0gHPBq9GQr
	 AuWd2cKWtAzlzNhbSL/+ZA0AyG4mldUxdLjzp4grDFfS+Y6mHyC8zJ211BMsBcUA+VWA9
	 brRbQSJWcpnERDYe/9opcA7s7VBFC/SFwJn1sRFSjxP1wm1Ske7vkn0SMUFs0xN160YiB
	 Q1+UTwxPoYOyBdasE/FMhl3uumssjZoZKuZJwtnahNNfancA9CLl6WzYUKfj0pRcsnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19ckGlg9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCA0606A320;
	Thu, 19 Nov 2026 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19ckGlg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20D81F000C4;
	Thu, 19 Nov 2026 01:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051657;
	bh=KJ1uAb/4KcZzS39Oh1PUeJ0D7liwCMB/WEZPyRRkZe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19ckGlg9bllrq3+TO5NPfLKxoQTj+mlTHQAG6eT65VFa8q/fOYb7lSNESazib5g8V
	 inin5jFqxSf1M6oIowjRwu7AoUTRTWTZgx8l6GvQLHqe9dKIkoqagvIAhQNvOLmiM8
	 gu5R1yEGYPtpdqJY+t0nJOKTd6uIZDpFyMfkXeXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 0286/2214] tcp: Fix potential UAF in reqsk_timer_handler().
Date: Wed, 18 Nov 2026 15:32:42 +0100
Message-ID: <20261118150021.492398473@linuxfoundation.org>
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
@@ -920,7 +920,7 @@ static void reqsk_timer_handler(struct t
 
 		if (!inet_ehash_insert(req_to_sk(nreq), req_to_sk(oreq), NULL)) {
 			/* delete timer */
-			__inet_csk_reqsk_queue_drop(sk_listener, nreq, true);
+			__inet_csk_reqsk_queue_drop(sk_listener, nreq, false);
 			goto no_ownership;
 		}
 


