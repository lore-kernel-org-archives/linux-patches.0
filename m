Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6153CAA55;
	Wed, 30 Sep 2026 19:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795215; cv=none; b=PB8Y3sPgim3gWdhuh1c8UO1bPPbi5zfhQ/QhlqddRRV+v06jheoUbaOdCIUX5ef5uUYjTDyV+yeP4yhiO8MEczxREKzSbUvRFCAZlwBb6DxNs/pBGjqzm/hKBFaQOhv5AFD/Sq8beNieOLR1q13WQHuJXHMaIdBsroHxHEocXU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795215; c=relaxed/simple;
	bh=QpmQWiE9D1BmZgdEM4rBByk0ECA333CZj502luZWLjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3EHuEVh7WTUxG2y8PhBqURpSPXyumRi/snJ2p/iMUhshs7dFb8jg26jRQvvV5UZ0VfOPn99Inf1rDvywxoGeZLhtvzxowWaImdW+2U1HtaNoP5/nzBQrHj4wtyk1nIgfM7FfZ/rjFn+WxqKzEyG6/6scE84CrCrljlVBrnDXeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0ffLLxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0ffLLxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573C61F00898;
	Wed, 30 Sep 2026 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795213;
	bh=DDXq+oyzvASYnvdE7EEFtBxsg9146jEk+O8c0ef18bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0ffLLxwiKOXYGoP+LqPYVeVncBp2hqfe3jAvvsPxVrI7N0R0emxpj8HnFPIVgarE
	 AhvnvJN03NcHTCL7HtgRpiMRehiBwjrt/Dx1p6oYApnxT5KlPBsoIP9s1ABJLmjWn9
	 G8Wc1t/p6hUEOThx/G8Th6aTc5hvQ7JbN9wRArnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0484/1193] net: bcmasp: fix tx_spb_ring_full() checking same slot cnt times
Date: Wed, 30 Sep 2026 17:19:28 +0200
Message-ID: <20260930152444.909939854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 0c5cf62e72d7a666ee4da757e122dc1600df1ecc ]

The loop initialised next_index from intf->tx_spb_index on every
iteration, so incr_ring() always produced the same result and only
one slot was ever tested.  Move the initialisation before the loop
so each iteration advances next_index and the function correctly
checks that cnt consecutive descriptor slots are available before
allowing a new transmission.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260831184235.4133351-3-danesh.petigara@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 7ed034389815b..407585420f4b7 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -147,8 +147,9 @@ static int tx_spb_ring_full(struct bcmasp_intf *intf, int cnt)
 	int next_index, i;
 
 	/* Check if we have enough room for cnt descriptors */
+	next_index = intf->tx_spb_index;
 	for (i = 0; i < cnt; i++) {
-		next_index = incr_ring(intf->tx_spb_index, DESC_RING_COUNT);
+		next_index = incr_ring(next_index, DESC_RING_COUNT);
 		if (next_index == intf->tx_spb_clean_index)
 			return 1;
 	}
-- 
2.53.0



