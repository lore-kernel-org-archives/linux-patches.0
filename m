Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B4B4EDCB6;
	Tue, 13 Oct 2026 11:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892537; cv=none; b=sH8ySdl3IVQjAwk5RLwsEe1tUzqlIpZW33+oaI2fq72fNw9vfa7PIRrImUPdA+sOnGMtDzbx4G2Ss206oPWWUKGoWDI9P/KA+XfOBMyXNl5y1+v3mj6D9Ln+vpiBCG6cZQe8jsU8CAh+mphq8GnTl9F7XMSf91DdMUxiiyk7zO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892537; c=relaxed/simple;
	bh=dwJvp0pmexUGBi+IS+6hHJqzGo0GbJiQq/D51QYtoY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI7tDUNeYyCQ0bHM0FeHjseBEMJg7mAbEUkoJKTVgMFNuhVbXRxJlqJoMHFkb8yUIf8VDeN6lr/1qRS0ZTwCdbLXGbepQCR9LD114n3NKME6ttw9C2bF0lar0hHnA550zz5wVvY8+XSVEM3673VJLqVpi5+3238BIQtCCLavFLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtVLuzTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtVLuzTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600501F000FF;
	Tue, 13 Oct 2026 11:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892535;
	bh=NnaABsNd/5mwx2poodLQVlq7ND3/+Cqt75Ca4c6aWAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtVLuzTyh0F9yh1HITo7v53N/hQ4+ggzJRbnNTIMRhmE1dDp9AkNgRbaJyxZXavVa
	 d9TYrlG2VOh8mZVKrm1ZSNaHkncNtHOKIdM9Xbl5YEnck/MWbwoewNMfnuejvXLt9W
	 uZ+N/IKipwWPupuE/jXTOmAbSYnxchPscfcPIlM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Fraschetti <bryan.fraschetti@canonical.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 205/281] ice: Restore Ordered MMIO Writes for Tx Doorbells
Date: Tue, 13 Oct 2026 13:38:41 +0200
Message-ID: <20261013112900.137547585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Fraschetti <bryan.fraschetti@canonical.com>

[ Upstream commit 7a579dec8423bba7bec96fcfcb2e30838b0858ee ]

The DQL accounting state which tracks the number of bytes queued for the
NIC to transmit, namely dql->num_queued, is updated by the ICE driver
when it invokes __netdev_tx_sent_queue(). Subsequently the driver
updates the hardware queue tail allowing the NIC to begin processing the
work queue. The queue accounting update should be ordered before the NIC
begins transmitting descriptors.

The transmit path currently updates the hardware doorbell using
writel_relaxed(), which (on arm64) does not provide the same ordering
guarantees between writes to normal memory and writes to MMIO registers
that writel() does. This introduces a potential race where the NIC
begins transmitting descriptors before the dql->num_queued update is
globally visible. If the NIC finishes before the update is observed by
dql_completed(), it detects an invalid state where more bytes have been
completed than have been queued. When this happens the following BUG_ON
is triggered.

  BUG_ON(count > num_queued - dql->num_completed);

This has been observed and manifests as the following crash (note that
the trace has been trimmed) in an environment with sustained network
load that uses an Intel Corporation Ethernet Controller E810-XXV for SFP
(rev 02) on an arm64 machine. Replacing writel_relaxed() with writel()
in a test kernel eliminated the crash in the user's workload, which
previously reproduced the issue reliably.

  kernel BUG at lib/dynamic_queue_limits.c:99

Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
pc : dql_completed+0x268/0x2a0
lr : ice_clean_tx_irq+0x1d4/0x620 [ice]
Call trace:
dql_completed+0x268/0x2a0 (P)
ice_napi_poll+0x94/0x520 [ice]
__napi_poll+0x48/0x3f0
net_rx_action+0x194/0x420

This restores the behaviour prior to commit ccde82e90946 ("ice: add E830
Earliest TxTime First Offload support"), which changed the notification
mechanism from writel() to writel_relaxed().

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2161572
Fixes: ccde82e90946 ("ice: add E830 Earliest TxTime First Offload support")
Signed-off-by: Bryan Fraschetti <bryan.fraschetti@canonical.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260928230429.495442-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index c04c5856dad6e..4e26ace793ec6 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1561,10 +1561,10 @@ ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 			}
 		}
 		tstamp_ring->next_to_use = j;
-		writel_relaxed(j, tstamp_ring->tail);
+		writel(j, tstamp_ring->tail);
 	} else {
 ring_kick:
-		writel_relaxed(i, tx_ring->tail);
+		writel(i, tx_ring->tail);
 	}
 	return;
 
-- 
2.53.0



