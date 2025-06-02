Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D809E227EBB;
	Mon,  2 Jun 2025 15:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876672; cv=none; b=Aj0UlcMPVxKzdc6HH++wc6sOVfZvHY+Rl28Z/uQK94zuveQA78kga5AmArRVb9aGed4blK4i+hLRB6P+b3nxM9dPqaavPNt7XVj0wexb+GjAIkBs0Br4SvOXtIbklUNMGRdXfVeFQaGatiSJ4yiHCZRXHYx+/5MBjZBgYh5Yo4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876672; c=relaxed/simple;
	bh=klRjDvD2FqsMOwMlbw0V/OlTbIl87XStf46HI7fiU1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+nGkMV6ZisRaFwycE52whsUxFYRi3/u+E8x4H0HVDAFYGTNHNJHFO2/7F0bFhP/nFPe7rfqVOjlOmWCJ7V053LRYO7UmdJ/ZygURv74aClzmcMW+ijWztTbRH1AgJspReQ8xo4mLGQVsFTxldx0zO1f5ToGe+q+VO8Kq15qMJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5jvrGFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5jvrGFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6CCC4CEEB;
	Mon,  2 Jun 2025 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876672;
	bh=klRjDvD2FqsMOwMlbw0V/OlTbIl87XStf46HI7fiU1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5jvrGFixlyHFcbteFe5R/CNoD2C1ESgoS4NDdW/7xPlElaqdZbWfaPs/eD0Csyjy
	 W/PgAOo9VoS9FYGm4N8cnAx/TU27gevkDb7iTrDnOHUwlu6nWacT6u+e+KKPydNB6u
	 1AkH28UUsvwQ8+94pO4096v9m6b5NDPfNl1WUHZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/325] SUNRPC: rpc_clnt_set_transport() must not change the autobind setting
Date: Mon,  2 Jun 2025 15:45:12 +0200
Message-ID: <20250602134321.222155827@linuxfoundation.org>
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
index b6529a9d37d37..a390a4e5592f2 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -275,9 +275,6 @@ static struct rpc_xprt *rpc_clnt_set_transport(struct rpc_clnt *clnt,
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



