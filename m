Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE1E57F75C;
	Wed,  9 Sep 2026 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964644; cv=none; b=Qn0wN2qwT9VzznJMnWTu6lhNadAQlYzb9jwepOOx39zpxrjrRwMcG1H8mmUmW0NoNjOnoTwSzhMfsAxr3Ds+S4SsDVYt3+jzrySyCC9Un6Dt3MyDgAkcIGZXmEzRnY90BwM2OKDzQVtafkW137WVDiFR/IIRVvcoNMCCzojnZo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964644; c=relaxed/simple;
	bh=3xmb+nSmop0rTejJ2bomPGzv3PVasploJsuK0N7XgxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3lAnuc9HYSwY0t8Tq8NhunI8f2d5PCWdcvtZSgJvztD2678nxCOhMA+lfpY4oHskRJ7Piwzx38Sftn7myg0v5GbE9f63eKj/rHrD/CLDNzisPwEAz9V8txGq3FT2E3zsTDcUpknkb804AanIRl9hqfcVmbglpHxNt4fOxUqMX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8rJXO9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8rJXO9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D771F00A3A;
	Wed,  9 Sep 2026 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964643;
	bh=4JywH0cuE857L4Ao6ZgOZYxmuifdTTW9QHrBcLrdyvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8rJXO9V8e3OEsPWwyJh5kCHNNO221c6W80d9vtYOKEaztZCuRgKOQk5Si438GgJd
	 cy3wmJ1cwDYdLFSxOlKtqsz6ieO2wsVHAm3+Tm+lzGxyj/UNxYbngtKzq42zKR43P6
	 E8byb6/cGuZLv5LDDWtEkRvRrTTxB68KSrG9052M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 494/583] rpcrdma: arm rn_done before publishing the notification
Date: Wed,  9 Sep 2026 15:42:59 +0200
Message-ID: <20260909134254.904676962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5b06f706374c37375bdff9d21cc10e61df925a92 ]

rpcrdma_rn_register() inserts @rn into rd_xa with xa_alloc() before
storing the caller's callback in rn->rn_done. The xarray makes @rn
reachable to rpcrdma_remove_one(), which walks rd_xa and invokes
rn->rn_done(rn) for every registered notification. A device removal
that races a fresh registration can therefore observe @rn with
rn_done still NULL, because the notification objects are zero
allocated by their owners, and call through a NULL function pointer.

Store rn->rn_done before xa_alloc() publishes @rn. The xarray's
store-side and load-side ordering then guarantees that any CPU which
finds @rn in rd_xa also observes the armed callback.

rpcrdma_rn_unregister() treats a non-NULL rn_done as the sentinel
for a completed registration, so the early store must not survive a
failed registration. Clear rn_done again when xa_alloc() fails.
Were it left set, the failed-accept cleanup path would call
rpcrdma_rn_unregister() on an @rn that was never inserted, erasing
an unrelated rd_xa slot and underflowing rd_kref.

Fixes: 7e86845a0346 ("rpcrdma: Implement generic device removal")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260601201703.46078-1-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/ib_client.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/net/sunrpc/xprtrdma/ib_client.c
+++ b/net/sunrpc/xprtrdma/ib_client.c
@@ -52,8 +52,8 @@ static struct rpcrdma_device *rpcrdma_ge
  * is unregistered first.
  *
  * On failure, a negative errno is returned. rn->rn_done is left
- * NULL on every failure path (it is assigned only after xa_alloc
- * and kref_get have both succeeded), so the @rn may safely be
+ * NULL on every failure path (it is armed before xa_alloc but
+ * cleared again if xa_alloc fails), so the @rn may safely be
  * passed to rpcrdma_rn_unregister() without a separate
  * registered/unregistered flag in the caller.
  */
@@ -66,10 +66,21 @@ int rpcrdma_rn_register(struct ib_device
 	if (!rd || test_bit(RPCRDMA_RD_F_REMOVING, &rd->rd_flags))
 		return -ENETUNREACH;
 
-	if (xa_alloc(&rd->rd_xa, &rn->rn_index, rn, xa_limit_32b, GFP_KERNEL) < 0)
+	/*
+	 * Arm rn_done before xa_alloc() publishes @rn: once @rn is
+	 * visible in rd_xa, a concurrent rpcrdma_remove_one() can
+	 * call rn->rn_done(), so the pointer must already be set.
+	 *
+	 * Restore NULL if xa_alloc() fails. rn_done doubles as the
+	 * registration sentinel for rpcrdma_rn_unregister(); a stale
+	 * value would unregister an @rn that was never inserted.
+	 */
+	rn->rn_done = done;
+	if (xa_alloc(&rd->rd_xa, &rn->rn_index, rn, xa_limit_32b, GFP_KERNEL) < 0) {
+		rn->rn_done = NULL;
 		return -ENOMEM;
+	}
 	kref_get(&rd->rd_kref);
-	rn->rn_done = done;
 	trace_rpcrdma_client_register(device, rn);
 	return 0;
 }
@@ -102,8 +113,9 @@ void rpcrdma_rn_unregister(struct ib_dev
 
 	/*
 	 * rn_done is the registration sentinel: rpcrdma_rn_register
-	 * assigns it last, after xa_alloc and kref_get have both
-	 * succeeded. A NULL rn_done means this notification was
+	 * leaves it NULL on every failure path, clearing it again if
+	 * xa_alloc fails, so a non-NULL rn_done marks a completed
+	 * registration. A NULL rn_done means this notification was
 	 * never registered (or its registration failed) or has
 	 * already been unregistered, and the call is a no-op.
 	 * Without this guard, rn_index == 0 from a kzalloc'd


