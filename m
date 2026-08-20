Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48809377A82;
	Thu, 20 Aug 2026 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248513; cv=none; b=VWOwlsjibXCX89AC7/Ckm2kc6UQ+Y0pIxdqzWh91NgTNppvlOSMSdVhhcf5s+oNzWbKG1ZKINnm+yGcXk885at/JDb2MhAIYWzsFA9sVIQia9A9Nl+bK/HJ/l3Y7hRCONFYVK0yalXGbND1h+08r3iKB7KOQJvu7NhFmPagPDN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248513; c=relaxed/simple;
	bh=Xk0I+bTArHvf1dn6CH+Mw87zFMqu1Bm1zF5ICeGf69M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXWMTp6BUAMjamDRKblcUJbllPvLtfVpM1ufAotssz0Ux5hQColhZO43xnlbwo2REfrpZ0VPUuLdW7isa36BCJSX24SgYcjmyqPr66S8Qyfg4ALmrgJbKbyQXEkeNvdQNZXd4jPwrrFYmkLbFzUVygNeIesWCr5qrlbgvJ/iKio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pADI5S5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pADI5S5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A561F000E9;
	Thu, 20 Aug 2026 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248512;
	bh=31KWPLS0M3X/zTQLFUHvEc5qGuV9r2zdSXn70q7r/mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pADI5S5ijKwkDVeBVI6SnieiJ9BqDSAVt2p4oyD9Ft32M3z0ofO1MMlQCytD36qCF
	 3w91M+HFjki1v1H7H7CReYfUZ0q/X01zbnoeBPlEaaDm5/E04nxePGOjjTB79TXFeP
	 WBsfP90CyDjn0c7GjR23bIuVRXKq7N5SL5SB10Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.1 253/303] ice: fix memory leak in ice_lbtest_prepare_rings()
Date: Thu, 20 Aug 2026 16:56:29 +0200
Message-ID: <20260820145301.051210487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 3a9de5590da4ffd9e9c541c4c4d492aa2b54cf6e ]

ice_lbtest_prepare_rings() frees Rx rings only when
ice_vsi_start_all_rx_rings() fails. If ice_vsi_setup_rx_rings() fails
after allocating some descriptors, or if ice_vsi_cfg_lan() fails after
the Rx rings were prepared, the function reaches the Tx cleanup path
without releasing the initialized Rx resources.

Fix this by adding separate unwind paths for Rx setup failure and LAN
configuration failure. The Rx setup failure path releases the partially
prepared Rx rings before freeing Tx rings, while later failures first
undo the LAN Tx configuration and then release the Rx rings in reverse
setup order.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc7.

An x86_64 allyesconfig build showed no new warnings. As we do not have an
Intel E800 Series adapter available to run the ethtool offline loopback
selftest, no runtime testing was able to be performed.

Fixes: 0e674aeb0b77 ("ice: Add handler for ethtool selftest")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -489,18 +489,18 @@ static int ice_lbtest_prepare_rings(stru
 
 	status = ice_vsi_cfg(vsi);
 	if (status)
-		goto err_setup_rx_ring;
+		goto err_cfg_lan;
 
 	status = ice_vsi_start_all_rx_rings(vsi);
 	if (status)
-		goto err_start_rx_ring;
+		goto err_cfg_lan;
 
 	return status;
 
-err_start_rx_ring:
-	ice_vsi_free_rx_rings(vsi);
-err_setup_rx_ring:
+err_cfg_lan:
 	ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, 0);
+err_setup_rx_ring:
+	ice_vsi_free_rx_rings(vsi);
 err_setup_tx_ring:
 	ice_vsi_free_tx_rings(vsi);
 


