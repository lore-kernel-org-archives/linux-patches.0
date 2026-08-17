Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9EC43CE79;
	Mon, 17 Aug 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974696; cv=none; b=MfIuCnxFf8+QyRBc8+IMHobr3wro1mDZrMKBRYLHZ2SPCR45eIl5nql/i/GThfpYpGeVN2guYscqd8VcAx6BDtbFZ1zacfecu2m8AjKSBLyNKsCGA27sGGXaZs+RmbQkOEq5gaTIFN8Zb/lKbu4UtYEpBNx9EF7upMXLi/1WgOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974696; c=relaxed/simple;
	bh=CJV7FyGEUv8yU/cAjSbofp/IrDWzpA/883fFDVIT+s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8JY3q+RuK0TQBDfHnLIoKezsqwM2w5tA7fvVGGkkIBgpZWCWTrSAAuucKFBpcxylbsmP7km26jhmg2Xzwg3BCE2WVQ+SJAPqkVVM8Vlve1gs8QZIZ5zUgvZNeU+Se+oj56HVc+3bsjbcArl7FZKec0aIvNOFU3xHxStRk4gffc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gz86cqkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gz86cqkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6381F000E9;
	Mon, 17 Aug 2026 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974689;
	bh=E+/oHnheto/DXktJ6nRjfe0Y7t1cSlZwK8SzxnV0YwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gz86cqkEWke556+KkROTdSXKUN0O9obQu99GzcIyGsfN+PHOkHKyTIJhWDXlYvYXn
	 bdq/tliFbGHz7NBidk9MGq5BSswrLjM2hSn8iCGoRGpJZDC+NzG7g8gBOyOTCxulR5
	 KW1Ye9heFnMXzObsYsoHAY+oyOADpnCkU+3KWcqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/250] ovpn: add missing rtnl_link_ops->get_size callback
Date: Mon, 17 Aug 2026 15:29:41 +0200
Message-ID: <20260817132537.280655491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
index 3f76b1b0e5f60..47859e1e3ef12 100644
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



