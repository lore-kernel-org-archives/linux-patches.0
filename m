Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302AA3B6368;
	Mon, 23 Mar 2026 15:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279263; cv=none; b=OAG0j5rnOTaubmCmN5LxzgINAcibZ/ZrYLe86sZu9O17mUkG/4uyjB91oAdsJxEjQfEE/P8VYhxKkOENDtYTqQzLR+g8ji41CiqIiJTL2FeG/FazQWZ3t9A58Emdb8UV/dZzZbXqKePpmSAe/QLghKJeyzza+1ab75C9vmz6NhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279263; c=relaxed/simple;
	bh=A/jXhKELRwy8eI3Xw7pcH/6bdxL9qWUXneBzAoAM4vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7Za3xNhdQZfap18/rnAs01TrS4XLhkU8Ne6TftF8qLQ7EeNS/RHy40fhIaHuzSvmcrnvSMBCbjjxGa40EfkEEllyK9anuvnxjX/vv2lC+FZG38iyYXZf6WFfNzF7ELeCtaQWMyhTOe6WNSl5jsWOHD2nge9sU1ks1RG3IiACzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2FcgYA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2FcgYA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550D9C4CEF7;
	Mon, 23 Mar 2026 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279262;
	bh=A/jXhKELRwy8eI3Xw7pcH/6bdxL9qWUXneBzAoAM4vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2FcgYA8Phih2NaYBQvFAFfDgFDb0cNAOvOpc9C2PpSpZ45Gy/PmWTOe6UFPM68sV
	 ejUqh7pbDIlkEyOW9rhoZtAqYPjVA46epkh72r2lpLKZBXfyafwn/aQxXlSqSlt+E1
	 7+lEAYL/AjePXc2fBeVZL0Cg8ZI8tHux+BDJKBgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobi Gaertner <tob.gaertner@me.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 528/567] net: usb: cdc_ncm: add ndpoffset to NDP16 nframes bounds check
Date: Mon, 23 Mar 2026 14:47:28 +0100
Message-ID: <20260323134547.061953800@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobi Gaertner <tob.gaertner@me.com>

[ Upstream commit 2aa8a4fa8d5b7d0e1ebcec100e1a4d80a1f4b21a ]

cdc_ncm_rx_verify_ndp16() validates that the NDP header and its DPE
entries fit within the skb. The first check correctly accounts for
ndpoffset:

  if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb_in->len)

but the second check omits it:

  if ((sizeof(struct usb_cdc_ncm_ndp16) +
       ret * (sizeof(struct usb_cdc_ncm_dpe16))) > skb_in->len)

This validates the DPE array size against the total skb length as if
the NDP were at offset 0, rather than at ndpoffset. When the NDP is
placed near the end of the NTB (large wNdpIndex), the DPE entries can
extend past the skb data buffer even though the check passes.
cdc_ncm_rx_fixup() then reads out-of-bounds memory when iterating
the DPE array.

Add ndpoffset to the nframes bounds check and use struct_size_t() to
express the NDP-plus-DPE-array size more clearly.

Fixes: ff06ab13a4cc ("net: cdc_ncm: splitting rx_fixup for code reuse")
Signed-off-by: Tobi Gaertner <tob.gaertner@me.com>
Link: https://patch.msgid.link/20260314054640.2895026-2-tob.gaertner@me.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 22554daaf6ff1..ae7a2829fe49d 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1656,6 +1656,7 @@ int cdc_ncm_rx_verify_ndp16(struct sk_buff *skb_in, int ndpoffset)
 	struct usbnet *dev = netdev_priv(skb_in->dev);
 	struct usb_cdc_ncm_ndp16 *ndp16;
 	int ret = -EINVAL;
+	size_t ndp_len;
 
 	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb_in->len) {
 		netif_dbg(dev, rx_err, dev->net, "invalid NDP offset  <%u>\n",
@@ -1675,8 +1676,8 @@ int cdc_ncm_rx_verify_ndp16(struct sk_buff *skb_in, int ndpoffset)
 					sizeof(struct usb_cdc_ncm_dpe16));
 	ret--; /* we process NDP entries except for the last one */
 
-	if ((sizeof(struct usb_cdc_ncm_ndp16) +
-	     ret * (sizeof(struct usb_cdc_ncm_dpe16))) > skb_in->len) {
+	ndp_len = struct_size_t(struct usb_cdc_ncm_ndp16, dpe16, ret);
+	if (ndpoffset + ndp_len > skb_in->len) {
 		netif_dbg(dev, rx_err, dev->net, "Invalid nframes = %d\n", ret);
 		ret = -EINVAL;
 	}
-- 
2.51.0



