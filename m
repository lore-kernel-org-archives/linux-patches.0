Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B9022257E;
	Mon,  2 Jun 2025 14:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876059; cv=none; b=B+h/WZTiyX4A2UXFHwBbUV3Tr3COUWkdFVN4QaIC8Qwb75A1YURBzGyLaT9vsqlNM8WYqtnig0XuC7Y2P6IqVaPDa8Jn+ONt5BEDiKLv9L3Q+2ATw45vnD60CF5sGd/yjgfFKq/2on9w0DPDZFCUpuf6z3cWgt9LkRut5Umz3Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876059; c=relaxed/simple;
	bh=75/t4yMqF2z+Bl9fFKfo11mHPf+WE6toyESZlhZk/gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIXrH7mZo6Nn4vhb0Xag9s5bxusIgYJjw+/PPga42S4eQP6dL8wajAP9KGpcx/9T87uAoUHLdR1XELOai/eCmE1d/V4TIYkD3uuEOk31hA8ecKjabjz0puBK+1nGOWTWBIT0EVjjETTivN0m4sIdv5YVVSYbqG8+3YvMtHCx7Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foqmrlHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foqmrlHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FA3C4CEEB;
	Mon,  2 Jun 2025 14:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876059;
	bh=75/t4yMqF2z+Bl9fFKfo11mHPf+WE6toyESZlhZk/gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foqmrlHsUf5MelSRnXysHcBPK7zHBt2pckoyK3Ed1UER7/lVmOvqxPJ9FhCPYfED+
	 oLnV+GNFZV3eDuFFUVi6zD0rpQCQiGoh6voryqgxcoGGrnzkSv1IwILQae8fi0Sw6l
	 4rMLmS490TQ6IDo2G9/tSdwRxpCcguVtNiWNk1Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/207] SUNRPC: rpcbind should never reset the port to the value 0
Date: Mon,  2 Jun 2025 15:46:29 +0200
Message-ID: <20250602134259.447365894@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 638b14f28101e..c49f9295fce97 100644
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



