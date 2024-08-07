Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0638680BF8;
	Wed,  7 Aug 2024 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043389; cv=none; b=TPbkQd0DHqwvVikAgAl055ey8Me7ENwAEE5U3z7jKBuf1azNKFJu660kyffRkUyZBkzqsku9Fe7X5zPinuSFTW4M3I8mESDjxZpVkcjg78JWsOhdA63UxGoUDCcW004bB55PT5vwvXiZ29X1j4+/glFRz3ExcWKofDEy4sgz8V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043389; c=relaxed/simple;
	bh=gdlVhb0ALYasFhZH4yovP6exVKlFQOVPaSjWPpFckrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvLolEIVAbr1ljFDZaAazLC68qIbDppQMuoeUoMUxffWE6yATX973Or5SqvnU1tgGNQ0i1EmmfFw6I+RCoqoqCwZlKFEPJeQTBHC31H2pQgBBz9PUDyZ1fJpdrkJMyrkduhah/ejMlP7zYnJXwSNyeIMkWeU/d1t+58xEwzncGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iwb9zJwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iwb9zJwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1ADC32781;
	Wed,  7 Aug 2024 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043388;
	bh=gdlVhb0ALYasFhZH4yovP6exVKlFQOVPaSjWPpFckrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iwb9zJwj4OArS0AY1ORq0VwmSf6f5V/alJ9zPLlW+b8xlxaGYNzlmd7Ny+xdqoM5x
	 wyoS7oGYiEva7+U3ouKYlbwY/N3eFJCqoEXgRj2EOVccqNgBYkfjLP5nLRutix/Vha
	 Pd62Zj9esQxjtIptKuJkI9AabBQ35nrAjF6yejXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 072/121] ice: add missing WRITE_ONCE when clearing ice_rx_ring::xdp_prog
Date: Wed,  7 Aug 2024 17:00:04 +0200
Message-ID: <20240807150021.760446324@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 6044ca26210ba72b3dcc649fae1cbedd9e6ab018 ]

It is read by data path and modified from process context on remote cpu
so it is needed to use WRITE_ONCE to clear the pointer.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 24c914015973e..49b1fa9651161 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -456,7 +456,7 @@ void ice_free_rx_ring(struct ice_rx_ring *rx_ring)
 	if (rx_ring->vsi->type == ICE_VSI_PF)
 		if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 			xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
-	rx_ring->xdp_prog = NULL;
+	WRITE_ONCE(rx_ring->xdp_prog, NULL);
 	if (rx_ring->xsk_pool) {
 		kfree(rx_ring->xdp_buf);
 		rx_ring->xdp_buf = NULL;
-- 
2.43.0



