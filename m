Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BE9227B94;
	Sun,  7 Jun 2026 10:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827110; cv=none; b=fDZDzQTiub9SI+RERLR4pm1TZfofFrDJbvrzyuZkC5UB0czmhdURg2UmnA/GicadTHoDuNBdN7Rko8cGAohcyFcvQ69IZyCB73ah+mImEVU73GLCDHmbtu4sQPXF8Vfq8to7GKMGAn3a/XXaUHPi+/kyvX3Fz+sGlVlw5Ve0I0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827110; c=relaxed/simple;
	bh=GJGDEXUO9Yx7TbVMUco3UJV11Dqsbjly2Dzao04z0pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d04QlTRCkxqRLdL3+JTznTnkZAMXb65FoOrsgK+19WBTvMdruiRlR4d4QHtV+d1HtGejKI49sWjI8C9JXwujhsZJBkDNifcuhDgKRfaBG9Ek4uBKKwJONulMMfKqn+5gHr0NpT3gQLay3LVWVpgLzHjvGMF17N97z3hF5Z2EVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9TeNf22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9TeNf22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90751F00893;
	Sun,  7 Jun 2026 10:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827109;
	bh=St0MSQWWehvx9Lz5DDau5g+BvjX2fy32WK9Mcwtnz8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9TeNf22iA+pz5B7HG87JxhSTM3aiE9QVIw3OJx2XbATcjYj5eWxV1WW5QcapStDU
	 HA2CmR675PhxotG8WEv61nj5gywWtX4w3m8qmhY0lf2irsnAesGLaNG4QUg2JSTgAr
	 EHwgSAza0KfQxPsaxHWOcbvFXXs0Jnx4iwjXPi7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 051/332] ethtool: module: fix cleanup if socket used for flashing multiple devices
Date: Sun,  7 Jun 2026 11:57:00 +0200
Message-ID: <20260607095729.997032134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 760d04ebad5c4304f22c0d2251c9623b87a117c8 ]

When a single Netlink socket issues MODULE_FW_FLASH_ACT against multiple
devices, ethnl_sock_priv_set() overwrites sk_priv->dev on each call,
retaining only the last one. The socket priv is used on socket close,
to walk the global work list and mark the uncompleted flashing work
as "orphaned". Otherwise if another socket reuses the PID it will
unexpectedly receive the flashing notifications.

Don't record the device, record net pointer instead. The purpose of
the dev is to scope the work to a netns, anyway. If we store netns
the overrides are safe/a nop since all flashed devices must be in
the same netns as the socket.

Fixes: 32b4c8b53ee7 ("ethtool: Add ability to flash transceiver modules' firmware")
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/module.c  | 9 ++++-----
 net/ethtool/netlink.c | 4 ++--
 net/ethtool/netlink.h | 4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 373326e49d150e..6eb83f6b3d267c 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -291,11 +291,9 @@ void ethnl_module_fw_flash_sock_destroy(struct ethnl_sock_priv *sk_priv)
 
 	spin_lock(&module_fw_flash_work_list_lock);
 	list_for_each_entry(work, &module_fw_flash_work_list, list) {
-		if (work->fw_update.dev == sk_priv->dev &&
-		    work->fw_update.ntf_params.portid == sk_priv->portid) {
+		if (work->fw_update.ntf_params.portid == sk_priv->portid &&
+		    dev_net(work->fw_update.dev) == sk_priv->net)
 			work->fw_update.ntf_params.closed_sock = true;
-			break;
-		}
 	}
 	spin_unlock(&module_fw_flash_work_list_lock);
 }
@@ -332,7 +330,8 @@ module_flash_fw_schedule(struct net_device *dev, const char *file_name,
 	fw_update->ntf_params.seq = info->snd_seq;
 	fw_update->ntf_params.closed_sock = false;
 
-	err = ethnl_sock_priv_set(skb, dev, fw_update->ntf_params.portid,
+	err = ethnl_sock_priv_set(skb, dev_net(dev),
+				  fw_update->ntf_params.portid,
 				  ETHTOOL_SOCK_TYPE_MODULE_FW_FLASH);
 	if (err < 0)
 		goto err_release_firmware;
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 6e5f0f4f815a1a..4cf928da607252 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -52,7 +52,7 @@ const struct nla_policy ethnl_header_policy_phy_stats[] = {
 	[ETHTOOL_A_HEADER_PHY_INDEX]		= NLA_POLICY_MIN(NLA_U32, 1),
 };
 
-int ethnl_sock_priv_set(struct sk_buff *skb, struct net_device *dev, u32 portid,
+int ethnl_sock_priv_set(struct sk_buff *skb, struct net *net, u32 portid,
 			enum ethnl_sock_type type)
 {
 	struct ethnl_sock_priv *sk_priv;
@@ -61,7 +61,7 @@ int ethnl_sock_priv_set(struct sk_buff *skb, struct net_device *dev, u32 portid,
 	if (IS_ERR(sk_priv))
 		return PTR_ERR(sk_priv);
 
-	sk_priv->dev = dev;
+	sk_priv->net = net;
 	sk_priv->portid = portid;
 	sk_priv->type = type;
 
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 89010eaa67dfcd..65c24f627b218f 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -318,12 +318,12 @@ enum ethnl_sock_type {
 };
 
 struct ethnl_sock_priv {
-	struct net_device *dev;
+	struct net *net;
 	u32 portid;
 	enum ethnl_sock_type type;
 };
 
-int ethnl_sock_priv_set(struct sk_buff *skb, struct net_device *dev, u32 portid,
+int ethnl_sock_priv_set(struct sk_buff *skb, struct net *net, u32 portid,
 			enum ethnl_sock_type type);
 
 /**
-- 
2.53.0



