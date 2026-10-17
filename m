Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338682C026C;
	Sat, 17 Oct 2026 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254569; cv=none; b=a1M3yOlelDZIWmfoukjFERRybsokWTRbwlw55ql07XFZUHBOLxaXkNYqGQjkpWBYHKQv3ObbmBusUzQS2PWjYtVVW+GwCZpribUQVMol3xRBUaX6cZvb6Mo5WbVxt+Bj+PFhLAI2qWNe8wZk4FujuO9B0Sy186MsxH2slRSriyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254569; c=relaxed/simple;
	bh=8i8N3sUlyMzm2Nk/eGLwIP78yShmaQf6Pdqw+HVKyeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zyh2oO24bga/Hr4RbdBlLv+ALZgBxMkS1Pz8Q5ywT9i+Fny3NRPbFUimkgP3LCl3yJMiENi8tszm4FJv2/pIlat3mLj/4C3WtaIWfhLhKoUjAYp7JY/NMUlUHOhKs9fnB6Yfcl1fT2Tzt3wV3G/RVLX4hLMbbfbE4B7p2GjOAt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9BqLF/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9BqLF/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA9B1F000C4;
	Sat, 17 Oct 2026 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254567;
	bh=SoLW1JHOPMaHl8DwykumUg2WyRWuPsDvrupKiDLF56E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9BqLF/9Vy4CZjgMHfYvGL3Wi9b7ECg79VW2xOAFPT5/xFps7f5N27Wv0dHwCOTCm
	 eo5JGOJLEf4oRcgHjtcTgHerO8Ojpm5ULfNNe9qCtO84xbw0xPYB5GZHSCu2RNUtCu
	 wAjJ9EPRfilXFYajmn9iifPTBs1xSqwOfXjWF20o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Chandelkar <rc@rexion.ai>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 490/869] dibs: fix use-after-free of dmb_node in loopback attach/detach/unregister
Date: Sat, 17 Oct 2026 17:55:31 +0200
Message-ID: <20261017160049.678368673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Hidayath Khan <hidayath@linux.ibm.com>

[ Upstream commit a10ea943356b9d70c5616a0a06f6fa97cfdaccb1 ]

dibs_lo_attach_dmb(), dibs_lo_detach_dmb() and dibs_lo_unregister_dmb()
look up the dmb_node under dmb_ht_lock, drop the lock and only then
operate on the node's refcount. Nothing keeps the node alive across
that window: __dibs_lo_unregister_dmb() removes the node from the hash
table under the write lock and immediately frees it.

A concurrent final put can therefore free the node between the lookup
and the refcount operation:

CPU0 (attach)                     CPU1 (owner unregisters)

read_lock_bh(&dmb_ht_lock)
find dmb_node (refcnt == 1)
read_unlock_bh(&dmb_ht_lock)
                                  refcount_dec_and_test() 1 -> 0
                                  write_lock_bh(&dmb_ht_lock)
                                  hash_del(&dmb_node->list)
                                  write_unlock_bh(&dmb_ht_lock)
                                  kfree(dmb_node)
refcount_inc_not_zero(&dmb_node->refcnt)  <-- use-after-free

The same window exists for the refcount_dec_and_test() calls in the
detach and unregister paths.

Close the race structurally by making hash table membership and the
refcount transitions atomic with respect to each other:

- Perform the final refcount_dec_and_test() and hash_del() in a single
  dmb_ht_lock write-side critical section, in both the unregister and
  the detach path. Freeing the node still happens after the lock is
  dropped, which is safe because a node whose refcount reached zero has
  left the hash table and can no longer be found.

- This establishes the invariant that any node found in the hash table
  holds at least one reference, and that the final reference can only
  be dropped under the write lock. dibs_lo_attach_dmb() can thus take
  its reference with a plain refcount_inc() while still holding the
  read lock; refcount_inc_not_zero() is no longer needed.

__dibs_lo_unregister_dmb() no longer touches the hash table and is
renamed to dibs_lo_free_dmb() accordingly.

Note: commit cc21191b584c ("dibs: Move data path to dibs layer") moved
the code to its current location; the race was introduced earlier by
commit c3a910f2380f ("net/smc: implement DMB-merged operations of
loopback-ism").

Tested SMC-D via ISM and dibs loopback.

Cc: stable@vger.kernel.org
Fixes: c3a910f2380f ("net/smc: implement DMB-merged operations of loopback-ism")
Reported-by: Rahul Chandelkar <rc@rexion.ai>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260727093530.968834-1-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_loopback.c | 45 +++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/net/smc/smc_loopback.c b/net/smc/smc_loopback.c
index 0bf9e4075f033..cb72ff920578a 100644
--- a/net/smc/smc_loopback.c
+++ b/net/smc/smc_loopback.c
@@ -117,14 +117,9 @@ static int smc_lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
 	return rc;
 }
 
-static void __smc_lo_unregister_dmb(struct smc_lo_dev *ldev,
-				    struct smc_lo_dmb_node *dmb_node)
+static void smc_lo_free_dmb(struct smc_lo_dev *ldev,
+			    struct smc_lo_dmb_node *dmb_node)
 {
-	/* remove dmb from hash table */
-	write_lock_bh(&ldev->dmb_ht_lock);
-	hash_del(&dmb_node->list);
-	write_unlock_bh(&ldev->dmb_ht_lock);
-
 	clear_bit(dmb_node->sba_idx, ldev->sba_idx_mask);
 	folio_put(virt_to_folio(dmb_node->cpu_addr));
 	kfree(dmb_node);
@@ -137,9 +132,10 @@ static int smc_lo_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 {
 	struct smc_lo_dmb_node *dmb_node = NULL, *tmp_node;
 	struct smc_lo_dev *ldev = smcd->priv;
+	bool last;
 
 	/* find dmb from hash table */
-	read_lock_bh(&ldev->dmb_ht_lock);
+	write_lock_bh(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb->dmb_tok) {
 		if (tmp_node->token == dmb->dmb_tok) {
 			dmb_node = tmp_node;
@@ -147,13 +143,16 @@ static int smc_lo_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 		}
 	}
 	if (!dmb_node) {
-		read_unlock_bh(&ldev->dmb_ht_lock);
+		write_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
 	}
-	read_unlock_bh(&ldev->dmb_ht_lock);
+	last = refcount_dec_and_test(&dmb_node->refcnt);
+	if (last)
+		hash_del(&dmb_node->list);
+	write_unlock_bh(&ldev->dmb_ht_lock);
 
-	if (refcount_dec_and_test(&dmb_node->refcnt))
-		__smc_lo_unregister_dmb(ldev, dmb_node);
+	if (last)
+		smc_lo_free_dmb(ldev, dmb_node);
 	return 0;
 }
 
@@ -179,14 +178,9 @@ static int smc_lo_attach_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 		read_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
 	}
+	refcount_inc(&dmb_node->refcnt);
 	read_unlock_bh(&ldev->dmb_ht_lock);
 
-	if (!refcount_inc_not_zero(&dmb_node->refcnt))
-		/* the dmb is being unregistered, but has
-		 * not been removed from the hash table.
-		 */
-		return -EINVAL;
-
 	/* provide dmb information */
 	dmb->sba_idx = dmb_node->sba_idx;
 	dmb->dmb_tok = dmb_node->token;
@@ -200,9 +194,10 @@ static int smc_lo_detach_dmb(struct smcd_dev *smcd, u64 token)
 {
 	struct smc_lo_dmb_node *dmb_node = NULL, *tmp_node;
 	struct smc_lo_dev *ldev = smcd->priv;
+	bool last;
 
 	/* find dmb_node according to dmb->dmb_tok */
-	read_lock_bh(&ldev->dmb_ht_lock);
+	write_lock_bh(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, token) {
 		if (tmp_node->token == token) {
 			dmb_node = tmp_node;
@@ -210,13 +205,17 @@ static int smc_lo_detach_dmb(struct smcd_dev *smcd, u64 token)
 		}
 	}
 	if (!dmb_node) {
-		read_unlock_bh(&ldev->dmb_ht_lock);
+		write_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
 	}
-	read_unlock_bh(&ldev->dmb_ht_lock);
+	last = refcount_dec_and_test(&dmb_node->refcnt);
+	if (last)
+		hash_del(&dmb_node->list);
+	write_unlock_bh(&ldev->dmb_ht_lock);
+
+	if (last)
+		smc_lo_free_dmb(ldev, dmb_node);
 
-	if (refcount_dec_and_test(&dmb_node->refcnt))
-		__smc_lo_unregister_dmb(ldev, dmb_node);
 	return 0;
 }
 
-- 
2.53.0



