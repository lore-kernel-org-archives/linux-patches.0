Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6820E1AE843;
	Wed, 20 Nov 2024 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107595; cv=none; b=U2y+Bh9H2ZzldDosk7QPh3LRo+EEVJq6llpzJCdLKURC/bnEk7mZiyV3VMkJWyEEbARt739ReIvgDNdMgTGyHk+CKWRbmZCKPYvkIGeC1Xtenm2ehkNFUoeP63G9gQXT+DBWNULJcOFR3DEfeQeEZu1cYXjI13zXmluPhkaFDxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107595; c=relaxed/simple;
	bh=UQulVs6SsxODkwYVWKlUF13lv/bG4SX3F8N4HV+rNj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Roy7H4MXpGjT+pJC84aF+cKjMohnTTlw63PbeqNxAwcD3J5myqpJMeTfj0GadEVT0hA8cV+q4GYBoP0y8MG1i6Gyy7EZdAEQk2LKcg6SeHkwH18zuroMs+wj8foDJe7TgDvB5WbLIHjUFfp+58Te2l3FGf8xIz9VV8fXKtFfBG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msO5GQIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msO5GQIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C8BC4CECD;
	Wed, 20 Nov 2024 12:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107595;
	bh=UQulVs6SsxODkwYVWKlUF13lv/bG4SX3F8N4HV+rNj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msO5GQIjHntunr7ow6q9jg1eA910vUdw4kUg+GtJLi4Ou5Grt+6yFfHn++AZWMLbR
	 X/GmToUo0fnR425rPK4XDM6cbczYQZC5mLlMEIySJJBrFdPQ5EBMSmVpmeZI6a4C7W
	 3uV2/GrPM4LK2PlYGZePEzBueK0lpHCknkJx5w/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/82] mptcp: cope racing subflow creation in mptcp_rcv_space_adjust
Date: Wed, 20 Nov 2024 13:56:16 +0100
Message-ID: <20241120125629.765330778@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit ce7356ae35943cc6494cc692e62d51a734062b7d ]

Additional active subflows - i.e. created by the in kernel path
manager - are included into the subflow list before starting the
3whs.

A racing recvmsg() spooling data received on an already established
subflow would unconditionally call tcp_cleanup_rbuf() on all the
current subflows, potentially hitting a divide by zero error on
the newly created ones.

Explicitly check that the subflow is in a suitable state before
invoking tcp_cleanup_rbuf().

Fixes: c76c6956566f ("mptcp: call tcp_cleanup_rbuf on subflows")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/02374660836e1b52afc91966b7535c8c5f7bafb0.1731060874.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e99ef1e67e957..b8357d7c6b3a1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2045,7 +2045,8 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 				slow = lock_sock_fast(ssk);
 				WRITE_ONCE(ssk->sk_rcvbuf, rcvbuf);
 				WRITE_ONCE(tcp_sk(ssk)->window_clamp, window_clamp);
-				tcp_cleanup_rbuf(ssk, 1);
+				if (tcp_can_send_ack(ssk))
+					tcp_cleanup_rbuf(ssk, 1);
 				unlock_sock_fast(ssk, slow);
 			}
 		}
-- 
2.43.0



