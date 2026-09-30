Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B6B3CF039;
	Wed, 30 Sep 2026 19:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795658; cv=none; b=MWE+YxjSkfU63Unpj1o+X6TL6Ws4TMDPtjTN2jJfqXzcEEjnt40403UUhF3ciJUQAcXQiFsEszNw0BTO/UWCZuG+ZFAGpPVmsKtV2d1s7zCWouTeyFUTTTL1Tqm1jWbL/tpdGxs1jCmbOXSMLhx1Q9HL/yKu6L2n9U0sfI+mnWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795658; c=relaxed/simple;
	bh=dDXmbwNuChZcMkRTn4Tj4WNJ9WlyGJUthHGxBHd84iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB7rgPhLJ9TkQHXYBumymLRfEGEtFePZZKSZRhNNzWvq5tTr7cggu0dsyuTZJwAPTAnhj/QPcpZ7nQTOBTRW8EhQbaEf+Vr/BjytbLT+sTfBC63knvadAN1kv4rX2wFTaWUx4VqBe+knSKBDURPw88XDAdx9yrQrs/lON0tqEkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNJjLun4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNJjLun4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DE81F000FF;
	Wed, 30 Sep 2026 19:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795657;
	bh=tEMI8T0mZEBjQnhbirAHYYgZfMpNl5nWzZ6asIGUUR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNJjLun44OpXro4+OPSarIFCMlkHIvl1ECCjelVUigVLRQeViIRdjyiLhNF9Qs8Cr
	 zsg+E+zFhTi6XmwimQFNClZT7itH/E+n3OErVF2OsdlVDLLeTUFmLnVF3WMLThuNql
	 uOYlv9jRk2dUJID3l4ASgwMljdL6E6dIlJLIAcdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+60332fd095f8bb2946ad@syzkaller.appspotmail.com,
	David Carlier <devnexen@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.6 0638/1193] ieee802154: hwsim: serialize pib updates to fix double-free
Date: Wed, 30 Sep 2026 17:22:02 +0200
Message-ID: <20260930152448.419960438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 979d5b8de8ed4e1f997aef12da5694b99be7b871 upstream.

hwsim_update_pib() does an unserialized read-swap-free of phy->pib:

	pib_old = rtnl_dereference(phy->pib);
	...
	rcu_assign_pointer(phy->pib, pib);
	kfree_rcu(pib_old, rcu);

It assumes the RTNL is held, but ->set_channel is not always called
under it: the mac802154 scan worker changes channels via
drv_set_channel() without the RTNL. Such an update can race an
RTNL-held one on the same phy; both read the same pib_old and both
kfree_rcu() it, double-freeing the object. With SLUB percpu sheaves
batching kfree_rcu(), this surfaces as a KASAN invalid-free in
rcu_free_sheaf().

struct hwsim_phy has no lock for pib. Add one and make the swap atomic
with rcu_replace_pointer() under it, dropping the misleading
rtnl_dereference().

Reported-by: syzbot+60332fd095f8bb2946ad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=60332fd095f8bb2946ad
Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20260709221858.158063-1-devnexen@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -72,6 +72,8 @@ struct hwsim_phy {
 	struct ieee802154_hw *hw;
 	u32 idx;
 
+	/* Serializes phy->pib_updates. */
+	spinlock_t pib_lock;
 	struct hwsim_pib __rcu *pib;
 
 	bool suspended;
@@ -102,8 +104,6 @@ static int hwsim_update_pib(struct ieee8
 	if (!pib)
 		return -ENOMEM;
 
-	pib_old = rtnl_dereference(phy->pib);
-
 	pib->page = page;
 	pib->channel = channel;
 	pib->filt.short_addr = filt->short_addr;
@@ -112,7 +112,10 @@ static int hwsim_update_pib(struct ieee8
 	pib->filt.pan_coord = filt->pan_coord;
 	pib->filt_level = filt_level;
 
-	rcu_assign_pointer(phy->pib, pib);
+	spin_lock_bh(&phy->pib_lock);
+	pib_old = rcu_replace_pointer(phy->pib, pib,
+				      lockdep_is_held(&phy->pib_lock));
+	spin_unlock_bh(&phy->pib_lock);
 	kfree_rcu(pib_old, rcu);
 	return 0;
 }
@@ -952,6 +955,7 @@ static int hwsim_add_one(struct genl_inf
 		goto err_pib;
 	}
 
+	spin_lock_init(&phy->pib_lock);
 	pib->channel = 13;
 	pib->filt.short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
 	pib->filt.pan_id = cpu_to_le16(IEEE802154_PANID_BROADCAST);


