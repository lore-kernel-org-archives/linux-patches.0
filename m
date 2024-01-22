Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6853150A75;
	Tue, 23 Jan 2024 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970389; cv=none; b=ljMH1lvXl2p0xChEiv5VWcjCdaqBzULsrJJGmRt0rnzHeMVa0MOUo9vfVMbb4h6Ev+2ndSZG0ccZjKOiMZn9WxETyjOk8j69lIQsLp+UMqqqjVTFmfQNDGUnHxmlGNlAy5JhWiOd7td6NVp8UvNBQm/4ci6C2nbjaOOIzaOEvCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970389; c=relaxed/simple;
	bh=qt06AEzndtFWNw/11YLickqloyK+Z7K4H33TyO2uU98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYeO+B5nMq99+/VPE7zYj9eqD5ykft7X0A3afd8RLb0IgyZf7t4amyjt5k6R7Vs2xp2lHpp9fz/ddJ9wTpBxeWxMIKlWktzk4ei21uKatJqFnmnB9Ke1vUW5WZLI0XfX2Qm3VDX8GRRu+H7IByS7X15DcpvRFp7nribwAOM8muU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELF7YSp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELF7YSp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C005BC433F1;
	Tue, 23 Jan 2024 00:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970389;
	bh=qt06AEzndtFWNw/11YLickqloyK+Z7K4H33TyO2uU98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELF7YSp18SPIXigfdNWnk2dPY8ZdkILFKNL+uvdsG3I5DkShrVM5d/n/i0Mi35PiA
	 4zIxnf+tSbqIsUp2lyGloHwdVNKdSgT2Z0csWvBNozPQ3EyKpDn5fKjIxN6poJz4VY
	 fRDbTdEBbp5MzhSqYoH06iuOIxHENVxv1c1VT1Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ludvig=20P=C3=A4rsson?= <ludvig.parsson@axis.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 632/641] ethtool: netlink: Add missing ethnl_ops_begin/complete
Date: Mon, 22 Jan 2024 15:58:56 -0800
Message-ID: <20240122235838.051842301@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



