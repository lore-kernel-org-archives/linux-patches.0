Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2F15187E5;
	Thu, 17 Sep 2026 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667007; cv=none; b=NwfcOqli8btRnUAKbuw99Io+FowGAcrYwmcRN5AeqqKqBs6UmspZ6XtPYaX4Cg8hIfF1Ca3mjSS0e74lLSHtSxh2TZjn+iZJt7jKqx6X1vxkcsUw6ostPtehM0DbSPlkbKVEOYxIa0TKrm/TbIQ8kmx+yRPs1E2FcV/BkDG8GN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667007; c=relaxed/simple;
	bh=fEJNZiiBRB6M/DMceE3TRGgBsKRrspPxe9rc/Kxoi9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTIWuTmBLBvRhW6HeAmEVgw780z4vLazFh3uTGw1Gavn6AXLsuwah+EJdc4b1Jh3z0JipPnwwtVrueixEKesZ6YpVk9oOmq25NtTWx3sQy930+bKqS/3h2yqgFCaWr4fGohEoNxBWJ67zGx68iXcnNogHFxvIA3pm5W17WXnza0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+WCuldW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+WCuldW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520501F0089C;
	Thu, 17 Sep 2026 17:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667005;
	bh=GhZ2/PbnCz0VQxmBRaBF2VPHXUGDcIvYhOvI1WtufmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+WCuldW0x2X6MuVsvLmpMM1grNe7q27OEclWVA2xTQLHCMxqcnm9jPIapLS6BeKZ
	 yUAYPsPDk7Bq9UfRzR5lKvjNNuWUYFchXKA9DJ463ci0uNXj9rrH8c8/cGTZ2Q+BP2
	 uxLRLVbs/LjaUgCmmOWgGgnnfqtLBuCgz4oUdb7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XingWang Xiang <v3rdant.xiang@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1198/1250] genetlink: pin family module during policy dump
Date: Thu, 17 Sep 2026 16:16:33 +0100
Message-ID: <20260917151624.757096312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/genetlink.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1514,6 +1514,7 @@ struct ctrl_dump_policy_ctx {
 	struct netlink_policy_dump_state *state;
 	const struct genl_family *rt;
 	struct genl_op_iter *op_iter;
+	struct module *owner;
 	u32 op;
 	u16 fam_id;
 	u8 dump_map:1,
@@ -1556,6 +1557,9 @@ static int ctrl_dumppolicy_start(struct
 		return -ENOENT;
 
 	ctx->rt = rt;
+	ctx->owner = rt->module;
+	if (!try_module_get(ctx->owner))
+		return -ENOENT;
 
 	if (tb[CTRL_ATTR_OP]) {
 		struct genl_split_ops doit, dump;
@@ -1566,7 +1570,7 @@ static int ctrl_dumppolicy_start(struct
 		err = genl_get_cmd_both(ctx->op, rt, &doit, &dump);
 		if (err) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
-			return err;
+			goto err_put_owner;
 		}
 
 		if (doit.policy) {
@@ -1584,16 +1588,20 @@ static int ctrl_dumppolicy_start(struct
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
@@ -1625,6 +1633,8 @@ err_free_state:
 	netlink_policy_dump_free(ctx->state);
 err_free_op_iter:
 	kfree(ctx->op_iter);
+err_put_owner:
+	module_put(ctx->owner);
 	return err;
 }
 
@@ -1761,6 +1771,7 @@ static int ctrl_dumppolicy_done(struct n
 
 	kfree(ctx->op_iter);
 	netlink_policy_dump_free(ctx->state);
+	module_put(ctx->owner);
 	return 0;
 }
 


