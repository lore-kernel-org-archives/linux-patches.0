Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C013D3C81B4;
	Fri,  7 Aug 2026 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117201; cv=none; b=l/TBAxJg3hB+Y0aQ+Epd7ujMrzRBXKVR2aTXLtjVOua7YbdLVj6vtcz2a5lgucFn3WraYhX58c3u07uVjH6HroI5/kMSAhbv4qZOieTl/ttgtaJ90awF106HvXDEXyCkO93I8SUtr0+yf2bAf0VwmzbDqgjgryBTpEYciYYfsp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117201; c=relaxed/simple;
	bh=QSWhOq5Z2dSaVJNHCjnfyxrb/GZvFQo6MttO0s0kFVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PylVoPP5NzCVIdraOYSVga1hf5whRyvn0MUtjqyT5Awz/jIIXts164wLuTiD+EiPVjofcAWSPux1FkVwSLg0TfogJQNVcGCHCc/ummbIVHxgTaMrUZL+LUe8K2X+paI9rfiEgFFTTcsLuLB38RBJSlYsOj+kuuWFJdBEddTUjrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yF9ErJ6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yF9ErJ6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FB61F000E9;
	Fri,  7 Aug 2026 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117199;
	bh=1BHuR3As/KWmQbb8afTMdQZsphY4hPU0YIus85faVP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yF9ErJ6GhJnwlT2Eptf3w+lMFRxBPQZTOhg4x7kqsfInsP1n+v9gKsVGdwpLVpHzL
	 568Mn3Y2GWDJ7yhM2tAAoj46S6wxWKx5Hrm3AbjyHFVWZlZoaRwcqsRLGKvaYXAmgo
	 NT4qVCoSWMywC+JMNch7qG4AreFznj4hkzkva1OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Chandelkar <rc@rexion.ai>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 235/438] dibs: fix use-after-free of dmb_node in loopback attach/detach/unregister
Date: Fri,  7 Aug 2026 16:37:11 +0200
Message-ID: <20260807143433.015269790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Hidayath Khan <hidayath@linux.ibm.com>

commit a10ea943356b9d70c5616a0a06f6fa97cfdaccb1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dibs/dibs_loopback.c |   47 +++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/drivers/dibs/dibs_loopback.c
+++ b/drivers/dibs/dibs_loopback.c
@@ -118,14 +118,9 @@ err_bit:
 	return rc;
 }
 
-static void __dibs_lo_unregister_dmb(struct dibs_lo_dev *ldev,
-				     struct dibs_lo_dmb_node *dmb_node)
+static void dibs_lo_free_dmb(struct dibs_lo_dev *ldev,
+			     struct dibs_lo_dmb_node *dmb_node)
 {
-	/* remove dmb from hash table */
-	write_lock_bh(&ldev->dmb_ht_lock);
-	hash_del(&dmb_node->list);
-	write_unlock_bh(&ldev->dmb_ht_lock);
-
 	clear_bit(dmb_node->sba_idx, ldev->sba_idx_mask);
 	folio_put(virt_to_folio(dmb_node->cpu_addr));
 	kfree(dmb_node);
@@ -139,27 +134,33 @@ static int dibs_lo_unregister_dmb(struct
 	struct dibs_lo_dmb_node *dmb_node = NULL, *tmp_node;
 	struct dibs_lo_dev *ldev;
 	unsigned long flags;
+	bool last;
 
 	ldev = dibs->drv_priv;
 
 	/* find dmb from hash table */
-	read_lock_bh(&ldev->dmb_ht_lock);
+	write_lock_bh(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb->dmb_tok) {
 		if (tmp_node->token == dmb->dmb_tok) {
 			dmb_node = tmp_node;
 			break;
 		}
 	}
-	read_unlock_bh(&ldev->dmb_ht_lock);
-	if (!dmb_node)
+	if (!dmb_node) {
+		write_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
+	}
+	last = refcount_dec_and_test(&dmb_node->refcnt);
+	if (last)
+		hash_del(&dmb_node->list);
+	write_unlock_bh(&ldev->dmb_ht_lock);
 
-	if (refcount_dec_and_test(&dmb_node->refcnt)) {
+	if (last) {
 		spin_lock_irqsave(&dibs->lock, flags);
 		dibs->dmb_clientid_arr[dmb_node->sba_idx] = NO_DIBS_CLIENT;
 		spin_unlock_irqrestore(&dibs->lock, flags);
 
-		__dibs_lo_unregister_dmb(ldev, dmb_node);
+		dibs_lo_free_dmb(ldev, dmb_node);
 	}
 	return 0;
 }
@@ -188,14 +189,9 @@ static int dibs_lo_attach_dmb(struct dib
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
 	dmb->idx = dmb_node->sba_idx;
 	dmb->dmb_tok = dmb_node->token;
@@ -209,11 +205,12 @@ static int dibs_lo_detach_dmb(struct dib
 {
 	struct dibs_lo_dmb_node *dmb_node = NULL, *tmp_node;
 	struct dibs_lo_dev *ldev;
+	bool last;
 
 	ldev = dibs->drv_priv;
 
 	/* find dmb_node according to dmb->dmb_tok */
-	read_lock_bh(&ldev->dmb_ht_lock);
+	write_lock_bh(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, token) {
 		if (tmp_node->token == token) {
 			dmb_node = tmp_node;
@@ -221,13 +218,17 @@ static int dibs_lo_detach_dmb(struct dib
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
+		dibs_lo_free_dmb(ldev, dmb_node);
 
-	if (refcount_dec_and_test(&dmb_node->refcnt))
-		__dibs_lo_unregister_dmb(ldev, dmb_node);
 	return 0;
 }
 


