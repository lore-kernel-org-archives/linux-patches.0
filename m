Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054550;
	b=WoEj1hKYEzH9pAZ5Nq9PsDJQblbVY1wOzpCSlWedw51X7OPStJXrqsKuoI4zQuxZz5L9
	 xi3YrApcyt12UdVGtsmI05wszxcJxnrpyvJ8f4MypL/o3bh4eRt3zMTPX25Q0/ikQ4gKP
	 UFdR7+Jh26PnyGlGq+q/Y/6/DD9voEMdLK+DnAmOwmMCVY/PaCfnI/ZpwcX8qV7ZOpGJz
	 T8TOaJ/V47Wmyx9yd/g1qJLO/wmmneuNj9tsE37krOxRHJQVtbtMvyLl4W3ELCD+n0s/X
	 gQ+/dmGL1J10v6cOCsVwLfxTwx8xHZF5CyV59M9APGlzaL8NEtEnopl4FnTAxy0+fAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YuJloHZ23C6CQXuAF4hB5ipJcpu4wijoFN0hKZaiaC8=;
	b=BwOf9KO/mgJdqEcGWP+dJQyn7dahJvsTOzd8H3xhyaFtZIZFQS/UDD/t7GV3lToO4slG
	 ODqa9cqbSdcupOrSdVEb7iJj+80vZqtDXY4PWZ0XACj27h9JNclJ0Hbl2amSjgMWpmHVg
	 JxlgUFUy1mr7NZwYH8JFSQ2qWVzxDmx0Xt4pH0bz6ytIn8a6mUgcq97PQSe7W3i9oOG7c
	 ApQwIfIybbE/cqs1FgbYQBD/VzGsDM3bqQ/6oob4JO3QXtxp3Xv7X2U7ziMqiqgF4s8hM
	 4Nvy2O835w7mdYZs6ZUTB3T0QpeDJgbDelwTk7s0HQPnXcXDguNeLf741TQ602ENt8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksA1EkqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3019606A31C;
	Thu, 19 Nov 2026 02:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksA1EkqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C891F000C4;
	Thu, 19 Nov 2026 02:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054549;
	bh=YuJloHZ23C6CQXuAF4hB5ipJcpu4wijoFN0hKZaiaC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksA1EkqG9sfZj6g28B5bWWMGB6unjrJGMl9RATBSjjArXP5ylVG10BLtpTGkqmot8
	 ZttClSUXNlejGTTUjpPAomF3QYVe89ZtgkRONpdyWVCaneEUU2lKjsrF+QgMS4VgAv
	 E5RYBiEpoS4RR5wWpUHGTCuOWZwIo9nGRtoooV6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Chuck Lever <cel@kernel.org>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1314/2214] SUNRPC: Copy the deferred RPC Call from the head buffer
Date: Wed, 18 Nov 2026 15:49:50 +0100
Message-ID: <20261118150104.052705603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit 2192a56b0686599358909c3e12e9a366f5b5d452 upstream.

svc_defer() snapshots the RPC Call for replay once a pending cache
upcall resolves. It copies the Call starting (rq_arg.len -
head[0].iov_len) bytes before head[0].iov_base, a back-up that once
covered a transport header. No transport has had one since commit
983084b2672c ("SUNRPC: Remove svc_rqst::rq_xprt_hlen"), so the two
lengths are meant to be equal.

An RPCSEC_GSS Call breaks that assumption. Unwrapping the integrity
service truncates rq_arg.len by the length of the trailing checksum,
and unwrapping the privacy service leaves rq_arg.len short by an
amount the client sets with trailing bytes after the wrap token.
Neither adjusts head[0].iov_len. Both lengths are size_t, so the
subtraction underflows and the copy starts past head[0].iov_base.
Every deferred integrity Call replays a shifted snapshot.

A deferred replay skips GSS verification, so a shifted snapshot runs
as an authenticated Call. With the privacy service the offset is
client-chosen. A forged Call placed in that window, naming another
user's GSS context handle, runs under that identity.

Copy the Call from head[0].iov_base. Refuse to defer a Call whose
length runs past the head buffer, so the copy cannot read out of
bounds.

Fixes: 260c1d1298f6 ("svc: Add transport hdr size for defer/revisit")
Cc: stable@vger.kernel.org
Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Reported-by: Yilin Zhang <yilinzhang@moonshot.ai>
Link: https://patch.msgid.link/20260902133101.48914-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[doebel: 5.15 backport. In this tree the RPC Call header is parsed
 with svc_getnl(), which advances rq_arg.head[0].iov_base while
 rq_arg.len keeps measuring from the start of the receive buffer, so
 len > head[0].iov_len for every Call at svc_defer() time and the
 upstream guard and copy-from-iov_base cannot apply; keep the
 skip-based snapshot that svc_deferred_recv() expects. A GSS privacy
 unwrap breaks the len - iov_len invariant by resetting rq_arg.len
 (gss_unwrap_kerberos_v2()); refuse to defer after a GSS
 integrity/privacy unwrap (rq_auth_slack != 0) or when
 len < head[0].iov_len.]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc_xprt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 59f88a15ca455..ef957c41c6f79 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1224,6 +1224,20 @@ static struct cache_deferred_req *svc_defer(struct cache_req *req)
 	} else {
 		size_t skip;
 		size_t size;
+
+		/*
+		 * A GSS integrity/privacy unwrap can reset rq_arg.len so
+		 * it no longer measures from the start of the receive
+		 * buffer (see gss_unwrap_kerberos_v2()). In that state
+		 * len - iov_len does not locate the buffer start, and a
+		 * snapshot taken here would be replayed without GSS
+		 * verification. Refuse to defer; the caller fails the
+		 * request and the client retries.
+		 */
+		if (rqstp->rq_auth_slack ||
+		    rqstp->rq_arg.len < rqstp->rq_arg.head[0].iov_len)
+			return NULL;
+
 		/* FIXME maybe discard if size too large */
 		size = sizeof(struct svc_deferred_req) + rqstp->rq_arg.len;
 		dr = kmalloc(size, GFP_KERNEL);
-- 
2.53.0



