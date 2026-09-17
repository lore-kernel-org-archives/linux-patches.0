Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFC336920C;
	Thu, 17 Sep 2026 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671066; cv=none; b=aBn9NP5GtrCOeNW9CkJWbyyv4uQUJeMs6j8MDxjGMhkOd83H+BHi0Wweg0yCgMp2aEan3mw0k6SbI8cC7IA8pCBq4p3159AE5BVfOzodrqZpb3/gBgMz1Dc5MI/LzVFJibBtTEGUdXKkbE1cGMXDxEKRxJ6B86z08eyaWUhDiuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671066; c=relaxed/simple;
	bh=UHltCWwUdS2X7GE+FNHs6PzmV2kmxZLPkMjJz8/yRZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGpk1xj26z/tL74RGHwuWHHW/0LsqPOFg27WhekM+wtQ2dQLgssal8OnLV8lHe8Mduf1neDIzgtIc04LdnVNn8+8izDauCoH1b9ewChZU+mz6Wni+MuqST/YSHUHBXZyfwggkomiW8/ae9yj2lTUfxWjMa/bifcIWeWZkg4y6mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXD/HI60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXD/HI60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DB91F000FF;
	Thu, 17 Sep 2026 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671064;
	bh=FStkMUp6dEl4k/UOBImSrbAar4ejjR1rpUi8OQQWw+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXD/HI6030v2Vene+whfbDPWFQ6RkuaPy0XsYmnjMHOs/t3KokKK8cgUcgrmZpgUr
	 X6KEmBYQFnTsscNUrlDTwAXCLqApKkB6wZKulbgsuXACjJW8m14/K7Q5OGTq3CgKcY
	 WlK1svLYm12DZ+z0IC90E2pWR7zpW+YSDSkqg9So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+60332fd095f8bb2946ad@syzkaller.appspotmail.com,
	David Carlier <devnexen@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.12 0857/1102] ieee802154: hwsim: serialize pib updates to fix double-free
Date: Thu, 17 Sep 2026 16:13:20 +0100
Message-ID: <20260917151602.059057283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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


