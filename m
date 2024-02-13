Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A2D5FBB5;
	Tue, 13 Feb 2024 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707844991; cv=none; b=qwNt5rjxc0HnrMbNj1f7RFhsJrhr/9rbTRevzcCN5XEypVAqkxOxoRXZXJ1js60ke8k4M2oNTN/HN5g20INOPPBjC5uzbL8nX7rCk/4jEnnrXrv2HXaTCVuaR3T3cyxG4rzQZriDSt4cBW2xke3BChLlQDiYB0EViNOqGLdQBcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707844991; c=relaxed/simple;
	bh=sWP6xPceu80LrzM3CdIQuo9Aq/BzkbixxBbd2/t7BpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlWUxwMPDgR+cHB2V258klVWPuY5AveqsNGyl2JhDRsGIA1MXd5VhoapFbJR/skNqa/TMMQy2a/Fz+pkH6yQkr4vzto+XVbTA7FakMb49ipKVkxrdMlE6QU3wjrf3cKBer7z27tkO0zRPVuBxXXxdeSEcNp8WeVeE6HZMgOOsys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mr98902L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mr98902L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91990C43399;
	Tue, 13 Feb 2024 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707844991;
	bh=sWP6xPceu80LrzM3CdIQuo9Aq/BzkbixxBbd2/t7BpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mr98902LOfgvxSewME66O7kxlIl1wR20S2OMg3aSsQnrHIqZIQoJPisWIEGkiNiAg
	 rjsWGo0/FFCLQ2qnTcObMpAsCLathhlZdlC46AcvVUaP0jN9qBs7pNf+bZe8GyeHI1
	 +iWeXkdWybNBS9uefz2gVACfup+gS+RfVviYFkbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/64] net: atlantic: Fix DMA mapping for PTP hwts ring
Date: Tue, 13 Feb 2024 18:21:02 +0100
Message-ID: <20240213171845.234380389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 2e7d3b67630dfd8f178c41fa2217aa00e79a5887 ]

Function aq_ring_hwts_rx_alloc() maps extra AQ_CFG_RXDS_DEF bytes
for PTP HWTS ring but then generic aq_ring_free() does not take this
into account.
Create and use a specific function to free HWTS ring to fix this
issue.

Trace:
[  215.351607] ------------[ cut here ]------------
[  215.351612] DMA-API: atlantic 0000:4b:00.0: device driver frees DMA memory with different size [device address=0x00000000fbdd0000] [map size=34816 bytes] [unmap size=32768 bytes]
[  215.351635] WARNING: CPU: 33 PID: 10759 at kernel/dma/debug.c:988 check_unmap+0xa6f/0x2360
...
[  215.581176] Call Trace:
[  215.583632]  <TASK>
[  215.585745]  ? show_trace_log_lvl+0x1c4/0x2df
[  215.590114]  ? show_trace_log_lvl+0x1c4/0x2df
[  215.594497]  ? debug_dma_free_coherent+0x196/0x210
[  215.599305]  ? check_unmap+0xa6f/0x2360
[  215.603147]  ? __warn+0xca/0x1d0
[  215.606391]  ? check_unmap+0xa6f/0x2360
[  215.610237]  ? report_bug+0x1ef/0x370
[  215.613921]  ? handle_bug+0x3c/0x70
[  215.617423]  ? exc_invalid_op+0x14/0x50
[  215.621269]  ? asm_exc_invalid_op+0x16/0x20
[  215.625480]  ? check_unmap+0xa6f/0x2360
[  215.629331]  ? mark_lock.part.0+0xca/0xa40
[  215.633445]  debug_dma_free_coherent+0x196/0x210
[  215.638079]  ? __pfx_debug_dma_free_coherent+0x10/0x10
[  215.643242]  ? slab_free_freelist_hook+0x11d/0x1d0
[  215.648060]  dma_free_attrs+0x6d/0x130
[  215.651834]  aq_ring_free+0x193/0x290 [atlantic]
[  215.656487]  aq_ptp_ring_free+0x67/0x110 [atlantic]
...
[  216.127540] ---[ end trace 6467e5964dd2640b ]---
[  216.132160] DMA-API: Mapped at:
[  216.132162]  debug_dma_alloc_coherent+0x66/0x2f0
[  216.132165]  dma_alloc_attrs+0xf5/0x1b0
[  216.132168]  aq_ring_hwts_rx_alloc+0x150/0x1f0 [atlantic]
[  216.132193]  aq_ptp_ring_alloc+0x1bb/0x540 [atlantic]
[  216.132213]  aq_nic_init+0x4a1/0x760 [atlantic]

Fixes: 94ad94558b0f ("net: aquantia: add PTP rings infrastructure")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240201094752.883026-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c  |  4 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 13 +++++++++++++
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h |  1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index abd4832e4ed2..5acb3e16b567 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -993,7 +993,7 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 	return 0;
 
 err_exit_hwts_rx:
-	aq_ring_free(&aq_ptp->hwts_rx);
+	aq_ring_hwts_rx_free(&aq_ptp->hwts_rx);
 err_exit_ptp_rx:
 	aq_ring_free(&aq_ptp->ptp_rx);
 err_exit_ptp_tx:
@@ -1011,7 +1011,7 @@ void aq_ptp_ring_free(struct aq_nic_s *aq_nic)
 
 	aq_ring_free(&aq_ptp->ptp_tx);
 	aq_ring_free(&aq_ptp->ptp_rx);
-	aq_ring_free(&aq_ptp->hwts_rx);
+	aq_ring_hwts_rx_free(&aq_ptp->hwts_rx);
 
 	aq_ptp_skb_ring_release(&aq_ptp->skb_ring);
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 9c314fe14ab6..0eaaba3a18ee 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -919,6 +919,19 @@ void aq_ring_free(struct aq_ring_s *self)
 	}
 }
 
+void aq_ring_hwts_rx_free(struct aq_ring_s *self)
+{
+	if (!self)
+		return;
+
+	if (self->dx_ring) {
+		dma_free_coherent(aq_nic_get_dev(self->aq_nic),
+				  self->size * self->dx_size + AQ_CFG_RXDS_DEF,
+				  self->dx_ring, self->dx_ring_pa);
+		self->dx_ring = NULL;
+	}
+}
+
 unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data)
 {
 	unsigned int count;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 52847310740a..d627ace850ff 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -210,6 +210,7 @@ int aq_ring_rx_fill(struct aq_ring_s *self);
 int aq_ring_hwts_rx_alloc(struct aq_ring_s *self,
 			  struct aq_nic_s *aq_nic, unsigned int idx,
 			  unsigned int size, unsigned int dx_size);
+void aq_ring_hwts_rx_free(struct aq_ring_s *self);
 void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic);
 
 unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data);
-- 
2.43.0



