Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4D71C6890;
	Tue, 27 Aug 2024 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771489; cv=none; b=PvubMzITPK4fgodRUkPvqxlX53yu4l/cckpzTVf9XK9lnWJCEiRpXJX4Q+raNa4vs3V+MLMlWVhmeuszT+EjuFwGWRSYQRccaWj3jTEVyOqH+SzMnJ+ksQqDEO7WiZ0z65jYC8G4Et1CREoOJeK3C0hhmj89GDEt4TS97bINopk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771489; c=relaxed/simple;
	bh=uwJStzhAFhtzb+T/leMICQxaSpR1Hp+hjSlwJ9faghE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTWqWa2dbVf/grLpQVyj2JGtnJWD0c4Tlqnqua/M6EpwcJDe7hpSg8yWm8BoKktLVaTpvqRm0WgQtTJPcibFHNvjriaupupl3GyHPvE1JDHkvDhQLO/35J/D1pBLOMb2L3u/zFIiBSGGkpCOXfPmn7ItXE9kLALwGlisCj4whcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REIxCs3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REIxCs3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF2EC4DDED;
	Tue, 27 Aug 2024 15:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771489;
	bh=uwJStzhAFhtzb+T/leMICQxaSpR1Hp+hjSlwJ9faghE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REIxCs3bkK7G1gQcZ5zfnG98TfwqaAIYTqPrTta8N0++Dw21204uLTObnRsRp5LfF
	 HAoosXK7e0cn00aPdqZFiZxxbjmrwlcAx6oHlSPw8NEVUGfgugyChK1ZPCF3aIftuj
	 VkhWH+kNIaHiqmOsA64c/HHCmthfJ4pEp1aqBoeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.10 172/273] ice: fix page reuse when PAGE_SIZE is over 8k
Date: Tue, 27 Aug 2024 16:38:16 +0200
Message-ID: <20240827143839.953142977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8d25b69812698..50211188c1a7a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -837,16 +837,15 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
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
@@ -949,12 +948,7 @@ ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
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



