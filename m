Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078281DE4E0;
	Thu, 28 May 2026 20:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000677; cv=none; b=nrWJvfEMPvCZSUa5XTi4yx+acAXUmAox61wVYPGcy2HKHureOIKupq03l394JA+U1hNTRzJfoE/5MTKdcgLBiZmWbxmT0/D/J9DEXQ656cFvsaKgd9ZONhmOYXVvMgipekwu9cQXmV3zY6A1TaYHm1OwEa/j7y3jqYqMJTzi+us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000677; c=relaxed/simple;
	bh=vIheZ4X8Hp9W9v5YiP+Bdag7PrXKi3Wq/Xb6GWy3fyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGd4W7LwAqzOYAFto93mZ8fnwLkEQtZO1hzeTivXkqUkzER7pFzk3rp6stmqOSAZgMMzW5fr47xOfEp9MXsuXauFLzai8rhuq7RCD71B+Gdbp0Qk4B+rY5op4/jJuRPmagClMHTboyRPvMb8qDIAebMUwwaRBTIj25jeSL+Q5I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OA2tOkBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OA2tOkBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187241F000E9;
	Thu, 28 May 2026 20:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000675;
	bh=Xdri/RPYf5OwKXjhY4iUbKAwRYxCEvxaKTc+lZ47OtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA2tOkBw27Ez+W0umyoO7WHDzR4YjhSdZfON9kjXkoDbW8UA/2mv8TdqUBmkUWivy
	 k/1bmZTMINg7WAB0wWQ2ZietH21rASY0PTHzYELGA9UAcGWwOhXYpOecGZ/5tX5WSR
	 TaoSErxVfQJkLRILCPZi7XbJp3UKwZIVloAryk5E=
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
Subject: [PATCH 6.12 093/272] ice: fix setting promisc mode while adding VID filter
Date: Thu, 28 May 2026 21:47:47 +0200
Message-ID: <20260528194631.983326185@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -3808,7 +3808,7 @@ int ice_vlan_rx_add_vid(struct net_devic
 		ret = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
 					       ICE_MCAST_VLAN_PROMISC_BITS,
 					       vid);
-		if (ret)
+		if (ret && ret != -EEXIST)
 			goto finish;
 	}
 


