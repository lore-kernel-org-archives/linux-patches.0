Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64791FBF;
	Tue, 23 Jan 2024 02:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975804; cv=none; b=nhx17kZfqLmbxMkOLZHKl0QIUB08cHxkTqDwei6EkSfzKRAoAFflZB76TjzmS9cBx286h2C4wwa9cAp90t8nHCZ88xVqvriNc6oU1MIufhYsJcYCk5XgW9qElqG8qb4SGiOwhifl3OqW5TUjHtctCwzP3dBL30Qor+ufjtf7D8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975804; c=relaxed/simple;
	bh=vBK5WmC558aC6lrbU6ZApHu7YWx0Yf4CS3fBZalpODs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=asxOzhSOFUv4vjR9HiyIj1jiKSpIM/rL5DHMQDRAVr+zjltmW9CPVr2sMoxuO4HZ9WJSNynqt/gWPGXLxelatWloTaCaiVBbwg1ssLu/uppG/dZ1i0iOUTxNghAhA9eIoaLixaXcnwVksoTtC0t8CJWJSutseSTY0IzjC0W5vCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRIumtC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRIumtC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8767BC433F1;
	Tue, 23 Jan 2024 02:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975804;
	bh=vBK5WmC558aC6lrbU6ZApHu7YWx0Yf4CS3fBZalpODs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRIumtC0xVjXpWi7bNef5bUXpkxy3gu2cKMSss907U9NT28DArF6a1vH0YjezY1xv
	 H0TlLF/vw3Vp62pJ351UqrlYuOiPHxy1/FgbHPsf/JJDX4xhRCNTpzoScP7pL5l9+I
	 WAuRD/lyr72ZCbnLd6HXgiJ1x62jrVitXDc8Elrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ludvig=20P=C3=A4rsson?= <ludvig.parsson@axis.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 573/583] ethtool: netlink: Add missing ethnl_ops_begin/complete
Date: Mon, 22 Jan 2024 16:00:24 -0800
Message-ID: <20240122235829.725573707@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludvig Pärsson <ludvig.parsson@axis.com>

[ Upstream commit f1172f3ee3a98754d95b968968920a7d03fdebcc ]

Accessing an ethernet device that is powered off or clock gated might
cause the CPU to hang. Add ethnl_ops_begin/complete in
ethnl_set_features() to protect against this.

Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET request")
Signed-off-by: Ludvig Pärsson <ludvig.parsson@axis.com>
Link: https://lore.kernel.org/r/20240117-etht2-v2-1-1a96b6e8c650@axis.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/features.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index a79af8c25a07..b6cb101d7f19 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -234,17 +234,20 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	dev = req_info.dev;
 
 	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
 	ethnl_features_to_bitmap(old_active, dev->features);
 	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
 	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
 				 tb[ETHTOOL_A_FEATURES_WANTED],
 				 netdev_features_strings, info->extack);
 	if (ret < 0)
-		goto out_rtnl;
+		goto out_ops;
 	if (ethnl_bitmap_to_features(req_mask) & ~NETIF_F_ETHTOOL_BITS) {
 		GENL_SET_ERR_MSG(info, "attempt to change non-ethtool features");
 		ret = -EINVAL;
-		goto out_rtnl;
+		goto out_ops;
 	}
 
 	/* set req_wanted bits not in req_mask from old_wanted */
@@ -281,6 +284,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	if (mod)
 		netdev_features_change(dev);
 
+out_ops:
+	ethnl_ops_complete(dev);
 out_rtnl:
 	rtnl_unlock();
 	ethnl_parse_header_dev_put(&req_info);
-- 
2.43.0



