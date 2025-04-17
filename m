Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F4C25742E;
	Thu, 17 Apr 2025 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912475; cv=none; b=R1vGbY5qktVVj/y3ZI7fC4g7mYLlCwru78UAoRsUC5B6qPWv0Zvyb+Cbj4aoeFyBH5joNg1wHsHRExRmnEF1dexm+3l9ocWX4tKIuUvNYt6r8epLU575jpP8m64YPTbt72mT+XHLTxlVBJEKmAqO8H810M5bu9iwMLHnPXbfHs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912475; c=relaxed/simple;
	bh=/eIucftY0VM6lhdHnEc4ZR3/mQksX9uzng4P5nOxnCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmF7AQ8fLNywWHpKk9EdlRPC/G43vtFFlFj1ySOjd/uL6k5VB7woMj29m/kczG1NEWgpwXX9Yz/dqbOeoEhWAE+pvSSOwHR1P15Zk3IDDiiahf9GiklDq+emsm5HSbbuUruflVP7JR+9HEFejFmIkd9JLYeqOHQPGgVOgt1EvaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bp0RP/3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bp0RP/3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA040C4CEE4;
	Thu, 17 Apr 2025 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912475;
	bh=/eIucftY0VM6lhdHnEc4ZR3/mQksX9uzng4P5nOxnCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bp0RP/3Pz/Qz3zBycT+o62DU6Ud2H/h+euUndQDanmEyoY3bvgbW8n96DDJ6GlmyV
	 qKyl5G8bMisUM0I6ThQ8jf/zWzR5YKXNdllIi+2v1yx4irdrIHzAlxkgS1M9HHMVK7
	 9wGZSm4U+xtRk+HQSDXREmjMpeQMruBxjNAMTHPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Michal Kubecek <mkubecek@suse.cz>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 022/449] net: ethtool: Dont call .cleanup_data when prepare_data fails
Date: Thu, 17 Apr 2025 19:45:10 +0200
Message-ID: <20250417175118.881561257@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 4f038a6a02d20859a3479293cbf172b0f14cbdd6 ]

There's a consistent pattern where the .cleanup_data() callback is
called when .prepare_data() fails, when it should really be called to
clean after a successful .prepare_data() as per the documentation.

Rewrite the error-handling paths to make sure we don't cleanup
un-prepared data.

Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250407130511.75621-1-maxime.chevallier@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/netlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 734849a573691..e088a30d1dd26 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -493,7 +493,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	ret = ops->prepare_data(req_info, reply_data, info);
 	rtnl_unlock();
 	if (ret < 0)
-		goto err_cleanup;
+		goto err_dev;
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
@@ -551,7 +551,7 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 	ret = ctx->ops->prepare_data(ctx->req_info, ctx->reply_data, info);
 	rtnl_unlock();
 	if (ret < 0)
-		goto out;
+		goto out_cancel;
 	ret = ethnl_fill_reply_header(skb, dev, ctx->ops->hdr_attr);
 	if (ret < 0)
 		goto out;
@@ -560,6 +560,7 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 out:
 	if (ctx->ops->cleanup_data)
 		ctx->ops->cleanup_data(ctx->reply_data);
+out_cancel:
 	ctx->reply_data->dev = NULL;
 	if (ret < 0)
 		genlmsg_cancel(skb, ehdr);
@@ -780,7 +781,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	ethnl_init_reply_data(reply_data, ops, dev);
 	ret = ops->prepare_data(req_info, reply_data, &info);
 	if (ret < 0)
-		goto err_cleanup;
+		goto err_rep;
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
@@ -815,6 +816,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 err_cleanup:
 	if (ops->cleanup_data)
 		ops->cleanup_data(reply_data);
+err_rep:
 	kfree(reply_data);
 	kfree(req_info);
 	return;
-- 
2.39.5



