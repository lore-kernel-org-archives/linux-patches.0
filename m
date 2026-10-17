Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054C43A0B38;
	Sat, 17 Oct 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259671; cv=none; b=q4z+BXrUHMGkf45L/icKdIthZmbIjj6sqwStVH7Tig1UWL2ZNhkzesxjliztK3TWbMhpx4egKnfX1oCu+EPz9ts3V7GQw18YsgpeaHRx8WBA7c7PuZzRCyCB58mD6V5szMIAn9wNTNnLk2iFIhqMRC4T8koAaSdnXtsZYktKxwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259671; c=relaxed/simple;
	bh=WwwXXkgTBwYvvsdSZbk/HJOe0EaLWPCiJvboUSMH8+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXGy8kVybXjFSkAa13qnk3Y1tDyWZlbLzKOUZNqqg3hRbsspqwzu/WDao0oYcsoiPPcqihrMn/zjaX3kmP/hBcfi88Ss5/y16L+9ARMGB7bN9wfyn2Cbbz63chLrgodkfF3HNMIZ0DOqy1AtMTpDOjZl24BlQH4Xxz8RZkKiHDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxSkeSC0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxSkeSC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE721F000C4;
	Sat, 17 Oct 2026 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259669;
	bh=bRPeiAF5cERGpAHQVtta4+8hMg2s4mXEfkPlw/rbSbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxSkeSC0ggZPuGYlzhVvUPz28CEZMpAArKaW8c0woiJ5VmNDNRj77st6omVbYFBTj
	 I30TlrNj69pTDmQnj1NHdP9amvJSnrtK32yv+RgbJmbZHUzTCcXTqz48I7f71SVNID
	 DBqsw9jiCh8O3fHZYoYpEXbWL95nvCoY27MySxLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1292/1674] sunrpc: refactor pool_mode setting code
Date: Sat, 17 Oct 2026 17:59:24 +0200
Message-ID: <20261017160504.304340558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 5f71f3c325534da55dfda487a67208e2e0f0cd1b ]

Allow the pool_mode setting code to be called from internal callers
so we can call it from a new netlink op. Add a new svc_pool_map_get
function to return the current setting. Change the existing module
parameter handling to use the new interfaces under the hood.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: c479bde671cb ("sunrpc: defer rq_argp and rq_resp free until after RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h |  2 +
 net/sunrpc/svc.c           | 85 ++++++++++++++++++++++++++++----------
 2 files changed, 66 insertions(+), 21 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 3d8b215f32d5b..d4558fefd9b4e 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -395,6 +395,8 @@ struct svc_procedure {
 /*
  * Function prototypes.
  */
+int sunrpc_set_pool_mode(const char *val);
+int sunrpc_get_pool_mode(char *val, size_t size);
 int svc_rpcb_setup(struct svc_serv *serv, struct net *net);
 void svc_rpcb_cleanup(struct svc_serv *serv, struct net *net);
 int svc_bind(struct svc_serv *serv, struct net *net);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 3ac71af655ed0..68f31611c22cc 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -72,57 +72,100 @@ static struct svc_pool_map svc_pool_map = {
 static DEFINE_MUTEX(svc_pool_map_mutex);/* protects svc_pool_map.count only */
 
 static int
-param_set_pool_mode(const char *val, const struct kernel_param *kp)
+__param_set_pool_mode(const char *val, struct svc_pool_map *m)
 {
-	int *ip = (int *)kp->arg;
-	struct svc_pool_map *m = &svc_pool_map;
-	int err;
+	int err, mode;
 
 	mutex_lock(&svc_pool_map_mutex);
 
-	err = -EBUSY;
-	if (m->count)
-		goto out;
-
 	err = 0;
 	if (!strncmp(val, "auto", 4))
-		*ip = SVC_POOL_AUTO;
+		mode = SVC_POOL_AUTO;
 	else if (!strncmp(val, "global", 6))
-		*ip = SVC_POOL_GLOBAL;
+		mode = SVC_POOL_GLOBAL;
 	else if (!strncmp(val, "percpu", 6))
-		*ip = SVC_POOL_PERCPU;
+		mode = SVC_POOL_PERCPU;
 	else if (!strncmp(val, "pernode", 7))
-		*ip = SVC_POOL_PERNODE;
+		mode = SVC_POOL_PERNODE;
 	else
 		err = -EINVAL;
 
+	if (err)
+		goto out;
+
+	if (m->count == 0)
+		m->mode = mode;
+	else if (mode != m->mode)
+		err = -EBUSY;
 out:
 	mutex_unlock(&svc_pool_map_mutex);
 	return err;
 }
 
 static int
-param_get_pool_mode(char *buf, const struct kernel_param *kp)
+param_set_pool_mode(const char *val, const struct kernel_param *kp)
+{
+	struct svc_pool_map *m = kp->arg;
+
+	return __param_set_pool_mode(val, m);
+}
+
+int sunrpc_set_pool_mode(const char *val)
+{
+	return __param_set_pool_mode(val, &svc_pool_map);
+}
+EXPORT_SYMBOL(sunrpc_set_pool_mode);
+
+/**
+ * sunrpc_get_pool_mode - get the current pool_mode for the host
+ * @buf: where to write the current pool_mode
+ * @size: size of @buf
+ *
+ * Grab the current pool_mode from the svc_pool_map and write
+ * the resulting string to @buf. Returns the number of characters
+ * written to @buf (a'la snprintf()).
+ */
+int
+sunrpc_get_pool_mode(char *buf, size_t size)
 {
-	int *ip = (int *)kp->arg;
+	struct svc_pool_map *m = &svc_pool_map;
 
-	switch (*ip)
+	switch (m->mode)
 	{
 	case SVC_POOL_AUTO:
-		return sysfs_emit(buf, "auto\n");
+		return snprintf(buf, size, "auto");
 	case SVC_POOL_GLOBAL:
-		return sysfs_emit(buf, "global\n");
+		return snprintf(buf, size, "global");
 	case SVC_POOL_PERCPU:
-		return sysfs_emit(buf, "percpu\n");
+		return snprintf(buf, size, "percpu");
 	case SVC_POOL_PERNODE:
-		return sysfs_emit(buf, "pernode\n");
+		return snprintf(buf, size, "pernode");
 	default:
-		return sysfs_emit(buf, "%d\n", *ip);
+		return snprintf(buf, size, "%d", m->mode);
 	}
 }
+EXPORT_SYMBOL(sunrpc_get_pool_mode);
+
+static int
+param_get_pool_mode(char *buf, const struct kernel_param *kp)
+{
+	char str[16];
+	int len;
+
+	len = sunrpc_get_pool_mode(str, ARRAY_SIZE(str));
+
+	/* Ensure we have room for newline and NUL */
+	len = min_t(int, len, ARRAY_SIZE(str) - 2);
+
+	/* tack on the newline */
+	str[len] = '\n';
+	str[len + 1] = '\0';
+
+	return sysfs_emit(buf, str);
+}
 
 module_param_call(pool_mode, param_set_pool_mode, param_get_pool_mode,
-		 &svc_pool_map.mode, 0644);
+		  &svc_pool_map, 0644);
 
 /*
  * Detect best pool mapping mode heuristically,
-- 
2.53.0



