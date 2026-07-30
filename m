Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503AF43C7A2;
	Thu, 30 Jul 2026 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422155; cv=none; b=k9rzviRSIugMGAgHmFX9KD/2JFCSIEtDwAC6J9HaTQN31E/Us9YiMsynilNWagGmBDeGZ1qaVxR14gEpmwuLShLJy6gJWBtb6Al7TYpMccQNa2Y7+PzdyWA1WqnMo8OEMSoF9LtJEnv5dzYSdUw8SbxE5aHtn4ZcnAJj4Ot1u9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422155; c=relaxed/simple;
	bh=vHNgSUKf5CmYrvINpLuio37r0XxwMnUUDpJGw1VsH44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBhgIfAkSEkFbifHV7Wr7U4tpVLRbex66PfI0BuKstAgEjYHOQlZwnT+v4ZaVwBOuKoXDKpMnxVQqL8uw/MkLeAdDtvEMSQ+drgFc5P1TZKOWBas0kUaQP/yssVg+s/qdnQ5+Xj9UvRtbqomDg79ZzzRCUCD6pZt1W1tu+4TCZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUKKpp1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUKKpp1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2441F00A3A;
	Thu, 30 Jul 2026 14:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422154;
	bh=r/TL0qxN+dQjPHVrxFQgjVxUAW15aKmYpMBiaX03zl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUKKpp1BRzMYLZrRYCJSfXMvr6u0L8dTBdNQn7X8yg4nhzhGgqkeIj+38E4NQhv3O
	 g23QPEt5+yVzz2Q8aFW3s7xcDTnbttdgngDWgaYR6lJvazVKTq1qHW1phxpB0yVkWA
	 sXVlLctfPNTy5hNjAKhqS6ty+c11HWlka8m2GawA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 7.1 343/744] ice: prevent tstamp ring allocation for non-PF VSI types
Date: Thu, 30 Jul 2026 16:10:16 +0200
Message-ID: <20260730141451.572662596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit 144539bbfd3cea1ab0fb6f5216d6004c1f4f029b ]

The pf->txtime_txqs bitmap tracks which Tx queues have ETF (Earliest
TxTime First) offload enabled. This bitmap is indexed by queue number
and is set by ice_offload_txtime(), which only operates on PF VSI
queues.

However, ice_is_txtime_ena() does not check the VSI type before
consulting the bitmap. When ETF offload is enabled on PF Tx queue 0,
bit 0 is set in pf->txtime_txqs. During a subsequent PCI reset
rebuild, the CTRL VSI's Tx queue 0 is reconfigured and
ice_is_txtime_ena() is called for that ring. Since it only checks
pf->txtime_txqs by queue index without distinguishing VSI type, it
finds bit 0 set and returns true, matching the PF VSI's ETF queue,
not the CTRL VSI's. This causes ice_vsi_cfg_txq() to spuriously
allocate a tstamp_ring for the CTRL VSI ring.

Since CTRL VSI rings have no associated netdev, ice_clean_tx_ring()
takes an early return at the !netdev check before reaching
ice_free_tx_tstamp_ring(), leaking the allocation. Each PCI reset
leaks one 64-byte tstamp_ring.

Fix this by restricting ice_is_txtime_ena() to return true only for
PF VSI rings, since txtime_txqs is only meaningful for PF VSI queues.

Fixes: ccde82e90946 ("ice: add E830 Earliest TxTime First Offload support")
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-11-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 725b130dd3a2c6..f6671a653f21f2 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -767,6 +767,9 @@ static inline bool ice_is_txtime_ena(const struct ice_tx_ring *ring)
 	struct ice_vsi *vsi = ring->vsi;
 	struct ice_pf *pf = vsi->back;
 
+	if (vsi->type != ICE_VSI_PF)
+		return false;
+
 	return test_bit(ring->q_index,  pf->txtime_txqs);
 }
 
-- 
2.53.0



