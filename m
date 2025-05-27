Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0BB1E89C;
	Tue, 27 May 2025 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366469; cv=none; b=ma3x2rJ02aJe/2TWgVngSFsBNLq2C7vEEsa38Fram5c4RfvpA8G4n7pAm8/QbAWmf37OfiyzHxsiNTRuqeJKK2tDpSfh6K9TBVaLVxenykU/eoR3c4bjazpV2JbMOy7693oJBYfJhZfT7V6V2Y2YISdJnHaxz4lQLEExxLzcrLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366469; c=relaxed/simple;
	bh=0xNSYELjfqngMV+KYFRZYEp7CuY/qeOQE8ffcw7q3uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPjL8Q1ZcrzxEUkucr1RBaRZqxsSsc+auJ/SD/Gmg817Cl0OKFcbhVmf4Elxcz4NKTZqUtTQex1vH/R/eQ6QCVGU931QoiDHZ+5GFxL/5i/BjQcS2y1GwcGpy5EoNsCpcK+nbhC8s2MtJ6DzrD8UxKahPH4kOMGsI5E51IxsBgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E33cZjFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E33cZjFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7717C4CEE9;
	Tue, 27 May 2025 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366469;
	bh=0xNSYELjfqngMV+KYFRZYEp7CuY/qeOQE8ffcw7q3uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E33cZjFayCb9Eh7dP7pRjoE8TM6VAjzz4njbUJagvOPmpSC83r4o391nxZdqJH2LN
	 D8ZLBm8NKpxz7e/7E7VNLGedkSP5iTRh8aF0xSaDInXy4DxzbSCoOjDWOmzcKDUlDO
	 /HvbBjq3gnEHosNRGnHRA8aO9W+vlH3IEkLU11c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 077/783] SUNRPC: rpcbind should never reset the port to the value 0
Date: Tue, 27 May 2025 18:17:54 +0200
Message-ID: <20250527162516.268591274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



