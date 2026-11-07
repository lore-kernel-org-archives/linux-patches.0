Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063460;
	b=S5cimH16CExW/CrzooV/B2Z6L6M7pzfzf8Hn2YZIqksNMPl/TntUD8HmsN9XMZBSH2at
	 gMBlx21pAMzzc4zMqaeLNJzcqVsVRCZV+Z3kJsc58664gisSVl+WDjlsL+agaYdYvESAm
	 /eD789FP7lPYcTF9xNsn2JAiXHLy0YvPmTguwkkyghxGoUUI/3iRPVX0Jus5pL9rUemKn
	 oZQ+kgsBUmKKlM1/9rpcpSilShRBikUOLGlXh6F+rlH/NAY29ppmupchFaxWTQei1iVBu
	 0D3IjAI6Jr2wvb5tiecXH7z4uM3tUOIkag6Wdp/SZDpZM6G9u04aVAsOcUZKrkRo0BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0qwuyJtQ3+MoOM8cHOOuCTM9Ffq+4bkjXtFE+dyCXos=;
	b=vuPcINIQalzN9xUPIkhQgwnE9Zo1gbZI6u7i5+M2mDun6MiO2jLIw0bZpj6/16pgPu8E
	 Jc0St2XH4ECH4nNQFgsb69PY/YFZ+qqqg5jV4XytSKWSUJzAVy78+fiDIU4YFxSGz4Orp
	 sxWyUuEFy1n3gP2IlETXB4+E4WOF8uKHmAmxd+JGK++eZWHNBhILw07SL5KkWXKUQVUxf
	 0Fo7s35llmp8FfsFJEJuz/pbGMA5tmMQtAyPySPgN/vLpoLGdn27TeGPwbWI9HNi3P8at
	 aDUdMaxMfF+LE+VdH4MjflKDwjWq3NLA4jcdyNwqv3HrVWG8JiejYHx9/XHYFxrdcaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oOx7yM9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326B960A6F46;
	Sat,  7 Nov 2026 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oOx7yM9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B791F008A3;
	Sat,  7 Nov 2026 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063459;
	bh=0qwuyJtQ3+MoOM8cHOOuCTM9Ffq+4bkjXtFE+dyCXos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOx7yM9DeFsGIEolwHmFvwO1OXlhsfmca7ahtSlnLcQoNlL5faFBd8iGCBCBV5p5M
	 GwJ9Up+o+fKcSLYYEseF+inVEgLPgvZ8K6S674+YjBuE6yZS0qW3/jeONzDFCHfZkA
	 OWoRHVibO7Q580LVo9sBJeopzlUUSg281Ha4O2xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanye Yang <quanyeyang@proton.me>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 616/869] mptcp: reset msk state on early connect failure
Date: Sat,  7 Nov 2026 08:54:58 -0500
Message-ID: <20261107134913.940767577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit 29afe67082b2d33ab2e90c56c337235d725f023f ]

mptcp_connect() can fall back before the subflow SYN is sent, for
example when the netns is in an MPTCP blackhole, token allocation fails,
or MD5SIG is in use. If the subsequent subflow connect() fails
immediately (EAFNOSUPPORT, ENETUNREACH, ...), __inet_stream_connect()
returns while the socket is still SS_UNCONNECTED and never calls
->disconnect(). This was reported by Clashiko [1].

The error path only dropped the token and moved the msk back to
TCP_CLOSE. MPTCP_FALLBACK_DONE, allow_subflows and
request_mptcp were left as after early fallback, so a later
connect() on the same fd stayed TCP-only.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/633 [1]
Fixes: 0235d075a592 ("mptcp: mark as fallback even early ones")
Cc: stable@vger.kernel.org
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-mptcp-misc-fixes-7-3-rc8-v1-1-932c9b182fc7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e14a49180eefe..df09dcfd15ce3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3921,9 +3921,16 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * subflow_finish_connect()
 	 */
 	if (unlikely(err)) {
-		/* avoid leaving a dangling token in an unconnected socket */
 		mptcp_token_destroy(msk);
 		mptcp_set_state(sk, TCP_CLOSE);
+
+		spin_lock_bh(&msk->fallback_lock);
+		msk->allow_subflows = true;
+		msk->allow_infinite_fallback = true;
+		clear_bit(MPTCP_FALLBACK_DONE, &msk->flags);
+		spin_unlock_bh(&msk->fallback_lock);
+
+		mptcp_subflow_ctx_reset(mptcp_subflow_ctx(ssk));
 		return err;
 	}
 
-- 
2.53.0



