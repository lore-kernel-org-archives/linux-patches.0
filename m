Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9701EF937;
	Mon, 21 Oct 2024 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507310; cv=none; b=k60955/B8xhVQ1kPID/FthVGWrblCzlAERElbUGS0vfmuw+Vyb6nRY4Djzjq8dSqmzqB0QTmDzzI/tcYutDywo4RNfwt7bT+2A6HLhrBhZtZ0Xc+kHWKfLuQx/cnQ68RZE756nLDew+y0b9t9mJBQGtifdUZk2z8/s5B/vPp83I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507310; c=relaxed/simple;
	bh=Pg8diUfVt5mEaXLyDv4sxdLQlPgdT+L2vtJst4JZukI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fY1NVlLy4WGHhwJ213lKELgMveBodTrXQ0fhT5Ot1rYEtKRdr1N2rbtsHLmmpIhaWZ0nn2aDfWwDZaAjvWshJyDLLnqS32+xBgR9+mo5iN1cbTrvinxWG4lMHrFUtH8fyDc+YgIcLJg+YFMpQY6rd2ZReDNWVwm4Fp9L6+z60Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tic6QMeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tic6QMeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04A1C4CEC3;
	Mon, 21 Oct 2024 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507310;
	bh=Pg8diUfVt5mEaXLyDv4sxdLQlPgdT+L2vtJst4JZukI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tic6QMebm1peU+yZbLVliRkkvcSAbYBqS/Imoq4Xy8MckSwwSF1dZ5h3f+R/QfuPA
	 lD7vp/iao8V8nTomgN1crxjlhdAUs7rDyEiqYj9Ix45zbWmMMMs0cBjw34J9o59MQ+
	 Faj03ZoZ256P4+1THT3d7mBWIo6jHSbZWPMFkDtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH 6.1 35/91] devlink: bump the instance index directly when iterating
Date: Mon, 21 Oct 2024 12:24:49 +0200
Message-ID: <20241021102251.193175399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit d772781964415c63759572b917e21c4f7ec08d9f upstream.

xa_find_after() is designed to handle multi-index entries correctly.
If a xarray has two entries one which spans indexes 0-3 and one at
index 4 xa_find_after(0) will return the entry at index 4.

Having to juggle the two callbacks, however, is unnecessary in case
of the devlink xarray, as there is 1:1 relationship with indexes.

Always use xa_find() and increment the index manually.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Ido: Moved the changes from core.c and devl_internal.h to leftover.c ]
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/devlink/leftover.c |   35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -289,15 +289,13 @@ void devl_unlock(struct devlink *devlink
 EXPORT_SYMBOL_GPL(devl_unlock);
 
 static struct devlink *
-devlinks_xa_find_get(struct net *net, unsigned long *indexp,
-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
-					  unsigned long, xa_mark_t))
+devlinks_xa_find_get(struct net *net, unsigned long *indexp)
 {
-	struct devlink *devlink;
+	struct devlink *devlink = NULL;
 
 	rcu_read_lock();
 retry:
-	devlink = xa_find_fn(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
+	devlink = xa_find(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
 	if (!devlink)
 		goto unlock;
 
@@ -306,31 +304,20 @@ retry:
 	 * This prevents live-lock of devlink_unregister() wait for completion.
 	 */
 	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
-		goto retry;
+		goto next;
 
-	/* For a possible retry, the xa_find_after() should be always used */
-	xa_find_fn = xa_find_after;
 	if (!devlink_try_get(devlink))
-		goto retry;
+		goto next;
 	if (!net_eq(devlink_net(devlink), net)) {
 		devlink_put(devlink);
-		goto retry;
+		goto next;
 	}
 unlock:
 	rcu_read_unlock();
 	return devlink;
-}
-
-static struct devlink *devlinks_xa_find_get_first(struct net *net,
-						  unsigned long *indexp)
-{
-	return devlinks_xa_find_get(net, indexp, xa_find);
-}
-
-static struct devlink *devlinks_xa_find_get_next(struct net *net,
-						 unsigned long *indexp)
-{
-	return devlinks_xa_find_get(net, indexp, xa_find_after);
+next:
+	(*indexp)++;
+	goto retry;
 }
 
 /* Iterate over devlink pointers which were possible to get reference to.
@@ -338,9 +325,7 @@ static struct devlink *devlinks_xa_find_
  * in loop body in order to release the reference.
  */
 #define devlinks_xa_for_each_registered_get(net, index, devlink)		\
-	for (index = 0,								\
-	     devlink = devlinks_xa_find_get_first(net, &index);	\
-	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
+	for (index = 0; (devlink = devlinks_xa_find_get(net, &index)); index++)
 
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)


