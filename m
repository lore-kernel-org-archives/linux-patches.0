Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A42313546;
	Wed,  3 Dec 2025 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778007; cv=none; b=ZRGIzh1J/HKQE2mPBrqHggu2nZib9eMZnXUJfQ1fV/GL6QCaJTAMPeZeVfFVOTwa7W6VSRonxNdDvA2a6uefKGfFjtkMugnEdSL13N8wxjqxk98oFXD7kpXnJakHGCO/Ox1KoIqMROqY580aA+LvGDTjRgFhvIoW6ePMrLfos2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778007; c=relaxed/simple;
	bh=okQcuGvZBw4SLKj+rlvT+hmejBrGJ+WIKH5q6PGn52o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anjsOpeVFPU0mFcKCDJOB5dS4Q97/LVh4Qdy5LlTOHBpVC2PmR2vRKbJWdMUMg9x9LEWcdkuIK1W0zFB6yvg6+V+VXixBiU7R9MobP9h1RaL5JwSfKEwddHkBUpRWO7rv8vEgnXIPiLBU7S95cGvs47tU40QE5FkmBpR7/334/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AW4CVKeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AW4CVKeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DA2C4CEF5;
	Wed,  3 Dec 2025 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778007;
	bh=okQcuGvZBw4SLKj+rlvT+hmejBrGJ+WIKH5q6PGn52o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AW4CVKehDKx8ExiDdjanffv3KUqGdRAEIpJTuedWHRmqqdk/6InRE7nAt9KSQ2niM
	 wtzlk7SfwvAIwJGdYBMqxzDSN8mxcmYKddXdeWrZB/rg31zQzQWOQYaeQ5Kb9OAcv1
	 TO9J/nXCU0WYCOQnhq7DZOuMtUZfI1uPSJ7epw5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/392] net: vlan: sync VLAN features with lower device
Date: Wed,  3 Dec 2025 16:26:05 +0100
Message-ID: <20251203152422.086381345@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2c5b532b0f054..7d61ab0647f20 100644
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



