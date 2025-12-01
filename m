Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D0C258CFF;
	Mon,  1 Dec 2025 11:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588630; cv=none; b=ae/tMLX9e9ocRhXuind3ubAMM2dNUcrJXmkJG8J5rhHBWdz0nXYVJSahP3h6nVJY8zuuRuGaUXi870+xDmp9rHrLXnGOLZ8DBrFvSTkykfuMXCi22JGyKmbMzTNqG1qOvUc5zaVWu2dtgYPVPhmtoZV7xw1JT9ZP7lV/MDxIHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588630; c=relaxed/simple;
	bh=K/iNE86s/GB/eInujDPbhUeM0VewOl3/ZD9DsvkT/b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRdJ6/ELmRuFxSro+WzAyjfwC8nC45zs4LuLV4v4iPxdFTiJYsNQ8CB8ftKYGbXuEd6+1ry5Z3vdSp2gl2ArVUj61x1OpEbVBKDebKawRpFQ8p/tkcJjryYx9pkIOwRw/7dvgIFxGiAm42S8Akf0yMuAYpQM0/8jAm6Zqi8ccz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4kkl3RZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4kkl3RZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA989C4CEF1;
	Mon,  1 Dec 2025 11:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588630;
	bh=K/iNE86s/GB/eInujDPbhUeM0VewOl3/ZD9DsvkT/b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4kkl3RZ7YZSy85jJnUjXFXwlW4dm6zbsP1tUm0SucAgHHU2JV8Q3ZRhYEUEDREY2
	 n82N6UzRMiahJl5FM45XBgUAc50z1WKHLvVHrJXcrWQR1X8uwv5Az1K1LdahgQ0yvj
	 DAbDtzinpMCEzBPF4tBiWMYq7cNEMin3SYN0p/2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/187] net: vlan: sync VLAN features with lower device
Date: Mon,  1 Dec 2025 12:23:42 +0100
Message-ID: <20251201112245.350391307@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 14244445f944a..c6d5cf8105232 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -187,6 +187,8 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	vlan_group_set_device(grp, vlan->vlan_proto, vlan_id, dev);
 	grp->nr_vlan_devs++;
 
+	netdev_update_features(dev);
+
 	return 0;
 
 out_unregister_netdev:
-- 
2.51.0



