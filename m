Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045956;
	b=ElPMKZmn7M9AZlTa0A5zP1i9CZwg5g0VgBac6SLGs9wY2DXtm1wQt7QejRc4NViWEYha
	 wGbpj1rqOfFcCA4/MmP3AAcZm5ZML9JqNshmCQezn8jbRk+0MaQ4Pw/b7LAxa3gOUPLmK
	 rirXEuknBqRCLlVFa0u7GI96CGrQMg3/r3g3gfA7aQGTYrTLZzme+dMNiBXewdamg7tnG
	 pdkHL7aNYlPv+GR18IrQESnCKHDYLTFeEFrgpNoG8h5de5Fr6HpYeHJv1tLZ2blCG4h+9
	 f8fnmSY53jQuEKLVglaBgaPENqX2dqwe4rNkt8LnS1I7sUEGLaItykbTvau9zeCYc0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pGPMoxkPiVMF6yv0FOEmAuyKq0ebkQ6kmur7vNvVa0Q=;
	b=TR/5Rp6htNZQuHBnfaXy+mV9CgT9pIkSaJCTSf25bn+UkT7ZQlytju0fx5i+viNXgjSl
	 Zw8fsJS2CwDqmp5nbu8d03GW3QjjJTP6VbrFTuCqmHLS+vsKnYVxietA1LiA7eLLp+bWf
	 Vr5yzNLfLD3pZh/lejy+nMR+JfJltH/OVYjhBrc7GIoyWa+42EnHf+Av9eCIWZpymLh+l
	 opqhSWMBVhIahyfxQdEKtrWUNy6MP8+Beaqbj2d1fDnXgkn6rMMztKh1Lbe5qSpe15lyT
	 y8ybbcQ4OiVPr1ymILWfaNFxEsxCyBuvuX61MwbICBaSLY4xbev21CmZuD3yC+eN1/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jOA8lxPu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FDE606A31C;
	Wed, 18 Nov 2026 23:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jOA8lxPu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF36B1F000C4;
	Wed, 18 Nov 2026 23:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045956;
	bh=pGPMoxkPiVMF6yv0FOEmAuyKq0ebkQ6kmur7vNvVa0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOA8lxPu2q9PSfPNv0w1aJTFtmcq24p3YZjhdxxUSBhOes/mu9X4HNxVrfZTrnNRk
	 WOlkH0iED4NTZLI/YHJVa1S7i3wOVfcHYF5XPKVlZe5qgGLWZU0rk4nUq2Go7WC+yV
	 Ixm2MSB8PDKWR7PrjzW4G3w8uCwdQlgDY6CJvFYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1108/2857] SUNRPC: fix oversized GSS proxy token copy
Date: Wed, 18 Nov 2026 15:35:42 +0100
Message-ID: <20261118150241.528183052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 62319c2534b603b416fa2aa2f3ef18c311f75010 ]

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
[ sashal: adapted XDR stream cursor access to the existing argv->iov_base and argv->iov_len fields. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 01b49960915b4..5ae15e3b40094 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1185,10 +1185,11 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 	}
 
 	length = min_t(unsigned int, inlen, argv->iov_len);
-	if (length)
-		memcpy(page_address(in_token->pages[0]), argv->iov_base, length);
+	for (to_offs = 0; to_offs < length; to_offs += PAGE_SIZE)
+		memcpy(page_address(in_token->pages[to_offs >> PAGE_SHIFT]),
+		       (char *)argv->iov_base + to_offs,
+		       min_t(unsigned int, length - to_offs, PAGE_SIZE));
 	inlen -= length;
-
 	to_offs = length;
 	from_offs = rqstp->rq_arg.page_base;
 	while (inlen) {
-- 
2.53.0



