Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40641DFD1;
	Sun,  1 Sep 2024 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209686; cv=none; b=D84pA+wu2xhL0+zrKhMFoftJG0Rd3zYYcGaUUjdf6Ecv5hYswsf9MFZkJd2D4QKWuBgkc2X72wbLuJ2hpqZczrpdz6nv8Buka+LOsMBs54R4dj4fO06O+50GcdZexbyd3yMQQoXAt2ppeI2ZH3UwZu0AaHORKuDKBy5AqH1MtJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209686; c=relaxed/simple;
	bh=+7KVQ9LQp3qiabAQrrieEpGMcKbdYv9JLTffEjA54gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqAJ+pYNyQO8/VeXEwqqkeE1qWM34RxeiGXUwJBusHETtqNkVTNWPuoxyaIpEWvwHkK3yOtZ4J64cHyOVg3Kbjem/nZaRpJhLldDFjiATdg5ydBoO0RA7phAkHoPCZWQ+2n9xz7diGeyqFAf1Lr1q+z+We0mte+CAg1iX9l8yUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEXWLQie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEXWLQie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2820CC4CEC3;
	Sun,  1 Sep 2024 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209686;
	bh=+7KVQ9LQp3qiabAQrrieEpGMcKbdYv9JLTffEjA54gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEXWLQiehIA75H0cadl/DW2hYM3+r4GEnYjTjOFc6AR5aHVsTpjCxBylnNqxdXCLZ
	 4vGAle4xuJIpIy90LRCYD6EJkxHd61PxZItOOHZRWz9mjFVkbWIDSf6lQ+Cyc3M3pb
	 geANhng1LXNUpC9s6KvgQ4O91ExzT0Pgk2bs6DnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 5.10 096/151] ice: fix ICE_LAST_OFFSET formula
Date: Sun,  1 Sep 2024 18:17:36 +0200
Message-ID: <20240901160817.724096795@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 442a9bcbf60a7..7734264d570db 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -786,7 +786,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
 		return false;
 #else
 #define ICE_LAST_OFFSET \
-	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_2048)
+	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_3072)
 	if (rx_buf->page_offset > ICE_LAST_OFFSET)
 		return false;
 #endif /* PAGE_SIZE < 8192) */
-- 
2.43.0



