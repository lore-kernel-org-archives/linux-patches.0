Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1939279F0;
	Mon,  8 Apr 2024 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583585; cv=none; b=GWvL2wy6ZTk/kEyQCu6NZ6BCCfakPkMFaQcn1A3XlI6IvNd4h0sbz9g/DdR7s1CZZE9uv5I1BdSQZkhyI/+ZOKjO1nkHE1rO+Dtng/EZLi785OCU946b++At52TanVkokj/cMFPho/CIF58pcxyhronJ6dJQKzMskIxxONZO2aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583585; c=relaxed/simple;
	bh=eR1t7MyofSe57AHmwtJxGa+QZwY4b7YmZR9JKSJyDBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY7p9dhyW+npfobyqSiaBpY8Lpv6r1dgPqCfSrmQAyySvKl0bWaliAa+MZkReKZbO/3NYxOzl5+Mpt/V1nllVUc1KDQmivSwJaCZoH80oE+maA153UXevA29Y6miPxT/sGf2DelW/7oWPXzeZmYBjw4N7Th6i72wrOtcdrfPB+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxKgjWlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxKgjWlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949E2C433C7;
	Mon,  8 Apr 2024 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583585;
	bh=eR1t7MyofSe57AHmwtJxGa+QZwY4b7YmZR9JKSJyDBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxKgjWlCew1/oa8AtHyMZrBYPgLXWsATeeNtCUd5YJj/ah5Tq2ILc4mFEWW/n1yNC
	 nSTrIE1ampsUmSss7cb1vUsk/FsQTXlh3bPuM6dO3lA8IivY1cxxuHeeXYU4ve/2dt
	 QLJlov0lyhFvfbcXOPRQv6q831412KrM5e5fgA8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 240/690] lockd: introduce lockd_put()
Date: Mon,  8 Apr 2024 14:51:46 +0200
Message-ID: <20240408125408.336238821@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 865b674069e05e5779fcf8cf7a166d2acb7e930b ]

There is some cleanup that is duplicated in lockd_down() and the failure
path of lockd_up().
Factor these out into a new lockd_put() and call it from both places.

lockd_put() does *not* take the mutex - that must be held by the caller.
It decrements nlmsvc_users and if that reaches zero, it cleans up.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c | 64 +++++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 9aa499a761591..7f12c280fd30d 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -351,14 +351,6 @@ static struct notifier_block lockd_inet6addr_notifier = {
 };
 #endif
 
-static void lockd_unregister_notifiers(void)
-{
-	unregister_inetaddr_notifier(&lockd_inetaddr_notifier);
-#if IS_ENABLED(CONFIG_IPV6)
-	unregister_inet6addr_notifier(&lockd_inet6addr_notifier);
-#endif
-}
-
 static int lockd_start_svc(struct svc_serv *serv)
 {
 	int error;
@@ -450,6 +442,27 @@ static int lockd_create_svc(void)
 	return 0;
 }
 
+static void lockd_put(void)
+{
+	if (WARN(nlmsvc_users <= 0, "lockd_down: no users!\n"))
+		return;
+	if (--nlmsvc_users)
+		return;
+
+	unregister_inetaddr_notifier(&lockd_inetaddr_notifier);
+#if IS_ENABLED(CONFIG_IPV6)
+	unregister_inet6addr_notifier(&lockd_inet6addr_notifier);
+#endif
+
+	if (nlmsvc_task) {
+		kthread_stop(nlmsvc_task);
+		dprintk("lockd_down: service stopped\n");
+		nlmsvc_task = NULL;
+	}
+	nlmsvc_serv = NULL;
+	dprintk("lockd_down: service destroyed\n");
+}
+
 /*
  * Bring up the lockd process if it's not already up.
  */
@@ -461,21 +474,16 @@ int lockd_up(struct net *net, const struct cred *cred)
 
 	error = lockd_create_svc();
 	if (error)
-		goto err_create;
+		goto err;
+	nlmsvc_users++;
 
 	error = lockd_up_net(nlmsvc_serv, net, cred);
 	if (error < 0) {
-		goto err_put;
+		lockd_put();
+		goto err;
 	}
 
-	nlmsvc_users++;
-err_put:
-	if (nlmsvc_users == 0) {
-		lockd_unregister_notifiers();
-		kthread_stop(nlmsvc_task);
-		nlmsvc_serv = NULL;
-	}
-err_create:
+err:
 	mutex_unlock(&nlmsvc_mutex);
 	return error;
 }
@@ -489,25 +497,7 @@ lockd_down(struct net *net)
 {
 	mutex_lock(&nlmsvc_mutex);
 	lockd_down_net(nlmsvc_serv, net);
-	if (nlmsvc_users) {
-		if (--nlmsvc_users)
-			goto out;
-	} else {
-		printk(KERN_ERR "lockd_down: no users! task=%p\n",
-			nlmsvc_task);
-		BUG();
-	}
-
-	if (!nlmsvc_task) {
-		printk(KERN_ERR "lockd_down: no lockd running.\n");
-		BUG();
-	}
-	lockd_unregister_notifiers();
-	kthread_stop(nlmsvc_task);
-	dprintk("lockd_down: service destroyed\n");
-	nlmsvc_serv = NULL;
-	nlmsvc_task = NULL;
-out:
+	lockd_put();
 	mutex_unlock(&nlmsvc_mutex);
 }
 EXPORT_SYMBOL_GPL(lockd_down);
-- 
2.43.0



