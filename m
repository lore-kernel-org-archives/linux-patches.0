Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38FE4D487C;
	Thu, 17 Sep 2026 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670404; cv=none; b=BKummO9I/5+wFisqCPepueyBgKgFqrNyCB0LXUm3U6+NbvQ1j4RUDK7O5KtPDvKncry8ThksBuBHkTIsO6/+ck1kCNgJLne1CVrD0D1fgZmnSoDkSdLbeDUDBez6qlbgtztJdgGB4Wvr/vvhYP9Z1v6VD0/xuD4cfuwcwOizT+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670404; c=relaxed/simple;
	bh=jhiZidng5X34dSlnYMvVEnKEpWBxVQv67xUOYALAEVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0Um0RRV5WBAxhy41BjtWJ1oaTW4vIhP5hFacZAsjNNjqC+lAl2m8e+niBNJNrlXw6zgKGkv6eGWFVUByMi02gKM2co5wlrTlL2vNFV2LrpPJibVlI0gLAGfx+FW55UkROwPGi5B2uWAAJGKJKl9X22l8YVnW5aAsEWcJ92WGhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImN/gMml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImN/gMml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C8C1F000FF;
	Thu, 17 Sep 2026 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670402;
	bh=djyJCuBPogpiBxaa0VlajhIKUh58RYcO5bTC+nYjCm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImN/gMml1GFicVleZiXPNVptKfZT232EXIFnUvZHkfyqHvt1SqhS9YkpL4Jj8hoKF
	 TvDphFzq5pxqWCId+5CWdLPT/OO8VPwZ7mh+YtIqy66YDMzjOeX/n5Ddh1q5glL3EJ
	 oiNMrKD3c8nGkyqK8av7w27ovt2+4pGM/A2QA0H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0653/1102] net: bcmasp: fix tx_spb_ring_full() checking same slot cnt times
Date: Thu, 17 Sep 2026 16:09:56 +0100
Message-ID: <20260917151556.561449566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6232dc6c6c6ba..c87baf249c5f6 100644
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



