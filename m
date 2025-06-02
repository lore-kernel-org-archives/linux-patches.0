Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF0F21885A;
	Mon,  2 Jun 2025 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873153; cv=none; b=PZpi/XxxCSBeQ0t4vLAIrS7D9Rhdnzey/ji88npu/C+Ui/QDLkoAZvzAoSPlTAtjGyI13756aItK3TldqVJd+nsmIGryLhJMWXYH5CvB6ZoQ1J6wmD5d8ZITjDwidFGjlhf3wtyd+IMZ3diqJqWtcFb7Ny8x3w/lXHs+kkLI6v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873153; c=relaxed/simple;
	bh=iWSZH5UmoMNuoVH2DLGAcrzYfry8h1p6RgTouAou21g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khjxMhKph9PK63rXLV73jxqvUpPqBBaaC/vgTKqGGts18sYHkU/IRfbMpd3Is1o2x5SwysIwBcfo/cJ3dlrBy+rLyIra5qkt39qd0W41SA/vlTlH6Uf6GN+vMzBe4UTOtinLyI1k8Cf53HzDT1QuyNoawElgR3tMTkMyYC3vjZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xvno7ZpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xvno7ZpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE10EC4CEEB;
	Mon,  2 Jun 2025 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873153;
	bh=iWSZH5UmoMNuoVH2DLGAcrzYfry8h1p6RgTouAou21g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xvno7ZpTlY/qnERkR+mQg83/NDlXAaiFeKUa9z6vgVSylQoczutdpyQiRKk+HRqkG
	 I+325DegooG/ew71fMoeaxIU6DOvHYc48N5kqemqNGDgH38JSmB8AVM7099/CO2JHQ
	 GgNOoeLku+MGLUpEINEQf8yK7k5DYKB4vB5viI4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/444] SUNRPC: rpc_clnt_set_transport() must not change the autobind setting
Date: Mon,  2 Jun 2025 15:41:59 +0200
Message-ID: <20250602134343.161438690@linuxfoundation.org>
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
index 142ee6554848a..4ffb2bcaf3648 100644
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



