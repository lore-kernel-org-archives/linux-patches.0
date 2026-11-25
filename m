Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621964;
	b=ZIOkmX797GR8T4pUvDa8kLTx9bRjn9/1HDJMjxPNt8c6fAMSVF6E2t+NGcLkFod8geyd
	 1XMLXDQ1jHPPjub5xcvOWnpbAcAsADnblZm9xH5mHGXuM85DDj9CljLvFpYe2jNd1CMAZ
	 Q7gb/V7LJtn7YY+Xnad/eX2RqrQJWPfxUFB+rAw6Iup1fAQZ41R9cAetes1ss1Kmdw8IS
	 llhMPZwCzHycOxQnx6gCSX0/3f4JryVfoIhL0HC2WEPLyBeB0k8m8k957zBQghqDXFMLr
	 5Nl4hgKZWaVfSvj2yqJW/xboPNBJkaHVEB6in+RjqnEtJ3A0S9lJ9/NpmM9h/eeTZUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3dWKfEWw98dEUD0RU2IxCNXnxQt2wstGWLF3urUL5I4=;
	b=lj1Zk3VIIGylmDCBsPQwMP/KxcimN5v5zJ8ekWHJAuuayiQfQOj72rK0tKTR+rOuynDx
	 3Q07l3FiOrm5d7Mnk35xtnqdbUvkweJq68hbqvJB/etRTmHzEcJAVGTEQmcSUnHvOega6
	 W9R3Nei3Z9JwR4Sc0AoVcnSJ64QxverMwT4mjLktBygHyMPW7tFRovHNgBY+IS7VrL3pM
	 Pzj0dKY9xOLedHJkEni3mSQ+D4nnURNf8DRojnkNVo5RxWPmUtwhXX89OMRaSpB2Gn3Ix
	 hStYx/VZJINdpda4ytT2W7dHYf2wGIGyae0hhDZzmBNyigq4K+BrmcgRiYMzlKroUlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ws73G3XE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE54E606A31E;
	Wed, 25 Nov 2026 15:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ws73G3XE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9AD1F000C0;
	Wed, 25 Nov 2026 15:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621963;
	bh=3dWKfEWw98dEUD0RU2IxCNXnxQt2wstGWLF3urUL5I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ws73G3XEIdaCPwPC+8dKFD4LCyyMwS7kp//fSbcFGvaT/SfeHiN0ZTrAiNDsTeXNq
	 R7kbBPp4s4gtwEzb20kGtFqH0uX3KKszQBhPw9qzHqZP3QjwyfrxRDS6ophZo2E7d/
	 Ex2FI7VDhXjooN4U6I0p0xFpHZ8BaZMpoZuYbyDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 386/990] SUNRPC: preserve timeout policy when cloning clients
Date: Wed, 25 Nov 2026 15:29:13 +0100
Message-ID: <20261125143831.132408149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index bb96cbaf02208..a234c9fedbdfd 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -653,6 +653,8 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	}
 	args->servername = xprt->servername;
 	args->nodename = clnt->cl_nodename;
+	if (!args->timeout)
+		args->timeout = clnt->cl_timeout;
 
 	new = rpc_new_client(args, xps, xprt, clnt);
 	if (IS_ERR(new))
-- 
2.53.0



