Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196003BD224;
	Wed, 30 Sep 2026 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795715; cv=none; b=Uq5HQNyyPAbWVq7fIUvTVAhpq9ul69DUohbc5T4FypitH+wgJ54rOrOExLdz84O9nwcFkNjc1gsn1G/qfXcY+j0U/KDNr5oU/LVh5MnO9/dR+6d4s3UTDMecVkS9Q5eBpRLVCguoVwqbGkX1VWKDRfSvFbbp3SmRa8b/24wfLV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795715; c=relaxed/simple;
	bh=fl3i4FCsArZm0/INC0zK225ZtxFKiSby+a/XLg+3OFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLN2MjDqjcx8B1vSR0kcxu1DqZ8RwcLOp9z7wH64swyq1ZvH4eVC5dEqVpKUQo20niyMZ0eAMZHFJpraQjoyqIjMgefrO5VH9L7jnQ3c7VmSfn9Si5uxBqZkbaIM17sqJQyWhxfOh+wxKHVIaVCQ62wyjIveTqEs6ehIs8YxjYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mgi+zBYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mgi+zBYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ADE1F000FF;
	Wed, 30 Sep 2026 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795714;
	bh=UDC2g5/rk1zf7YWBkMxJ9yFF3nNRmJUpSC84VqkTmbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mgi+zBYDYfbjiHI9AXWgLCSZvvoDsxl7OSuE2GpBFDCKlrsTw7qxE99u3gyAXBSC6
	 yeDcF7QrEz8+6H10dOoAkNCPbpQpBwI/kW0lbhrWm3WlSYFaVBYrK1BK+eClN0EqME
	 GjocgHn60NjYPpmBsalNHnLeVFV8xxqFVJkcYbk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 0656/1193] bnxt_en: Only restore LRO if the device supports TPA
Date: Wed, 30 Sep 2026 17:22:20 +0200
Message-ID: <20260930152448.819407336@linuxfoundation.org>
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

From: Joe Damato <joe@dama.to>

commit 4e17b5007b6664559cdad2b2fe270526cf786b5b upstream.

With a P5+ device with firmware that reports max_aggs_supported == 0, it is
possible to make LRO settable by attaching and detaching an XDP program
even though the device does not support TPA.

Fix this by testing BNXT_SUPPORTS_TPA before restoring the feature bit.

Fixes: f0aa6a37a3db ("eth: bnxt: always recalculate features after XDP clearing, fix null-deref")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-2-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4045,7 +4045,8 @@ void bnxt_set_rx_skb_mode(struct bnxt *b
 		bnxt_get_max_rings(bp, &rx, &tx, true);
 		if (rx > 1) {
 			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features |= NETIF_F_LRO;
+			if (BNXT_SUPPORTS_TPA(bp))
+				bp->dev->hw_features |= NETIF_F_LRO;
 		}
 	}
 


