Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ACC3B38B2;
	Mon, 23 Mar 2026 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274907; cv=none; b=DvuA/VUWOzXasafi8f1QAAUfeZc3/UFA4aFr2YzkcaHY06vIBayLMc3zCJdY023viwO5PNaaKdVTZ/aptZQmrztXZcaxxCh7MCjxq5TBDqDoMyInIIfFedqU4IRO1oytkbZyMejTGKQgXtMeN6/PG2MLAM/1GvSJF4bH+ZYwR4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274907; c=relaxed/simple;
	bh=t0jslZ4tF+5xbIvE1lh2o2EJ6IOrL/STVRzVvGOa4W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxZgxr7tBbl3u2I/LGw4LybFBqb/rl9lqmONHkq5CDKPvyY8wG2fB3lD/olYBp3SPZuJRAgJgRI2pve6AJ3rCBsHujnS1gdTtsUnNh/W5hqKC4LaOPiBhMCYG/YeZd+8yUVH5tizRsJj+mhZQuYjjwRsM32daorfrF5old2Quco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqKrVQd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqKrVQd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F81C4CEF7;
	Mon, 23 Mar 2026 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274907;
	bh=t0jslZ4tF+5xbIvE1lh2o2EJ6IOrL/STVRzVvGOa4W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqKrVQd5RfnKBcDIA/jBRrHqSm/kKN6cjEIltvpWUT06a4BP4sP4H6u93oCM8ZG3L
	 fjJdPw64nTpPuJWt35FADtn8BEOfhkmZkX5pJJUGV2iG719RAxFsUzzU0kLu3Q5bJ4
	 Hhn0+03vqzlnDkHJyXZ4THyxDK6Do0exkhDXzKfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobi Gaertner <tob.gaertner@me.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/212] net: usb: cdc_ncm: add ndpoffset to NDP32 nframes bounds check
Date: Mon, 23 Mar 2026 14:46:13 +0100
Message-ID: <20260323134508.562151167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a9d0162b5ee01..81d7e99fc0f09 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1693,6 +1693,7 @@ int cdc_ncm_rx_verify_ndp32(struct sk_buff *skb_in, int ndpoffset)
 	struct usbnet *dev = netdev_priv(skb_in->dev);
 	struct usb_cdc_ncm_ndp32 *ndp32;
 	int ret = -EINVAL;
+	size_t ndp_len;
 
 	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp32)) > skb_in->len) {
 		netif_dbg(dev, rx_err, dev->net, "invalid NDP offset  <%u>\n",
@@ -1712,8 +1713,8 @@ int cdc_ncm_rx_verify_ndp32(struct sk_buff *skb_in, int ndpoffset)
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



