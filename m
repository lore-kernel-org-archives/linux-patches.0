Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208585;
	b=odt63XeLS41Ib3Jh3C9aaQnggXAU3IBbwYnb2ppFrE+IEA0N8+Gzj/pKTWulijZuHTHW
	 epCl82/WLyh3ySKLEu2khcYaK7U+s0ynPj37Z5i8+tynD46z1hhOM0125NFJN6HvGZFXI
	 Wv0cp1BMf58bJBi1BmInnJgEFsTq46xrinAztk075LzOmy6I0LgAbSb5/vI0Nh1z8534J
	 v65u70AVG4i+UXeHldv0xl/RjfmJC5IBDzdceVsmu3pw6BT+ZDydYQkyYYr6Yb2v4SArk
	 HMFu+aVNu5+rKRzqu2Cl/PNna9eUkbUc70kSUj8fGhdRjK9zvi9p2oGN+PMkAYIAY4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uP34cH5wN59tcDgO4JYtTquv4akWKWz+DI0w73nABNY=;
	b=IuNZZ5AsaVKGNopegjlk+EJonFU6n5J9TXVZ439t7rehiA9jMfLU/ENqJOc7lpStzqpQ
	 EWG35tP1DGXmHfZmJEvnDGG1Mcn+a8y8PWia/T0f3ipUW62SFRkGBhHwHxVZCjB7nQYrH
	 ZUrQTFa8yoEgs1jiJ0boSYo7h3qPHucLoQzpHLmc+oD3GAtQ/KZGA1r1bwtmPj1L85rhM
	 VtJAVd+9CO6Ry2uJ2bVALdmUM8MnjjpPbtVd1d/1/iJCsyS8EdF/l49XMcq+SnFAvjGIb
	 SENuNeQcWX3EIToD+BVIgvhz7QLAna2mtaJHQIT15i0Wxj7UnwK1lwgJkmSc/pU9dxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yk7ifeFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333D8606A31A;
	Wed, 28 Oct 2026 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yk7ifeFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4500A1F01825;
	Wed, 28 Oct 2026 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208584;
	bh=uP34cH5wN59tcDgO4JYtTquv4akWKWz+DI0w73nABNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yk7ifeFNYUkKRaDkM7mvrNmfZknmYMhP+L00PdvecZ5BjU/5EyYRmnz4apPsIwn/r
	 M/vm0STQLtowJsnRrX3fxap5C2WKppkh8Hcaqh/ZhXZuPSFMHUXX1SEK0JEQ9Qxlan
	 /rfegfQnhWEoleU44ScBcekOyUZrxIFTW4iqMr8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 144/516] sctp: check RCV_SHUTDOWN after the sendmsg connect wait
Date: Wed, 28 Oct 2026 17:54:56 +0100
Message-ID: <20261028170006.920149072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Jun Yang <junvyyang@tencent.com>

commit 4f1da630d13de0370e2f6361f961f1c8b384af1c upstream.

sctp_wait_for_connect() drops the socket lock while it sleeps. An
out-of-the-blue ABORT can then be processed from the socket backlog and
unlink the association. If a concurrent shutdown(fd, SHUT_RD) sets
RCV_SHUTDOWN, the waiter breaks with err == 0 before checking
asoc->base.dead. Its final sctp_association_put() can then free the
association, leaving sctp_sendmsg_to_asoc() to continue with a dangling
pointer.

Check RCV_SHUTDOWN along with the wait error in sctp_sendmsg_to_asoc()
before using the association again. The check only accesses the socket,
so it needs no additional association reference. Return the existing
-ESRCH so that sctp_sendmsg() skips freeing a new association that may
already have been destroyed.

Keep sctp_wait_for_connect() unchanged to preserve its behavior for the
connect() caller.

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260926095606.68601-1-juny24602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1846,7 +1846,7 @@ static int sctp_sendmsg_to_asoc(struct s
 		if (asoc->ep->intl_enable) {
 			timeo = sock_sndtimeo(sk, 0);
 			err = sctp_wait_for_connect(asoc, &timeo);
-			if (err) {
+			if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
 				err = -ESRCH;
 				goto err;
 			}


