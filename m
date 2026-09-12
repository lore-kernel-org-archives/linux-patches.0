Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD92C3CDBB5;
	Sat, 12 Sep 2026 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228765; cv=none; b=GQ55xx8zvuCxDNhCYcJcGUKaVyEZ2h0dRJYAC6o96/PL+rLmX5yoh5cch4gQmk+VWLn2hwCubw+zFrM1vEqNvmD/tXWxQqeSF15PO6e6V2AQbtGDoogyNJuDhFVnGOzRBSskuq67eg4JB/XIBFrQGf4sJZFTnf2oAplXM8V4kEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228765; c=relaxed/simple;
	bh=ayCvz/0qbY43qCObapC7cGCe10axLjdTNmNC7ARsgJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+YazlQ49iTx+gHdt8Iy3sVpo/f8lUs/nVXVC9Nttnzb3bkhkLpxIupJBKpGp53XnnsnioxJrmkPglJVwU53t8WwXqXd9sXMmC+GkxbnqpewR5JIUF4lTJPTai5GQHx5OoqkbyjvWn3bidCNafgyzGcNe8UOM1u/hXmqXP9ngXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1/E5HVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1/E5HVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F701F000FF;
	Sat, 12 Sep 2026 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228764;
	bh=9MTDhob0SJ0HmL1llcEm3Ar6zfbzV4Ta8wcuOfsM2OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1/E5HVt1mWgSh9ApR72qEWcKLt3vTMeYBJrVlWp/B7mx5/rKP8/nI8xLwtRp58lc
	 oT4/c4INBZ7ve4ceppqN5dq+ZTMptDWkAoKKlkHb0lJ7PZU9Xgc9anBHTfEK3qg4lx
	 DsMDfcljGLT6eN9E6rCKqWYjQnXUl7l+VhXJ1pbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobi Gaertner <tob.gaertner@me.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0451/1191] net: usb: cdc_ncm: add ndpoffset to NDP16 nframes bounds check
Date: Sat, 12 Sep 2026 08:52:59 +0200
Message-ID: <20260912065558.362114276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c3b1e9af922b1..72f97a6d04bcc 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1655,6 +1655,7 @@ int cdc_ncm_rx_verify_ndp16(struct sk_buff *skb_in, int ndpoffset)
 	struct usbnet *dev = netdev_priv(skb_in->dev);
 	struct usb_cdc_ncm_ndp16 *ndp16;
 	int ret = -EINVAL;
+	size_t ndp_len;
 
 	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb_in->len) {
 		netif_dbg(dev, rx_err, dev->net, "invalid NDP offset  <%u>\n",
@@ -1674,8 +1675,8 @@ int cdc_ncm_rx_verify_ndp16(struct sk_buff *skb_in, int ndpoffset)
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
2.53.0



