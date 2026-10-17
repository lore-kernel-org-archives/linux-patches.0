Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE35B18787A;
	Sat, 17 Oct 2026 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255826; cv=none; b=bqH9XkyXtqxoP92ApWbiP8FWYrWey4UOxvumOpg1KsjEGj9gspqy+VOCkY9O49oPcPVJoSnTHjh3LZGCuPwQ2Ejhui2ENsdqhlYx9HR6Gw7lYaUDCF81Jcriw0IjxC9EJ1O07eeWMUbNZISdvPmilIeE6YZj0cCxYVqkeqKR+Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255826; c=relaxed/simple;
	bh=8zC0ERMg38wIYAgW0oClsD3+EUAPBS8fVCulCPyIJAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvL9U9KDnEz9aJi3nOzMqPIt9fE4JzzxQNltJYc7r8zyfugrMG8Ev/Uq2dC0x/FiMuArwvTgrW/5H0tCJmeME1euBJDPVgNIMRvn6WoRYSYceXCwD+ZW7DQqmpWEY1G+hKBaUosD9sRe/MPa+PobreaWPRnlFrQ0w7FRSRz1CmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIufp/7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIufp/7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064051F000C5;
	Sat, 17 Oct 2026 16:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255825;
	bh=D2cekqi2W30xz9hbqHWV4ohnvY3Epb0vbmpelK/GkbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIufp/7da4aDFlzivKS/8+frBo1HfPLKz42rlMLV71Hnl5c35QzPpMKSVPMHrjaXm
	 F2rD3WqxAIXH3Fe9rkTy9CL9ZsEwEtJJKVd1UF8VkGw+3fW5Vcl8e4oFZFRlnDcceP
	 M1wdlo2yEo2UIv/1W5dMKooBcb70+UQd6y4mJKPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XingWang Xiang <v3rdant.xiang@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0035/1674] genetlink: pin family module during policy dump
Date: Sat, 17 Oct 2026 17:38:27 +0200
Message-ID: <20261017160432.041115908@linuxfoundation.org>
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

From: XingWang Xiang <v3rdant.xiang@gmail.com>

[ Upstream commit 6a1094c34d176827b2b173e163dcc964a13af93f ]

The generic netlink controller's policy dump keeps pointers to the target
family's operation and policy tables in its callback state.  A dump may be
split across multiple skbs and remain pending after the initial request.

Netlink pins the module which owns the dump callback, but in this case
that is the controller's owner rather than the target family's owner.  The
target family can consequently be unregistered and its module unloaded
while a policy dump is pending.  Advancing the dump then dereferences
policy memory from the unloaded module.

Take a reference to the target family's module when the dump starts.
Drop it from the error and done paths.  This matches the lifetime for which
the dump context retains the family and policy pointers.

Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: XingWang Xiang <v3rdant.xiang@gmail.com>
Link: https://patch.msgid.link/20260902084317.4092542-1-v3rdant.xiang@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjusted context to retain kmalloc(sizeof(*ctx->op_iter), GFP_KERNEL) instead of kmalloc_obj(*ctx->op_iter). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/genetlink.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 015b14b852f84..563ede127b6b3 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1368,6 +1368,7 @@ struct ctrl_dump_policy_ctx {
 	struct netlink_policy_dump_state *state;
 	const struct genl_family *rt;
 	struct genl_op_iter *op_iter;
+	struct module *owner;
 	u32 op;
 	u16 fam_id;
 	u8 dump_map:1,
@@ -1410,6 +1411,9 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		return -ENOENT;
 
 	ctx->rt = rt;
+	ctx->owner = rt->module;
+	if (!try_module_get(ctx->owner))
+		return -ENOENT;
 
 	if (tb[CTRL_ATTR_OP]) {
 		struct genl_split_ops doit, dump;
@@ -1420,7 +1424,7 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		err = genl_get_cmd_both(ctx->op, rt, &doit, &dump);
 		if (err) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
-			return err;
+			goto err_put_owner;
 		}
 
 		if (doit.policy) {
@@ -1438,16 +1442,20 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 				goto err_free_state;
 		}
 
-		if (!ctx->state)
-			return -ENODATA;
+		if (!ctx->state) {
+			err = -ENODATA;
+			goto err_put_owner;
+		}
 
 		ctx->dump_map = 1;
 		return 0;
 	}
 
 	ctx->op_iter = kmalloc(sizeof(*ctx->op_iter), GFP_KERNEL);
-	if (!ctx->op_iter)
-		return -ENOMEM;
+	if (!ctx->op_iter) {
+		err = -ENOMEM;
+		goto err_put_owner;
+	}
 
 	genl_op_iter_init(rt, ctx->op_iter);
 	ctx->dump_map = genl_op_iter_next(ctx->op_iter);
@@ -1479,6 +1487,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	netlink_policy_dump_free(ctx->state);
 err_free_op_iter:
 	kfree(ctx->op_iter);
+err_put_owner:
+	module_put(ctx->owner);
 	return err;
 }
 
@@ -1617,6 +1627,7 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
 
 	kfree(ctx->op_iter);
 	netlink_policy_dump_free(ctx->state);
+	module_put(ctx->owner);
 	return 0;
 }
 
-- 
2.53.0



