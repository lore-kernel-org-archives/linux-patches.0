Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052DB3A9627;
	Tue, 16 Jun 2026 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632482; cv=none; b=bW9UakRlmSco4qmNDaC+Np9c0iKHbd0kx9Jflna1ka9GBLatlRe2gqpdUydUSiR586tLQFTgESP4fwfUs4DC0kxiZ8ZBaU0zXvr7heirdDJWQ2KJ8VBEkyFa9/1PVifl8jXowyHLMUDv+IGZYWwqw0uJ+lXtReyspLQ5niorJl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632482; c=relaxed/simple;
	bh=MzdlHS1dw1CQknE8HSvgJ9tKgKq7zl/2ItS5bcFxTHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZ+b6vGR23f68OaqFI8WkoruBlo3fiQzwMoX5nwa0gBflsaZMU8VffMv5topnJe4se0aRHICVEqPxbN9D/45Ry00YmHgoZcwze8hmWXhbwJiU//NI2r5q3JSR0KChWh5H5hbhGS4b9Y+vKpXr9oLIEmOZ35dSwDa9f59n1UiOKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcje19oJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcje19oJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69A91F000E9;
	Tue, 16 Jun 2026 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632480;
	bh=3tl7nkCekVTLjYQ8iCmD44Z49iWXI+DbLiIh1vvgTRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcje19oJ7hpo2FgpOflYKjQrKaC7ZoV3HC5HoYYm41JAQCdOEhMWJYY5DlGE07ohX
	 gHB/Xfhi/NOZ6Onv1zxK/8n8g3RJe7f6eQ2Ce1emhoGEMp8d2nlHN9/y1H8IMo2QXp
	 PgQUa83ZZ+wq0crqIIqQYTkvsRjSQpHZMgR2xytE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Tuller <lance@lance0.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 420/522] mptcp: fastclose msk when linger time is 0
Date: Tue, 16 Jun 2026 20:29:27 +0530
Message-ID: <20260616145145.648932248@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit f14d6e9c3678a067f304abba561e0c5446c7e845 ]

The SO_LINGER socket option has been supported for a while with MPTCP
sockets [1], but it didn't cause the equivalent of a TCP reset as
expected when enabled and its time was set to 0. This was causing some
behavioural differences with TCP where some connections were not
promptly stopped as expected.

To fix that, an extra condition is checked at close() time before
sending an MP_FASTCLOSE, the MPTCP equivalent of a TCP reset.

Note that backporting up to [1] will be difficult as more changes are
needed to be able to send MP_FASTCLOSE. It seems better to stop at [2],
which was supposed to already imitate TCP.

Validated with MPTCP packetdrill tests [3].

Fixes: 268b12387460 ("mptcp: setsockopt: support SO_LINGER") [1]
Fixes: d21f83485518 ("mptcp: use fastclose on more edge scenarios") [2]
Cc: stable@vger.kernel.org
Reported-by: Lance Tuller <lance@lance0.com>
Closes: https://github.com/lance0/xfr/pull/67
Link: https://github.com/multipath-tcp/packetdrill/pull/196 [3]
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260427-net-mptcp-misc-fixes-7-1-rc2-v1-3-7432b7f279fa@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ kept `mptcp_check_readable()` name and explicit `inet_sk_state_store(sk, TCP_CLOSE)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3158,7 +3158,8 @@ bool __mptcp_close(struct sock *sk, long
 		goto cleanup;
 	}
 
-	if (mptcp_check_readable(msk)) {
+	if (mptcp_check_readable(msk) ||
+	    (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime)) {
 		/* the msk has read data, do the MPTCP equivalent of TCP reset */
 		inet_sk_state_store(sk, TCP_CLOSE);
 		mptcp_do_fastclose(sk);


