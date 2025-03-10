Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7B8374EA;
	Mon, 10 Mar 2025 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630772; cv=none; b=J3ElMDBEQhQVHTAToHgpK7UyaFLDa9gsXzBKY2EBj79s0czK7qLQW7NoaOI2I8eGDlJUbqY/l9m04CCj9/hF+xeBxaVVNCHhjateOsMW0ISxaXewKEFd0m736VmdFAEUBWeTNKDJ438T/+HlCZhMuHFkMP2U/FGVYHxmRcq6ssY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630772; c=relaxed/simple;
	bh=SSouJf3D3p5GCdCXb9lGd56L7zOYV+YnUVfk88drQHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2XSet/MLtO69Pxp+qrnoXQH56ryrkbpMsxyre04DXr59f4rrsujBUI3x0TbnYrpWVN9TBYBnt1If+/DH2O3EscS3yMFwueoFJRFNCAxeWIkZ2oAmP05u3awuy4JDMgQmxJWMz2Q+o9XyHDdj7KAYHPvOCp+8kImPBSQnwsGehk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzhsOMWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzhsOMWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9583C4CEE5;
	Mon, 10 Mar 2025 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630772;
	bh=SSouJf3D3p5GCdCXb9lGd56L7zOYV+YnUVfk88drQHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzhsOMWb/5iJ0iICc4eFHDmCKxO2ybZjst4E3avQq3zT60q8eKRflDjLIX4juD464
	 dqy0oDqKVQFh6wfdKN92K0NEKYbEK0aL+aZZvt93ODNcDYw0AbkpiL9G0bQeDVvz/J
	 YbHQWllymp1+yeAEIYTU8IUDi2HFgNF1zoW/MiBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 522/620] net: enetc: correct the xdp_tx statistics
Date: Mon, 10 Mar 2025 18:06:08 +0100
Message-ID: <20250310170606.157617978@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1343,7 +1343,7 @@ static int enetc_clean_rx_ring_xdp(struc
 				enetc_xdp_drop(rx_ring, orig_i, i);
 				tx_ring->stats.xdp_tx_drops++;
 			} else {
-				tx_ring->stats.xdp_tx += xdp_tx_bd_cnt;
+				tx_ring->stats.xdp_tx++;
 				rx_ring->xdp.xdp_tx_in_flight += xdp_tx_bd_cnt;
 				xdp_tx_frm_cnt++;
 				/* The XDP_TX enqueue was successful, so we


