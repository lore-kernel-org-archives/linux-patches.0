Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF2C3AE70F;
	Mon, 23 Mar 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277368; cv=none; b=KMHsxMnrVzWf5J5YXv20G3ju84DV2GrvHBA2TUNI6N81usLbtYnJUbpoeBO4iSp//SUIpMjSCNx615tzSnvtVCrDuWUitpWalqUrsr3ZnoZffHwpF8dVHz1wAqUEcd16JE87CHbmvHBsaGlDjV1yfu0jeYFCBxkvEBDZDt3lW8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277368; c=relaxed/simple;
	bh=DjHrKctnXrgdjYd5QrqK2AvKV2NUsJEobc9RI5HPCeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5Uma6n889tKfKNGoDIHD4Ajo3pkZhbxI6XkhnZy2EgRdRwRXlqxzcdqwKAAvjVsVtExBp4eIze4NLI+cWIXPKZ5PCpH8o+7vz1pJKMfGOeUZ96oDadvnO4K7erx/oiVr1XZ23SSM4ykgpAXZQeIl/PNKs1Y2m/pQy1lybdo0bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUUj7qvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUUj7qvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BAFC2BC9E;
	Mon, 23 Mar 2026 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277367;
	bh=DjHrKctnXrgdjYd5QrqK2AvKV2NUsJEobc9RI5HPCeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUUj7qvkrBJszcdGQtKNVRqhNJzdx7D7mNdVLUr9c1V/CympaQeCeLdWgsfeM9Epu
	 FqY1tv/x1+taPFRAUscxf6Z/FaKXAvYyxHQnMi8ypStJqgFaixaC6TDZyCv881pyRq
	 bw2lfP4higXDtBp0Ot8jPU8zykrvvgPVtwz17bSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobi Gaertner <tob.gaertner@me.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 412/460] net: usb: cdc_ncm: add ndpoffset to NDP16 nframes bounds check
Date: Mon, 23 Mar 2026 14:46:48 +0100
Message-ID: <20260323134536.675718549@linuxfoundation.org>
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
index 5c89e03f93d61..a006583e8e085 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1657,6 +1657,7 @@ int cdc_ncm_rx_verify_ndp16(struct sk_buff *skb_in, int ndpoffset)
 	struct usbnet *dev = netdev_priv(skb_in->dev);
 	struct usb_cdc_ncm_ndp16 *ndp16;
 	int ret = -EINVAL;
+	size_t ndp_len;
 
 	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb_in->len) {
 		netif_dbg(dev, rx_err, dev->net, "invalid NDP offset  <%u>\n",
@@ -1676,8 +1677,8 @@ int cdc_ncm_rx_verify_ndp16(struct sk_buff *skb_in, int ndpoffset)
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



