Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E27821516E;
	Mon,  2 Jun 2025 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875470; cv=none; b=ZSr8pznP3pbdRDmDoLXzK+LAGoG/ppU4yYZO7qG8hqP8ydAsCUq9w3+HYbku5BaslKjVr0BB9bmqR1DQ9RXpkownjnO6OzPXSa7FUXYcV17ZQa/X6PJbDrx6CsGvQ9i7qTsxqkMiDxVxslHNlksHebE+Ha5yDAnTJCFdlmRgLU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875470; c=relaxed/simple;
	bh=c+cYTeMDis26MORFk2tcc5264TUUgLRXR2KSL0pp4q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRr+GNUwxfJR+jVx/II7ASTB/f3Is+V7RPgAnbW74JeXvLBrYBvPXxj6VrurBlYjchr+WYp/yEiOpH6J59zmD/Ut9EpeeEXdVGg1iE8MCrxvu+j2hV5mEuXWLleSWT3pqC5wHEDzhy1W4UVuFSPzu1YstzomaXahvWbFKbRlty4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrSPql8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrSPql8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB3FC4CEEB;
	Mon,  2 Jun 2025 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875470;
	bh=c+cYTeMDis26MORFk2tcc5264TUUgLRXR2KSL0pp4q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrSPql8J+MajeQW0wQ1bWtb/MMIqLPJ9XM3FqAJRcTJCv31og2GA50KECtaGbGrz7
	 jWYiXJwcKEwAVsijV/NFntfxAPG9FJmZU4xPee4pt8Q7QslROiP3Q1EcI0Wz3vqd5v
	 DvG/iFsCOPxBVsLwFGc0Dg2JL1ydhXNSTFIMLa3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/270] SUNRPC: rpcbind should never reset the port to the value 0
Date: Mon,  2 Jun 2025 15:46:52 +0200
Message-ID: <20250602134312.419448172@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8fad45320e1b9..f1bb4fd2a2707 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -794,9 +794,10 @@ static void rpcb_getport_done(struct rpc_task *child, void *data)
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



