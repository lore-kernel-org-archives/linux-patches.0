Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9464D489C;
	Fri,  9 Oct 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555571; cv=none; b=kGVQMKr8Xc4QfO6Cr45t+HUyz8gX4CEBEw0q3fokS2MhrZhrAsiRTJTyDS2tl6AcfX3jP2M48YhNBbdRnPN3hiVhWqAS27GzuNaF38WI2rO3OE3JsU6sOX0L81GUIF8gW6a3dXumlQHPIOeL3s+Eq4rjU+taHbhzCXYugFNuFUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555571; c=relaxed/simple;
	bh=/av7F/hA2H4AmmGhCtu3sg3WJwXSXGjNcnDjWtK9XfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RVXWuCcqh4lDO13vFhAOAgOaYZlaub7hXdc7DKmUZQLaVrVUu33f3h5KG2GB3Bszk40Vj8impkpHMerPpr8espBGe8prmNTR9lsA2UNSwBc5KGPUOtEGCYIAiPKN7fVHBmTv45GK9lxhvTbZVmZdOQ8MizZbqh3sGtq1jPyr/Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4NWBxJW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4NWBxJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE17A1F00893;
	Fri,  9 Oct 2026 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555568;
	bh=AZ+cEetsMiLpg124Y1MIvCg3BUFaWiiRT9Te33ksZIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4NWBxJWww/Ygqd9KjCP/cjQAXhW/J12Au1C1eRRA4Yc/rtyPDdoTg6o8rYRnuo82
	 XF9oos1oSWzijT66ohQSZjsMuk+OybBcPiohamD7JniqfIebcaE9usl4fZMa+TN4DL
	 HL6IWQ8F9mKOa89qnAFZfb+D+yI87DdYPcwYW3g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jari=20Sepp=C3=A4l=C3=A4?= <jase@nocloud.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 030/428] octeontx2-pf: Fix RSS indirection table size
Date: Fri,  9 Oct 2026 16:06:07 +0200
Message-ID: <20261009140946.740454232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jari Seppälä <jase@nocloud.org>

commit 9e792901418d814295674d1f53d6b615fb5c15c8 upstream.

The conversion to the dedicated RSS context operations replaced the
pointer to struct otx2_rss_ctx with an inline u32 ind_tbl[] array.
However, otx2_rss_init() still uses sizeof(*rss->ind_tbl) to set rss_size.
This now yields the size of one u32 (4), rather than the 256 entries in
the indirection table.

The RSS initialization and hardware programming loops use rss_size,
so only four entries are initialized and programmed despite the NIX LF
being allocated a 256-entry table. On an OCTEON CN102 with eight RX
queues, the table contained 0, 1, 2, 3 followed by zeros. Traffic was
concentrated on queue 0 and ethtool -X equal 8 did not correct the table.

Use ARRAY_SIZE() to count the indirection table entries. On the same
hardware, this restores the full table repeating queue numbers 0 through
7, and bidirectional multi-flow traffic increments multiple RX queues.

Runtime testing on an Asterfusion ET2500 (OCTEON CN102 A0).

Fixes: 62e01d8c4170 ("eth: otx2: migrate to the *_rxfh_context ops")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/netdev/361df563-e29e-43bf-8806-24bdfefed33d@nocloud.org/
Signed-off-by: Jari Seppälä <jase@nocloud.org>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260928084711.2462571-1-jase@nocloud.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -394,7 +394,7 @@ int otx2_rss_init(struct otx2_nic *pfvf)
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
 	int idx, ret = 0;
 
-	rss->rss_size = sizeof(*rss->ind_tbl);
+	rss->rss_size = ARRAY_SIZE(rss->ind_tbl);
 
 	/* Init RSS key if it is not setup already */
 	if (!rss->enable)


