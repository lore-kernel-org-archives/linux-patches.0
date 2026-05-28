Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B21330B2D;
	Thu, 28 May 2026 19:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998201; cv=none; b=YCIrquvIVbHSeRRoZakHHHDTD8HYkRniWpL9Jonz91PMiSBjK2AbUcGt9AAJ7cKWeE1s7LWOov2kBQzwxLBI2c2tV8YF/ob7FZYK4Z6i2KnBo61l+lfbWzxj09eaDQvm4uBFo4DvUXqDQpQXtQD1uUyzOFz1fkVLjRwdAHqvwB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998201; c=relaxed/simple;
	bh=iJciqmpfDb99dcyquj/P75wsND9NmsYjDvlHIEVZ4IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNJsE9hq1IDDpfP518lgAMJVmx0X+7F8fvd3rgrwUQrI4Fvq4gQzVp/flu6x5rf4y4KfHYxlpQKo6h9Os6eKRBPOnyQ/dKPkoJg2f8xTV+0ugY4adW5nvx91cP16KkLi1ijhZkoGvx98vLw1x0Sd+3/vwyfMmPZufpJulbygnVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whaLQBLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whaLQBLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616B91F000E9;
	Thu, 28 May 2026 19:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998199;
	bh=iKO26lfo+7RyKoQSNFHvidHJ8EBI9j9BJMzJ7E56k1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whaLQBLSWWhWwSsx3lo097AoFzJb3V+QVZGJ8Y0JfH1NnKtBjWfd2KyThasywpMKa
	 B1tPjwozRLLICdj6APrbFsY+qs2QaGgXTAr5n2mD7fnn54qgIvSx84wUG2iOz2V/So
	 6AqK+T2M+2X/Auy++GoPBmCRdhjy+fmT8Xd1C08I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Szycik <marcin.szycik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 7.0 090/461] ice: fix setting promisc mode while adding VID filter
Date: Thu, 28 May 2026 21:43:39 +0200
Message-ID: <20260528194649.536535748@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@intel.com>

commit ebc8de716c9ec2be384abdc2dd866da26c6580d1 upstream.

There are at least two paths through which VSI promiscuous mode can be
independently configured via ice_fltr_set_vsi_promisc():
- ice_vlan_rx_add_vid() (netdev op)
- ice_service_task() -> ... -> ice_set_promisc()

Both paths may try to program promiscuous mode concurrently. One such
scenario is:

1. Add ice netdev to bond
2. Add the bond netdev to bridge
3. ice netdev enters allmulticast mode (IFF_ALLMULTI)
4. Service task programs promisc mode filter
5. Bridge -> bond calls ice_vlan_rx_add_vid()

Crucially, ice_vlan_rx_add_vid() fails if ice_fltr_set_vsi_promisc()
returns any error, including -EEXIST. This causes VLAN filtering setup
to fail on the bond interface. ice_set_promisc() already handles -EEXIST
correctly.

Fix by adding the same -EEXIST check to ice_vlan_rx_add_vid(): if the
promisc filter is already programmed, continue without returning error.

Fixes: 1273f89578f2 ("ice: Fix broken IFF_ALLMULTI handling")
Cc: stable@vger.kernel.org
Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260515182419.1597859-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3682,7 +3682,7 @@ int ice_vlan_rx_add_vid(struct net_devic
 		ret = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
 					       ICE_MCAST_VLAN_PROMISC_BITS,
 					       vid);
-		if (ret)
+		if (ret && ret != -EEXIST)
 			goto finish;
 	}
 


