Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB41381BA;
	Wed, 23 Apr 2025 14:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420021; cv=none; b=ZlyNEYHgiJe8w5//9C/jQ92wDoromCT+dygkZXnfLbw1ZjkRHeWIdZFHpFmP2GSF6n4YSZTV29sZyClIcAHrTwC1RMMxA2AftfL+nKVrffDaSPACtgbZLqohlGNebVFluw8DXOSMS+PDZtn4KQ2E1gIz6LKwpoQdZRL8GMy1XCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420021; c=relaxed/simple;
	bh=+6R7jy++AODK32EdpUccDLuD9pjfe0GohYW8BsuCfmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2PAXHoWQpZJMQJw7/Ev7+CpfS9SmCxpsSsN4np4kH0pqKPVPyizBKY2qQa2ILHbCkdDoV1Yymc0H9wrekjNN6+jp2iqTeNNq8uEL+Gh1OUm0SXpvDac0NIFafGV1jHddD5BQliApkQog7eYDqmkIFDYrOrqXDOfkV7P0H7pzJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNORmj1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNORmj1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91185C4CEE2;
	Wed, 23 Apr 2025 14:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420020;
	bh=+6R7jy++AODK32EdpUccDLuD9pjfe0GohYW8BsuCfmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNORmj1+K/8mxzKTUPbcIRpyCOWWToXwKnRv/JhqpuIzDm7uXJmmsI8EJVKCANRNa
	 kvfcJW5mS9vSyT+8gA9olzbOcuHfO2pa50ljFq6Pxa8F4TbYXIbQ5ca5J3+7UY+zzv
	 wCVxJfOqYy97wBt/4eijiW4/wQGxY5aVmVRROtLY=
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
Subject: [PATCH 6.1 010/291] net: ethtool: Dont call .cleanup_data when prepare_data fails
Date: Wed, 23 Apr 2025 16:39:59 +0200
Message-ID: <20250423142624.829914585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e5efdf2817eff..98c0641138825 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -384,7 +384,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	ret = ops->prepare_data(req_info, reply_data, info);
 	rtnl_unlock();
 	if (ret < 0)
-		goto err_cleanup;
+		goto err_dev;
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
@@ -442,7 +442,7 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 	ret = ctx->ops->prepare_data(ctx->req_info, ctx->reply_data, NULL);
 	rtnl_unlock();
 	if (ret < 0)
-		goto out;
+		goto out_cancel;
 	ret = ethnl_fill_reply_header(skb, dev, ctx->ops->hdr_attr);
 	if (ret < 0)
 		goto out;
@@ -451,6 +451,7 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 out:
 	if (ctx->ops->cleanup_data)
 		ctx->ops->cleanup_data(ctx->reply_data);
+out_cancel:
 	ctx->reply_data->dev = NULL;
 	if (ret < 0)
 		genlmsg_cancel(skb, ehdr);
@@ -636,7 +637,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	ethnl_init_reply_data(reply_data, ops, dev);
 	ret = ops->prepare_data(req_info, reply_data, NULL);
 	if (ret < 0)
-		goto err_cleanup;
+		goto err_rep;
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
@@ -671,6 +672,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 err_cleanup:
 	if (ops->cleanup_data)
 		ops->cleanup_data(reply_data);
+err_rep:
 	kfree(reply_data);
 	kfree(req_info);
 	return;
-- 
2.39.5



