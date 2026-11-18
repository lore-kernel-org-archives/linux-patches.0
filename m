Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018098;
	b=XlLgvplsWSIjP0DkopXwgBrsswPb/GV+5i0QaKAhs8jGvkG5B13YVtLaw6vGX3aLtCJV
	 DrBVem71J2oLptmeifeYUJopZ8EbSdtgOtsc0GyiszOXDNaAWAmnJmHYLpiWZEH3eJ2tC
	 mElDjNeTsfUOpsG0E3CJBcxP3rNR3h/xMeBf6rb3YrE85+va6Alz25koGeIU8twaJHtVE
	 d1iKaKtgeCQ4+CpZSlzntDV1T7QG0lCUjEF6nV/jbnimU7nj5DjsDK7Y5t2paTc///OHL
	 rV22ETy0sc6wt3vMfd38saqaBl4ERSgmFubqc0QFSJ4U8zp5EyOictEN5Q0gVP6z27A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JfgEahKzFZZhUKEPA9Cemd5lQp0DGGVc3DJnRljl5b0=;
	b=b9kyFZ7c/oHg+jHRcnRphqsurucZAnvU1M7FJlYrSJnroEyrnhaB0AM41QRHOfhn5ruw
	 2OJD1TsJYksI+ab1mTBSaskEDaZ35H6XSZ62XrJkliTXxhsx0u8eCtcEODpTGWXtjlK2A
	 6/ERQb9qLjUmtQ5qyxhjWH7WJ/Ib4epwM16VcKO5GGlFNdygy+mGMN6FBcjC1YHXORCaQ
	 sQTRnvR7IlRWZ/Xc4Z91UX4w4n0iHOi5ieyWSFe391pwZwFx/Ozj5TJhYn5t0wh7LmR/P
	 OhpBm2kDQFMMwq4VHnKeGdjfReGi4A/X/ec7KXSxtNk0s2OQAFM8J+E0cnKPM5W4lmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VmPTujP8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC66606A330;
	Wed, 18 Nov 2026 16:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VmPTujP8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDAC1F000C4;
	Wed, 18 Nov 2026 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018098;
	bh=JfgEahKzFZZhUKEPA9Cemd5lQp0DGGVc3DJnRljl5b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmPTujP8PZqpoYhJuNVtqPFIAH7eTiFOc1O0H7oTaaJecAUXxf5ivnGZ2ahdP2S4E
	 Bq74PGluz1sroEaL8lvvwBbLRf4OIpWOsA241Z510V/kJDh2MdvPFhtmytPra7jpfA
	 XEK5QO1zubIobyFBMDLoFy62lU/iOCb8F8BUDurc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1085/2651] ice: rebuild ring stats arrays instead of reallocating them in place
Date: Wed, 18 Nov 2026 15:38:45 +0100
Message-ID: <20261118150327.056735281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 66444f06a9fe96ac49f5c168d06aaebbfa109c9e ]

ice_vsi_realloc_stat_arrays() resized the ring stats arrays in place
with krealloc_array(), sizing them from vsi->req_txq/req_rxq. That is
not what ice_vsi_set_num_qs() computes later in ice_vsi_cfg_def(), so
after a rebuild the arrays could end up shorter than vsi->alloc_txq /
vsi->alloc_rxq, and ice_vsi_alloc_ring_stats() then walked past their
end.

The VF case shows the divergence. ice_sriov_set_msix_vec_count() writes
vsi->req_txq and then calls ice_vsi_rebuild(), so the old resizer sized
from req_txq, while ice_vsi_get_num_qs() reads vf->num_req_qs ?:
vf->num_vf_qs and ignores req_txq entirely. Once a guest has raised
vf->num_req_qs through VIRTCHNL_OP_REQUEST_QUEUES the two disagree and
the arrays come out shorter than the alloc_txq/alloc_rxq the rebuild
installs. The reset that such a request triggers is a different path,
ice_vf_reconfig_vsi(), which does not use this resizer at all; that one
is handled by the next patch.

Replace it with ice_vsi_resize_stat_arrays(), which allocates a fresh
struct ice_vsi_stats instead, sized with ice_vsi_get_num_qs() and the
queues ice_vsi_decfg() is about to return to the PF pool, which is
exactly what ice_vsi_set_num_qs() will compute once they are back
there, barring a concurrent change of the PF pool; the next patch stops
relying on that. Copy the surviving entry pointers over and install
the new structure, all before ice_vsi_decfg() runs. The entries that
did not fit are freed by ice_vsi_free_unused_stat_arrays(); the old
container itself then goes through __ice_vsi_free_stats() with
@free_entries set to false, since the entries it still points at now
belong to the new structure.

Allocating up front also means a failure no longer leaves a half-updated
ice_vsi_stats behind, with the Tx array already swapped and its surplus
Tx entries already freed, but the Rx allocation failed.

Put the allocate-install-free-surplus sequence in
ice_vsi_install_stat_arrays(), next to ice_vsi_new_stat_arrays(), so
that only the sizing decision is left in the resizer.

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20260925132636.123300-6-przemyslaw.kitszel@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1c3b87896e6 ("ice: size ring stats arrays from the final queue count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 144 ++++++++++++++---------
 1 file changed, 88 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 134984077d5da..448d3c7780adf 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -557,6 +557,80 @@ static struct ice_vsi_stats *ice_vsi_new_stat_arrays(int txq, int rxq)
 	return vsi_stat;
 }
 
+static void ice_vsi_free_unused_stat_arrays(struct ice_vsi_stats *vsi_stat,
+					    struct ice_vsi_stats *new_vsi_stat)
+{
+	int new_txq = new_vsi_stat->tx_ring_stats_len;
+	int new_rxq = new_vsi_stat->rx_ring_stats_len;
+	int prev_txq = vsi_stat->tx_ring_stats_len;
+	int prev_rxq = vsi_stat->rx_ring_stats_len;
+
+	for (int i = new_txq; i < prev_txq; i++) {
+		if (vsi_stat->tx_ring_stats[i]) {
+			kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
+			WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
+		}
+	}
+	for (int i = new_rxq; i < prev_rxq; i++) {
+		if (vsi_stat->rx_ring_stats[i]) {
+			kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
+			WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
+		}
+	}
+}
+
+static void ice_vsi_set_stat_arrays(struct ice_vsi *vsi,
+				    struct ice_vsi_stats *new_vsi_stat)
+{
+	u16 new_txq, new_rxq, prev_txq, prev_rxq;
+	struct ice_vsi_stats *vsi_stat;
+	struct ice_pf *pf = vsi->back;
+
+	new_txq = new_vsi_stat->tx_ring_stats_len;
+	new_rxq = new_vsi_stat->rx_ring_stats_len;
+	vsi_stat = pf->vsi_stats[vsi->idx];
+	pf->vsi_stats[vsi->idx] = new_vsi_stat;
+	if (!vsi_stat)
+		return; /* don't copy if there is no source */
+
+	prev_txq = vsi_stat->tx_ring_stats_len;
+	prev_rxq = vsi_stat->rx_ring_stats_len;
+
+	memcpy(new_vsi_stat->tx_ring_stats, vsi_stat->tx_ring_stats,
+	       sizeof(*vsi_stat->tx_ring_stats) * min(prev_txq, new_txq));
+	memcpy(new_vsi_stat->rx_ring_stats, vsi_stat->rx_ring_stats,
+	       sizeof(*vsi_stat->rx_ring_stats) * min(prev_rxq, new_rxq));
+}
+
+/**
+ * ice_vsi_install_stat_arrays - swap in freshly sized ring stats arrays
+ * @vsi: VSI to install the ring stats arrays of
+ * @txq: number of Tx ring stats entries to make room for
+ * @rxq: number of Rx ring stats entries to make room for
+ *
+ * Surviving entries are carried over, the rest is freed together with the old
+ * container.
+ *
+ * Return: 0 on success and negative value on failure.
+ */
+static int ice_vsi_install_stat_arrays(struct ice_vsi *vsi, u16 txq, u16 rxq)
+{
+	struct ice_vsi_stats *old_stat, *new_stat;
+
+	new_stat = ice_vsi_new_stat_arrays(txq, rxq);
+	if (!new_stat)
+		return -ENOMEM;
+
+	old_stat = vsi->back->vsi_stats[vsi->idx];
+	ice_vsi_set_stat_arrays(vsi, new_stat);
+	if (old_stat) {
+		ice_vsi_free_unused_stat_arrays(old_stat, new_stat);
+		__ice_vsi_free_stats(old_stat, false);
+	}
+
+	return 0;
+}
+
 /**
  * ice_vsi_alloc_stat_arrays - Allocate statistics arrays
  * @vsi: VSI pointer
@@ -3040,69 +3114,27 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 }
 
 /**
- * ice_vsi_realloc_stat_arrays - Frees unused stat structures or alloc new ones
- * @vsi: VSI pointer
+ * ice_vsi_resize_stat_arrays - resize ring stats arrays for new queue count
+ * @vsi: VSI to swap the ring stats arrays of
+ *
+ * Call while @vsi still owns its queues and before ice_vsi_decfg() returns them
+ * to the PF pool, so that the new size is what ice_vsi_set_num_qs() will compute
+ * afterwards. Surviving entries are carried over, the rest is freed.
+ *
+ * Return: 0 on success and negative value on failure.
  */
-static int
-ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi)
+static int ice_vsi_resize_stat_arrays(struct ice_vsi *vsi)
 {
-	u16 req_txq = vsi->req_txq ? vsi->req_txq : vsi->alloc_txq;
-	u16 req_rxq = vsi->req_rxq ? vsi->req_rxq : vsi->alloc_rxq;
-	struct ice_ring_stats **tx_ring_stats;
-	struct ice_ring_stats **rx_ring_stats;
-	struct ice_vsi_stats *vsi_stat;
-	struct ice_pf *pf = vsi->back;
-	u16 prev_txq = vsi->alloc_txq;
-	u16 prev_rxq = vsi->alloc_rxq;
-	int i;
+	struct ice_vsi_alloc_queues_params qs;
 
 	/* channel VSIs have no entry in pf->vsi_stats[] */
 	if (vsi->type == ICE_VSI_CHNL)
 		return 0;
 
-	vsi_stat = pf->vsi_stats[vsi->idx];
-
-	if (req_txq < prev_txq) {
-		for (i = req_txq; i < prev_txq; i++) {
-			if (vsi_stat->tx_ring_stats[i]) {
-				kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
-				WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
-			}
-		}
-	}
-
-	tx_ring_stats = vsi_stat->tx_ring_stats;
-	vsi_stat->tx_ring_stats =
-		krealloc_array(vsi_stat->tx_ring_stats, req_txq,
-			       sizeof(*vsi_stat->tx_ring_stats),
-			       GFP_KERNEL | __GFP_ZERO);
-	if (!vsi_stat->tx_ring_stats) {
-		vsi_stat->tx_ring_stats = tx_ring_stats;
-		return -ENOMEM;
-	}
-	vsi_stat->tx_ring_stats_len = req_txq;
+	qs = ice_vsi_get_num_qs(vsi, vsi->alloc_txq + vsi->num_xdp_txq,
+				vsi->alloc_rxq);
 
-	if (req_rxq < prev_rxq) {
-		for (i = req_rxq; i < prev_rxq; i++) {
-			if (vsi_stat->rx_ring_stats[i]) {
-				kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
-				WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
-			}
-		}
-	}
-
-	rx_ring_stats = vsi_stat->rx_ring_stats;
-	vsi_stat->rx_ring_stats =
-		krealloc_array(vsi_stat->rx_ring_stats, req_rxq,
-			       sizeof(*vsi_stat->rx_ring_stats),
-			       GFP_KERNEL | __GFP_ZERO);
-	if (!vsi_stat->rx_ring_stats) {
-		vsi_stat->rx_ring_stats = rx_ring_stats;
-		return -ENOMEM;
-	}
-	vsi_stat->rx_ring_stats_len = req_rxq;
-
-	return 0;
+	return ice_vsi_install_stat_arrays(vsi, qs.alloc_txq, qs.alloc_rxq);
 }
 
 /**
@@ -3132,7 +3164,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, u32 vsi_flags)
 
 	mutex_lock(&vsi->xdp_state_lock);
 
-	ret = ice_vsi_realloc_stat_arrays(vsi);
+	ret = ice_vsi_resize_stat_arrays(vsi);
 	if (ret)
 		goto unlock;
 
-- 
2.53.0



