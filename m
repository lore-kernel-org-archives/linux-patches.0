Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705255;
	b=A+lRxkF+Xl05l488RLvRyD9I/F2bw7kBwq4mdg+9yZcWKlF6UBbZgEGYrlrgyyb+rPdg
	 3uJt3we/unm/CIbEPEbBf3UmsAmMR1j1zsszAvsag+3s9kbneUxO2/VdQtD2a4tsUgguN
	 kKQCWzU05d7IwqGBjXgR9Nitjt+9lrSHmiyjMaQEPxc8flaswMgqHIPT5jJ4PbIYOGy/5
	 vTzoFP+qnXQfdvVKrgPiw3QrK6jA2Qli54gB5VSTni8Atprp8uX4vSbpdiV/dJ0IUPU25
	 RQnVDTSYPbqYdbdUD6Su1yn91VPJzenHlGo+y/ZXmcA//XFaD6T5hR5F7rHIwYTZTxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3uhCCHCCns9XNbV6g70q2H6DnHVa80ckzUv2KH1Yfz8=;
	b=0gnTjhW6IsE98vij6vMFRNQx8vZKk6o7gZUnmu/8ra/uYdxZJs/vNjsnXcDJMaGDBTgL
	 tkHy13PKuilRbBmnTbmidQIvb5mAJj5MbkZsI/uGiaO5LpLkMmKTVT2c5gx09x17IwdNZ
	 vKAYgUnc9zkMS6qwhW+Qum7OPFEbZnglLdV31dp4q5XUOsaCGaOZkBWgTKlY/jIaHjF1v
	 Fp7ptcRJXW2sIST6OK2xbcXJNtG+midJruTt87SKkA1uMXXMZGw3xkbAjxICABVxL7SEu
	 IQvc6UDmQ+LudQG6LEvwVeOGaUwcVuW8J4vYgLxfC3IfGltyA58y4Yr5MtdWPKRYHnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z2JwDgeb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332F606A321;
	Thu, 26 Nov 2026 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z2JwDgeb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DD81F000C4;
	Thu, 26 Nov 2026 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705255;
	bh=3uhCCHCCns9XNbV6g70q2H6DnHVa80ckzUv2KH1Yfz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2JwDgebCsmKl0SX3ecf6rdCNO2pA1xzLqlUplwJT2nddkkXwChgQbDCpBB0rPdfV
	 XgDFX+Iif+3xiXNUF1BjrdL0DnRGYc3NKoZZLnfSetTfQjGcp+LAwWhwb7dHo8uEsA
	 ZROcYGmR+RyVaXjJLIBJKP9xRBlG2kpFiM0N4Q6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/319] SUNRPC: preserve timeout policy when cloning clients
Date: Thu, 26 Nov 2026 15:38:26 +0100
Message-ID: <20261126144009.860484545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 5b0ac1f82201c2ab2d9c31ed568cc782bac6a399 ]

rpc_clone_client() and rpc_clone_client_set_auth() leave the
timeout argument unset, causing rpc_new_client() to use the
transport defaults instead of the parent's configured
timeout. This also affects pNFS data-server clients and
changes their request timeout and initial RTT calculations.

Use the parent's cl_timeout when no timeout is specified.
Preserve explicitly supplied timeout overrides.

Fixes: 1b63a75180c6 ("SUNRPC: Refactor rpc_clone_client()")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 48ffdd4192538..de2d24a16087e 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -638,6 +638,8 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	}
 	args->servername = xprt->servername;
 	args->nodename = clnt->cl_nodename;
+	if (!args->timeout)
+		args->timeout = clnt->cl_timeout;
 
 	new = rpc_new_client(args, xps, xprt, clnt);
 	if (IS_ERR(new))
-- 
2.53.0



