Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A603EDAB8;
	Mon, 17 Aug 2026 13:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973916; cv=none; b=VNGZqN2jZYEu2+8nymqP3X3Wd7HRpXaR61MObw8sqOxI6t0ZxepgIgzjb4AnvyRxPnOnh1j6EmJduac8GXzEm+zwOOu7rkR7kMI9/snNDZMDUvZ+hbZQG9ubUoc+X3V6KKbSrIsMlyjFAqb0rOYdGgstrI5bFaScZPHj6KHfgew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973916; c=relaxed/simple;
	bh=woedMb4jaJC85/iVg3TwADtl/a7h7wg5C8Xi7LJgLXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7a/tj5atWoMOktUFqycjRQIwL1oH4/dM9oxasUdPVGD39JetbIgajc5EeNHtIOCj5op88rJLuX+a2zm/QuRX6NldPmtaSu6DldVPWunOuJHneAqaHVpE/LDZSLnofE7p4MarreNj6z3tTjlQFPWOfhQ18MT8RgjlnOvWOF6868=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3GhTmTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3GhTmTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FEE1F000E9;
	Mon, 17 Aug 2026 13:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973914;
	bh=oxBkhkr/Tcu6NqUBOcV2GUgJU7xM4GLxYAvjjCwMCzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3GhTmTh+lPaC/KLwYDiyV9dpFONdVg8sArqWY2nEPM45kaYIay2zGEHXNPHJV8U/
	 xxmjJR5LSiXwX3Attj4yJdrl+ADWSaCrTQIbJ1yQr91pAyWUumtJg8dA2RIrLmg+KL
	 6DC9n6jHb6Kz8/p7sR+eDrcSNu+1CNangoYVbSQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 025/271] ovpn: add missing rtnl_link_ops->get_size callback
Date: Mon, 17 Aug 2026 15:29:10 +0200
Message-ID: <20260817132537.789361578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 6e9f539e4f01153651dd77609b5ccadd44b74df8 ]

ovpn_fill_info emits IFLA_OVPN_MODE inside IFLA_INFO_DATA, but
ovpn_link_ops does not provide a get_size callback. Consequently,
rtnetlink's size estimate for ovpn link messages does not include the
nested mode attribute.

Available skb tailroom may hide this mismatch. When the remaining space
is insufficient, however, ovpn_fill_info returns -EMSGSIZE and message
construction fails.

Add the callback and account for IFLA_OVPN_MODE.

Fixes: c2d950c4672a ("ovpn: add basic interface creation/destruction/management routines")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ovpn/main.c b/drivers/net/ovpn/main.c
index 9993c1dfe471d..9d9a0ff690d66 100644
--- a/drivers/net/ovpn/main.c
+++ b/drivers/net/ovpn/main.c
@@ -210,6 +210,12 @@ static int ovpn_newlink(struct net_device *dev,
 	return register_netdevice(dev);
 }
 
+static size_t ovpn_get_size(const struct net_device *dev)
+{
+	/* IFLA_OVPN_MODE */
+	return nla_total_size(sizeof(u8));
+}
+
 static int ovpn_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct ovpn_priv *ovpn = netdev_priv(dev);
@@ -228,6 +234,7 @@ static struct rtnl_link_ops ovpn_link_ops = {
 	.policy = ovpn_policy,
 	.maxtype = IFLA_OVPN_MAX,
 	.newlink = ovpn_newlink,
+	.get_size = ovpn_get_size,
 	.fill_info = ovpn_fill_info,
 };
 
-- 
2.53.0



