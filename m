Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57F14198C;
	Tue, 23 Jan 2024 01:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972041; cv=none; b=PBdSXImsMhUxC+FKUnI3E/nwS7QNsye3dz+8vqFOiVxeCzKYPMiRlugp4QmXRnpNqSbRSB1Boev5WyxnhqWBHOHFEkQ64Lz0dtaed1jo+1Bs3vk7i0Njhq23SemLxIKChLBxC+rWiYoljn0wgnDgV7iO8DmM4r5nRcWIGw0Zq1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972041; c=relaxed/simple;
	bh=ubRS45iu8LiMpexXkhcH5fUu11vIhsLSDvM9AZR4Tak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ogCVMU4IgoRKq9H5n/kY5hoPePTa3r5DFqE2D7xHiEzKjHzVf1sR/FvndoNwsNFiR8/X0l5zWI6Rob64kSeq/USUWn64KPasoXUWbb6jmaE3d/uiWHImqjCPXSbFa+Z2dPOneheE2nwKN7a8oipPKWoxNsUADmFBxDyB6bGAhfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7yggkTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7yggkTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F19C433C7;
	Tue, 23 Jan 2024 01:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972041;
	bh=ubRS45iu8LiMpexXkhcH5fUu11vIhsLSDvM9AZR4Tak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7yggkTkkrHbgSgEUC86YXEkeLa2m7CJsct18Hx1pX1WFx/QcCPU+ZMGzmWqU17BF
	 F65JGKmHv4ycnZwnb0y0cDhsysxTMJ/g5Tm9NyajWjVnfPhC7kqwKwlr/paQraFTM5
	 C7W22B2mwU1ZdufaO6NfNr/Gc+7iAxbH2KHj1z5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ludvig=20P=C3=A4rsson?= <ludvig.parsson@axis.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 409/417] ethtool: netlink: Add missing ethnl_ops_begin/complete
Date: Mon, 22 Jan 2024 15:59:37 -0800
Message-ID: <20240122235805.868320761@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 55d449a2d3fc..090e493f592e 100644
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



