Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA262561A7;
	Tue, 11 Nov 2025 01:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824781; cv=none; b=dOebbquYaddqJl0baeaPCr8hfuHT1WnJUt2jvuTAhUNHM4I+2E/vhbTaS4PF0F3IKvfZPS+/pQfTY+TorKyH7l0lsjyDVG4CaC2QCG6EIQ+qTkEg7aY6L5+jGMuhFN0cEcS/qpJfvaWDBBd5sxXTAdz5tanq8TmBUvufHKC6rPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824781; c=relaxed/simple;
	bh=IeCDjyzIU59MNxj4/XI17rhV/BPcbHSwyiw35ol+mBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1ZO6YmsLCsrMNbv7vkML+ACmiTT8aqiWAD/EpI52aR44VyROrCk9/g8eBJQo9AF+BblrPlT1+38seSQ1b6LDMwVfJHfr1TtarIOw/RXmJNMloev+HKpNo+wU6+NAp9sIUBy7UjXaWV3wv5DMMZ2qz6KoU1qpsm+s3ejDTS9G/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAvTODHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAvTODHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2721C113D0;
	Tue, 11 Nov 2025 01:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824781;
	bh=IeCDjyzIU59MNxj4/XI17rhV/BPcbHSwyiw35ol+mBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAvTODHRIOcfXB0mkSbX/f3xlCzv3b7UeVGyjQV1r+N/Aah2tyM9tYyEEFc9uNKPC
	 chfJgNuZJ++bC455gwaNkf7MTjd5ONv6oGysywaH9KGLl8Aggdb4KljVnkGUrsqopj
	 YX6cOk4Rm009wG/M2RzPnTkrsUbybRPKbeRewtTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 516/565] net: vlan: sync VLAN features with lower device
Date: Tue, 11 Nov 2025 09:46:12 +0900
Message-ID: <20251111004538.568087388@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 49a6d49c23dc5..ecc1c8624006f 100644
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



