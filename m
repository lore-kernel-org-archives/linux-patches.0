Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3973173336;
	Wed,  3 Jul 2024 10:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004039; cv=none; b=ofOSq/Ytr3HGUgH0I+eij/UEujPCvvX392f42HKoJ7QhSrffxLQkK1jybKL521BtZ0RCqBURhHcWar8C1YLTqtUO75oHAR7Sq0twh9hJelz3KX6l7/oYjP+w63/fJu7q30wPVU3Baw3kpv6VzzHqGLzOUHh1HFNGUXeynRzdxto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004039; c=relaxed/simple;
	bh=YwIcw2hFws2N+2nG7kY1n2oyv7SleyoyV/toWEAjNZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MI1Ioxd5kp7i71mCUn16/gtXAqN/dTu7OtC8ez++9V35t/RCo7Ke4ThwEW71PudBDitnFYQX7zK3RVrtTVixdEOmA0M8jJoPikoA2KUpBsBWiBPkyCcUyKBQfJylKhahQHJI7CzYsfDq06i6niWCXRyNUL5vMTNClzxVhpYsPlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkSu5Rx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkSu5Rx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65455C2BD10;
	Wed,  3 Jul 2024 10:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004038;
	bh=YwIcw2hFws2N+2nG7kY1n2oyv7SleyoyV/toWEAjNZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkSu5Rx5j/sgqW5a6VSjRQtSo5x2NrW2qTz1/n5zV5mHOIfg3vIS171AD1AbPCwKG
	 eLT3GMWYdU7+rQd2HNPts6ez4+XQ+KUKewhbwNMQn544MphZCU6tq2RE5T4i1e0p7X
	 rH2CbcqJrCHo/fnn5OwnJQyRNJrhaZ+uiVvXGFBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d327a1f3b12e1e206c16@syzkaller.appspotmail.com,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/189] netrom: Fix a memory leak in nr_heartbeat_expiry()
Date: Wed,  3 Jul 2024 12:39:25 +0200
Message-ID: <20240703102845.429156524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



