Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8402517AE;
	Wed,  5 Mar 2025 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198522; cv=none; b=GlxbocGpN/C5v0lathU0WCCVVYs+V/Nn4goB6Y7ybJwmwbtKt+gzbEmZLJQvjXt7dTbSXumaKMpPPTeNug0k/wWPKO29o0aK9WaWB25nSA7nsyDKhjmV1B9AkY96ZejqLXdZ0Kc+6w7VJvtygpR0v0aD9NFrj4mFg2NCnxyEYqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198522; c=relaxed/simple;
	bh=GOkJSUFhYiVjTu5hpkiiSK/uFhMZY5N72WXCLxE7iXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOKTOakZEAUf/1lOmu9Z6NcEcLZOIkMacJbgMGF5swVB0/BwYj7ZmF8RUb/7tnKgrKIFe1I9I4znmHA5/E4mAn35L+0osD38D6tZ6+13ihm0SpYFk6K+lLWqt2utfckz8gCexFB+pySiP7Oc78zUbBEgnFuaqHZCcehmDfyodwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTGMcMiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTGMcMiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563E1C4CED1;
	Wed,  5 Mar 2025 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198521;
	bh=GOkJSUFhYiVjTu5hpkiiSK/uFhMZY5N72WXCLxE7iXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTGMcMiQlWerbh51VvxHxI1937k3sNemr+2CIMlp87Q96wdub8UPp1p4enXK42CvM
	 Z5E7nuu5Klo8IAy507RK4QbaJVeVHLfpAAkq/aawMq3R1HiwhAYzrIVUecU7C3NJcV
	 LMFKr8gtBR8qa89U1gWASuWKFtxyIXprLPmPO4pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 024/157] sunrpc: suppress warnings for unused procfs functions
Date: Wed,  5 Mar 2025 18:47:40 +0100
Message-ID: <20250305174506.267534916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1f7a4f98c11fbeb18ed21f3b3a497e90a50ad2e0 ]

There is a warning about unused variables when building with W=1 and no procfs:

net/sunrpc/cache.c:1660:30: error: 'cache_flush_proc_ops' defined but not used [-Werror=unused-const-variable=]
 1660 | static const struct proc_ops cache_flush_proc_ops = {
      |                              ^~~~~~~~~~~~~~~~~~~~
net/sunrpc/cache.c:1622:30: error: 'content_proc_ops' defined but not used [-Werror=unused-const-variable=]
 1622 | static const struct proc_ops content_proc_ops = {
      |                              ^~~~~~~~~~~~~~~~
net/sunrpc/cache.c:1598:30: error: 'cache_channel_proc_ops' defined but not used [-Werror=unused-const-variable=]
 1598 | static const struct proc_ops cache_channel_proc_ops = {
      |                              ^~~~~~~~~~~~~~~~~~~~~~

These are used inside of an #ifdef, so replacing that with an
IS_ENABLED() check lets the compiler see how they are used while
still dropping them during dead code elimination.

Fixes: dbf847ecb631 ("knfsd: allow cache_register to return error on failure")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/cache.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 059f6ef1ad189..7fcb0574fc79e 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1669,12 +1669,14 @@ static void remove_cache_proc_entries(struct cache_detail *cd)
 	}
 }
 
-#ifdef CONFIG_PROC_FS
 static int create_cache_proc_entries(struct cache_detail *cd, struct net *net)
 {
 	struct proc_dir_entry *p;
 	struct sunrpc_net *sn;
 
+	if (!IS_ENABLED(CONFIG_PROC_FS))
+		return 0;
+
 	sn = net_generic(net, sunrpc_net_id);
 	cd->procfs = proc_mkdir(cd->name, sn->proc_net_rpc);
 	if (cd->procfs == NULL)
@@ -1702,12 +1704,6 @@ static int create_cache_proc_entries(struct cache_detail *cd, struct net *net)
 	remove_cache_proc_entries(cd);
 	return -ENOMEM;
 }
-#else /* CONFIG_PROC_FS */
-static int create_cache_proc_entries(struct cache_detail *cd, struct net *net)
-{
-	return 0;
-}
-#endif
 
 void __init cache_initialize(void)
 {
-- 
2.39.5



