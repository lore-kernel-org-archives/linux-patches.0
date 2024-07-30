Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEFA1A6166;
	Tue, 30 Jul 2024 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357972; cv=none; b=bv4gRnAdFX1bKH3g1AOKDeNKlcoHV6QEXCcflbwHg8iTh80mCu8PPvnKwe4Vh+yvrjavTLZy6cFh81iWZymKGMs7Xdi3RbpTSTMKIKug17PDHh+wJZB32ktbYlVIiiNyhVuJoMeU9wxWZ1mo42eHSlc2Kh9sLYxFRfOvj4rOWQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357972; c=relaxed/simple;
	bh=tpI/QsWwtKu6pHRuf6HO5viDKv5JOTMWNiFaLG2F57Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnF8eDpD3vCs1WpHQJLDfXidFJFYmKdMjdmwLms+1T3p1h/XmGz33R7FJNAaxrteBYhl+4xsIzPLT9QbN8IUyYcCdJ/Ya0DTMGY0+WZrHw9CI7/BRyg2mhPcKTEDLclGp52EXwGiz+9IFGIzClq4968/jMtwZu1fHH4GznAotwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEa533sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEa533sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73556C32782;
	Tue, 30 Jul 2024 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357971;
	bh=tpI/QsWwtKu6pHRuf6HO5viDKv5JOTMWNiFaLG2F57Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEa533sfz9/gdkUZ/SwJP0td2R69rHbjH7FzXXRFVdnzUAoLJ8RB96JeIV4smUxzZ
	 D7OS3qrqvrJHl3LZRJmqhxnEhR1uQgg3hSKe7c033yQyDYDOIr2JbCZmMYSKQl8IP0
	 kc2iHGB6BZNIV3t632c45SQvQQwMT375twhTrZH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/568] gve: Fix XDP TX completion handling when counters overflow
Date: Tue, 30 Jul 2024 17:47:00 +0200
Message-ID: <20240730151652.105093215@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9f6ffc4a54f0b..2ae891a62875c 100644
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



