Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92532383C86;
	Wed, 30 Sep 2026 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791736; cv=none; b=svjK56Awb0PhAjpdzHmdzekmDPcweL3+wau7W8aqf76/nPYx5kMiZhTn3RK3lfrlo1YDVDBj/dcyFOAffKC82C/zAbB8YuAo1TUxbj+Kg7CavBUxhmCIlqRAuT3hIegcWqGFN9z5V0xyKmiCNpk0xvmKzBUhf2Tiswn2nizfOxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791736; c=relaxed/simple;
	bh=YzaOyI9jXqXNP3d7zl2EuDEkO03WhM2C6N0sUY47leE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqFajf4git4hghdjIvq9b7kysuAv/2EJzPTxQYVRCYth2xNwsWTVAhGBblK/WmcAbkqjukZUQev0WmnMhPCy4NuQ67yXW7jThX7bZZ+APbAKOtjmEqxIv9tcThSjiuJsc0e64VC+X7ZJpBaD6eJHoXhAwLdvvZSK0tBz2dpqB8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRWjWY3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRWjWY3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6131F000FF;
	Wed, 30 Sep 2026 18:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791735;
	bh=MZL2IJb4Q4hSJbjhySTpnyo44Gthyybhpv5cOR81WLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRWjWY3CyqOJZieFOYiOh5ZljXswxJaZl6TMRekC/g8IahdrbxIQ2tDhzYCJoRWS4
	 rAoNOa5HLdamEL71jmooFqvAlOWzH/hQlrekgS/T/q21yli3PmZ1mM2aB60z7udvr6
	 YHLdzPXa2lQYj6gOAww6AfWTOzcRe1TsbEGbxh/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 405/752] bnxt_en: Propagate RX ring init failures in bnxt_init_nic()
Date: Wed, 30 Sep 2026 17:24:35 +0200
Message-ID: <20260930152407.044620930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

commit 8e6a850c0746bb4be167aedf1ee57469fcda09a9 upstream.

bnxt_init_rx_rings() returns an error when bnxt_alloc_one_rx_ring()
fails, but bnxt_init_nic() discards that return value and calls
bnxt_init_chip(), which enables TPA.

If an allocation fails, this could leave rxr->rx_tpa[] partially zeroed
and TPA would be enabled over an array with zeroed entries. This would
lead to a zeroed DMA address being handed out if the agg_idx is
translated to a SW index at a zeroed entry.

Fix this by propagating the error out of bnxt_init_nic(). Both callers
already check its return value and unwind with bnxt_free_skbs() and
bnxt_free_mem(), which tolerate a partially initialized RX ring.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-6-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8706,8 +8706,13 @@ static int bnxt_shutdown_nic(struct bnxt
 
 static int bnxt_init_nic(struct bnxt *bp, bool irq_re_init)
 {
+	int rc;
+
 	bnxt_init_cp_rings(bp);
-	bnxt_init_rx_rings(bp);
+	rc = bnxt_init_rx_rings(bp);
+	if (rc)
+		return rc;
+
 	bnxt_init_tx_rings(bp);
 	bnxt_init_ring_grps(bp, irq_re_init);
 	bnxt_init_vnics(bp);


