Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC06305067;
	Wed,  3 Dec 2025 16:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779623; cv=none; b=U/Bxwg7D2Km8riOHv+KYOZumuOe94Bn7JaFABYR8UP0rftT2HHHIWC0cGCxcvUFsViQbEfjjwPLCqS0XoLcNIcBx1BlkLd5TuFZDAK3ODGzXG9y+eyRrD1RP+pfjVFo3Q/oJw3dyakhg/VbZqWEtdJ3V3Vlh+B/94GgorSILE8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779623; c=relaxed/simple;
	bh=pJdbAzIucR1rJvAlDkw+AqIc2jDZssvOqDObs0DnM2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thAsJJTgxaeVAC55l72D5GZTjPQy+VDT8TO8uplbp6FkVYDYraAf0YPHb+NjWpdn0lAIvfNaOAuk67VoC5QE4OmKCJDOPCBm+eZK2KczY3s7GScM2MYOk9Hs2BqRs57NOfmkXGdQHnfFitY40q7mE1QoQhjSnl/r0pWl5xNr4/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OohpW8rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OohpW8rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6370BC4CEF5;
	Wed,  3 Dec 2025 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779622;
	bh=pJdbAzIucR1rJvAlDkw+AqIc2jDZssvOqDObs0DnM2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OohpW8rwvhd5kuJkY+d7RWuroFz84uApmlP8s3Z02YzffHabA07O/h2yIomesRIIS
	 cQlCVCb06zFKdIOR+wsATP4Swdy8QSdNC2ZWZvCdTZA4vP4OFuzbt9uSRIIWiAYC1o
	 FnVm+wFjHjO4TXwnPw5+R+Vy3zm6mask1Fi1lwkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 311/568] net: vlan: sync VLAN features with lower device
Date: Wed,  3 Dec 2025 16:25:13 +0100
Message-ID: <20251203152452.105274753@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



