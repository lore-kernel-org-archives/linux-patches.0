Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029212405F9;
	Tue, 11 Mar 2025 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706088; cv=none; b=FY2hFF/GJ8EcqDbuFM8bmJlhpoj3X7V2/UaLzqeZPpYV7hgC28dntLK7dzFNbsGRKacsd5zBMGnsJR4K9JNGNMWliPA9RGTr/uioOIk1Rh4bUzxeIASq31SSdcNr1aqaUfe22qkH75dQyZ1g3XjwXAX+dydyrq/s0O9i86JVnHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706088; c=relaxed/simple;
	bh=fQmpOhYTG/lOcPq3Y6AWZfYMhWUlV45kdOnDnGSfhS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To6DHDiOSGiFz2wPjB3/Jer1wYKi2+vg7KxQoDB6tIMPwEmaXVvzP5zrhU0mWs0hCkQBO9uuT36xTuu+Jo/X1iMjnZIDMAKUFx1/yVvqJMDhHXVUXpuRcHrAGCKCSr/KmFSRWuKFOakweBXU+Tpb11XpkYUfeyvJikOzI4ugRGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQG2mEW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQG2mEW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEC5C4CEE9;
	Tue, 11 Mar 2025 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706087;
	bh=fQmpOhYTG/lOcPq3Y6AWZfYMhWUlV45kdOnDnGSfhS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQG2mEW6VLT8fLWMp1g+zK3ND4GwuUJDv8Ys8l6OvQ6Q05rwX4MS1yK+DZzgkIf60
	 uWTPBoA6MoUsSRiYXyhVSWOnym2vtyf5OB+NruTMQbypUw404tJzPqVas/6wX+apGW
	 KZMO1kwoWeuWIfSz8T69stH9V3zYTp7KKrvam/kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 258/328] sunrpc: suppress warnings for unused procfs functions
Date: Tue, 11 Mar 2025 16:00:28 +0100
Message-ID: <20250311145725.162830694@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d050e70138601..2215314dc4c5d 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1652,12 +1652,14 @@ static void remove_cache_proc_entries(struct cache_detail *cd)
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
@@ -1685,12 +1687,6 @@ static int create_cache_proc_entries(struct cache_detail *cd, struct net *net)
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



