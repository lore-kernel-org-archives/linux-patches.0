Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005CA18A6B0;
	Tue, 30 Jul 2024 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359398; cv=none; b=rI1pbgtkxeOi5sDWAhaGDWsgNQubKHbVdTFStYY92hqVQJ2++L2hDYmR5A0LBKO+2B5s61p2SWFMPgZKw8PbBlgIuTElTXWHxgLeqYYKb8j8Kh5H6w73fHxCp7sYNw4QJbMkgm2P3eM0iFM5gYgKfc0gzWDlktjdjM35YkhvaRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359398; c=relaxed/simple;
	bh=rf0NZeZ15Z1Gc9+SBRdslZaNRcOZaDFaNfYJ6xhk/B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uM+YW7o3lA7WJzlrsEjJks0Xg4g4wWdyjGnnc5h4xIEIldpFUcL/r6VFPh5vlJGtB21e72BIeEdAjQVgxlaCiyJAg+EIYRenkJepQfyAflCTySYEGf4hCkB2x2TadF85mI0oaeQX1327hpuvLkpf3KRp9FIkdf31qC3vS0V5OVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjYoL9Ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjYoL9Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE02C32782;
	Tue, 30 Jul 2024 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359397;
	bh=rf0NZeZ15Z1Gc9+SBRdslZaNRcOZaDFaNfYJ6xhk/B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjYoL9Oljxyr9KWB2txGXLEVK3k4PohyS+hjij0tk+in/Q+1l6G5mGfxyEF7uwUu6
	 0P6inACICdWhuqEfLDIIgTKfP7Esvap8z9ctuAI9eAYC91O7FtYX57dxHq393qHAjA
	 aW2gySELv8XBftJRkFPtlEIMMlXVas3oBocNF/X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 478/809] gve: Fix XDP TX completion handling when counters overflow
Date: Tue, 30 Jul 2024 17:45:54 +0200
Message-ID: <20240730151743.616127085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Joshua Washington <joshwash@google.com>

[ Upstream commit 03b54bad26f3c78bb1f90410ec3e4e7fe197adc9 ]

In gve_clean_xdp_done, the driver processes the TX completions based on
a 32-bit NIC counter and a 32-bit completion counter stored in the tx
queue.

Fix the for loop so that the counter wraparound is handled correctly.

Fixes: 75eaae158b1b ("gve: Add XDP DROP and TX support for GQI-QPL format")
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240716171041.1561142-1-pkaligineedi@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 24a64ec1073e2..e7fb7d6d283df 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -158,15 +158,16 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 			      u32 to_do)
 {
 	struct gve_tx_buffer_state *info;
-	u32 clean_end = tx->done + to_do;
 	u64 pkts = 0, bytes = 0;
 	size_t space_freed = 0;
 	u32 xsk_complete = 0;
 	u32 idx;
+	int i;
 
-	for (; tx->done < clean_end; tx->done++) {
+	for (i = 0; i < to_do; i++) {
 		idx = tx->done & tx->mask;
 		info = &tx->info[idx];
+		tx->done++;
 
 		if (unlikely(!info->xdp.size))
 			continue;
-- 
2.43.0



