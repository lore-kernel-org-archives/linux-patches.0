Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77D61CFEA9;
	Tue, 15 Oct 2024 11:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993493; cv=none; b=TDeYS3LvdXhrK1LntNL8QU9GsatlkRrrCpZ4wcjkqBGc7xS9ILd6fTqbYiVQdXyx33FgQD8sWJontzJbX5UCfbS7UrEAzEFlsXcJ8uAAqoOEgBPIGlwT/t70PsNaZGx6BJ5hE8MJ2T04XMndlkrhYt23cFPVQvDJ9vCs43JEGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993493; c=relaxed/simple;
	bh=x68vgtp09PyDClyK+F5A83z6ZdTc+PtxyZ28GI9tnNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv93aWMGufWOqfiTQR5rZO1U4FewgJv9bcI91wvypTJTIniKvaeK0cX8bZX+apNcukgWiuuTVnyQuE7IVnhxn8CjKiUhD8uJDimubZHLoL0oJTFK03IU/UzMubNL13gKAHhMwBbwUpK/OgZcbf0uJkEd4B4PyYKkZYcoP1d6VkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxMnY5RP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxMnY5RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E06C4CEC6;
	Tue, 15 Oct 2024 11:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993493;
	bh=x68vgtp09PyDClyK+F5A83z6ZdTc+PtxyZ28GI9tnNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxMnY5RPIlkN7WtfgO+3Iqq6/Td4YmA67pPT6jWlfHvLzsJmlj31afT5++SezRW0V
	 T1DybXRwFF4IxY8NgxowNp5jGkOEoRCoZNmgxEkAsCes8GlWFAVGaGgQuBJRCBSEW1
	 L7Mu6yuvCjNQSfENEiEch5pOc3Tz0HJi6pYHwpYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jade Dong <jadedong@tencent.com>,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 429/691] tcp: avoid reusing FIN_WAIT2 when trying to find port in connect() process
Date: Tue, 15 Oct 2024 13:26:17 +0200
Message-ID: <20241015112457.369914602@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 0d9e5df4a257afc3a471a82961ace9a22b88295a ]

We found that one close-wait socket was reset by the other side
due to a new connection reusing the same port which is beyond our
expectation, so we have to investigate the underlying reason.

The following experiment is conducted in the test environment. We
limit the port range from 40000 to 40010 and delay the time to close()
after receiving a fin from the active close side, which can help us
easily reproduce like what happened in production.

Here are three connections captured by tcpdump:
127.0.0.1.40002 > 127.0.0.1.9999: Flags [S], seq 2965525191
127.0.0.1.9999 > 127.0.0.1.40002: Flags [S.], seq 2769915070
127.0.0.1.40002 > 127.0.0.1.9999: Flags [.], ack 1
127.0.0.1.40002 > 127.0.0.1.9999: Flags [F.], seq 1, ack 1
// a few seconds later, within 60 seconds
127.0.0.1.40002 > 127.0.0.1.9999: Flags [S], seq 2965590730
127.0.0.1.9999 > 127.0.0.1.40002: Flags [.], ack 2
127.0.0.1.40002 > 127.0.0.1.9999: Flags [R], seq 2965525193
// later, very quickly
127.0.0.1.40002 > 127.0.0.1.9999: Flags [S], seq 2965590730
127.0.0.1.9999 > 127.0.0.1.40002: Flags [S.], seq 3120990805
127.0.0.1.40002 > 127.0.0.1.9999: Flags [.], ack 1

As we can see, the first flow is reset because:
1) client starts a new connection, I mean, the second one
2) client tries to find a suitable port which is a timewait socket
   (its state is timewait, substate is fin_wait2)
3) client occupies that timewait port to send a SYN
4) server finds a corresponding close-wait socket in ehash table,
   then replies with a challenge ack
5) client sends an RST to terminate this old close-wait socket.

I don't think the port selection algo can choose a FIN_WAIT2 socket
when we turn on tcp_tw_reuse because on the server side there
remain unread data. In some cases, if one side haven't call close() yet,
we should not consider it as expendable and treat it at will.

Even though, sometimes, the server isn't able to call close() as soon
as possible like what we expect, it can not be terminated easily,
especially due to a second unrelated connection happening.

After this patch, we can see the expected failure if we start a
connection when all the ports are occupied in fin_wait2 state:
"Ncat: Cannot assign requested address."

Reported-by: Jade Dong <jadedong@tencent.com>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240823001152.31004-1-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 44a9fa957301b..43415de60d7f0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -113,6 +113,9 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 	const struct tcp_timewait_sock *tcptw = tcp_twsk(sktw);
 	struct tcp_sock *tp = tcp_sk(sk);
 
+	if (tw->tw_substate == TCP_FIN_WAIT2)
+		reuse = 0;
+
 	if (reuse == 2) {
 		/* Still does not detect *everything* that goes through
 		 * lo, since we require a loopback src or dst address
-- 
2.43.0



