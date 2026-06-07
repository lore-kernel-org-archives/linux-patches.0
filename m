Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8964071DA;
	Sun,  7 Jun 2026 10:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827400; cv=none; b=icka3RHLSIC9BvmbrmNg6YUzF+KNBFcsSeM0kciHil/r3d+25YqU+MZS9LE6B5JUqWMLCp1OGM7erOr48sEdjrXmTejhew54jbOAsZzQLdv0QH7sSmsyd8aIleHL2qjMNs5y1fKmuFSoJMmrMOK8ysPb+8ToYaelDaMJ+Cwk8uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827400; c=relaxed/simple;
	bh=6cqMWrKn459iVCmRlk6cynPWt5HKVopIoaW99SsgCg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3ei4cmr/Y/+luwki77Ah/0snGKP3ut0bX2daBT1PcqKxQA17DqzjsklFLV19OpymjfiodqZVlyajDMh2Xk9Q+Wn25HeqICyk1K/BCXAzg/v7ZFoNuUSZxOUTsNnLjXB+xaHFtJ9O2i8CJQwj4NvxmpkcxZKMOvxSqBEsUA1lhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnKzEHjo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnKzEHjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE31F00893;
	Sun,  7 Jun 2026 10:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827399;
	bh=/ocu62ECjItGzf94llBQVZiz28roKPVM9pl/l+H8Pv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnKzEHjoQYY+aEYDTXehBHN6FFcoWZB5Dqba9eL56GdJZG25Uti9YhM4+5Fj2rKjX
	 zBA+l0aNFPm4CmmQcYkx6HzihUGQqqu51YQgETTM3U0gaULSNkEUABIfirQWpQH7Mx
	 sJrOigDKCMTt+U3dHuQWsidvBxOZY42xy4uz9FGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/307] ethtool: module: fix cleanup if socket used for flashing multiple devices
Date: Sun,  7 Jun 2026 11:57:29 +0200
Message-ID: <20260607095729.632104259@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
index ab1e8a83acd0b1..5a08c320b4660d 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -282,11 +282,9 @@ void ethnl_module_fw_flash_sock_destroy(struct ethnl_sock_priv *sk_priv)
 
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
@@ -323,7 +321,8 @@ module_flash_fw_schedule(struct net_device *dev, const char *file_name,
 	fw_update->ntf_params.seq = info->snd_seq;
 	fw_update->ntf_params.closed_sock = false;
 
-	err = ethnl_sock_priv_set(skb, dev, fw_update->ntf_params.portid,
+	err = ethnl_sock_priv_set(skb, dev_net(dev),
+				  fw_update->ntf_params.portid,
 				  ETHTOOL_SOCK_TYPE_MODULE_FW_FLASH);
 	if (err < 0)
 		goto err_release_firmware;
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index a52be67139d0ac..409b4109940b7c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -50,7 +50,7 @@ const struct nla_policy ethnl_header_policy_phy_stats[] = {
 	[ETHTOOL_A_HEADER_PHY_INDEX]		= NLA_POLICY_MIN(NLA_U32, 1),
 };
 
-int ethnl_sock_priv_set(struct sk_buff *skb, struct net_device *dev, u32 portid,
+int ethnl_sock_priv_set(struct sk_buff *skb, struct net *net, u32 portid,
 			enum ethnl_sock_type type)
 {
 	struct ethnl_sock_priv *sk_priv;
@@ -59,7 +59,7 @@ int ethnl_sock_priv_set(struct sk_buff *skb, struct net_device *dev, u32 portid,
 	if (IS_ERR(sk_priv))
 		return PTR_ERR(sk_priv);
 
-	sk_priv->dev = dev;
+	sk_priv->net = net;
 	sk_priv->portid = portid;
 	sk_priv->type = type;
 
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 5e176938d6d228..11843bd10bcade 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -315,12 +315,12 @@ enum ethnl_sock_type {
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



