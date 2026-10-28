Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216962;
	b=CZyOXuNUKbYa4MBkCiCz5h0gRhwpCcVln0vbD5hLooZXUuD6AqsA6SEjkfcguORg2qOk
	 X5nUMkLsW4xU0MOP3FW5g8Q0CehLGQw68z5H2ScucX+7z81U+JTrxsLmDkC/j62wHftx9
	 T68Csa3xce/U4u+QjAMpstcGgLtkJes1gfMZiAhvXj5b4sFEeBuVlh/Zm9w+n1PsTcqGK
	 VOk7Z59zVWRdDKn+TQRNZb9t1gCnyWX33olPBS63g7WCCylckB+jH5NHRLHi57zCXJHDT
	 T8BzGJS63Do27j675BJcgFGoCkghCc/gQU0E/jO0K98PFl4Lj/mrqkQ/ckIc8C2ZBUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fWkQJIz2fgOCA2OjaWQw+KhTicrr2X1duIuRL1qzdvQ=;
	b=cGRrW/6hTBvOy/e5piHUoaDQFX5kR6edYhZgccsPD/AkdxBO6DyPF6nRW9SIQV1sOl8/
	 1gccjyRKx9bweB/3T8/eWGL7jpzIcu9NwfWzIoO6sUbWRXCw0y4EezP5TJlr9wWXtvKIY
	 bXpsayuFvJVXgjXKpA/vLaYw5WV35n9u4r3SbUmebRLAWiNr+U1XFsB0mra7UqnHTW0Xt
	 r1pJGagqBtwhTscIdOn4XisnnPzdo60M4um7BciSfd4l/CLmAkS/Z/Hx+XrtqIirQ3Gdt
	 3fD0uMMftODp9q1CdQm9b5d5J0+5PX1DQXWjED4JptQ6fUa91kUX+WHkvKQTweGvDIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZS72Ezz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDAA606A31A;
	Wed, 28 Oct 2026 19:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZS72Ezz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1AF1F01825;
	Wed, 28 Oct 2026 19:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216962;
	bh=fWkQJIz2fgOCA2OjaWQw+KhTicrr2X1duIuRL1qzdvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZS72EzzWdcju81PYLm689qGt2QVo7wB2GmUMtuNlwdFvcxAiScVBtixf2aCZYST5
	 lmkBlmgNMihtzz9u3gibgfdm3pYYP9FtJ/tYIiRIMRREANH0JxGgh3Ehs61sl3vfcX
	 ANaFjsJeGTpKaIvexj7mZRgtLdNrtB+KiXHaPdVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+60332fd095f8bb2946ad@syzkaller.appspotmail.com,
	David Carlier <devnexen@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1696/1887] ieee802154: hwsim: serialize pib updates to fix double-free
Date: Wed, 28 Oct 2026 18:03:12 +0100
Message-ID: <20261028170538.049739030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 979d5b8de8ed4e1f997aef12da5694b99be7b871 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 9b3da61840a8f..1b00efc44dcb0 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -69,6 +69,8 @@ struct hwsim_phy {
 	struct ieee802154_hw *hw;
 	u32 idx;
 
+	/* Serializes phy->pib_updates. */
+	spinlock_t pib_lock;
 	struct hwsim_pib __rcu *pib;
 
 	bool suspended;
@@ -100,8 +102,10 @@ static int hwsim_hw_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 	pib->page = page;
 	pib->channel = channel;
 
-	pib_old = rtnl_dereference(phy->pib);
-	rcu_assign_pointer(phy->pib, pib);
+	spin_lock_bh(&phy->pib_lock);
+	pib_old = rcu_replace_pointer(phy->pib, pib,
+				      lockdep_is_held(&phy->pib_lock));
+	spin_unlock_bh(&phy->pib_lock);
 	kfree_rcu(pib_old, rcu);
 	return 0;
 }
@@ -789,6 +793,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 		goto err_pib;
 	}
 
+	spin_lock_init(&phy->pib_lock);
 	pib->channel = 13;
 	rcu_assign_pointer(phy->pib, pib);
 	phy->idx = idx;
-- 
2.53.0



