Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624771;
	b=4W6uV52tS5tledPnxBqrMtq+XG9v4xC6QAZBtXVCPhg2BVemvUQeZ/ylvZ15/eDWHDkP
	 cVDFzDsdOg654mZZUsPNSHMOXx5NeDvdy2ArHn0perdmqvMzO2JxCqhZwmgA+S2ii7fjg
	 grVhfIbc8ZCbYCTk5+cx9SmzHBa1MDs6v48JaCMn3emgBB6pV5N2JZHRqugSGnffNnCBa
	 gaTJjdVzP1bCGD9X7eo3SBXS70DPZZyxddqakRBvjQ2MYUcWHGhcUluTW5CNZKMC/u/tQ
	 /XdSvYjEeQbwZUYavKmss66Vj715dkwS48C9OowMQtBjR7Er1ye+k505CvL1ONhLIRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HOq+dyO0A3DudCANgAaZQZDA8jalkGw2MxII/Eav16U=;
	b=F5mF3vsZM+OIxTE+fR+alVVZsNTHWDP6OQzxCYoZ3bN+2lATuiR3tZWgd45vuqJkXkDU
	 dJ91Avb4AZRkKC+M7/1VldpoQw0IgEPsfe+2GbPN1KKc50IbXq507fWf02UBrCFIFaiL9
	 Fiq5GCOf7H69+KwbEvCRN7KeMeyv1uHj7ZbyG3NgGXuD1ZKzMVGdjNc9gIlLW6z6fgwL0
	 3G3LGivQY1LUjx4efyylwvt3VC4W87yVw5CihWYiVe1p2K4mxJSy6UY4ZDExJm0q9P32c
	 mWnuMezAIj+Ts/0kpBGzDO+xK63b6c0Uy0OMNwUX944bhilDb4XR2b6OpIpeHDuIoFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jc/kitCE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90D2606A337;
	Wed, 25 Nov 2026 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jc/kitCE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA0A1F000C6;
	Wed, 25 Nov 2026 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624771;
	bh=HOq+dyO0A3DudCANgAaZQZDA8jalkGw2MxII/Eav16U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jc/kitCEeQDsgSd06SbLAesostb89cdG7SZK5ZG9t9A/94WKBMB8hPxDI0pxEQKYK
	 9PoUpVgKxIkmpuqiA2OrAgL+xv4+n4dvdcJ1IuETrgWmm/6uihVDGRWs2YWKAHhQrP
	 FKJTwV4jiJzsVoC5wY3waw+B0decOHoJJbsJ5l8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/816] SUNRPC: preserve timeout policy when cloning clients
Date: Wed, 25 Nov 2026 15:30:49 +0100
Message-ID: <20261125143856.172126909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f23a17ebd0391..bda5f8331b9fb 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -651,6 +651,8 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	}
 	args->servername = xprt->servername;
 	args->nodename = clnt->cl_nodename;
+	if (!args->timeout)
+		args->timeout = clnt->cl_timeout;
 
 	new = rpc_new_client(args, xps, xprt, clnt);
 	if (IS_ERR(new))
-- 
2.53.0



