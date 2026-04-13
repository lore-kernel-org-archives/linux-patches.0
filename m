Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B122C29D27A;
	Mon, 13 Apr 2026 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097738; cv=none; b=tsIjTHGi3e8b4n+jlNlqGjQwR34Vpys885mWrSmAyPuO7u9oxZk6oXEFKlQp5OPy4EO//HbBM2iFWw4WZjTHBVuVd2EBJMdgkLvLdI1aOPW1WpDIQ6OICDXkr5mHTokoM0qWtzvOWzACGg41NasNOpSaY9Y1Q8NiudH4rWyhB3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097738; c=relaxed/simple;
	bh=AIb3bK47fgl0ePukb+sMUXobAEeD6BfJB89u+nAnHQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAYbDajwrn33wuFw665SHTOTEf6gVB9hUqdlLkYvn2vfWoaZ7Uc8nNiectdvPJ54MEMoTawSTBLnoZQv+vrTGQkKA5cnvVAzvCJRrWYj7P2nxmDvOaj/EYJI7kuBGEHAzkQ1SPksbQm6ZsuISk4+SA8Jeb4pSyNQoIEqUj5DprE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04wOMS3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04wOMS3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478EFC2BCAF;
	Mon, 13 Apr 2026 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097738;
	bh=AIb3bK47fgl0ePukb+sMUXobAEeD6BfJB89u+nAnHQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04wOMS3xdisDV0pr0YmcPEmM9X7DExVf7B6GIcimj4QlGeWXaLc/2+5mEkyMuK0td
	 E/qvaqCIki551UuVeTy8zNB/RnO87iOHk4yFjIWN1u2u0LbwBAsLbDsh4E/giO9L5U
	 ZREbkervSXh8zbJEj0P7qaT4qFL2f+cBGqDhijHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d00f90e0af54102fb271@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/570] net/rose: fix NULL pointer dereference in rose_transmit_link on reconnect
Date: Mon, 13 Apr 2026 17:56:24 +0200
Message-ID: <20260413155839.943405726@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit e1f0a18c9564cdb16523c802e2c6fe5874e3d944 ]

syzkaller reported a bug [1], and the reproducer is available at [2].

ROSE sockets use four sk->sk_state values: TCP_CLOSE, TCP_LISTEN,
TCP_SYN_SENT, and TCP_ESTABLISHED. rose_connect() already rejects
calls for TCP_ESTABLISHED (-EISCONN) and TCP_CLOSE with SS_CONNECTING
(-ECONNREFUSED), but lacks a check for TCP_SYN_SENT.

When rose_connect() is called a second time while the first connection
attempt is still in progress (TCP_SYN_SENT), it overwrites
rose->neighbour via rose_get_neigh(). If that returns NULL, the socket
is left with rose->state == ROSE_STATE_1 but rose->neighbour == NULL.
When the socket is subsequently closed, rose_release() sees
ROSE_STATE_1 and calls rose_write_internal() ->
rose_transmit_link(skb, NULL), causing a NULL pointer dereference.

Per connect(2), a second connect() while a connection is already in
progress should return -EALREADY. Add this missing check for
TCP_SYN_SENT to complete the state validation in rose_connect().

[1] https://syzkaller.appspot.com/bug?extid=d00f90e0af54102fb271
[2] https://gist.github.com/mrpre/9e6779e0d13e2c66779b1653fef80516

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+d00f90e0af54102fb271@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69694d6f.050a0220.58bed.0027.GAE@google.com/T/
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260311070611.76913-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 04173c85d92b5..0130c13f73552 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -808,6 +808,11 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 		goto out_release;
 	}
 
+	if (sk->sk_state == TCP_SYN_SENT) {
+		err = -EALREADY;
+		goto out_release;
+	}
+
 	sk->sk_state   = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
-- 
2.51.0



