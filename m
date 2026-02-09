Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D7523D291;
	Mon,  9 Feb 2026 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647648; cv=none; b=LicpSHnPwJVGs3Xab7dVuHpactjYh/n7zQM4gy0VKoHL2hArzX19hFQzZIwslbAoGAzl/wc2QVzHfPbTmx/hLkWTFeCwhVWNzdVP+1Lx2d9ZIQiqtLMa8KbtSx63HxqRzWjCeUnRQC9+SXREiQsFmGVI4u073pTMMeaSWPbs7i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647648; c=relaxed/simple;
	bh=MnZlSQ6W1WXZWUQsc+eogd1PjL8ONXn0nVZiCN9LcUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lnhbt/xYSqF6wocqU5RH2b9tNCIdFwU4TURBqHNYM5s9tJrcHGYScfzYRkE+1/+MdKocxicKpZq3gnBGZFPikRz2OfRomtzVjeobkuocj2v7OdEo3QLrDplxV7MBdHoDyXJOhJqtXIvL4ecWY5/zOKMS85F4S1NYMs5ozXKZG+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+LjyM1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+LjyM1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DB9C116C6;
	Mon,  9 Feb 2026 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647648;
	bh=MnZlSQ6W1WXZWUQsc+eogd1PjL8ONXn0nVZiCN9LcUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+LjyM1AJz//pbYhDqtc+AmWtK3Q1DdAUdrlAAeeCGPyhRtB3Od+lqCs5cwrShuvf
	 jzyAKGm26kV95hEgw6r2IM9DixoO9o8zrjIoGjpY0/UjSAnWVIimcXWH2Tme6zOOey
	 Dz8jN12ZrOgFIKobBN8H77q7MvmPyBoH0scmM+20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Heib <mheib@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 129/175] ice: drop udp_tunnel_get_rx_info() call from ndo_open()
Date: Mon,  9 Feb 2026 15:23:22 +0100
Message-ID: <20260209142325.152371336@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Mohammad Heib <mheib@redhat.com>

[ Upstream commit 234e615bfece9e3e91c50fe49ab9e68ee37c791a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d34a32a09bf87..f2b91f7f87861 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9678,9 +9678,6 @@ int ice_open_internal(struct net_device *netdev)
 		netdev_err(netdev, "Failed to open VSI 0x%04X on switch 0x%04X\n",
 			   vsi->vsi_num, vsi->vsw->sw_id);
 
-	/* Update existing tunnels information */
-	udp_tunnel_get_rx_info(netdev);
-
 	return err;
 }
 
-- 
2.51.0



