Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743DF3CB56A;
	Wed, 30 Sep 2026 19:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795925; cv=none; b=Ql59lufvS/z7adzr68PP5JKCmSKrlK3PgccbRnShl1iek554GytUFeG5zuKenbK5AEzeetRGI/OBgObnPXfhjPUx6SyGVKeURrwB6iipzGb30blv3jwa9R93NjC4LBJIGpUdgNQuIn2A0jlDwhH5Rp+/wHs/fauFVkUFdOZdG2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795925; c=relaxed/simple;
	bh=csF0MsW4/ALrXjGIR8IoCJbXoc+n1LiT2PxeuYPx8N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTrsZXUzxR0DJL4p8mGmjJ3W96l0QTKQQ21bnnycaKs61g9cjWV5lz9Vvpb1VzbOhZaJ1VzaoU3kvz0nhBhMNjBGl16mkOtR/nxAENQ0lZ/weqpd94djJ9l2YvDZoYSAZhXTRyWNPBwogx7Huom/IzzXI/mSj4+um/dLwHgOm2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVcnCuDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVcnCuDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D034A1F000FF;
	Wed, 30 Sep 2026 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795924;
	bh=Hk9NxgYFTd9l8Ds58yfDZjVCYv1MGokEjS2R52WzPcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVcnCuDjZvE2JzPngjS8PLni1FIauqQwi7qN31FqtrHZWNv8sKfEqbi0uMt3stn3Q
	 MJIqk7Z0BSK/Hbp13CeFOhv2qmf8RzYyhCD4AoNBZOVRX82bKoWKWp5LEBhRj9fX6d
	 wP988KeX8qAjmP1bGzfJwpHPJDBtiSfFFOQ00BZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0732/1193] RDMA/rxe: insert mcg into mcg_tree only after rxe_mcast_add() succeeds
Date: Wed, 30 Sep 2026 17:23:36 +0200
Message-ID: <20260930152450.516724376@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 1caceeb2d74bbe88223aea55eb8626b4c5f076fd ]

rxe_get_mcg() publishes a newly allocated multicast group in
rxe->mcg_tree before programming the backing Ethernet multicast address
with rxe_mcast_add(), which runs outside mcg_lock. A local userspace
RDMA client reaches this path with ATTACH_MCAST on a UD QP; if
rxe_mcast_add() then returns an error (for example -ENODEV when the
backing netdev has been removed, or a propagated dev_mc_add() error),
the unwind frees the published group without removing it from the tree.
A later lookup of the same MGID dereferences the freed struct rxe_mcg
from __rxe_lookup_mcg().

Fix this by keeping the new mcg private until rxe_mcast_add() succeeds.
Split the tree publication into __rxe_publish_mcg(), call rxe_mcast_add()
before taking the tree reference, and free the still-private mcg on
failure. Because the group is never visible in mcg_tree until the
multicast address is programmed, no concurrent caller can look it up or
attach a QP to a group that is about to be torn down, so the error path
needs no conditional unwind. If another caller publishes the same MGID
while the address is being programmed, the post-add re-check under
mcg_lock finds the winner; this caller then drops its private object and
balances its own rxe_mcast_add() with rxe_mcast_del() before returning
the winner.

Reproduced by forcing the rxe_mcast_add() error return under KASAN:
without the change the next attach to the same MGID reports a
slab-use-after-free in __rxe_lookup_mcg(); with it the forced failure
returns cleanly. A no-injection attach/detach regression, including a
two-QP shared join/leave and re-attach, stays KASAN- and leak-clean.

Fixes: a926a903b7dc ("RDMA/rxe: Do not call  dev_mc_add/del() under a spinlock")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260617022728.2770116-1-michael.bommarito@gmail.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mcast.c | 50 +++++++++++++++++++--------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mcast.c b/drivers/infiniband/sw/rxe/rxe_mcast.c
index 07ff47bae31df..c14680c9a5362 100644
--- a/drivers/infiniband/sw/rxe/rxe_mcast.c
+++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
@@ -175,7 +175,9 @@ struct rxe_mcg *rxe_lookup_mcg(struct rxe_dev *rxe, union ib_gid *mgid)
  * @mgid: multicast address as a gid
  * @mcg: new mcg object
  *
- * Context: caller should hold rxe->mcg lock
+ * Initializes the mcg fields. The mcg is private and not yet visible in
+ * mcg_tree, so this may run without rxe->mcg_lock; __rxe_publish_mcg()
+ * makes it visible under the lock once it is ready.
  */
 static void __rxe_init_mcg(struct rxe_dev *rxe, union ib_gid *mgid,
 			   struct rxe_mcg *mcg)
@@ -184,13 +186,22 @@ static void __rxe_init_mcg(struct rxe_dev *rxe, union ib_gid *mgid,
 	memcpy(&mcg->mgid, mgid, sizeof(mcg->mgid));
 	INIT_LIST_HEAD(&mcg->qp_list);
 	mcg->rxe = rxe;
+}
 
-	/* caller holds a ref on mcg but that will be
-	 * dropped when mcg goes out of scope. We need to take a ref
-	 * on the pointer that will be saved in the red-black tree
-	 * by __rxe_insert_mcg and used to lookup mcg from mgid later.
-	 * Inserting mcg makes it visible to outside so this should
-	 * be done last after the object is ready.
+/**
+ * __rxe_publish_mcg - make a fully initialized mcg visible in mcg_tree
+ * @mcg: the mcg object
+ *
+ * Context: caller must hold rxe->mcg_lock and a reference on mcg
+ */
+static void __rxe_publish_mcg(struct rxe_mcg *mcg)
+{
+	/* caller holds a ref on mcg but that will be dropped when mcg goes
+	 * out of scope. We need to take a ref on the pointer that will be
+	 * saved in the red-black tree by __rxe_insert_mcg and used to lookup
+	 * mcg from mgid later. Inserting mcg makes it visible to outside so
+	 * this is done last after the object is ready and the multicast
+	 * address has been programmed.
 	 */
 	kref_get(&mcg->ref_cnt);
 	__rxe_insert_mcg(mcg);
@@ -228,26 +239,37 @@ static struct rxe_mcg *rxe_get_mcg(struct rxe_dev *rxe, union ib_gid *mgid)
 		err = -ENOMEM;
 		goto err_dec;
 	}
+	__rxe_init_mcg(rxe, mgid, mcg);
+
+	/* program the multicast address while mcg is still private, before
+	 * it is inserted into mcg_tree. dev_mc_add() may sleep so this must
+	 * run outside mcg_lock. On failure mcg was never published, so a
+	 * plain free is correct and the tree is untouched.
+	 */
+	err = rxe_mcast_add(rxe, mgid);
+	if (err) {
+		kfree(mcg);
+		goto err_dec;
+	}
 
 	spin_lock_bh(&rxe->mcg_lock);
-	/* re-check to see if someone else just added it */
+	/* re-check to see if someone else just added it while we were adding
+	 * the multicast address; if so use theirs and drop ours
+	 */
 	tmp = __rxe_lookup_mcg(rxe, mgid);
 	if (tmp) {
 		spin_unlock_bh(&rxe->mcg_lock);
+		rxe_mcast_del(rxe, mgid);
 		atomic_dec(&rxe->mcg_num);
 		kfree(mcg);
 		return tmp;
 	}
 
-	__rxe_init_mcg(rxe, mgid, mcg);
+	__rxe_publish_mcg(mcg);
 	spin_unlock_bh(&rxe->mcg_lock);
 
-	/* add mcast address outside of lock */
-	err = rxe_mcast_add(rxe, mgid);
-	if (!err)
-		return mcg;
+	return mcg;
 
-	kfree(mcg);
 err_dec:
 	atomic_dec(&rxe->mcg_num);
 	return ERR_PTR(err);
-- 
2.53.0



