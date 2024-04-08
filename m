Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E12B81726;
	Mon,  8 Apr 2024 13:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583675; cv=none; b=AZ72q37TUQ0U2yM74TJ4baEwPjSBSP/rMv+hkXGSZ7xcWP7SXbC2lvyZLikOvTCcL+UDdo2XkYKaLMxIEOSBQsaJ8BD08S9WQsfx3XrC4o0haqj4/xljZOqvPB1NDFXIVOsljqmc55e508wlwRQ+88Wl1KHT+9E0RR+JFZOD6BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583675; c=relaxed/simple;
	bh=kYlvxuj6B0LPsvivweJ0Dnvq8DHg0ggXaexgb7oi63I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mq+n4OohIFSgJQx37hA9dc178VNIWl7WjnNNLGI3ogdEzjp+D1mVfw9KMS4YRRDD5DcGw3QPQGX2RmCFFPpDgFH/im0MvdghyOUM1yTXgdNrZfJtWmxy2g4P1U0EkOJKXE6zBJYi1aVl8odCvP8TVNlkmi08PHKfHj+zOoI3O6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjDZtlKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjDZtlKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71C1C433F1;
	Mon,  8 Apr 2024 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583675;
	bh=kYlvxuj6B0LPsvivweJ0Dnvq8DHg0ggXaexgb7oi63I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjDZtlKYr4A1FEe86PEJZhzeGj9x9EAjEqxposxnYhMyN6HE6AkNPR4GahTkUw8XH
	 1y7/OtP2wILKvQs62qe1S0ciKQNcto/EUoLOz9U9Utqvc3lbDDYi+Tz2UqvUMJwBz6
	 KalwbfDyF6XXKYkinbDrHQU9mg+gUUwYq4A1k4R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Brown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 273/690] SUNRPC: Merge svc_do_enqueue_xprt() into svc_enqueue_xprt()
Date: Mon,  8 Apr 2024 14:52:19 +0200
Message-ID: <20240408125409.518559441@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c0219c499799c1e92bd570c15a47e6257a27bb15 ]

Neil says:
"These functions were separated in commit 0971374e2818 ("SUNRPC:
Reduce contention in svc_xprt_enqueue()") so that the XPT_BUSY check
happened before taking any spinlocks.

We have since moved or removed the spinlocks so the extra test is
fairly pointless."

I've made this a separate patch in case the XPT_BUSY change has
unexpected consequences and needs to be reverted.

Suggested-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/sunrpc/svc_xprt.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 795dc8eb2e1d5..5a6d4ccb4a607 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -31,7 +31,6 @@ static int svc_deferred_recv(struct svc_rqst *rqstp);
 static struct cache_deferred_req *svc_defer(struct cache_req *req);
 static void svc_age_temp_xprts(struct timer_list *t);
 static void svc_delete_xprt(struct svc_xprt *xprt);
-static void svc_xprt_do_enqueue(struct svc_xprt *xprt);
 
 /* apparently the "standard" is that clients close
  * idle connections after 5 minutes, servers after
@@ -268,12 +267,12 @@ void svc_xprt_received(struct svc_xprt *xprt)
 	trace_svc_xprt_received(xprt);
 
 	/* As soon as we clear busy, the xprt could be closed and
-	 * 'put', so we need a reference to call svc_xprt_do_enqueue with:
+	 * 'put', so we need a reference to call svc_xprt_enqueue with:
 	 */
 	svc_xprt_get(xprt);
 	smp_mb__before_atomic();
 	clear_bit(XPT_BUSY, &xprt->xpt_flags);
-	svc_xprt_do_enqueue(xprt);
+	svc_xprt_enqueue(xprt);
 	svc_xprt_put(xprt);
 }
 EXPORT_SYMBOL_GPL(svc_xprt_received);
@@ -413,6 +412,8 @@ static bool svc_xprt_ready(struct svc_xprt *xprt)
 	smp_rmb();
 	xpt_flags = READ_ONCE(xprt->xpt_flags);
 
+	if (xpt_flags & BIT(XPT_BUSY))
+		return false;
 	if (xpt_flags & (BIT(XPT_CONN) | BIT(XPT_CLOSE)))
 		return true;
 	if (xpt_flags & (BIT(XPT_DATA) | BIT(XPT_DEFERRED))) {
@@ -425,7 +426,12 @@ static bool svc_xprt_ready(struct svc_xprt *xprt)
 	return false;
 }
 
-static void svc_xprt_do_enqueue(struct svc_xprt *xprt)
+/**
+ * svc_xprt_enqueue - Queue a transport on an idle nfsd thread
+ * @xprt: transport with data pending
+ *
+ */
+void svc_xprt_enqueue(struct svc_xprt *xprt)
 {
 	struct svc_pool *pool;
 	struct svc_rqst	*rqstp = NULL;
@@ -469,18 +475,6 @@ static void svc_xprt_do_enqueue(struct svc_xprt *xprt)
 	put_cpu();
 	trace_svc_xprt_do_enqueue(xprt, rqstp);
 }
-
-/*
- * Queue up a transport with data pending. If there are idle nfsd
- * processes, wake 'em up.
- *
- */
-void svc_xprt_enqueue(struct svc_xprt *xprt)
-{
-	if (test_bit(XPT_BUSY, &xprt->xpt_flags))
-		return;
-	svc_xprt_do_enqueue(xprt);
-}
 EXPORT_SYMBOL_GPL(svc_xprt_enqueue);
 
 /*
-- 
2.43.0



