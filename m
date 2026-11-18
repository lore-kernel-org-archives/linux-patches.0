Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036671;
	b=F4vGccSMlN/uDCesrCqgaO3rPXej6ofzQ4q6TiCI5rVAnS6TQ1Na1jg0qiCr59ra4Sug
	 dMStiG09lWds1dTHRHJgUdVu69P4W2UBSle34/ej4bxnM3zU56NavL8mNev5mwjgj8UPg
	 Ba613E4x8jZzgLDj69pDY0vnabQg4U4TOvqCUuakerP66R4bVwglgtS7zABA12AhFyUt6
	 8vsvTR5IJRQuOleXlSdKMtqQ/9tFeCos89VjULXMZF2vOD4oJ7bUll7X9PMG1UtRs8puP
	 o59QuspUa5R6zF+TgB31duQlvSSH2/QHgLhXFMxz+Tx8npjOF+uKxrv2jJ4rjBzvs0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E58r34CWScoteNkO7vieDSRm6v21dR75A7rZ2cu+JTA=;
	b=BIhAV4YMOkC4HPvdB9cQqGk/GVNbhKHgV0dSz01sRd2juM/BlTv5/dgSgOvs0YevxYxw
	 YoMGFuSMvJRyH3vsRQrVeXR+ulLEG0IJpt+cVjjLBY49cWLp7k6FGrzVumk2zO99zzENX
	 VjiMtX1XHbGl9lo4JZNhoBnt964CUFyWsBGdcgm+6/iokgQJAggr54Nmezzq4h6dsgjSy
	 gYXRg3fxZuvrai9HmvNPKMsxh978veDSnfaCjw/V6qMkFZhYEXLRJWPyvZp6pjyXffcAh
	 NVTxF2imEeQPtEL1WO5xouBmquiRgqpEg6h2eWrl70ZmK0kph1neT89tiR4kL7jmdvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZcqcf8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F04606A320;
	Wed, 18 Nov 2026 21:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZcqcf8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B121F000C4;
	Wed, 18 Nov 2026 21:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036671;
	bh=E58r34CWScoteNkO7vieDSRm6v21dR75A7rZ2cu+JTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZcqcf8pGeLIGZfqwfkExJ5GzNcMUNDao7qFB8IEAiN9xxmEQk7Ai4G+VXB3SoqbA
	 LIkIL18iB3fPQxs9ZoViVZAP5hdJnAo8FHatXmvFgT1jCjDXCTIH10AyBfqnsN8EJH
	 QTTaOK0CkqgNjwoZpAXtgMsI84YHDUUzZ78/nVC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanye Yang <quanyeyang@proton.me>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1142/3318] mptcp: reset msk state on early connect failure
Date: Wed, 18 Nov 2026 15:29:24 +0100
Message-ID: <20261118150354.327408417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7b08b5899ef39..331a10fc46eb5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3952,9 +3952,16 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
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



