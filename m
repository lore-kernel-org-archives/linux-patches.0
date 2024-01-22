Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B322913EFF3;
	Tue, 23 Jan 2024 01:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972027; cv=none; b=KrrpqE6nDcJYbz9wLcrHQWO4pJzeqiKKvc9Sdg6kTp8ro3Wr3CYFy6JUAzhz5VRZ+8AaW3GrfAY3b39df/JzRPbGOhH3cVe0037rWdCEH9nYGX/Q89LGrsaKkyC5WWigsERSmPlDv8VHvVLS5J2JwJ/MNvt6vkyQRE/zjGEl9YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972027; c=relaxed/simple;
	bh=nwJ64hJfzOcc/eiy8q2jy3tobS1sbfZxEPNsHvuVN6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIMksJ2DCtZghm5tN8ImK622nfjmlZ9Wo3y3I0Dm/vBn0VgH8VRs0JAe+cYw1Lboup6BgEbwJ1q5znM8laG5t7qxgmWPGpsOcSJPspcLSp5XqflGLez2hvdnq033WFg/FKRobyXdXYbyGbQjM8j/Xsq79Nh26b1RV0ilOFOFglE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e74LYRjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e74LYRjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E73C433F1;
	Tue, 23 Jan 2024 01:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972027;
	bh=nwJ64hJfzOcc/eiy8q2jy3tobS1sbfZxEPNsHvuVN6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e74LYRjhgSUcdqXtkqbIu4RS3oqimEYgpS3ex+DQZqYo7vrnV0t9I2qV1UeJe0vIJ
	 BpnIjGOPQI8uhNHuqOxPOHitNA1+PP4EjXWaMs9SxBtNIIyBRyy34nt4Kc/C0XwDdH
	 YBuCUGh4Z+sqEQenz8xB2+3qMYrrcCtSEmzY+5V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ludvig=20P=C3=A4rsson?= <ludvig.parsson@axis.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/286] ethtool: netlink: Add missing ethnl_ops_begin/complete
Date: Mon, 22 Jan 2024 15:59:42 -0800
Message-ID: <20240122235742.682494261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



