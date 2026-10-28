Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210766;
	b=svx8V+2IZBRysxVhbKuEVD4lXhSW9ru4vorfVM+ApufMsdH19L1S6NM2q0q9cxBR4Yyd
	 +K35IKTldv4vti7eBCoa4i1hSOxgTPTkzVYSC3iswsrBriZ3ipTuVmO++PCop/nV4pP95
	 03JqsEYlXU2eNyubXwOsL52qOc3VgPgL2fVmDhV37hVnrJYzHgyFbep8MU50nT2EOtW6t
	 Gh45/vbsLEYg9UEaEgzXC8tf7SArbB0t+zJjSfkz8jhVahvdWRoezZOXM/4bUc+Gxj06c
	 qVC/Ax+ZJQT4Np+dOrOHAV7ba32jHkY9zusCI1T7W2yr5HGZya/f3IlyLApdG1MNJkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8FO8qZ9gARGDgK3w5w2rU+iPtfOgPtkf6Geza2EirgE=;
	b=smSKk0acnMQVnftPsXbA9CDJqyyv8uCv3xZJCJJarlbttoxru/L+WyZCTqCnPGablkTt
	 338cfs7qagn5Yz5moNWJ2JI3tMmh6LnBDqishSujJjP/0dK0jZz5uR9mXlqySGsH7NmAf
	 Dwe+LokQXz8veoSaTN+DF0A3U5hRp8igYk1nlaDxUZHwCumhQjHoulepiEGsmbtW3YPyG
	 D/BjGQyxD3m4zPB3CVT4zVKSixMQI947HkLpG3/2S33j2sHljMy9czu1bHu5ET0VHmhBN
	 K7mXITv61hovDsw9BgVxqTkGqraRwTgIgVjYfDmgGjEKBVGtJALLUqY3ojyADkbrUUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7YgccpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F104606A31A;
	Wed, 28 Oct 2026 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7YgccpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7546B1F01825;
	Wed, 28 Oct 2026 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210766;
	bh=8FO8qZ9gARGDgK3w5w2rU+iPtfOgPtkf6Geza2EirgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7YgccpTM+ryFTYWVhrxBSVe19VfMRKBR+bpxTf5QYk0YZVpFCcEnSNd5dmXikC5x
	 DOux3gIOpLkCSeL7Z0nFiXjyAjSIgFcZo1LHwRo9Tcs/xYIqzBmgAy54y2m/3ESjdJ
	 Uy0P8x6KCaIX770yop4406UHAJ+2gblD2HE5m0uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 142/571] sctp: check RCV_SHUTDOWN after the sendmsg connect wait
Date: Wed, 28 Oct 2026 17:54:49 +0100
Message-ID: <20261028170011.385311203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -1844,7 +1844,7 @@ static int sctp_sendmsg_to_asoc(struct s
 		if (asoc->ep->intl_enable) {
 			timeo = sock_sndtimeo(sk, 0);
 			err = sctp_wait_for_connect(asoc, &timeo);
-			if (err) {
+			if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
 				err = -ESRCH;
 				goto err;
 			}


