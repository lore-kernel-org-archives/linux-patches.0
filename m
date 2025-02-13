Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFBF1547E3;
	Thu, 13 Feb 2025 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458902; cv=none; b=uAN6B7TwRZPZy8Aab+Gn8tP+x4HPidXuk9zd/UXQdr+6S2K9LiTO09mEy5n8PQ5fchOx0D1QpUlzTOC1qI2N1oyvBj6YColta1FNwmqHaZGTGwk6DH6NVtQnDy/46luKJ0P6aDw3uYic2X4mzX1Pez5Mudyfqni5ODGtxQKDvYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458902; c=relaxed/simple;
	bh=VZr1Ro/Kguo7fHajJ8+DynOsMAKJFtfDJw9i0jt542M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn4OvQ9MF7EGmSymIjieX5LnHDuotc/SCptz++LkZlK/pryA2K74zSSh6sCPhaEZfmmaAF30iw+VPr+V2+yIs32PLJrte+Wv7+AKyURjtaaLbg2FDsRqCdupR9iKDVhOX5gGSsStdS9QU3WgU5pNUDAE5HQ/FbnGc/rfqeUCPUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdH1OrUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdH1OrUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72494C4CEE4;
	Thu, 13 Feb 2025 15:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458902;
	bh=VZr1Ro/Kguo7fHajJ8+DynOsMAKJFtfDJw9i0jt542M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdH1OrUw9Y4c1QCfQ9KwKIKhjh4YH4JH5lPibhVlvhBrKUSsqwFY/12KKWkNXWgFM
	 OufcdPaJaU2S29VRBmpKfp8ChDnr0lVJNNnGt5hioTFYPfQIgvfCjJN6ieEFCOHmx9
	 CzPxmB6ipqLqHiiWL8n1hxcSc1F//HApu/a2fLK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Xu Du <xudu@redhat.com>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.13 111/443] ice: gather page_count()s of each frag right before XDP prog call
Date: Thu, 13 Feb 2025 15:24:36 +0100
Message-ID: <20250213142444.893306397@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 11c4aa074d547d825b19cd8d9f288254d89d805c ]

If we store the pgcnt on few fragments while being in the middle of
gathering the whole frame and we stumbled upon DD bit not being set, we
terminate the NAPI Rx processing loop and come back later on. Then on
next NAPI execution we work on previously stored pgcnt.

Imagine that second half of page was used actively by networking stack
and by the time we came back, stack is not busy with this page anymore
and decremented the refcnt. The page reuse algorithm in this case should
be good to reuse the page but given the old refcnt it will not do so and
attempt to release the page via page_frag_cache_drain() with
pagecnt_bias used as an arg. This in turn will result in negative refcnt
on struct page, which was initially observed by Xu Du.

Therefore, move the page count storage from ice_get_rx_buf() to a place
where we are sure that whole frame has been collected, but before
calling XDP program as it internally can also change the page count of
fragments belonging to xdp_buff.

Fixes: ac0753391195 ("ice: Store page count inside ice_rx_buf")
Reported-and-tested-by: Xu Du <xudu@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 27 ++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e173d9c989883..cf46bcf143b4b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -924,7 +924,6 @@ ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
 	struct ice_rx_buf *rx_buf;
 
 	rx_buf = &rx_ring->rx_buf[ntc];
-	rx_buf->pgcnt = page_count(rx_buf->page);
 	prefetchw(rx_buf->page);
 
 	if (!size)
@@ -940,6 +939,31 @@ ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
 	return rx_buf;
 }
 
+/**
+ * ice_get_pgcnts - grab page_count() for gathered fragments
+ * @rx_ring: Rx descriptor ring to store the page counts on
+ *
+ * This function is intended to be called right before running XDP
+ * program so that the page recycling mechanism will be able to take
+ * a correct decision regarding underlying pages; this is done in such
+ * way as XDP program can change the refcount of page
+ */
+static void ice_get_pgcnts(struct ice_rx_ring *rx_ring)
+{
+	u32 nr_frags = rx_ring->nr_frags + 1;
+	u32 idx = rx_ring->first_desc;
+	struct ice_rx_buf *rx_buf;
+	u32 cnt = rx_ring->count;
+
+	for (int i = 0; i < nr_frags; i++) {
+		rx_buf = &rx_ring->rx_buf[idx];
+		rx_buf->pgcnt = page_count(rx_buf->page);
+
+		if (++idx == cnt)
+			idx = 0;
+	}
+}
+
 /**
  * ice_build_skb - Build skb around an existing buffer
  * @rx_ring: Rx descriptor ring to transact packets on
@@ -1241,6 +1265,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		if (ice_is_non_eop(rx_ring, rx_desc))
 			continue;
 
+		ice_get_pgcnts(rx_ring);
 		ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring, rx_buf, rx_desc);
 		if (rx_buf->act == ICE_XDP_PASS)
 			goto construct_skb;
-- 
2.39.5



