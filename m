Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605167580D;
	Mon, 15 Apr 2024 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191755; cv=none; b=O1YTOuBujB8hzx0olQf67HjyZIBlKUX+6tFslV9qhIdYDMGwpMB9Oh2KKyA7glh1JPwguDhDXVTU87vPofTjZ2hNPo3PW5rxjHSHI2TuxoEeGLhWUQE3UdDK0nXyHC/yjpGrbej642hI/XQbgvl/HgFMlsnjPmnTTsfedxUyY6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191755; c=relaxed/simple;
	bh=82I+S6/Y+ACyMeYsxLfyBioEyZmB9VdDl/oXxWfKzA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPyKWEIoj6EdBvVaPUwhGuBRfLom+ceQ6kA6b/GvJNfhqoqXdITRt1fnREfNpeTwznOUlmEY1BmxePc1zgZeCKhIUw7GkEcYpuhOkoHsgKG4h6TWt0p1HD9vPQvj4xqyOFEY0FMcpcqX/CNQQaaTklW2ugXHSbZuP1U8q9S4VPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTvshqhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTvshqhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86918C113CC;
	Mon, 15 Apr 2024 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191754;
	bh=82I+S6/Y+ACyMeYsxLfyBioEyZmB9VdDl/oXxWfKzA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTvshqhl0baGs7UT4SgczmHf7rAlvGDtijtfjk+cY91/7Ayy0U93DJv8cX//fsugx
	 BlMpoJrAMwknY5CNzpA+oZpTUCwUjXXK62duC8w8JqGawccVzWsAEIU3lY7RNGjGYh
	 q6eVdfP9QSf3uSflZvPfVZStiih5pzipEZlT+A1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/122] net: ena: Set tx_info->xdpf value to NULL
Date: Mon, 15 Apr 2024 16:20:39 +0200
Message-ID: <20240415141955.598167053@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 36a1ca01f0452f2549420e7279c2588729bd94df ]

The patch mentioned in the `Fixes` tag removed the explicit assignment
of tx_info->xdpf to NULL with the justification that there's no need
to set tx_info->xdpf to NULL and tx_info->num_of_bufs to 0 in case
of a mapping error. Both values won't be used once the mapping function
returns an error, and their values would be overridden by the next
transmitted packet.

While both values do indeed get overridden in the next transmission
call, the value of tx_info->xdpf is also used to check whether a TX
descriptor's transmission has been completed (i.e. a completion for it
was polled).

An example scenario:
1. Mapping failed, tx_info->xdpf wasn't set to NULL
2. A VF reset occurred leading to IO resource destruction and
   a call to ena_free_tx_bufs() function
3. Although the descriptor whose mapping failed was freed by the
   transmission function, it still passes the check
     if (!tx_info->skb)

   (skb and xdp_frame are in a union)
4. The xdp_frame associated with the descriptor is freed twice

This patch returns the assignment of NULL to tx_info->xdpf to make the
cleaning function knows that the descriptor is already freed.

Fixes: 504fd6a5390c ("net: ena: fix DMA mapping function issues in XDP")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_xdp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_xdp.c b/drivers/net/ethernet/amazon/ena/ena_xdp.c
index 363e361cc5aa8..25de2f511649f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_xdp.c
+++ b/drivers/net/ethernet/amazon/ena/ena_xdp.c
@@ -89,7 +89,7 @@ int ena_xdp_xmit_frame(struct ena_ring *tx_ring,
 
 	rc = ena_xdp_tx_map_frame(tx_ring, tx_info, xdpf, &ena_tx_ctx);
 	if (unlikely(rc))
-		return rc;
+		goto err;
 
 	ena_tx_ctx.req_id = req_id;
 
@@ -112,7 +112,9 @@ int ena_xdp_xmit_frame(struct ena_ring *tx_ring,
 
 error_unmap_dma:
 	ena_unmap_tx_buff(tx_ring, tx_info);
+err:
 	tx_info->xdpf = NULL;
+
 	return rc;
 }
 
-- 
2.43.0



