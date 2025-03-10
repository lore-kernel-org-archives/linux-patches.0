Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7CD1B3927;
	Mon, 10 Mar 2025 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628314; cv=none; b=uGEalQ1//hC+IqvDnx4+6a9BKXwoX5irIKWG3Fs7bPMzsxK1g8PbCNV0VieRBm1iugI2eRoqtks6Nx2SaxdRqAegWJH5DEP69jSWmLb0UwPyvP9gCpTU4B7kVJFoyZvxt4rlsGceAVOJid2KbOL34CzJmHQ9dJZIUTVIGzTPoXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628314; c=relaxed/simple;
	bh=LWs2Ee9wnXDfAPAR0otQ7zAd7+jORXDdXmGUURgcX/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J37M7IPymU0EHHe76AN0IXn9lReev7J8X66mXymqDqRQ76nz9q6JXJypEOH15U8EYgKArWJSvSiamRODURhFGkYTGxb27z0w/HQ0wLE9p/VT1BqWctgtNTTx8tPjo2CEVYKy+3Wu9+bDBBgg0R+SVOpWL9kYO5Rjy/s4CvKj8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNPsIY2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNPsIY2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E2DC4CEE5;
	Mon, 10 Mar 2025 17:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628314;
	bh=LWs2Ee9wnXDfAPAR0otQ7zAd7+jORXDdXmGUURgcX/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNPsIY2IyTjQIC/QkinvnkH4+yfS1xD0PYcCDDfKekJH4K88C/EcKFi9girAoIfNg
	 yQIOSr2dCgJv5KcO3ylC+uXWPwqdD6SLBWWdu/o6Mzmv5vSJWCx/uWEnfuNICkTf6g
	 Zy3h4Tvnj/wB27gfbJiuvFaj/VS3ESHXM+UxWouA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/109] ibmvnic: Inspect header requirements before using scrq direct
Date: Mon, 10 Mar 2025 18:05:46 +0100
Message-ID: <20250310170427.638809866@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit de390657b5d6f7deb9d1d36aaf45f02ba51ec9dc ]

Previously, the TX header requirement for standard frames was ignored.
This requirement is a bitstring sent from the VIOS which maps to the
type of header information needed during TX. If no header information,
is needed then send subcrq direct can be used (which can be more
performant).

This bitstring was previously ignored for standard packets (AKA non LSO,
non CSO) due to the belief that the bitstring was over-cautionary. It
turns out that there are some configurations where the backing device
does need header information for transmission of standard packets. If
the information is not supplied then this causes continuous "Adapter
error" transport events. Therefore, this bitstring should be respected
and observed before considering the use of send subcrq direct.

Fixes: 74839f7a8268 ("ibmvnic: Introduce send sub-crq direct")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241001163200.1802522-2-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 578b9b5460108..071dca86fc883 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2300,9 +2300,11 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	/* if we are going to send_subcrq_direct this then we need to
 	 * update the checksum before copying the data into ltb. Essentially
 	 * these packets force disable CSO so that we can guarantee that
-	 * FW does not need header info and we can send direct.
+	 * FW does not need header info and we can send direct. Also, vnic
+	 * server must be able to xmit standard packets without header data
 	 */
-	if (!skb_is_gso(skb) && !ind_bufp->index && !netdev_xmit_more()) {
+	if (*hdrs == 0 && !skb_is_gso(skb) &&
+	    !ind_bufp->index && !netdev_xmit_more()) {
 		use_scrq_send_direct = true;
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    skb_checksum_help(skb))
-- 
2.39.5



