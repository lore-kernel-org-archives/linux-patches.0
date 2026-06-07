Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D871E98EF;
	Sun,  7 Jun 2026 10:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827194; cv=none; b=RKzmA4aaIXUZVg4KFNxzVkaQlh/MJMwCLU+33dt1Hqn9JzgfS85fmTiTOF/v1M4O1T1RYBc/LzBOTBqAv9Ai7TImRviw23PJ+K2hdmd845UjDCpFwG7eLqGucquk3z2MNWdC/9uz1PymOVGZTczoUzNzzcdQlZG//udolxYbXmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827194; c=relaxed/simple;
	bh=Org/6No6rjAE8PBoED6rmLcCTUl9XLb4AwdoLpEwzBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1PKiiA5VBeRA4qBo2eiiYN5vqKL8cGHa3pojmMDEVMFgTosBnxA/oltpAROGpzRza2dkCQT+wcXVMPqP9r5/7AekPdF5ce1FI0BiMM17cqRD0xQ8+SBvcwistsUkR62GXzDa+s7i/rl95kYLGx9JDDyM4JT5gcULu4JAjH20qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uta3yP5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uta3yP5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C459C1F00893;
	Sun,  7 Jun 2026 10:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827193;
	bh=7ZUIcjxsDjN6KtwRXIJn3ltceg6XLIqSIjK8H/Kbmoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uta3yP5Q7vNNj9od62IDHphR5lK2Xd6Wt+XGmEw4BYkRUzRp/FJ5BjyGdaHSc2OzW
	 Ab78Svk2PPVwSMFcLkUiulhKY+qXk86wbaQWP13Kkoh2L+puc7EPRzIOzkcroCaRua
	 0qC29LR0pU4d0K6Vu/UVZEWabYHqhKcFHk6h7DqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/315] ethtool: module: fix cleanup if socket used for flashing multiple devices
Date: Sun,  7 Jun 2026 11:57:15 +0200
Message-ID: <20260607095729.351478369@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 202e4c25280a76..9a11e7def0029a 100644
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
index 2f813f25f07e1a..28577b878fd5b5 100644
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
index 1d4f9ecb3d263b..3923188097ac0a 100644
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



