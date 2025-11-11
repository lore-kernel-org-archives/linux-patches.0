Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304602AE8D;
	Tue, 11 Nov 2025 00:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822090; cv=none; b=ReAPT2vsEJ7FW08Q41vXj0Z8gAPx+lXgMFgxylu1jwF8ATEe5Dff+4EGt5+RG4+A+R5X4FrDWKg07LSWK7n7P0JvcSqEWqgTJkBVwgJudPjeq+aEkL+bc0ykOtZjSp0FY4ypIobgZDlp+dbl/JteZ4uNgGuRc+xQHici78OzpH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822090; c=relaxed/simple;
	bh=DtY0udAnNvU2i9uVY9QI4eUiAh7Xn4BqiUx23Hy64cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkWPkh85K8CSRFpIrUSi4u1rFth0sZkhLzYd29RTLHxwpD/CuIB8HRhFmCPsaq7xVOA3oVAKce9SyuxcKH4Si11Fe2faqIjayjeNXElbXPF3cLX0eNhWxj2bqbUaWQ1fykCBsdruZKUUxG4zPyZEPEC0/rp9FvPwgBg9zF4yP7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9BAn1uu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9BAn1uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE102C113D0;
	Tue, 11 Nov 2025 00:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822090;
	bh=DtY0udAnNvU2i9uVY9QI4eUiAh7Xn4BqiUx23Hy64cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9BAn1uucy2QbPw3WeCWnH953XpLfvJMKF5itahftu8BHrrxb3UyVL4yQocs2dcCj
	 oXp6/pDC1/7FrR9TdrDDZ/RbKBwBbQsXyez2O7Hq/71baPpCPlNr8/csat0kOOgR+D
	 nt2pann0zriZJ9FVW5zGLrskbjVZamZF6o5XpqTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.17 013/849] batman-adv: Release references to inactive interfaces
Date: Tue, 11 Nov 2025 09:33:03 +0900
Message-ID: <20251111004536.783333041@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit f12b69d8f22824a07f17c1399c99757072de73e0 upstream.

Trying to dump the originators or the neighbors via netlink for a meshif
with an inactive primary interface is not allowed. The dump functions were
checking this correctly but they didn't handle non-existing primary
interfaces and existing _inactive_ interfaces differently.

(Primary) batadv_hard_ifaces hold a references to a net_device. And
accessing them is only allowed when either being in a RCU/spinlock
protected section or when holding a valid reference to them. The netlink
dump functions use the latter.

But because the missing specific error handling for inactive primary
interfaces, the reference was never dropped. This reference counting error
was only detected when the interface should have been removed from the
system:

  unregister_netdevice: waiting for batadv_slave_0 to become free. Usage count = 2

Cc: stable@vger.kernel.org
Fixes: 6ecc4fd6c2f4 ("batman-adv: netlink: reduce duplicate code by returning interfaces")
Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -764,11 +764,16 @@ int batadv_hardif_neigh_dump(struct sk_b
 	bat_priv = netdev_priv(mesh_iface);
 
 	primary_if = batadv_primary_if_get_selected(bat_priv);
-	if (!primary_if || primary_if->if_status != BATADV_IF_ACTIVE) {
+	if (!primary_if) {
 		ret = -ENOENT;
 		goto out_put_mesh_iface;
 	}
 
+	if (primary_if->if_status != BATADV_IF_ACTIVE) {
+		ret = -ENOENT;
+		goto out_put_primary_if;
+	}
+
 	hard_iface = batadv_netlink_get_hardif(bat_priv, cb);
 	if (IS_ERR(hard_iface) && PTR_ERR(hard_iface) != -ENONET) {
 		ret = PTR_ERR(hard_iface);
@@ -1333,11 +1338,16 @@ int batadv_orig_dump(struct sk_buff *msg
 	bat_priv = netdev_priv(mesh_iface);
 
 	primary_if = batadv_primary_if_get_selected(bat_priv);
-	if (!primary_if || primary_if->if_status != BATADV_IF_ACTIVE) {
+	if (!primary_if) {
 		ret = -ENOENT;
 		goto out_put_mesh_iface;
 	}
 
+	if (primary_if->if_status != BATADV_IF_ACTIVE) {
+		ret = -ENOENT;
+		goto out_put_primary_if;
+	}
+
 	hard_iface = batadv_netlink_get_hardif(bat_priv, cb);
 	if (IS_ERR(hard_iface) && PTR_ERR(hard_iface) != -ENONET) {
 		ret = PTR_ERR(hard_iface);


