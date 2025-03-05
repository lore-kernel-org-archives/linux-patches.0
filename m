Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799AE253F3C;
	Wed,  5 Mar 2025 18:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198699; cv=none; b=estBMyZHauQYchj13W6WWE+tgZo85hrN7pjYdMgdYzGY8h+SYHoxnuFnrY6w825A3zrXfuT6dJrKNMZR8hlyHLSB+zbBKt/o/djS2+wtgsdmW+KjhAQsFCeCxkHT2TYbW6ABjxnliVmVl9PSYWgkTAKa1dE9VngBhXngiCzX0HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198699; c=relaxed/simple;
	bh=xnP8mafd0ShtL5PBkO11rrnMfQJLGewTL8TRLn3wsHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/ehVFP/ktvL4sKeB1x2VTbtJ83V4No+ct3tqs2xVDwI94cxVbcH2vYFutDfI9vCvmETK4yYCyW7Xf+fNOTKIOqh9JIUIBJY8KIwrbw2Mu7QdyrqKD3GuWAbzfVbD1bmgflj8UNf6RqH0u+9AgdEb+2ebtsYHhXErM4aBrNKwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJlDKDsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJlDKDsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FFAC4CED1;
	Wed,  5 Mar 2025 18:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198697;
	bh=xnP8mafd0ShtL5PBkO11rrnMfQJLGewTL8TRLn3wsHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJlDKDsa9prwsD/tDqpEABjRa4XW1xUJdpXwUdT47feCBv+yFJoMbe9Pz2AcrfQ2d
	 2xm1Bn4l/LAqaoI+k1HoUo0VLM7Unu/iBw3IItPfHoaqS2ELIlVlK8yS7lkVW5wgk+
	 H7cxXMmt7Dqnb8uIUG7AxqbByr62nFbrv2f2J4hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 117/157] net: enetc: correct the xdp_tx statistics
Date: Wed,  5 Mar 2025 18:49:13 +0100
Message-ID: <20250305174510.014285003@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 432a2cb3ee97a7c6ea578888fe81baad035b9307 upstream.

The 'xdp_tx' is used to count the number of XDP_TX frames sent, not the
number of Tx BDs.

Fixes: 7ed2bc80074e ("net: enetc: add support for XDP_TX")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-4-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1668,7 +1668,7 @@ static int enetc_clean_rx_ring_xdp(struc
 				enetc_xdp_drop(rx_ring, orig_i, i);
 				tx_ring->stats.xdp_tx_drops++;
 			} else {
-				tx_ring->stats.xdp_tx += xdp_tx_bd_cnt;
+				tx_ring->stats.xdp_tx++;
 				rx_ring->xdp.xdp_tx_in_flight += xdp_tx_bd_cnt;
 				xdp_tx_frm_cnt++;
 				/* The XDP_TX enqueue was successful, so we


