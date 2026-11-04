Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827024;
	b=3/DmyyRsbnrFjNBI0CDv5i0eu+PMYFdeo25EO0jx27+0A6treF1lOpQnMpKc/D/hGzMf
	 89a9R1T3gtDYRE9WNFZN+BY4jLyi7UoX4ctZLfJ+z9wOvCGJWjDaaBcXXCeOgoKGP2XFf
	 xEyla7AxX7vOTPGXNVnYIcfx7vBR7Rvzwmd6nupDJcI4RfRqxa6CwIY8ggPppNo+oju4N
	 Re3yk5Vt28xS9xOvASqeOB2TRGzdqcLADkf3dsKFXU4BGKHew8fJm2BovPheqITUWipf6
	 /kULPnkWyoZBGQ/5RBHDnPdU38lGihUq/1KJehD5PmLMz5JJAqNT8wR1lpZQuLD6P4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ptqqpyAfD4vhW/hBgj6QX2AedPWcXh9cL98X4KtnJQ=;
	b=48KKYuWOBy1WRsIHmGpr65iB5GelibBo5Xhg2I+rrzJ7vp+6Mf1eDbPZJ0sE1JSGPz3T
	 aYzBP/kF/pSOagg1PgMxsAeHB9c3MXU/QxqOGGYd7/DPPg1QYFT6EXK8dlbcdp4DlEGQk
	 3KCqQi0FgmCRO6/qQSovnIoifyv05e5VJx0KY4Dynw4xfW/6jUm8HhjLyv605nqI9LdxO
	 E6ecK/Qp4aGaoQ3fWptaM03pQHhO36smKPSYnmzwY7PBWCgcUPmcFzdO87KaYASoDSRxy
	 0lrYpzJo3g61W0yNbPhjZtLGujZccRRoDt7Vs0/mLjAivsS+4iPdhFwM1E4ELA1Ei1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAIiZrsh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95390606A86B;
	Wed,  4 Nov 2026 21:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAIiZrsh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3023E1F00A02;
	Wed,  4 Nov 2026 21:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827024;
	bh=+ptqqpyAfD4vhW/hBgj6QX2AedPWcXh9cL98X4KtnJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAIiZrsh9GAPE07lW7t1GRHCr7Mvm+wg8I9v7Jn0I/fWvzB4NvS0FSvuLBcR0sRre
	 2E4rc6BoNjEEdghEWhLGAs6Tk3M2njQRMBGcFWU7tQgsR9c+LGimwSA4DeP9tjd8+g
	 kljyk+Sa/12LNTULaZPV0DByjEurPrZnl8yuSljU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.3 150/547] PM: EM: Fix use-after-free of perf domain in netlink doit handlers
Date: Wed,  4 Nov 2026 16:05:34 -0500
Message-ID: <20261104211042.426602251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit f58dacfbadb7be7c7dbb2b95e9341ad56710849e upstream.

The doit handlers dropped em_pd_list_mutex before dereferencing the
perf domain, so a concurrent device unregister could free it while the
reply was being built.

Encode the reply from em_perf_domain_for_id() callbacks, which run
under the mutex, and allocate the skb outside of it, like the dumpit
path already does.

This issue was found by an in-house static analysis tool.

Fixes: 380ff27af25e ("PM: EM: Add dump to get-perf-domains in the EM YNL spec")
Fixes: f2d2946eaa5c ("PM: EM: Implement em_nl_get_pd_table_doit()")
Cc: All applicable <stable@vger.kernel.org>
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260922081052.321581-1-fanwu01@zju.edu.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/em_netlink.c   |  122 +++++++++++++++++++++++++++-----------------
 kernel/power/em_netlink.h   |    8 +-
 kernel/power/energy_model.c |    8 +-
 3 files changed, 87 insertions(+), 51 deletions(-)

--- a/kernel/power/em_netlink.c
+++ b/kernel/power/em_netlink.c
@@ -95,41 +95,62 @@ static int __em_nl_get_pd_for_dump(struc
 	return ret;
 }
 
+struct em_nl_doit_ctx {
+	struct genl_info *info;
+	int cmd;
+	struct sk_buff *msg;
+};
+
+static int __em_nl_get_pd_doit_fill(struct em_perf_domain *pd, void *data)
+{
+	struct em_nl_doit_ctx *ctx = data;
+	void *hdr;
+
+	hdr = genlmsg_put_reply(ctx->msg, ctx->info, &dev_energymodel_nl_family, 0,
+				ctx->cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (__em_nl_get_pd(pd, ctx->msg)) {
+		genlmsg_cancel(ctx->msg, hdr);
+		return -EMSGSIZE;
+	}
+
+	genlmsg_end(ctx->msg, hdr);
+	return 0;
+}
+
 int dev_energymodel_nl_get_perf_domains_doit(struct sk_buff *skb,
-					      struct genl_info *info)
+					     struct genl_info *info)
 {
-	int id, ret = -EMSGSIZE, msg_sz = 0;
-	int cmd = info->genlhdr->cmd;
-	struct em_perf_domain *pd;
+	struct em_nl_doit_ctx ctx = {
+		.info = info,
+		.cmd = info->genlhdr->cmd,
+	};
 	struct sk_buff *msg;
-	void *hdr;
+	int id, ret, msg_sz = 0;
 
 	if (!info->attrs[DEV_ENERGYMODEL_A_PERF_DOMAIN_PERF_DOMAIN_ID])
 		return -EINVAL;
 
 	id = nla_get_u32(info->attrs[DEV_ENERGYMODEL_A_PERF_DOMAIN_PERF_DOMAIN_ID]);
-	pd = em_perf_domain_get_by_id(id);
-	if (!pd)
-		return -EINVAL;
 
-	__em_nl_get_pd_size(pd, &msg_sz);
+	/* Encode under em_pd_list_mutex, like the dumpit path. */
+	ret = em_perf_domain_for_id(id, __em_nl_get_pd_size, &msg_sz);
+	if (ret)
+		return ret;
+
 	msg = genlmsg_new(msg_sz, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	hdr = genlmsg_put_reply(msg, info, &dev_energymodel_nl_family, 0, cmd);
-	if (!hdr)
-		goto out_free_msg;
-
-	ret = __em_nl_get_pd(pd, msg);
+	ctx.msg = msg;
+	ret = em_perf_domain_for_id(id, __em_nl_get_pd_doit_fill, &ctx);
 	if (ret)
-		goto out_cancel_msg;
-	genlmsg_end(msg, hdr);
+		goto out_free_msg;
 
 	return genlmsg_reply(msg, info);
 
-out_cancel_msg:
-	genlmsg_cancel(msg, hdr);
 out_free_msg:
 	nlmsg_free(msg);
 	return ret;
@@ -148,19 +169,6 @@ int dev_energymodel_nl_get_perf_domains_
 	return for_each_em_perf_domain(__em_nl_get_pd_for_dump, &ctx);
 }
 
-static struct em_perf_domain *__em_nl_get_pd_table_id(struct nlattr **attrs)
-{
-	struct em_perf_domain *pd;
-	int id;
-
-	if (!attrs[DEV_ENERGYMODEL_A_PERF_TABLE_PERF_DOMAIN_ID])
-		return NULL;
-
-	id = nla_get_u32(attrs[DEV_ENERGYMODEL_A_PERF_TABLE_PERF_DOMAIN_ID]);
-	pd = em_perf_domain_get_by_id(id);
-	return pd;
-}
-
 static int __em_nl_get_pd_table_size(const struct em_perf_domain *pd)
 {
 	int id_sz, ps_sz;
@@ -245,34 +253,58 @@ out_err:
 	return -EMSGSIZE;
 }
 
+static int __em_nl_get_pd_table_size_cb(struct em_perf_domain *pd, void *data)
+{
+	*(int *)data = __em_nl_get_pd_table_size(pd);
+	return 0;
+}
+
+static int __em_nl_get_pd_table_doit_fill(struct em_perf_domain *pd,
+					  void *data)
+{
+	struct em_nl_doit_ctx *ctx = data;
+	void *hdr;
+
+	hdr = genlmsg_put_reply(ctx->msg, ctx->info, &dev_energymodel_nl_family, 0,
+				ctx->cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (__em_nl_get_pd_table(ctx->msg, pd))
+		return -EMSGSIZE;
+
+	genlmsg_end(ctx->msg, hdr);
+	return 0;
+}
+
 int dev_energymodel_nl_get_perf_table_doit(struct sk_buff *skb,
-					    struct genl_info *info)
+					   struct genl_info *info)
 {
-	int cmd = info->genlhdr->cmd;
-	int msg_sz, ret = -EMSGSIZE;
-	struct em_perf_domain *pd;
+	struct em_nl_doit_ctx ctx = {
+		.info = info,
+		.cmd = info->genlhdr->cmd,
+	};
 	struct sk_buff *msg;
-	void *hdr;
+	int id, ret, msg_sz;
 
-	pd = __em_nl_get_pd_table_id(info->attrs);
-	if (!pd)
+	if (!info->attrs[DEV_ENERGYMODEL_A_PERF_TABLE_PERF_DOMAIN_ID])
 		return -EINVAL;
 
-	msg_sz = __em_nl_get_pd_table_size(pd);
+	id = nla_get_u32(info->attrs[DEV_ENERGYMODEL_A_PERF_TABLE_PERF_DOMAIN_ID]);
+
+	ret = em_perf_domain_for_id(id, __em_nl_get_pd_table_size_cb, &msg_sz);
+	if (ret)
+		return ret;
 
 	msg = genlmsg_new(msg_sz, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	hdr = genlmsg_put_reply(msg, info, &dev_energymodel_nl_family, 0, cmd);
-	if (!hdr)
-		goto out_free_msg;
-
-	ret = __em_nl_get_pd_table(msg, pd);
+	ctx.msg = msg;
+	ret = em_perf_domain_for_id(id, __em_nl_get_pd_table_doit_fill, &ctx);
 	if (ret)
 		goto out_free_msg;
 
-	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
 
 out_free_msg:
--- a/kernel/power/em_netlink.h
+++ b/kernel/power/em_netlink.h
@@ -12,7 +12,8 @@
 #if defined(CONFIG_ENERGY_MODEL) && defined(CONFIG_NET)
 int for_each_em_perf_domain(int (*cb)(struct em_perf_domain*, void *),
 			    void *data);
-struct em_perf_domain *em_perf_domain_get_by_id(int id);
+int em_perf_domain_for_id(int id, int (*cb)(struct em_perf_domain *, void *),
+			  void *data);
 void em_notify_pd_created(const struct em_perf_domain *pd);
 void em_notify_pd_deleted(const struct em_perf_domain *pd);
 void em_notify_pd_updated(const struct em_perf_domain *pd);
@@ -24,9 +25,10 @@ int for_each_em_perf_domain(int (*cb)(st
 	return -EINVAL;
 }
 static inline
-struct em_perf_domain *em_perf_domain_get_by_id(int id)
+int em_perf_domain_for_id(int id, int (*cb)(struct em_perf_domain *, void *),
+			  void *data)
 {
-	return NULL;
+	return -EINVAL;
 }
 
 static inline void em_notify_pd_created(const struct em_perf_domain *pd) {}
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -1031,7 +1031,9 @@ int for_each_em_perf_domain(int (*cb)(st
 	return 0;
 }
 
-struct em_perf_domain *em_perf_domain_get_by_id(int id)
+/* Run @cb on the matching domain with em_pd_list_mutex held. */
+int em_perf_domain_for_id(int id, int (*cb)(struct em_perf_domain *, void *),
+			  void *data)
 {
 	struct em_perf_domain *pd;
 
@@ -1040,9 +1042,9 @@ struct em_perf_domain *em_perf_domain_ge
 
 	list_for_each_entry(pd, &em_pd_list, node) {
 		if (pd->id == id)
-			return pd;
+			return cb(pd, data);
 	}
 
-	return NULL;
+	return -EINVAL;
 }
 #endif


