Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2928F7C6D4;
	Mon,  8 Apr 2024 13:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583256; cv=none; b=Y7nv0zVxnkd7KOxrBvapXfafzP4QuOd939hXnccfUBiq/WUwyNDB+UoIo0qc5tq7OI0i08HD7ExIybvqqaiZ9N8xgeQ+2pUi1B3mlKHNuBeCqpQJteiVVszhqvbaLuOzaQkJz6UU/33E0t6Q0Mizk/u3bhAmrgqbYUsANi+iK68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583256; c=relaxed/simple;
	bh=AH2FyjJh6rkgL+MQrh/MCMbNYb64wpnczM2p717jhxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nByIbBUWX2wRyBlI1x6/ETHPMxBSCy4aNGdgkQQS/pGXxs1NFuVJFwGhUvQtPtN+034XLeGkKBy4Kj0oKVVOBnq1B+wBf8RHuQDQgWKT6Y80bJoALxhqwQrfaUXWjSQJCqUkJfVO5TJrOGQQcIvburktbb8xg9tHT+/8QGmIE/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ypsObpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ypsObpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33C2C433C7;
	Mon,  8 Apr 2024 13:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583256;
	bh=AH2FyjJh6rkgL+MQrh/MCMbNYb64wpnczM2p717jhxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ypsObpID47dHj5TR1FjiThpBDR1CYjwcxyWbq/KkZexZHGjFLZmZcik7wwnkjJUB
	 zykEJUpsj4N8IzONjblY/qWGEXDLHOoacdnyODv1RiVzk4I6jkHzAPhDdVTH6ltCi5
	 1NgqxUFh9W2hVhMsqaO4xAzlEyaBiTIkuJvJQJCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 227/690] SUNRPC: change svc_get() to return the svc.
Date: Mon,  8 Apr 2024 14:51:33 +0200
Message-ID: <20240408125407.758712047@linuxfoundation.org>
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

[ Upstream commit df5e49c880ea0776806b8a9f8ab95e035272cf6f ]

It is common for 'get' functions to return the object that was 'got',
and there are a couple of places where users of svc_get() would be a
little simpler if svc_get() did that.

Make it so.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c             | 6 ++----
 fs/nfs/callback.c          | 6 ++----
 include/linux/sunrpc/svc.h | 3 ++-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index b220e1b917268..2f50d5b2a8a42 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -430,14 +430,12 @@ static struct svc_serv *lockd_create_svc(void)
 	/*
 	 * Check whether we're already up and running.
 	 */
-	if (nlmsvc_rqst) {
+	if (nlmsvc_rqst)
 		/*
 		 * Note: increase service usage, because later in case of error
 		 * svc_destroy() will be called.
 		 */
-		svc_get(nlmsvc_rqst->rq_server);
-		return nlmsvc_rqst->rq_server;
-	}
+		return svc_get(nlmsvc_rqst->rq_server);
 
 	/*
 	 * Sanity check: if there's no pid,
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 3c86a559a321a..674198e0eb5e1 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -266,14 +266,12 @@ static struct svc_serv *nfs_callback_create_svc(int minorversion)
 	/*
 	 * Check whether we're already up and running.
 	 */
-	if (cb_info->serv) {
+	if (cb_info->serv)
 		/*
 		 * Note: increase service usage, because later in case of error
 		 * svc_destroy() will be called.
 		 */
-		svc_get(cb_info->serv);
-		return cb_info->serv;
-	}
+		return svc_get(cb_info->serv);
 
 	switch (minorversion) {
 	case 0:
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 4813cc5613f27..80d44df8663db 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -120,9 +120,10 @@ struct svc_serv {
  * change the number of threads.  Horrible, but there it is.
  * Should be called with the "service mutex" held.
  */
-static inline void svc_get(struct svc_serv *serv)
+static inline struct svc_serv *svc_get(struct svc_serv *serv)
 {
 	serv->sv_nrthreads++;
+	return serv;
 }
 
 /*
-- 
2.43.0



