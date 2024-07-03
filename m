Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E17817C7A2;
	Wed,  3 Jul 2024 11:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004726; cv=none; b=N+rj09ewJ3WE2nU2lXuUAaF0KuHewA/rXoDILtD/KRBwuresPMqo8+ivT/bmN7jJexKkExyfb5YBmzBwHppV0PBHWWrTKd8QwpqYqsLc8masBJHXzrgZub47j9LMIoeM/94zPbYV9mGzIymA4k3MWOiraOniGNflY0E8BS80pzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004726; c=relaxed/simple;
	bh=n0llrkMFPcMzxIAEf/RDZmGT9adqh21LPm/vgq4YZ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqRDajLjNSl6Q+VOoe/6S5oXmRkKWeTIdQbigqRDEKnO76aPRkJTa9GbR+X68FrEPu62xkCc4hqCFN6IbsmNBAm5YUBYGzgqjHRN5k2KTuqYuGrHTQ9aBGbsvyNIqBVyceWZIabh5+C61qCmAjYt4uY0US0iKQOArKc5CzSXXoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZQCJDmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZQCJDmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A02C2BD10;
	Wed,  3 Jul 2024 11:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004726;
	bh=n0llrkMFPcMzxIAEf/RDZmGT9adqh21LPm/vgq4YZ1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZQCJDmDMzAOlHjDqjsb0g+bkDEUIxGfRQvGrtUc6evpH5Qi79TYY0IIaDMfBv9mk
	 wHbKfv4VTR9/L8KtLDz+vdsXxFkKlXOXvUswcsnW4IApZjclGoNiw+arSGUQpUdlNU
	 HGqULlH9N2EO9lHwV+9/3htJbVy1ihz8Eeo2W9CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d327a1f3b12e1e206c16@syzkaller.appspotmail.com,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/290] netrom: Fix a memory leak in nr_heartbeat_expiry()
Date: Wed,  3 Jul 2024 12:38:40 +0200
Message-ID: <20240703102909.437467699@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit 0b9130247f3b6a1122478471ff0e014ea96bb735 ]

syzbot reported a memory leak in nr_create() [0].

Commit 409db27e3a2e ("netrom: Fix use-after-free of a listening socket.")
added sock_hold() to the nr_heartbeat_expiry() function, where
a) a socket has a SOCK_DESTROY flag or
b) a listening socket has a SOCK_DEAD flag.

But in the case "a," when the SOCK_DESTROY flag is set, the file descriptor
has already been closed and the nr_release() function has been called.
So it makes no sense to hold the reference count because no one will
call another nr_destroy_socket() and put it as in the case "b."

nr_connect
  nr_establish_data_link
    nr_start_heartbeat

nr_release
  switch (nr->state)
  case NR_STATE_3
    nr->state = NR_STATE_2
    sock_set_flag(sk, SOCK_DESTROY);

                        nr_rx_frame
                          nr_process_rx_frame
                            switch (nr->state)
                            case NR_STATE_2
                              nr_state2_machine()
                                nr_disconnect()
                                  nr_sk(sk)->state = NR_STATE_0
                                  sock_set_flag(sk, SOCK_DEAD)

                        nr_heartbeat_expiry
                          switch (nr->state)
                          case NR_STATE_0
                            if (sock_flag(sk, SOCK_DESTROY) ||
                               (sk->sk_state == TCP_LISTEN
                                 && sock_flag(sk, SOCK_DEAD)))
                               sock_hold()  // ( !!! )
                               nr_destroy_socket()

To fix the memory leak, let's call sock_hold() only for a listening socket.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with Syzkaller.

[0]: https://syzkaller.appspot.com/bug?extid=d327a1f3b12e1e206c16

Reported-by: syzbot+d327a1f3b12e1e206c16@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d327a1f3b12e1e206c16
Fixes: 409db27e3a2e ("netrom: Fix use-after-free of a listening socket.")
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netrom/nr_timer.c b/net/netrom/nr_timer.c
index 4e7c968cde2dc..5e3ca068f04e0 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -121,7 +121,8 @@ static void nr_heartbeat_expiry(struct timer_list *t)
 		   is accepted() it isn't 'dead' so doesn't get removed. */
 		if (sock_flag(sk, SOCK_DESTROY) ||
 		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
-			sock_hold(sk);
+			if (sk->sk_state == TCP_LISTEN)
+				sock_hold(sk);
 			bh_unlock_sock(sk);
 			nr_destroy_socket(sk);
 			goto out;
-- 
2.43.0



