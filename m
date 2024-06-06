Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3493196DA8;
	Thu,  6 Jun 2024 14:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683020; cv=none; b=BV3pIotjq8LmBwW5CdG7pUm1E8mWELMv2bUFRBXzMhiF4aYc0+1/aEtipdC+17dEMcuX7GzA9CkVsbI+oU3KSm3bEL9mghuPAKyBg90hJ1fV0Uh9GZjxDVU1JUcjV7OhoAxp0kQVdeR8N8WiO0xaaX0QEihd8aYjlxXGJ64sgi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683020; c=relaxed/simple;
	bh=3SR9vtNG3VjnIJqLs3IZ+6xuEJ+MgFXsLOx9Mf3j2go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eX/AX6lkBK1rlhq0QmCgmEbBPz6JAUaWYLhd4K5j0oO0mbgNmNEJzIZjLHWdwH2W+L8csrwcUpFLfohefLJrqDydo2H3157S/6LiBJN9lz0p1pysEE63S2WV7biVKHCQG6nXotPukOYXOHaqTKR0Td8CTCQlqzjWW5nH5FuMQkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4uqRQZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4uqRQZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816B7C32781;
	Thu,  6 Jun 2024 14:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683020;
	bh=3SR9vtNG3VjnIJqLs3IZ+6xuEJ+MgFXsLOx9Mf3j2go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4uqRQZctxljIjw1NZQ+tUGNOitOSpf3pGRGYMffv/T5igjBJpt4Y5tRzqXvHbyFq
	 guvWIkgf86sDJWPwbVzTS9lWaSoJhsp3QctoRrUlgc8MDX5t3IcVczM0SZRFLuKDtN
	 gP030/4aPBJCnTwKOoLbBBNf+HJf1yjNskxU4gOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Dan Aloni <dan.aloni@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 241/374] sunrpc: fix NFSACL RPC retry on soft mount
Date: Thu,  6 Jun 2024 16:03:40 +0200
Message-ID: <20240606131659.893211997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Aloni <dan.aloni@vastdata.com>

[ Upstream commit 0dc9f430027b8bd9073fdafdfcdeb1a073ab5594 ]

It used to be quite awhile ago since 1b63a75180c6 ('SUNRPC: Refactor
rpc_clone_client()'), in 2012, that `cl_timeout` was copied in so that
all mount parameters propagate to NFSACL clients. However since that
change, if mount options as follows are given:

    soft,timeo=50,retrans=16,vers=3

The resultant NFSACL client receives:

    cl_softrtry: 1
    cl_timeout: to_initval=60000, to_maxval=60000, to_increment=0, to_retries=2, to_exponential=0

These values lead to NFSACL operations not being retried under the
condition of transient network outages with soft mount. Instead, getacl
call fails after 60 seconds with EIO.

The simple fix is to pass the existing client's `cl_timeout` as the new
client timeout.

Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Link: https://lore.kernel.org/all/20231105154857.ryakhmgaptq3hb6b@gmail.com/T/
Fixes: 1b63a75180c6 ('SUNRPC: Refactor rpc_clone_client()')
Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 28f3749f6dc6c..59b2fbd88e5eb 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1071,6 +1071,7 @@ struct rpc_clnt *rpc_bind_new_program(struct rpc_clnt *old,
 		.authflavor	= old->cl_auth->au_flavor,
 		.cred		= old->cl_cred,
 		.stats		= old->cl_stats,
+		.timeout	= old->cl_timeout,
 	};
 	struct rpc_clnt *clnt;
 	int err;
-- 
2.43.0



