Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140C74FB9C8;
	Wed, 30 Sep 2026 16:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786700; cv=none; b=KAKYmJArHYEbRe3BuIcMX83/N4k/E8wNr0hlI+p7O6nvNrJCi5F+h6V+FtOS69i/FawO9J1ks68+ltEF/6IB6V+yq9ulW3TZDjENuLy55ycjZJd4PUnPZsQnZ/HScO1PnAq4REUVanRyU3cZbmmn2WDP2luHUqz5SXnylG01hx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786700; c=relaxed/simple;
	bh=bGnlVIBK2VDkqbbz2igQSYVivsUPd37ZNZAGsmHgU9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DtznoYbJkIlN6tSxe5mc4XBxx9bBJREWpjxx9nwLJHwOwwWgG22vDFThZe/o0PyyNNW1VO2qJiiIuTqfVYOENrz+U32NWTIzbp2vjMO1B1yjwl5MBU69D+/EgGIAsUpF5kF8EZwr+DQJjkp3vhZ186ABd4cNw5nCWEiJusmO3AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgKpS0Eg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgKpS0Eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E42A1F000FF;
	Wed, 30 Sep 2026 16:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786699;
	bh=BB2P79rKjSG/hlRFPoTZwjPKH8s+u8KTpOQU3AIKOuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgKpS0Eg0hUqAFXSAq/E+l8GIpcs4ojW2NmExHGHsEIAutoeoU1ownERS4o4/WpRR
	 kpXORGjWodziX1R6Bx0LcZ0omYnMDsMxtxmp11XBZmaLwYgt07V2f//JWwFqhQ/7D8
	 J4GrShCA+4SYp6JRLrmb97tGLifwFJZDoi2aSdfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gajdos=20Tam=C3=A1s?= <tamas@rimpianto.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 954/982] net: atl1: fix soft lockup on out-of-range cmb_tpd_next_to_clean read
Date: Wed, 30 Sep 2026 17:28:10 +0200
Message-ID: <20260930152437.226156832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gajdos Tamás <tamas@rimpianto.com>

commit 43e746821f5f5afbbf68e388bf9fbe221e03bfca upstream.

Same issue as atl1c (see the first commit in this series, "net:
atl1c: fix soft lockup on out-of-range tpd_cons read"): the hardware
can report an out-of-range cmb_tpd_next_to_clean (seen as 0xffff)
while the PCIe link/MAC is resetting. An out-of-range value can
never be reached and the loop below would spin forever. Treat it as
"nothing new to clean" instead.

Fixes: f3cc28c797604f ("Add Attansic L1 ethernet driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Gajdos Tamás <tamas@rimpianto.com>
Link: https://patch.msgid.link/20260921091334.3571525-4-tamas@rimpianto.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atlx/atl1.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2066,6 +2066,9 @@ static int atl1_intr_tx(struct atl1_adap
 	sw_tpd_next_to_clean = atomic_read(&tpd_ring->next_to_clean);
 	cmb_tpd_next_to_clean = le16_to_cpu(adapter->cmb.cmb->tpd_cons_idx);
 
+	if (unlikely(cmb_tpd_next_to_clean >= tpd_ring->count))
+		cmb_tpd_next_to_clean = sw_tpd_next_to_clean;
+
 	while (cmb_tpd_next_to_clean != sw_tpd_next_to_clean) {
 		buffer_info = &tpd_ring->buffer_info[sw_tpd_next_to_clean];
 		if (buffer_info->dma) {


