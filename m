Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8461402BAA;
	Wed, 20 May 2026 18:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302582; cv=none; b=g/nv+xuHPajyJLwUrlixRPyK9ddhlELyVuJkqInJXoSx7BtRq+7A6xtx2Aq25iecvQ+Fzqs7bycvZbvwmugXsiyvMdKMnJrnvw2EmUxd8a+Vypqf21p+wUd6hReaRPuCrAFbl45sEmXd8dMe5TMwiQVv1lZGseW1fEOd4RVvx3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302582; c=relaxed/simple;
	bh=k3cqNzJ/8TsaXEmSbut49LYXwTXR+3Izi3ZX0GMX2QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIqJvImadgjtz+bgBZQCpMqyisC0IXvLCHdOBE48Tb9JrKe5SioXTWBicYznhVnmd7yWF6nyJ7XIDXID5s+SzWPzyhZOQkDTE1WUv8W6B16t9AQ+FiRCm13j9vmf97Aq5rPNYdcSb4YOsHxXef2LloUGpJk0T/CH0UQC8y/t0Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAwYIu+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAwYIu+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACE81F000E9;
	Wed, 20 May 2026 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302580;
	bh=cCbd2CJuUWZXALeoYSjYooG7IVHrXTmtQfmgUQzuq2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAwYIu+yCq1A5RtAI/vFq2fYOzQh1VWQIhH1gSwd3puRWf2cAF3mdSL4wUUuwFQ3V
	 CMXfnlCt0HTOzLPnaCmOx4sBfeHQyKU/fWj25F5stcrOrhlQKSdnh+UWXdz4V+FDJb
	 jksRzqxvwQHz1/8oTIOuV2Ny2akENs9YVGN+1+cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/508] ice: Remove jumbo_remove step from TX path
Date: Wed, 20 May 2026 18:22:24 +0200
Message-ID: <20260520162105.592723781@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 8b76102c5e00d1f090e0c31d17b060c76d8fa859 ]

Now that the kernel doesn't insert HBH for BIG TCP IPv6 packets, remove
unnecessary steps from the ice TX path, that used to check and remove
HBH.

Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260205133925.526371-8-alice.kernel@fastmail.im
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1a303baa715e ("ice: fix double-free of tx_buf skb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index eae4376c68595..66da8a34be0f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2364,9 +2364,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
-	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
-		goto out_drop;
-
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.53.0



