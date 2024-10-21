Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EA51EABD4;
	Mon, 21 Oct 2024 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507307; cv=none; b=BdFDfr/XsUjPt4DM2eXMUCKy2IamZup6oq+0+Yum6qLLVwqOfcIN+qHsWDYn9C/ctXfxwJDZLT33XC1EOlhCLzbZ9QFgvypl+0Lbj+naQHeDcxvhv90VCTl8S10dgAxQsELcbhgbLAKl15L/wv3/LoYWxsUgCgh5B8MN2s4ENlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507307; c=relaxed/simple;
	bh=AQlfZEGWnmhPQ3PicZ0mHQoAQVP5Z1TYCrt0B3+OVQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoE13GEpDB6rn739BcCd1ot47bpWCisouJcs6wbRbErliujAFth2qPWp10TxRvHJSD+kw2z8wCrwAIyyUkKWn7Q5ktZxc6f+FnirHU50/Pf48DulvwsaucUkWiFxD9S90ZSUokX+BT1ixFZEm5bkTTxn3cM9EaggXxomGNE1puY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6YAw0w0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6YAw0w0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8FBC4CEC3;
	Mon, 21 Oct 2024 10:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507307;
	bh=AQlfZEGWnmhPQ3PicZ0mHQoAQVP5Z1TYCrt0B3+OVQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6YAw0w0p1BnXM2MEXdUziHi85SPaY+XpXluMZHE9BNOEY3Zqt2mUmGJBkPN3+i6j
	 XGL0piC9jIG8MiFgi0L37L0BrQVIO3jp8/nqKhujrj2E6WctTv9XzshTLOeV9fWVrD
	 6tst9IW3OKPSRMT8LuYBUBMqrNLrUMA7tIasV+fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH 6.1 34/91] devlink: drop the filter argument from devlinks_xa_find_get
Date: Mon, 21 Oct 2024 12:24:48 +0200
Message-ID: <20241021102251.155479379@linuxfoundation.org>
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

commit 8861c0933c78e3631fe752feadc0d2a6e5eab1e1 upstream.

Looks like devlinks_xa_find_get() was intended to get the mark
from the @filter argument. It doesn't actually use @filter, passing
DEVLINK_REGISTERED to xa_find_fn() directly. Walking marks other
than registered is unlikely so drop @filter argument completely.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Ido: Moved the changes from core.c and devl_internal.h to leftover.c ]
Stable-dep-of: d77278196441 ("devlink: bump the instance index directly when iterating")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/devlink/leftover.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -289,7 +289,7 @@ void devl_unlock(struct devlink *devlink
 EXPORT_SYMBOL_GPL(devl_unlock);
 
 static struct devlink *
-devlinks_xa_find_get(struct net *net, unsigned long *indexp, xa_mark_t filter,
+devlinks_xa_find_get(struct net *net, unsigned long *indexp,
 		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
 					  unsigned long, xa_mark_t))
 {
@@ -322,30 +322,25 @@ unlock:
 }
 
 static struct devlink *devlinks_xa_find_get_first(struct net *net,
-						  unsigned long *indexp,
-						  xa_mark_t filter)
+						  unsigned long *indexp)
 {
-	return devlinks_xa_find_get(net, indexp, filter, xa_find);
+	return devlinks_xa_find_get(net, indexp, xa_find);
 }
 
 static struct devlink *devlinks_xa_find_get_next(struct net *net,
-						 unsigned long *indexp,
-						 xa_mark_t filter)
+						 unsigned long *indexp)
 {
-	return devlinks_xa_find_get(net, indexp, filter, xa_find_after);
+	return devlinks_xa_find_get(net, indexp, xa_find_after);
 }
 
 /* Iterate over devlink pointers which were possible to get reference to.
  * devlink_put() needs to be called for each iterated devlink pointer
  * in loop body in order to release the reference.
  */
-#define devlinks_xa_for_each_get(net, index, devlink, filter)			\
-	for (index = 0,								\
-	     devlink = devlinks_xa_find_get_first(net, &index, filter);		\
-	     devlink; devlink = devlinks_xa_find_get_next(net, &index, filter))
-
 #define devlinks_xa_for_each_registered_get(net, index, devlink)		\
-	devlinks_xa_for_each_get(net, index, devlink, DEVLINK_REGISTERED)
+	for (index = 0,								\
+	     devlink = devlinks_xa_find_get_first(net, &index);	\
+	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
 
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)


