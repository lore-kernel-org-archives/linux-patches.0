Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5981C7B82;
	Tue, 27 Aug 2024 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772540; cv=none; b=i5zA2+sV0R1Iwp8nJ3dk5ndIgg+BfJAxFc9IIRNBkLeYPqJkfUv7NSnT0de35oZfaKcK2VV3s9eoxB0of4QynsMhsiqvOu2S4WLELDUOcGqufa8lW0GGjRCYf2roCtmZ/uv1lbMGGBOIIcPYLklvDa3llNQ+MlDVSsSF0XPV/7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772540; c=relaxed/simple;
	bh=FvA5kQKsxoXMdiHDhoXAeXTZIGfb/UdUB1/BrdTByZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/nWL4H28jkeA3x80WOewQ434T0/77poOEWuvfXcYq5GWvKqDZ6k+EybrMR2Iup/VabonMIErMyEG4KdpsbPR9RCP52KnvS46BhKEngq3VUdH0iqD7+a7vAeNS+WJdcApl5BRvqdxnX96lewKwtOdNVi+8g3dpqd6KYf4SRVxv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ktn2wQ6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ktn2wQ6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D24C6107E;
	Tue, 27 Aug 2024 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772540;
	bh=FvA5kQKsxoXMdiHDhoXAeXTZIGfb/UdUB1/BrdTByZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ktn2wQ6sIEF/JAqT8rPS4kJXE5P61FzDRxvren92C7202byhbfPNV4YCRyW1ese+y
	 DBNHZuQdqwgK3wAysh4C2tRSPN3rzeATl4ZVjSqmAc/HyrJW2E2CPineFpHhxBnYjp
	 ehIyjhw5sN/V02Z4AToSVT8TmsjE5K4Zws+F030g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.1 246/321] ice: fix page reuse when PAGE_SIZE is over 8k
Date: Tue, 27 Aug 2024 16:39:14 +0200
Message-ID: <20240827143847.608479264@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 50b2143356e888777fc5bca023c39f34f404613a ]

Architectures that have PAGE_SIZE >= 8192 such as arm64 should act the
same as x86 currently, meaning reuse of a page should only take place
when no one else is busy with it.

Do two things independently of underlying PAGE_SIZE:
- store the page count under ice_rx_buf::pgcnt
- then act upon its value vs ice_rx_buf::pagecnt_bias when making the
  decision regarding page reuse

Fixes: 2b245cb29421 ("ice: Implement transmit and NAPI support")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 6f930d99b496b..6ad4bdb0124e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -807,16 +807,15 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 	if (!dev_page_is_reusable(page))
 		return false;
 
-#if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
 	if (unlikely(rx_buf->pgcnt - pagecnt_bias > 1))
 		return false;
-#else
+#if (PAGE_SIZE >= 8192)
 #define ICE_LAST_OFFSET \
 	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_2048)
 	if (rx_buf->page_offset > ICE_LAST_OFFSET)
 		return false;
-#endif /* PAGE_SIZE < 8192) */
+#endif /* PAGE_SIZE >= 8192) */
 
 	/* If we have drained the page fragment pool we need to update
 	 * the pagecnt_bias and page count so that we fully restock the
@@ -904,12 +903,7 @@ ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
 	struct ice_rx_buf *rx_buf;
 
 	rx_buf = &rx_ring->rx_buf[ntc];
-	rx_buf->pgcnt =
-#if (PAGE_SIZE < 8192)
-		page_count(rx_buf->page);
-#else
-		0;
-#endif
+	rx_buf->pgcnt = page_count(rx_buf->page);
 	prefetchw(rx_buf->page);
 
 	if (!size)
-- 
2.43.0



