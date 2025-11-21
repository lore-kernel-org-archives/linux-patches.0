Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457E535294E;
	Fri, 21 Nov 2025 13:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733084; cv=none; b=GtaERC+xEc2W0ZPMtZy3LCmAureBmz1VF6J3ecizIj/QDxRfL47pPGBrLyw/OOdgTt5LaIT/KThKPmYu3kxiGMPbKXjGUc2OV0OR1JyxSRUb09I+zF/Uh8EzTwOS9LUBUlJrtz6T0WwI8GqAx0lrJJLVSlA6uKkZFcvhZl/Lqvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733084; c=relaxed/simple;
	bh=t74yt6+Q8LMQtwmmO4elpmPtCk7J3egbhhWAusUnBj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nd/rMoa2cV1oQwoMhWVYCmOQOsM/KIOj8a0d5nzeRVNBhSSrP+OOzhleyNhmTMMDVnSi/qPLH9FHO6p+hM9bHHwhP5fRpoB/12Ug18td7WZaZp6cKn/+q4i61VptoA9gumdjGRThqnaBvXmD+rzI1XqHq3lCHSrARx+yrXLdLgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zt3Dkgv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zt3Dkgv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32FBC4CEF1;
	Fri, 21 Nov 2025 13:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733084;
	bh=t74yt6+Q8LMQtwmmO4elpmPtCk7J3egbhhWAusUnBj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zt3Dkgv31Ts0EkMXUqyw4WI+hsVgI7RPtn6NXwvcrWN1tdwAYwf4BiPSNeNGzL3aU
	 gPYXkKqhMxwPwnhteVzzHoO4VUZBKcz2/Y0GDqrhlTFVUQbUAYumHYHojNbTdCWI+P
	 5sdSi8hZjKMhhJM82p0WjkZgdRzCqH3o6hVTOpwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 344/529] net: vlan: sync VLAN features with lower device
Date: Fri, 21 Nov 2025 14:10:43 +0100
Message-ID: <20251121130243.271113193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit c211f5d7cbd5cb34489d526648bb9c8ecc907dee ]

After registering a VLAN device and setting its feature flags, we need to
synchronize the VLAN features with the lower device. For example, the VLAN
device does not have the NETIF_F_LRO flag, it should be synchronized with
the lower device based on the NETIF_F_UPPER_DISABLES definition.

As the dev->vlan_features has changed, we need to call
netdev_update_features(). The caller must run after netdev_upper_dev_link()
links the lower devices, so this patch adds the netdev_update_features()
call in register_vlan_dev().

Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20251030073539.133779-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 422f726346ea5..7c77482f31594 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -194,6 +194,8 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	vlan_group_set_device(grp, vlan->vlan_proto, vlan_id, dev);
 	grp->nr_vlan_devs++;
 
+	netdev_update_features(dev);
+
 	return 0;
 
 out_unregister_netdev:
-- 
2.51.0



