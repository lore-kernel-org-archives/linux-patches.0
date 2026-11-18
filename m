Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019766;
	b=XkmT5yUnP5/7WxnJK0z39CP0/jFSXDwj2l1v+7mOu5ZAwnxj8lj07+lHBpw/zwLkR4mq
	 eA39IrIMREuCaKeT4bQMebmRh7kCVhP84zVMjEdwobxT/opEXgXP2K5GlFh2XLCDySPE8
	 AvZft1UD++OWrWVfrOdaITT8DXAFwYp5FupeQvsvs7BS0KR9ubnGNwZ1al9B0Axyd2jUl
	 jIYGwyWHsgafYbQHqM8ulWYVkNSSbCsE9bogGE+mM4/CXwBNlhBvhGHi5SsIwbIzVZ6Qj
	 h+yoWciLNZ9I+v180S+w840QdcnZVRp+jCYWJR0gjJGsL9hKIMIyHyJRqjAK3GAkaGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0d92w0/8b9EbcavtdqjXwaJpSI1S93zSrw9aZWfYhHU=;
	b=senSYh072tG9GMcYzdBN9xkOzh/x8a8sKrPqzPXN4574wkL02qi33DCHTmawlpreheK3
	 a6XNukc6dYNM1g+EZfLE/iaIf2lVa9GUntDyi3PqRcsa+1wHodS2Tqv+dW/sNMllBhUWG
	 r6UNX+dbgH98o8nnTngx6A/ytQMeUrkjZixsZ+IJYEmdg2BKEnimOIoaU20iHqBwMhBPZ
	 os1peA0Oo4XwTyhJb5j+7NqSIf7Mu+W+nb5A4lAywvEz9nAZQ89BOlsb5XNH9nzAOclq2
	 Nl0mE9wsjYGhANFLTLn9b81eoDjX78atQut4T6mLzKxRIx8C5ND19HQh5wnEsLX2F7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsegO+Pc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915FA606A320;
	Wed, 18 Nov 2026 16:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsegO+Pc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6ED1F000C4;
	Wed, 18 Nov 2026 16:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019766;
	bh=0d92w0/8b9EbcavtdqjXwaJpSI1S93zSrw9aZWfYhHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsegO+PcXJ0p6Pirklbu4d1lgna1XFQSbkFpx+PBFHx2FkE3Tu/nS8T8c5anJwJVR
	 5wZRHNKviNIvJiCpA9c8vBFk1yIuFZlwUxiASn3ncAm6w+P48O7jknpW4kq7U7HXGn
	 tb/qWpqqGfSt7BaqRW1hCRyMvb/s6zLVprB1nLKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1714/2651] tcp_cubic: fix divide by zero and endless loop on bad module params
Date: Wed, 18 Nov 2026 15:49:14 +0100
Message-ID: <20261118150349.338023983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 7d52b5d16afc1cf8484ae321658e217a80e3ff4d ]

beta_scale and cube_factor are computed once at module init, and
beta == 1024 or bic_scale == 0 is a divide by zero right there. Other
out of range values give garbage: negative beta can make beta_scale 0,
and bic_scale * 10 can overflow. Reject them. Read beta once, as it
can be written through sysfs before the init function runs.

A small beta also gives a small beta_scale, and (cwnd * beta_scale) >> 3
truncates to 0 for a tiny cwnd, so the TCP friendliness loop never
ends. Rather than testing delta on every ACK, make sure beta_scale is
at least 8 at init, so delta is >= 1 within the cwnd < 1 million
packets limit this code is designed for. This slows the TCP friendly
estimate for beta < 512, a backoff harder than Reno's 0.5, which is
not a setting anyone should use.

Fixes: df3271f3361b ("[TCP] BIC: CUBIC window growth (2.0)")
Suggested-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261008092641.140777-4-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_cubic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 119bf8cbb007c..a88e4bf86150f 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -500,16 +500,26 @@ static const struct btf_kfunc_id_set tcp_cubic_kfunc_set = {
 
 static int __init cubictcp_register(void)
 {
+	int b = READ_ONCE(beta);
 	int ret;
 
 	BUILD_BUG_ON(sizeof(struct bictcp) > ICSK_CA_PRIV_SIZE);
 
+	if (b < 0 || b >= BICTCP_BETA_SCALE ||
+	    bic_scale <= 0 || bic_scale > INT_MAX / 10) {
+		pr_err("tcp_cubic: invalid beta %d or bic_scale %d\n",
+		       b, bic_scale);
+		return -EINVAL;
+	}
+
 	/* Precompute a bunch of the scaling factors that are used per-packet
 	 * based on SRTT of 100ms
 	 */
 
-	beta_scale = 8*(BICTCP_BETA_SCALE+beta) / 3
-		/ (BICTCP_BETA_SCALE - beta);
+	beta_scale = 8 * (BICTCP_BETA_SCALE + b) / 3
+		/ (BICTCP_BETA_SCALE - b);
+	/* bictcp_update() needs (cwnd * beta_scale) >> 3 to be >= 1 */
+	beta_scale = max(beta_scale, 8U);
 
 	cube_rtt_scale = (bic_scale * 10);	/* 1024*c/rtt */
 
-- 
2.53.0



