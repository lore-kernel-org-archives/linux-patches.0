Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF02C4BE43B;
	Fri,  9 Oct 2026 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555507; cv=none; b=OT8kWrWST3pRaNb8pqH/vE51mDUsDPm4oCmoqJXEr4szqirQffnSVXKgD8LJ7WuMAw9lI1e9rNrmUh+YLhdW/bF6+oAQUCUp4jaUfZlFKxrHg4zObmiU93dZajWfdEF7uCiSbVJmpzKb/1obb+4qCvdL5ofHmczUiLYi0bXpmHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555507; c=relaxed/simple;
	bh=wul1UMX2Xc90RYivHGTcK1+PCLJI+CR69XGq7G014OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RyvS108r1iL6CYywqgh68koXV+WO64qM8apFZJEfUdejthW1QC9WRzehEXZrRF8d3hlYYBx0EWl3lCnuC+U6HOx647R8WEu36HtaymcwVhCm0x2jHAThRYVqAWP0j8OAQGLw3pBXDrpEOqGsM+8PY3ytxYEgucotA5yjWROA9bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SD/enyAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SD/enyAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ADD1F000FF;
	Fri,  9 Oct 2026 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555505;
	bh=F3KaD7Ms1ypAN/AI+x1wgEc+Iw67gaBQz6+SLrfTZlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SD/enyAwkEN/VjueKR6ApfQSQrMafHeeyT1Rr4DpFWKDhmKHTY9r2+wn2zRxww7K+
	 fD7VJagWMK77LcKZ0S3mv+6OGx6oLIwgDd6sHfxSR7xuxCytRcvTQsIHNfLbSNzpJC
	 zx3fX/5aGdv2GnwA5QHgCzRe+eEc14zJQk9J6zeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jari=20Sepp=C3=A4l=C3=A4?= <jase@nocloud.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 028/403] octeontx2-pf: Fix RSS indirection table size
Date: Fri,  9 Oct 2026 16:06:29 +0200
Message-ID: <20261009140952.771811911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 0f3f405d9f1b..b11389a841d1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -394,7 +394,7 @@ int otx2_rss_init(struct otx2_nic *pfvf)
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
 	int idx, ret = 0;
 
-	rss->rss_size = sizeof(*rss->ind_tbl);
+	rss->rss_size = ARRAY_SIZE(rss->ind_tbl);
 
 	/* Init RSS key if it is not setup already */
 	if (!rss->enable)
-- 
2.56.0



