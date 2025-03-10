Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2121BBBFD;
	Mon, 10 Mar 2025 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630761; cv=none; b=sZ7xlTnyZStiu2DtO5AMthc2uD4xlfPskWbUbEReqru9rVc9kgDkCcWvVnt9iebTccpHKKOrML8E80HJFUkopeguex/c53Qd6Cu3e8veHfN0wW5B140eNecPf3raaJx+TSlRzgfK0tOtz8R/u49Il3epEUOYihxjavIBsuET0KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630761; c=relaxed/simple;
	bh=YrteuGJe4guQZ94KID31DzERlehSU8UmkH/WGeXedeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPa9/GC4Tj8xsrjc6ERMKOG48RAS0EP0JR4XJqv4zhIW6f9zj+QTI3eCb3RHzTzl+UjkzPNIiAi2JtoiCcldbOi/Fah+3QCudUPiLgNYRethx59R3LDuOpfPOQ/9rR6FCsIglY+on+aTUXmpZ9V8LoWQvgM6qGLeuq3iBDDTmXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pz2Y1FIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pz2Y1FIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A6AC4CEE5;
	Mon, 10 Mar 2025 18:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630760;
	bh=YrteuGJe4guQZ94KID31DzERlehSU8UmkH/WGeXedeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pz2Y1FIYsO5OEiC8SQqncJsEoX7++NaAVCIfrQsH3BoczH+q0QHCcZdjIA5+gnAtw
	 BjP6NGmPb20u8u3rh6AeN434Elf/WJBDmRWNETkoOGmzzKHX9iUQMP8mJLO6ug6RlN
	 +bVhVuWPmrd5nmQBjxgf0VZNt025w+t55Yuonayo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 493/620] sunrpc: suppress warnings for unused procfs functions
Date: Mon, 10 Mar 2025 18:05:39 +0100
Message-ID: <20250310170605.030430343@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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
index 8c9597b9a3f2e..95aab48d32e67 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1659,12 +1659,14 @@ static void remove_cache_proc_entries(struct cache_detail *cd)
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
@@ -1692,12 +1694,6 @@ static int create_cache_proc_entries(struct cache_detail *cd, struct net *net)
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



