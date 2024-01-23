Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9A863400;
	Tue, 23 Jan 2024 01:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975082; cv=none; b=O7KwFqBLd0d2PvAcWGGhfvYg+dfp2EUMH218H/lKh1dV1r/2qXDv+ydSMf5Q41ZpQeR2qDWwOXcjUX6dTFXu4JTCQ76ryILhfgphGE10MMYsFPSl3Nr4TGce/shRgXiSlFZFaAs0pk2ahITLwQHIvsx+iDkDMLYCyzR/5fDBBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975082; c=relaxed/simple;
	bh=A4qta6Q9iaSe5lYq3ilwUOYYfFbCJWDcwF1lcVTh37E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tIi+ANWicmVddihrS5pNXV2qCvRasES+5JxhnPfP2GRPHKXmGCoAgOnloR9Tp99dyApiwj3Fob6V1FcCHULD+YJvqwHcLtu69sJjSgAD53s/CAXYJHowEyLe4tTmDrZdgZg2jswe+5QpWquc48m51dNE8OUTX4MT4IwAiXyCLwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUyeLxec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUyeLxec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C48C433C7;
	Tue, 23 Jan 2024 01:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975082;
	bh=A4qta6Q9iaSe5lYq3ilwUOYYfFbCJWDcwF1lcVTh37E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUyeLxec+2P/XOJOrOtKu9bU6nb09vUCkgAvSrUjgFylDPI7B3ryFrFp9beY1RPdN
	 poitwrBBcyKdkgYZ7XjfDAf0gtxdpeB8GjPVbmdh7SGX4RRt8btKOUziJoDbaXrUSR
	 dsMhMoNM0rOHB1/s5iANW1aFkTeUKtDrnl21SovM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ludvig=20P=C3=A4rsson?= <ludvig.parsson@axis.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 357/374] ethtool: netlink: Add missing ethnl_ops_begin/complete
Date: Mon, 22 Jan 2024 16:00:13 -0800
Message-ID: <20240122235757.366546902@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1c9f4df273bd..faccab84d865 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -235,17 +235,20 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
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
@@ -282,6 +285,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	if (mod)
 		netdev_features_change(dev);
 
+out_ops:
+	ethnl_ops_complete(dev);
 out_rtnl:
 	rtnl_unlock();
 	dev_put(dev);
-- 
2.43.0



