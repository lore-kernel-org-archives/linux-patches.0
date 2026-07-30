Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB033769F5;
	Thu, 30 Jul 2026 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424360; cv=none; b=t6Lk6palh7rH/ueOiYRCI6fmD1gvmLVKcYGKPsyS1qaCu3AhFqxYNDaYZUVb7EHwCmMEtodx2wYenpAOIXrSw4r+nuPSlhc9ZoG8j+DUpGNPgPNkeSiOc1QofDK57bn1AejU7FNEiMaJ/TDYq7WMLPU42Gi4lbuP9ZWKenb0z6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424360; c=relaxed/simple;
	bh=wLy1OEUNA+qAu4vZw2oUBBW6/euDJiu7UFZfwJ7Y31M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heiM3Dx6zLqQrdF4Me50aBF0gvEzIU9BiaMlN3qKB8SIE/xabc2sK43hC/I3qTmYnb/KHtIzA8fbKqZEE3NyD3neKN7iWWeE0MPXxiO0is91VKvW3bG8kV8L73/FwoGFy2OtZ/MKng+M+oJR3ANPF5f/R6ZQJg5KL7mzEmRBPvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqbfHa9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqbfHa9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7D11F000E9;
	Thu, 30 Jul 2026 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424358;
	bh=PlbhihFddmujZUktXzDzNEH1mt8lO+tgPg2dyerBgOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqbfHa9nVirYaogPfkRUhV9ze+wvwG9quwEf75DwWM7PZ6vMrIdBn1KEdOD/+MTeD
	 NTfUsYm3fEsRWGF6KpMDIsA9i/oLSzsxr9dCT7JqgzBN+YIXXwDvMBGGhLMYPsSytp
	 1QWP/9C1XmiGbLU5ns3lLWO68Gu1FGm2Mj5bOAnc=
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
Subject: [PATCH 6.18 311/675] ice: prevent tstamp ring allocation for non-PF VSI types
Date: Thu, 30 Jul 2026 16:10:41 +0200
Message-ID: <20260730141451.736011245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6886188043764c..fc4eae0a00cd3b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -765,6 +765,9 @@ static inline bool ice_is_txtime_ena(const struct ice_tx_ring *ring)
 	struct ice_vsi *vsi = ring->vsi;
 	struct ice_pf *pf = vsi->back;
 
+	if (vsi->type != ICE_VSI_PF)
+		return false;
+
 	return test_bit(ring->q_index,  pf->txtime_txqs);
 }
 
-- 
2.53.0



