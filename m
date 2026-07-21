Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37D4434E2C;
	Tue, 21 Jul 2026 20:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664621; cv=none; b=tUp1abCzZ2afDnfZkA76jIMUIQUmAw/3CaQ+c7CN7RrkDmDT3m0Z1AMibYfjREJHTOiv2muSd0DMRupTQcSKPuuwYOWvospIe0g8I08KAVsMCfghTfLdUODKDpdj3bQBRNuq8LcrZiCHSEz3tDFYEc63Gx5L5u29zo9zndUkFBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664621; c=relaxed/simple;
	bh=ars0G0h1IldXweqgEZ5c0pyvzXcqUS6ciM+Yh8/Vw6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpHus+hghSQScu6VUyq2/t3a9OJnt+1pyrfuquJFrKcNCI60sidH8vo+5YYz6NoZ2t+qLJ5ZcAi3dMghMy0tki4KQnBq305f+1kHDTwYLeU8VQC+X8z6Ef2SMq90GVGZ03XB63C13EXDDm54c9tFjEKNuULpz5OAQti2kx/mKzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6JQOaD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6JQOaD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551E91F000E9;
	Tue, 21 Jul 2026 20:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664619;
	bh=aNie2vYY7XxRZFOs0IjK4SFTmzwBWmzb+wxA2i9zWhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6JQOaD8elwTvebc3ZeRLqvNCriZqMY84oAFf/XQpQxYdP+2b9WgVtTbEX1Szmuc8
	 FJQ8fFFBYsAoEnaTdPRFFQ6qHKbsCc0rlnKXxdZ9NsYzYRgjOvFEp1bsXtlb8vlYBf
	 XAHztH09D6pZSnRVByBDTLdK/vlXbd9Pb3y373LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Heib <mheib@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 1269/1276] ice: drop udp_tunnel_get_rx_info() call from ndo_open()
Date: Tue, 21 Jul 2026 17:28:32 +0200
Message-ID: <20260721152514.488392148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Mohammad Heib <mheib@redhat.com>

commit 234e615bfece9e3e91c50fe49ab9e68ee37c791a upstream.

The ice driver calls udp_tunnel_get_rx_info() during ice_open_internal().
This is redundant because UDP tunnel RX offload state is preserved
across device down/up cycles. The udp_tunnel core handles
synchronization automatically when required.

Furthermore, recent changes in the udp_tunnel infrastructure require
querying RX info while holding the udp_tunnel lock. Calling it
directly from the ndo_open path violates this requirement,
triggering the following lockdep warning:

Call Trace:
  <TASK>
  ice_open_internal+0x253/0x350 [ice]
  __udp_tunnel_nic_assert_locked+0x86/0xb0 [udp_tunnel]
  __dev_open+0x2f5/0x880
  __dev_change_flags+0x44c/0x660
  netif_change_flags+0x80/0x160
  devinet_ioctl+0xd21/0x15f0
  inet_ioctl+0x311/0x350
  sock_ioctl+0x114/0x220
  __x64_sys_ioctl+0x131/0x1a0
  ...
  </TASK>

Remove the redundant and unsafe call to udp_tunnel_get_rx_info() from
ice_open_internal() to resolve the locking violation

Fixes: 1ead7501094c ("udp_tunnel: remove rtnl_lock dependency")
Signed-off-by: Mohammad Heib <mheib@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9574,9 +9574,6 @@ int ice_open_internal(struct net_device
 		netdev_err(netdev, "Failed to open VSI 0x%04X on switch 0x%04X\n",
 			   vsi->vsi_num, vsi->vsw->sw_id);
 
-	/* Update existing tunnels information */
-	udp_tunnel_get_rx_info(netdev);
-
 	return err;
 }
 


