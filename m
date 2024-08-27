Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4171C57BF;
	Tue, 27 Aug 2024 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771385; cv=none; b=t7ybcRvs7o7w3xS7dgYEg3NwrUKKDte8U9YcDaOt3Pe+ILTOhihxwaaINzK2LGCrOHGBHivVkdXjoQmx9cSXrwXfbILdM9Hz4jM4feFF3dp2utLPlio43DQY9Hl7RgE2SaNiY/6ciY6Q38VAptgwZGEaErqhm0gmIgLT0SlphZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771385; c=relaxed/simple;
	bh=G6WUCtWF+Yjqj9Quz3nukRTc9QjueeyZp/LS1WzKnOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv386XEvbXNaQPlhADyYZhz0zma3T4jFNDqb7gCSmN9x6/4Qn5FTSVydoVbWSC0XfZoThaIo5f7dp3YL3JoonrRTOz0mCeBPIzNEJjul7kQbg8DLUu9qSTuzRVW6HxEJ1ahFLSlgb0kJo5MF2sQiWEhmRy+Vp8IZjWoNS82CbcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LI2+Bkyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LI2+Bkyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05441C4AF1A;
	Tue, 27 Aug 2024 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771385;
	bh=G6WUCtWF+Yjqj9Quz3nukRTc9QjueeyZp/LS1WzKnOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LI2+BkyfehwV14/8WebNREW9WGs+TykUp/tIqwTc3BAzh23ZWxj0IyBlagl2U7oJK
	 GdxNFdxweqUdG7TfsZDyDRTz6NyLAsiDgc371pNjddaqKBKV7mIsqQOTnxCJ1ztKEm
	 GneXVYis54VIecOUTmYvzib/ZCB09P/4UZCNx0A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.10 173/273] ice: fix ICE_LAST_OFFSET formula
Date: Tue, 27 Aug 2024 16:38:17 +0200
Message-ID: <20240827143839.992343056@linuxfoundation.org>
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

[ Upstream commit b966ad832942b5a11e002f9b5ef102b08425b84a ]

For bigger PAGE_SIZE archs, ice driver works on 3k Rx buffers.
Therefore, ICE_LAST_OFFSET should take into account ICE_RXBUF_3072, not
ICE_RXBUF_2048.

Fixes: 7237f5b0dba4 ("ice: introduce legacy Rx flag")
Suggested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 50211188c1a7a..4b690952bb403 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -842,7 +842,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 		return false;
 #if (PAGE_SIZE >= 8192)
 #define ICE_LAST_OFFSET \
-	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_2048)
+	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_3072)
 	if (rx_buf->page_offset > ICE_LAST_OFFSET)
 		return false;
 #endif /* PAGE_SIZE >= 8192) */
-- 
2.43.0



