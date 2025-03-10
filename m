Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AFB17A31A;
	Mon, 10 Mar 2025 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627945; cv=none; b=B4yKvUUYGf5w3r0/ipzkpQPVXrlaRvhucAURXiBYXW7Ara0A56mbi0NUgTMWuThwTk0KSRorERBRDFDDSXLXWW3woaOv8Azxa8nu8eWqB4DV8Zth6vzzVojEtw7xNMxQAPSbzDP7tPfC48qMQPNyytGjVR9E+3+F0oU7afo5t/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627945; c=relaxed/simple;
	bh=n/fZjVSEJfQgY5h15ghT3uHfy9/bnspL9cGK4/yAhnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqEqTREwc4rMveZN7R0TjIhbodZxB/2E2nd8fA9BZPKTH8XsIGtw598La6mD89SOCT5OLSOSysDBrgizbijTX1AbjhfUHN0C0kqEidk6YARfsY39aFa+93jw7q1mpJgZo3nFK9jY6zGnKiqVTQo+3D3wcxdV1IvZFcPEUD47Ibc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epR0oQq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epR0oQq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23DCC4CEEC;
	Mon, 10 Mar 2025 17:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627945;
	bh=n/fZjVSEJfQgY5h15ghT3uHfy9/bnspL9cGK4/yAhnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epR0oQq45savx2T09fSsBkdOfNaE63Siqm8pmL/ezsn3tqUtoVDIUZ5y+LVrcGe6K
	 /FKBhXWe7rH7NDMqwlXWjS4ZJL/ZN+gNad7VCAJaxSmSnztK2hpmmAgxHzI4MTKoOj
	 T73zMjN/yiYMuwfJZyPoe9WcVwKxUYFWaPtMrQ9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/145] ibmvnic: Inspect header requirements before using scrq direct
Date: Mon, 10 Mar 2025 18:05:02 +0100
Message-ID: <20250310170435.079910301@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4bcfdf6e6d3f2..05f410999a5a1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2490,9 +2490,11 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
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



