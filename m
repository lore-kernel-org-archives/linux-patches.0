Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8868D337EB9;
	Wed, 17 Sep 2025 12:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113002; cv=none; b=a4hnnQ5JZ9Crkd+31IrNnH8VLm/1eBi5i7JvcNjap6XeeBc5h41b9EE9gSBAbvbbWuPmc+SumOYDeC1OV5WKFJ+7NqpFvtqsJU47Bfx0oZ0zDOu+WJ6YMtwvZIxBGoS9dZsmFjIpOPgfSlNkQjldHO0F1Lb6cWRxwMGVwU3iZ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113002; c=relaxed/simple;
	bh=ON64tQisSpeRv+BeE0wpfhMX6TuJoOGT7PvccQs+yCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAJgTnYUCDL1CiYSZJHl4W9llYHNhKrLJ03Q/ZpNcgnpx1YWtkQiRgEAOVtYan/F6ACXJPmggIBtV5EL8UjA4JO2HiGCqQ+5+Y5aK5iFHXmktlGQzMXxhfotofb/v/PxqjjSX/Gx2p00GPx9FpcGFBmJ2hri3npHdWtPASRJH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j762exvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j762exvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A604EC4CEF0;
	Wed, 17 Sep 2025 12:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113002;
	bh=ON64tQisSpeRv+BeE0wpfhMX6TuJoOGT7PvccQs+yCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j762exvkx++0+W/UmL/9tQp7iax55VMBT5uJFcsCMBCYgCLRuzGgDlqkkxohYmVW8
	 ybUOtPneMyy9VnJqGeFjMKwLZL+Nt/injBOkMYleLvdP2z5MUZ6t+nySIVIT4Fpi58
	 7gnPkMkzFjxNYS5bdFIUVT+Llu2tRo5c26rKBtZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Joe Damato <joe@dama.to>,
	Tianyu Xu <tianyxu@cisco.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 140/189] igb: Fix NULL pointer dereference in ethtool loopback test
Date: Wed, 17 Sep 2025 14:34:10 +0200
Message-ID: <20250917123355.284104545@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyu Xu <tianyxu@cisco.com>

[ Upstream commit 75871a525a596ff4d16c4aebc0018f8d0923c9b1 ]

The igb driver currently causes a NULL pointer dereference when executing
the ethtool loopback test. This occurs because there is no associated
q_vector for the test ring when it is set up, as interrupts are typically
not added to the test rings.

Since commit 5ef44b3cb43b removed the napi_id assignment in
__xdp_rxq_info_reg(), there is no longer a need to pass a napi_id to it.
Therefore, simply use 0 as the last parameter.

Fixes: 2c6196013f84 ("igb: Add AF_XDP zero-copy Rx support")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Joe Damato <joe@dama.to>
Signed-off-by: Tianyu Xu <tianyxu@cisco.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b76a154e635e0..d87438bef6fba 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4451,8 +4451,7 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-			       rx_ring->queue_index,
-			       rx_ring->q_vector->napi.napi_id);
+			       rx_ring->queue_index, 0);
 	if (res < 0) {
 		dev_err(dev, "Failed to register xdp_rxq index %u\n",
 			rx_ring->queue_index);
-- 
2.51.0



