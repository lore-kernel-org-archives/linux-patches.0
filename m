Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA3018A6D7;
	Fri, 15 Nov 2024 06:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652831; cv=none; b=d3mCK7oO6E8DtH4XXxIysWeNfUkxXW5po10GZt32aKrv/rneKIULePJ0EzbdUNVVK9NiagNbNCzusY6aPM/5IBSrBf+PmkCUtoPjOrLV3QA4sK3+bk5Npx+BbHOFN7kKF/f4YP8N+r9rOUjk/sHzx67RTyUvitN+lGvbHJqcU7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652831; c=relaxed/simple;
	bh=vKGi/S1TStsitfQjenuCHvci4zrVoeni5gNwlrKf3eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shaXLDqo9kVTjaj8SOcxauBO4sqJGWsdxEwnMMOtloouDQvM/NKzL0Nnp1mcZ/5AkHJ8pL/Qq867MCu2lhF/3M1O6QQPcdJsv6Lxg9wTuPxh8lyrVVOsADxaQqx6HKY4L+qxDZZJaXx0QrRzbvBVIJuNcAADVsJaPSW5MZ/xjKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlBct9F4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlBct9F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBBEC4CECF;
	Fri, 15 Nov 2024 06:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652831;
	bh=vKGi/S1TStsitfQjenuCHvci4zrVoeni5gNwlrKf3eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlBct9F4PDVHBZDzgB9USAFPs7O2ZuKPfnSyKWQKk+OjAGl65byOLNMkKZrauD69G
	 cjvL3pq3i3Cx4pGRy7Y0fhphjWUTfsDwf/Wz3b81XF1fyT6DaC7ReFynRnp+SU6OG/
	 /yS6QNDexXDEltEc9+m6AI1QNWi+RPTdAWWX6mP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Liska <mliska@suse.cz>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Veaceslav Falico <vfalico@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 27/52] bonding (gcc13): synchronize bond_{a,t}lb_xmit() types
Date: Fri, 15 Nov 2024 07:37:40 +0100
Message-ID: <20241115063723.839238313@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 777fa87c7682228e155cf0892ba61cb2ab1fe3ae upstream.

Both bond_alb_xmit() and bond_tlb_xmit() produce a valid warning with
gcc-13:
  drivers/net/bonding/bond_alb.c:1409:13: error: conflicting types for 'bond_tlb_xmit' due to enum/integer mismatch; have 'netdev_tx_t(struct sk_buff *, struct net_device *)' ...
  include/net/bond_alb.h:160:5: note: previous declaration of 'bond_tlb_xmit' with type 'int(struct sk_buff *, struct net_device *)'

  drivers/net/bonding/bond_alb.c:1523:13: error: conflicting types for 'bond_alb_xmit' due to enum/integer mismatch; have 'netdev_tx_t(struct sk_buff *, struct net_device *)' ...
  include/net/bond_alb.h:159:5: note: previous declaration of 'bond_alb_xmit' with type 'int(struct sk_buff *, struct net_device *)'

I.e. the return type of the declaration is int, while the definitions
spell netdev_tx_t. Synchronize both of them to the latter.

Cc: Martin Liska <mliska@suse.cz>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221031114409.10417-1-jirislaby@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[iwamatsu: adjust context]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bond_alb.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -172,8 +172,8 @@ int bond_alb_init_slave(struct bonding *
 void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
 void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char link);
 void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave);
-int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
-int bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
+netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
+netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
 void bond_alb_monitor(struct work_struct *);
 int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
 void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);


