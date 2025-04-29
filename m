Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3621F244664;
	Tue, 29 Apr 2025 17:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948493; cv=none; b=bXHfhUeJfjXKCZgmgkSpt0gEDSUhNmMZ7/g5ZcOooQPNp+dH6We6gHBp6yxOHcDF3sunkv3ZJe04Fld87VLvyXtL+1GjAbmCfo47b2iugAarIZPpoy3xMux5KFPBeHaYzPewHzcPt2a8FCBBMglf1yXToZz6HEXzMboHol6lzRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948493; c=relaxed/simple;
	bh=tynQ6U8fgPcR+s94YcaAxfDc/H/JAgJ4Qjv8KchxAqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0J2V8S/hxghCOF2hjNatWoQ9/zdJ4Ws0jMI9ddauhV6k548xGA331vctKwF7zKM1icSPwskpzBzs4KlCh4Xf7M5ADvHkxQ54DEldLnmgNEDtkKOkd/KER+HEkYkNdt9+sT7GYmr0UdbnuNQvOT41pnwBAraTEAl3eWw9wotYfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9qs0mHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9qs0mHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD87C4CEE3;
	Tue, 29 Apr 2025 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948493;
	bh=tynQ6U8fgPcR+s94YcaAxfDc/H/JAgJ4Qjv8KchxAqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9qs0mHcgKAHliSIOxp/HZykYTI3X7hdiHrLdWtdFQEQCK/CQXgw2QJzjgFwvmd7C
	 TxPx3VAmkhxPtc78oq6zA/+fxkY0+vIuMl/kBGhos4OKQ2bNDcWAwhiZ7y0152Ul3k
	 tdkSazbNht6gHiqho8BMclnF1LT8musj5+MbysT4=
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
Subject: [PATCH 5.15 005/373] net: ethtool: Dont call .cleanup_data when prepare_data fails
Date: Tue, 29 Apr 2025 18:38:02 +0200
Message-ID: <20250429161123.357690537@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0ffcd0e873b60..e35a3e5736cfd 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -377,7 +377,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	ret = ops->prepare_data(req_info, reply_data, info);
 	rtnl_unlock();
 	if (ret < 0)
-		goto err_cleanup;
+		goto err_dev;
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
@@ -435,7 +435,7 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 	ret = ctx->ops->prepare_data(ctx->req_info, ctx->reply_data, NULL);
 	rtnl_unlock();
 	if (ret < 0)
-		goto out;
+		goto out_cancel;
 	ret = ethnl_fill_reply_header(skb, dev, ctx->ops->hdr_attr);
 	if (ret < 0)
 		goto out;
@@ -444,6 +444,7 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 out:
 	if (ctx->ops->cleanup_data)
 		ctx->ops->cleanup_data(ctx->reply_data);
+out_cancel:
 	ctx->reply_data->dev = NULL;
 	if (ret < 0)
 		genlmsg_cancel(skb, ehdr);
@@ -628,7 +629,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	ethnl_init_reply_data(reply_data, ops, dev);
 	ret = ops->prepare_data(req_info, reply_data, NULL);
 	if (ret < 0)
-		goto err_cleanup;
+		goto err_rep;
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
@@ -664,6 +665,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 err_cleanup:
 	if (ops->cleanup_data)
 		ops->cleanup_data(reply_data);
+err_rep:
 	kfree(reply_data);
 	kfree(req_info);
 	return;
-- 
2.39.5



