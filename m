Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CE17D09F;
	Mon,  8 Apr 2024 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583361; cv=none; b=pN3VFy8SsQ/hSSBGL+mhaKYMjQnNW6Sy8bYoohgyZE2K7RB8/jJ35rLLvMA2scnWnrt077FidoX+tMaIubi8QpScnZQtOLNCM6khuA+UnAmMVF4x/RrRe92wyYrv7UrmjDQvIdQztW/XL4Sy73srMSeZgmmd2WOIEvpNhUGVnKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583361; c=relaxed/simple;
	bh=/wl4n6TMvO5XNaYBxluFbm/n+7Me0egCTrepcjudcis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9NIm/8AJi7KHhNKbww0cIYEYka5HSwpYwktdjVxBEVQjMb82UcnH32WaedsMIO3rhy0zNkJalP0qhhaBciIg7Coy09rKcaLLmlCprXsHj1tkJziAEdjplqRqHSe48mYPVik72ul2w8dbAFi/+MxkqSWEW/3agXQJripc0j3QD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wv2rCCsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wv2rCCsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFF5C433F1;
	Mon,  8 Apr 2024 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583360;
	bh=/wl4n6TMvO5XNaYBxluFbm/n+7Me0egCTrepcjudcis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wv2rCCsGboXGXog9c+uthXbnPJn2obZ8z3iMr7gazuc53fl7dwI2NMCDlH4UOeiQn
	 cPW9kPlTs5xEfmYDIehPoBLNMm/MxynrvPunPehdVtmqcFuhxz83ceviKqwhWGFLn/
	 GFUHJoaLrE4xCsxRsdr6AI6Sy7hXq/ixMjuy394o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 238/690] lockd: move lockd_start_svc() call into lockd_create_svc()
Date: Mon,  8 Apr 2024 14:51:44 +0200
Message-ID: <20240408125408.265634422@linuxfoundation.org>
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

[ Upstream commit b73a2972041bee70eb0cbbb25fa77828c63c916b ]

lockd_start_svc() only needs to be called once, just after the svc is
created.  If the start fails, the svc is discarded too.

It thus makes sense to call lockd_start_svc() from lockd_create_svc().
This allows us to remove the test against nlmsvc_rqst at the start of
lockd_start_svc() - it must always be NULL.

lockd_up() only held an extra reference on the svc until a thread was
created - then it dropped it.  The thread - and thus the extra reference
- will remain until kthread_stop() is called.
Now that the thread is created in lockd_create_svc(), the extra
reference can be dropped there.  So the 'serv' variable is no longer
needed in lockd_up().

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 20cebb191350f..91e7c839841ec 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -359,9 +359,6 @@ static int lockd_start_svc(struct svc_serv *serv)
 {
 	int error;
 
-	if (nlmsvc_rqst)
-		return 0;
-
 	/*
 	 * Create the kernel thread and wait for it to start.
 	 */
@@ -406,6 +403,7 @@ static const struct svc_serv_ops lockd_sv_ops = {
 static int lockd_create_svc(void)
 {
 	struct svc_serv *serv;
+	int error;
 
 	/*
 	 * Check whether we're already up and running.
@@ -432,6 +430,13 @@ static int lockd_create_svc(void)
 		printk(KERN_WARNING "lockd_up: create service failed\n");
 		return -ENOMEM;
 	}
+
+	error = lockd_start_svc(serv);
+	/* The thread now holds the only reference */
+	svc_put(serv);
+	if (error < 0)
+		return error;
+
 	nlmsvc_serv = serv;
 	register_inetaddr_notifier(&lockd_inetaddr_notifier);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -446,7 +451,6 @@ static int lockd_create_svc(void)
  */
 int lockd_up(struct net *net, const struct cred *cred)
 {
-	struct svc_serv *serv;
 	int error;
 
 	mutex_lock(&nlmsvc_mutex);
@@ -454,25 +458,19 @@ int lockd_up(struct net *net, const struct cred *cred)
 	error = lockd_create_svc();
 	if (error)
 		goto err_create;
-	serv = nlmsvc_serv;
 
-	error = lockd_up_net(serv, net, cred);
+	error = lockd_up_net(nlmsvc_serv, net, cred);
 	if (error < 0) {
 		goto err_put;
 	}
 
-	error = lockd_start_svc(serv);
-	if (error < 0) {
-		lockd_down_net(serv, net);
-		goto err_put;
-	}
 	nlmsvc_users++;
 err_put:
 	if (nlmsvc_users == 0) {
 		lockd_unregister_notifiers();
+		kthread_stop(nlmsvc_task);
 		nlmsvc_serv = NULL;
 	}
-	svc_put(serv);
 err_create:
 	mutex_unlock(&nlmsvc_mutex);
 	return error;
-- 
2.43.0



