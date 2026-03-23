Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C433E3AF672;
	Mon, 23 Mar 2026 14:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277370; cv=none; b=lTzb6EVbMNiFjBb1pJQ/PVpinS9WptiTprpTFjHcpql8da4Cs14n22cHAavCGsSbK+M/G5pIi/rr2BDD1COYREtOLBG9V31ew9J4wq0n9+kbeBgGjsV8ep2AB/ihpSLMW/hIWoY8wV9H6qM4bDP0AIbjWnZ4vO6GJXpOWRDon7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277370; c=relaxed/simple;
	bh=6+ttoRRmly0kXpRS4+B6XrAX95X1b7OQjdUbUkBAQ5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIqtvUZ20OKUzUdcbWwu5G97QYf2FHo085Dp8N8wlr4vDvwUaeXqYjAsktY5Ut8852YuH8i92+OF88g3GoHi74PUIdtlgHhtWjQCroXWK9wyoU+p6jYwWmpcn9BDo53RuO4sE8gIlSeS9pq5hn1bz9fglOZQPpL7EVR1EdPjef0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yxEUyEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yxEUyEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E060C2BC9E;
	Mon, 23 Mar 2026 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277370;
	bh=6+ttoRRmly0kXpRS4+B6XrAX95X1b7OQjdUbUkBAQ5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yxEUyEf0PyOY2KGV1MUe6I5cJpHi2DjxuOpBvzdRuJY+vCcc1K0RD4/LLDKqLROx
	 v/dIDPzKGMEfBgu2paN0hZ/PwY1FrQEKVD1Vbk5vIX8oOzwUo4QnCpAS47P9+hEtZl
	 nEG2L9mX926lKOmSSRh9GdXdpeLa5UhwtqGNPPaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobi Gaertner <tob.gaertner@me.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 413/460] net: usb: cdc_ncm: add ndpoffset to NDP32 nframes bounds check
Date: Mon, 23 Mar 2026 14:46:49 +0100
Message-ID: <20260323134536.698195360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobi Gaertner <tob.gaertner@me.com>

[ Upstream commit 77914255155e68a20aa41175edeecf8121dac391 ]

The same bounds-check bug fixed for NDP16 in the previous patch also
exists in cdc_ncm_rx_verify_ndp32(). The DPE array size is validated
against the total skb length without accounting for ndpoffset, allowing
out-of-bounds reads when the NDP32 is placed near the end of the NTB.

Add ndpoffset to the nframes bounds check and use struct_size_t() to
express the NDP-plus-DPE-array size more clearly.

Compile-tested only.

Fixes: 0fa81b304a79 ("cdc_ncm: Implement the 32-bit version of NCM Transfer Block")
Signed-off-by: Tobi Gaertner <tob.gaertner@me.com>
Link: https://patch.msgid.link/20260314054640.2895026-3-tob.gaertner@me.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index a006583e8e085..c00699cd3e350 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1694,6 +1694,7 @@ int cdc_ncm_rx_verify_ndp32(struct sk_buff *skb_in, int ndpoffset)
 	struct usbnet *dev = netdev_priv(skb_in->dev);
 	struct usb_cdc_ncm_ndp32 *ndp32;
 	int ret = -EINVAL;
+	size_t ndp_len;
 
 	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp32)) > skb_in->len) {
 		netif_dbg(dev, rx_err, dev->net, "invalid NDP offset  <%u>\n",
@@ -1713,8 +1714,8 @@ int cdc_ncm_rx_verify_ndp32(struct sk_buff *skb_in, int ndpoffset)
 					sizeof(struct usb_cdc_ncm_dpe32));
 	ret--; /* we process NDP entries except for the last one */
 
-	if ((sizeof(struct usb_cdc_ncm_ndp32) +
-	     ret * (sizeof(struct usb_cdc_ncm_dpe32))) > skb_in->len) {
+	ndp_len = struct_size_t(struct usb_cdc_ncm_ndp32, dpe32, ret);
+	if (ndpoffset + ndp_len > skb_in->len) {
 		netif_dbg(dev, rx_err, dev->net, "Invalid nframes = %d\n", ret);
 		ret = -EINVAL;
 	}
-- 
2.51.0



