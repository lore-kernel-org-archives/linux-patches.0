Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF5613C3CF;
	Tue, 18 Jun 2024 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715808; cv=none; b=ZbpNBhxKbFZPSShFsXy5unpSt0cPo/B2pwdtAB4kxVcKlN8EhS0p4n05kvD/EIAu8is6VwxtOre0YR268MFwdqbgw/Yy2Y+tV/Hh2fkPbU5DNflLQrMxCz8YOSUI1A6lrTm7zM5C/UyxLoNe96l/DHflQG8ho8GlxmYwrj0fJxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715808; c=relaxed/simple;
	bh=Deznd9npYLt9Mx0oU+piw3/in06mfvofUV7/O8NiqYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0RBVuYJJ06F0Q56gKPI6FiIlyTikgt1Q2caLWKT0sMW8v2VlrVuhBtWRRNyc66kjW2FkGb2x0s04bn6bkX3RQi8ilz0kOn0RSEn5YwwnUeVYLBijs7cfG2TQ6a6AgFQY+IeDNJ9fOxZPCRiFTAdiHDaFdlevgnG3EoKBVH51GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBkGVWVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBkGVWVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B0DC3277B;
	Tue, 18 Jun 2024 13:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715808;
	bh=Deznd9npYLt9Mx0oU+piw3/in06mfvofUV7/O8NiqYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBkGVWVEsUtKov13EiJLo/810+1maN/Jx2+qd1ydG7xuaZBSmG5ZE3Zr5DgWV647u
	 +cJQF/NKClPHyAohAiwJrPjK/yGh9Awu42s+XYH01zBH8gT+QEU/k5LXMdbxXzauOm
	 1UjQrWVYRNfwxHyyAGMEQHTeotOFIrcFVGxOSY58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/770] lockd: introduce lockd_put()
Date: Tue, 18 Jun 2024 14:34:46 +0200
Message-ID: <20240618123423.998963433@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



