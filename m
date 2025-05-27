Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8C627C856;
	Tue, 27 May 2025 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364488; cv=none; b=k+hzv/h6DTwYAsVEzdNwiGQ8PxToNHQ9zuJs9M/LWQmMoDlKxufT5D35sszm6TWzHGAeUmotoFsj6RYr+9tEIbsOcaGOmqoc6SN1fSsGG9mHqjxnQT0qs16NGZgZnatIbI/ZnVNJMhdh/BxRkA3p9GI1DDOUTyGqHE27Y084MZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364488; c=relaxed/simple;
	bh=88v5Jgv+e4KneiaNRX3chLOCZu1bz1qLD6C7W9xjT0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXNSm1CPO8cZdFyHs6omEEIM5jE62tRIadncF8GNBhPWjzRJs/q4Fu9eGxDUEL3RoShvemIQPw5xW61QafZXEgP5cpbPIv/QRvUad5kW5R4a0HY1gUnEmQhTRR1LaiFrQtmEgqV+vaLsa735WU/XscKKB+YbqydF7M5saZHKf9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlD7WOVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlD7WOVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C5FC4CEEB;
	Tue, 27 May 2025 16:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364487;
	bh=88v5Jgv+e4KneiaNRX3chLOCZu1bz1qLD6C7W9xjT0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlD7WOVE4cxz6KTwG7leju4naI5VTEhl4Sty712tKw4Yn166XU/niRqYSd9RD0Q7j
	 lcbOACQjnomJyXsjLpVSSraaNEmoti+f6PsYXbJsicyjw6Jia96dQ5B1LczBxSJrKT
	 oS3snEsQHQP7fatCtR5eS3ej0hbAmSBDoSx8g1Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/626] SUNRPC: rpc_clnt_set_transport() must not change the autobind setting
Date: Tue, 27 May 2025 18:19:25 +0200
Message-ID: <20250527162447.975591811@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit bf9be373b830a3e48117da5d89bb6145a575f880 ]

The autobind setting was supposed to be determined in rpc_create(),
since commit c2866763b402 ("SUNRPC: use sockaddr + size when creating
remote transport endpoints").

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 0090162ee8c35..17a4de75bfaf6 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -270,9 +270,6 @@ static struct rpc_xprt *rpc_clnt_set_transport(struct rpc_clnt *clnt,
 	old = rcu_dereference_protected(clnt->cl_xprt,
 			lockdep_is_held(&clnt->cl_lock));
 
-	if (!xprt_bound(xprt))
-		clnt->cl_autobind = 1;
-
 	clnt->cl_timeout = timeout;
 	rcu_assign_pointer(clnt->cl_xprt, xprt);
 	spin_unlock(&clnt->cl_lock);
-- 
2.39.5



