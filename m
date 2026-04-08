Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F073BB4A;
	Wed,  8 Apr 2026 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674992; cv=none; b=jzaqVk0lLvn4ebkXedyoWfzVA49CrFn1SgL7V5C1zSvAnjx6NjCpcyUCHb9xhxvQOTzp3/+fy2jhto9XGZloUJ3i0BiNDbQUCEkY3FZPW19g7yUP2/e03Lupxi06+lB7t99sGiZ5itotfE+xfM3UyiVu5oFCbbyCKA8tmaU5I0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674992; c=relaxed/simple;
	bh=Yf3htFrjHJuQ7HsR7YkxEScsiaNwG40hRiiK0+ARxHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWe10W2SgRJM9Ou2BVkY3Assh+Pb71B4jQhnPQQWCGSvv9TEm8YGhfJw9hyQjCcVHKsCHmhDQm1CV2QX8ZUBJUC6wgIllRsnLUBydJPw+4qTxXeKyS1yQEMJMyAPO0DsXYVAiurObuJ6B2MqGPVWPfoJPlxz6JS4QjEE7g7OUpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D05eKA/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D05eKA/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FBAC19421;
	Wed,  8 Apr 2026 19:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674992;
	bh=Yf3htFrjHJuQ7HsR7YkxEScsiaNwG40hRiiK0+ARxHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D05eKA/a6uIZKgOkASqZZqgrCQLEl0pzoidHvEg8N7MeWK7zcz0DpXl6RjtlHbo66
	 E4YLT+Uaudrcxop82OX88vj5c1Z4nQWpdGJ/Aow+0AV8DqqlyKXXVaFdlg8SLWYiVD
	 plyGXLKs3g7T0au5x/FjarPVvbMnAqq+IuS3tcvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Popov <alex.popov@linux.com>,
	Breno Leitao <leitao@debian.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.19 311/311] wifi: virt_wifi: remove SET_NETDEV_DEV to avoid use-after-free
Date: Wed,  8 Apr 2026 20:05:11 +0200
Message-ID: <20260408175950.977586583@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Popov <alex.popov@linux.com>

commit 789b06f9f39cdc7e895bdab2c034e39c41c8f8d6 upstream.

Currently we execute `SET_NETDEV_DEV(dev, &priv->lowerdev->dev)` for
the virt_wifi net devices. However, unregistering a virt_wifi device in
netdev_run_todo() can happen together with the device referenced by
SET_NETDEV_DEV().

It can result in use-after-free during the ethtool operations performed
on a virt_wifi device that is currently being unregistered. Such a net
device can have the `dev.parent` field pointing to the freed memory,
but ethnl_ops_begin() calls `pm_runtime_get_sync(dev->dev.parent)`.

Let's remove SET_NETDEV_DEV for virt_wifi to avoid bugs like this:

 ==================================================================
 BUG: KASAN: slab-use-after-free in __pm_runtime_resume+0xe2/0xf0
 Read of size 2 at addr ffff88810cfc46f8 by task pm/606

 Call Trace:
  <TASK>
  dump_stack_lvl+0x4d/0x70
  print_report+0x170/0x4f3
  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
  kasan_report+0xda/0x110
  ? __pm_runtime_resume+0xe2/0xf0
  ? __pm_runtime_resume+0xe2/0xf0
  __pm_runtime_resume+0xe2/0xf0
  ethnl_ops_begin+0x49/0x270
  ethnl_set_features+0x23c/0xab0
  ? __pfx_ethnl_set_features+0x10/0x10
  ? kvm_sched_clock_read+0x11/0x20
  ? local_clock_noinstr+0xf/0xf0
  ? local_clock+0x10/0x30
  ? kasan_save_track+0x25/0x60
  ? __kasan_kmalloc+0x7f/0x90
  ? genl_family_rcv_msg_attrs_parse.isra.0+0x150/0x2c0
  genl_family_rcv_msg_doit+0x1e7/0x2c0
  ? __pfx_genl_family_rcv_msg_doit+0x10/0x10
  ? __pfx_cred_has_capability.isra.0+0x10/0x10
  ? stack_trace_save+0x8e/0xc0
  genl_rcv_msg+0x411/0x660
  ? __pfx_genl_rcv_msg+0x10/0x10
  ? __pfx_ethnl_set_features+0x10/0x10
  netlink_rcv_skb+0x121/0x380
  ? __pfx_genl_rcv_msg+0x10/0x10
  ? __pfx_netlink_rcv_skb+0x10/0x10
  ? __pfx_down_read+0x10/0x10
  genl_rcv+0x23/0x30
  netlink_unicast+0x60f/0x830
  ? __pfx_netlink_unicast+0x10/0x10
  ? __pfx___alloc_skb+0x10/0x10
  netlink_sendmsg+0x6ea/0xbc0
  ? __pfx_netlink_sendmsg+0x10/0x10
  ? __futex_queue+0x10b/0x1f0
  ____sys_sendmsg+0x7a2/0x950
  ? copy_msghdr_from_user+0x26b/0x430
  ? __pfx_____sys_sendmsg+0x10/0x10
  ? __pfx_copy_msghdr_from_user+0x10/0x10
  ___sys_sendmsg+0xf8/0x180
  ? __pfx____sys_sendmsg+0x10/0x10
  ? __pfx_futex_wait+0x10/0x10
  ? fdget+0x2e4/0x4a0
  __sys_sendmsg+0x11f/0x1c0
  ? __pfx___sys_sendmsg+0x10/0x10
  do_syscall_64+0xe2/0x570
  ? exc_page_fault+0x66/0xb0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

This fix may be combined with another one in the ethtool subsystem:
https://lore.kernel.org/all/20260322075917.254874-1-alex.popov@linux.com/T/#u

Fixes: d43c65b05b848e0b ("ethtool: runtime-resume netdev parent in ethnl_ops_begin")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Popov <alex.popov@linux.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260324224607.374327-1-alex.popov@linux.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/virtual/virt_wifi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/virtual/virt_wifi.c
+++ b/drivers/net/wireless/virtual/virt_wifi.c
@@ -557,7 +557,6 @@ static int virt_wifi_newlink(struct net_
 	eth_hw_addr_inherit(dev, priv->lowerdev);
 	netif_stacked_transfer_operstate(priv->lowerdev, dev);
 
-	SET_NETDEV_DEV(dev, &priv->lowerdev->dev);
 	dev->ieee80211_ptr = kzalloc(sizeof(*dev->ieee80211_ptr), GFP_KERNEL);
 
 	if (!dev->ieee80211_ptr) {


