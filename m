Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037116;
	b=rcQy3UcapAastrfzkgaz20J+LEfczIlrj5dcy+/SO46dypzKjscmMQISaKEa5pkd92IY
	 d3zNnSB+718gZ90HyW2cUjxYEk37UO4mwe+FnVnCZP/sf6BVbVJmP+2G2sc/OnwIXL3N2
	 WTnG16ZP64e4znr26yQMxakkEoUf7riVHRZI6qD6/TY9G1myBHI6aellXGeLAJtR3eqOK
	 sZHiwok3UF2z+mieHUsgWKDF/j0+Xs2OrzDTfvp558IK9HPgf7KF4k5rF8QF7eqscyeJ7
	 1R1AvoWY6Ih6iI0KNAoRQ3bKK7NBb2H+pZEfrVJS7ellSsGhJBfqKcW1wptfrBw/QoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ti5N9OPX5y1JlpeX0cMRzQfjoiK+1OckUdzTnRATN4o=;
	b=5pW3CyMHS8ynXQFt15Stn3T6Vx9zlABG/51+gT+b/TXqQLmUDxd8EJBbDxiAqAWglFY0
	 vmwITlWJSmSJQ1GzWYw9y2GAzjCgmMCpkmwY9VIth+7YY0ghT6yvdFeAdRO4Xum/3+biQ
	 eB8hTC235bogI0I3Y0KlliWj+HEsdD9noROUG5gkermQ5oM2dQNs9eWn/5pyIH+hniY5n
	 m7Z1I86J3NZvUh9qRRb6NKd9ZdPR6dtvMi1Ujd5B9eHzbZqaMocaMes3BIvsc4DzMZ+sm
	 6H34V3kxiCDnzbpqmXY9WMhzDbd1iwO9f6i4IMi3K985p0MenYPde6NL3ujQCzeMdCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrYObqgE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA1B606A31C;
	Wed, 18 Nov 2026 21:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrYObqgE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7054D1F000C4;
	Wed, 18 Nov 2026 21:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037116;
	bh=ti5N9OPX5y1JlpeX0cMRzQfjoiK+1OckUdzTnRATN4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrYObqgET+V3AgllvMfrs9f4dZ2gZ7XOjrHgtpyQOf7I+iWpUvq3Gu4ccK9wM3WiE
	 DKGCjvD8mo5Jx5KVO6iCAFXzjfrt7leXZv4MlScbib//KefAWm+BBj5LQmy/XKglLM
	 QycuwLJP4PdC85sevH8MWQZsb2VVtzXICleWnL/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1300/3318] NFSD: Set nn->cld_net before registering the cld pipe
Date: Wed, 18 Nov 2026 15:32:02 +0100
Message-ID: <20261118150359.265033065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 14996e662f3b734427e2d645cacffc27b779f7d1 ]

rpc_mkpipe_dentry() instantiates the pipe's dentry before it returns,
so the cld pipe can be opened as soon as nfsd4_cld_register_net() has
run. __nfsd4_init_cld_pipe() does not store the new cld_net in
nn->cld_net until after that call. cld_pipe_downcall() reaches the
cld_net only through that pointer and takes cn_lock without checking
it, so a write() that lands in the window oopses.

Store nn->cld_net once @cn is fully initialized and before the pipe is
registered, and clear it again when registration fails.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-6-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ sashal: adapted to the dentry-returning pipe registration API while retaining unconditional cn_has_legacy initialization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index f48cd56840942..c6e8a853bf5f5 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -1020,6 +1020,13 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 	spin_lock_init(&cn->cn_lock);
 	INIT_LIST_HEAD(&cn->cn_list);
+	cn->cn_has_legacy = false;
+
+	/*
+	 * The pipe's methods reach @cn through nn->cld_net, so set
+	 * it before the pipe can be opened.
+	 */
+	nn->cld_net = cn;
 
 	dentry = nfsd4_cld_register_net(net, cn->cn_pipe);
 	if (IS_ERR(dentry)) {
@@ -1028,11 +1035,10 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 
 	cn->cn_pipe->dentry = dentry;
-	cn->cn_has_legacy = false;
-	nn->cld_net = cn;
 	return 0;
 
 err_destroy_data:
+	nn->cld_net = NULL;
 	rpc_destroy_pipe_data(cn->cn_pipe);
 err:
 	kfree(cn);
-- 
2.53.0



