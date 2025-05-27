Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04661E89C;
	Tue, 27 May 2025 17:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366467; cv=none; b=gBBDUcTDhNjzoGexmT24CwodqGMw4oQ/e1dsVYWbXqcNJh+smoeNrUsc01kMXK6wovSYGtl/jZuA5F2kYsfWIFJwkd8tIrGj8qu2mPzhv/EO+7mwuRmUFGrJPVqJMc9v+mbByExbuixRIhP8cDtUbFFOMbTpYYUEzDbucUcN/+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366467; c=relaxed/simple;
	bh=n5LoNNEFxMg5tNxfLXGSxrL57aXQHV3F1SO9dPWA8hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjzcTiWBJZfb7NCLNM23Q5HMsSFTyb+y9qJMn8HYs/W3KYsGtDassoZruoHIMOqg9vbV37KzXaLEpy8Hh2uJxhdAAg70lZ2KKjGlCkRSo57Pgt/Z6LRmW2gfDr7U+eurRFoHCx5uJlyA5K8SfrjGGGixjZr5ZC/GsV9WOT8Lwjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hV4mQF7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hV4mQF7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6240C4CEE9;
	Tue, 27 May 2025 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366466;
	bh=n5LoNNEFxMg5tNxfLXGSxrL57aXQHV3F1SO9dPWA8hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hV4mQF7CUoBxgrbZjhvqzTnI9TG+VXCqA6mKv8HVx/Le2dA6UkbXfrG6Eg/NSdVG5
	 zofzVNETPYiUxACsABmYg6rXuWeJ29kleqxvIOhzHT0HyavIkjflu4R9d8HoTBGqan
	 G4QS/nW2HZrdsOl8kFHMUC/EDYS3xJlM0RpP4psQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 076/783] SUNRPC: rpc_clnt_set_transport() must not change the autobind setting
Date: Tue, 27 May 2025 18:17:53 +0200
Message-ID: <20250527162516.228139952@linuxfoundation.org>
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
index 2fe88ea79a70c..c9c5f0caef6bd 100644
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



