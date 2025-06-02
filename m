Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B491C84DC;
	Mon,  2 Jun 2025 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876675; cv=none; b=B3YyxpdN7ACj8hfieF7YhIh5mKH0fSd1GI7aNnENSavwi3+ZD33sXcpdG1mQmb7YXSOduibUykpHpOOQGpkXOTZkNhnnxrBN54ivAwoE9eXkd2geD5wzq8NjpTtWGAjrVG/xrShxYguVUGp0U3nLwbdn88ME5mtccLAeoJ9Lgmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876675; c=relaxed/simple;
	bh=lyJR2MCoFbjRabnQtuFHa7CZD8YbIGt6XAWt2EW3818=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdmOH4F7k2uJ6Gd+8Wh3XZmgOdYYYTO3FgqYNmTz+gKKNo6HBLHr04icsRECpqjq/saBUwgZHlGD2RCGY2nXmGd5gmnP3ZOoK0x+EbuGq38//r3nb87sljPPdEeQXprwsiSAr01OJBJhyFiFPUvkGYeNAhFResTL85IL3KUn2Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWx13I2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWx13I2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296EBC4CEEB;
	Mon,  2 Jun 2025 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876675;
	bh=lyJR2MCoFbjRabnQtuFHa7CZD8YbIGt6XAWt2EW3818=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWx13I2U9SXa5RiF+bal54E1EdCR+l4xOlMcfEPjqoJ4B6Q1wSmhg2VqSfuK3HVsX
	 QP4MUChxBmN4V1xnIwq4XuzZRorz5Bbzsp7bxNKHKmAp129Qm+fI+BFn0wT/Hsa/Lu
	 sQbxNah5FaCSH2pUHVyV1FjHq8x2ybxUm1tslwSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/325] SUNRPC: rpcbind should never reset the port to the value 0
Date: Mon,  2 Jun 2025 15:45:13 +0200
Message-ID: <20250602134321.264981747@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 82afb56695f8d..1ec20163a0b7d 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -797,9 +797,10 @@ static void rpcb_getport_done(struct rpc_task *child, void *data)
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



