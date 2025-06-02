Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50AD1FBC8C;
	Mon,  2 Jun 2025 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873156; cv=none; b=sazU4zfjZmDmjdNfvVgNPsFCynPdsiwLRLWmOXuNROQzRersnlKRJxU6z3aOpGPTgWFO3sbokNYQahKU463Ul8nNtZ42Dku37V3XXKU+yIB+uhQ3tATtO7m4kCW6nc0f0u79dFUEBYWYQiZKFQFkimDM0LmquCFpdkzIQQ5fohA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873156; c=relaxed/simple;
	bh=SPkRKiXJhLA8fNo8fhO8Ipa3hJa0JYvO2SrAPKP5QQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKpGhwxRu+rOK72jgQhE6kZXbIQgupOUDlQHp4qOtb6UqbceFvNKF7F5JpM32ptDbj74hjhU+ubTD4xeDtgqT8VYvQZ74q/+u+GFo+x5wPe0pYjBe5A2gWZNPF1R9qbCcey2A+afgKxszRHqkuyAWu/D0oVSJsn03lHRSYFDxvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvOINXe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvOINXe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62CFC4CEF0;
	Mon,  2 Jun 2025 14:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873156;
	bh=SPkRKiXJhLA8fNo8fhO8Ipa3hJa0JYvO2SrAPKP5QQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvOINXe5qvwq7/eaOdatStZ+jtA0pJVvb/Bl0CsK/KgxpPVnn/IeJrAiTZ9Wzdl2s
	 wo1TK9EjHgoO7/Kp40Iyug4spmYFvmd55THn63w2E9RmeFQ9VJK4rZhkczFXQ7P9KL
	 DW8Wq4PfgHB5oBdDuT0SjgjKK7iRF0wVe8R6GbAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/444] SUNRPC: rpcbind should never reset the port to the value 0
Date: Mon,  2 Jun 2025 15:42:00 +0200
Message-ID: <20250602134343.199929464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 214c13e380ad7636631279f426387f9c4e3c14d9 ]

If we already had a valid port number for the RPC service, then we
should not allow the rpcbind client to set it to the invalid value '0'.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/rpcb_clnt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 102c3818bc54d..53bcca365fb1c 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -820,9 +820,10 @@ static void rpcb_getport_done(struct rpc_task *child, void *data)
 	}
 
 	trace_rpcb_setport(child, map->r_status, map->r_port);
-	xprt->ops->set_port(xprt, map->r_port);
-	if (map->r_port)
+	if (map->r_port) {
+		xprt->ops->set_port(xprt, map->r_port);
 		xprt_set_bound(xprt);
+	}
 }
 
 /*
-- 
2.39.5



