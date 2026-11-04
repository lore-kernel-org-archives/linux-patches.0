Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829144;
	b=jbw4KvHzo+cQMfTB0teRDlF7KjyPo/7ZMxKTzYjdJQ3OcI+JIZgOxO6h44Z9iw1CUeHa
	 DU1LZESLu7gGCSpJ5big+nh19+7dS/5IpAHmjQrCmqrflHvYi2h/7mv7qV+s9sb1mlryy
	 vyNMld5XFbMCTwwsKNX+BjHfS/g36/i1zYZvDVjV2qBHsa+orIPszuTrhPqFxzwTNSMPK
	 4BoIvyFFy2cpxivpC4SMdLJq0wOlK7HtBEzeIYK3bhu55Sq8cr42hBVnBtM3hXm4MglQp
	 Cz6mpGu1JiTMmXdPuHFrHyH8Zn8JMwlXT5nt/sPW6Jo9DCOqi98SzmcuW9FeUUMFtZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MQ81KAnpzUblvOcC+94EFguBBLsSFP+yZ5X8NYHQnM8=;
	b=V/j9ZmT42qk/yosawLiQD0j88ykiwJMbM8XVIgliPOusMdDq4og+aodbQxjj2lA446ms
	 2lPSB3ZRXSFQAd33DW6wf0BmKyKJQFDBObKWtctxbSZbnH+gLx1h35HkkM/T+cAQQYE0U
	 gAB4dDhdzeVv+PQVeSkAu7X5zg1JN2dD7x6sK8qc2a6Si92xxDkTPGFY4Zhm8PdeHazTS
	 ATTHyGwJErdktTJaAF2aN2xiDlmySc9lS00mvPo98f82PnBB2qRb7CMDOAwww5Uf23SXA
	 0WcjwWTVxkTWZ/AZYvhgQ/Kis4Xrdk7NR8D17nb+8QUhhOZ8xyLdL4cOMQLDLNhQSYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbZze3oz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04D2607031A;
	Wed,  4 Nov 2026 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbZze3oz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077401F000C1;
	Wed,  4 Nov 2026 21:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829144;
	bh=MQ81KAnpzUblvOcC+94EFguBBLsSFP+yZ5X8NYHQnM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbZze3ozA8GctpT7nSEDNoCr7O5TTVNjlDxUk0Bkve2fSGlO06jVlPwLKX7dS6hZ0
	 pn3fIjUUED2nrAah6EzoZg3jcOl6o3lCnImUru9zeRJInzkgmjOtsc3Qc16dUSJXy/
	 0lnGqHcENvBSfZMFtqPd6Y+uHFVOlT+vX7cxD39Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 436/547] SUNRPC: fix oversized GSS proxy token copy
Date: Wed,  4 Nov 2026 16:10:20 -0500
Message-ID: <20261104211050.734602985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 62319c2534b603b416fa2aa2f3ef18c311f75010 upstream.

gss_read_proxy_verf() allocates one page per token chunk, but it copies the
entire linear head of an RPC request into in_token->pages[0]. A UDP datagram
can leave more than PAGE_SIZE bytes in the linear head, so a large
RPCSEC_GSS INIT token overwrites following pages.

Copy the linear head in page-sized chunks before switching to the request
page array. The linear head itself can span multiple pages.

Fixes: 5866efa8cbfb ("SUNRPC: Fix svcauth_gss_proxy_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Assisted-by: Codex:gpt-5
Link: https://patch.msgid.link/20260910125120.3798995-1-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1085,10 +1085,11 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	length = min_t(unsigned int, inlen, (char *)xdr->end - (char *)xdr->p);
-	if (length)
-		memcpy(page_address(in_token->pages[0]), xdr->p, length);
+	for (to_offs = 0; to_offs < length; to_offs += PAGE_SIZE)
+		memcpy(page_address(in_token->pages[to_offs >> PAGE_SHIFT]),
+		       (char *)xdr->p + to_offs,
+		       min_t(unsigned int, length - to_offs, PAGE_SIZE));
 	inlen -= length;
-
 	to_offs = length;
 	from_offs = rqstp->rq_arg.page_base;
 	while (inlen) {


