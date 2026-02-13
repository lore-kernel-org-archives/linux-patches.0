Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF7241665;
	Fri, 13 Feb 2026 13:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990705; cv=none; b=hF2cG57HAlho5sKnxXKOZIxgRfMQvbo7/ClT8joNw1aZZ96MRMrY0zYSnfk4OOFaT1587Fq3WWtlwhlmERAZ9/xIfvilHfh61tFehfBEEfbEiSHV2DpE9CsvoTufrdGBHN7JoIgNdxlS5mOFNDpKqHj//dyceJtdDBSwimkcahI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990705; c=relaxed/simple;
	bh=z4aIl31E2zpDC48OVEyKLQxCN86gcaFCCVMgBvNSTRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPNEYZat9z/BYtjqhWglmkqvFKlouDkprDUMNiy6VDUWu00Y6fCgIIqIjgdl5NVXBIn7w5tWFYsDY33vqBQewUQevBMhdTXxrnHw94oS0OJHRUVSarppSff12xn3ul+cPCPZczqSQ0CMHKgHHlE3rZbQpppvyORXGLja+luKpms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gq17rJII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gq17rJII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B482AC116C6;
	Fri, 13 Feb 2026 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990705;
	bh=z4aIl31E2zpDC48OVEyKLQxCN86gcaFCCVMgBvNSTRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gq17rJIIEbkO8KQwLfhmxZhvcq9AxNkhBsQ4PdXwIX79fpe2qlXwS0hIPdnxfYPOd
	 gfySWAgDm3fiNyg/h8KjvujzKa4FUDLnST+P0afAKfJofeXdi386xwnHU0vEtMmnxq
	 CniJC1gSvkAH0pPainh1Y8UsWgV/0BYXPfbTExEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.19 49/49] wifi: rtl8xxxu: fix slab-out-of-bounds in rtl8xxxu_sta_add
Date: Fri, 13 Feb 2026 14:48:08 +0100
Message-ID: <20260213134710.504909787@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Tariq <alitariq45892@gmail.com>

commit 86c946bcc00f6390ef65e9614ae60a9377e454f8 upstream.

The driver does not set hw->sta_data_size, which causes mac80211 to
allocate insufficient space for driver private station data in
__sta_info_alloc(). When rtl8xxxu_sta_add() accesses members of
struct rtl8xxxu_sta_info through sta->drv_priv, this results in a
slab-out-of-bounds write.

KASAN report on RISC-V (VisionFive 2) with RTL8192EU adapter:

  BUG: KASAN: slab-out-of-bounds in rtl8xxxu_sta_add+0x31c/0x346
  Write of size 8 at addr ffffffd6d3e9ae88 by task kworker/u16:0/12

Set hw->sta_data_size to sizeof(struct rtl8xxxu_sta_info) during
probe, similar to how hw->vif_data_size is configured. This ensures
mac80211 allocates sufficient space for the driver's per-station
private data.

Tested on StarFive VisionFive 2 v1.2A board.

Fixes: eef55f1545c9 ("wifi: rtl8xxxu: support multiple interfaces in {add,remove}_interface()")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251225115430.13011-1-alitariq45892@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -7826,6 +7826,7 @@ static int rtl8xxxu_probe(struct usb_int
 		goto err_set_intfdata;
 
 	hw->vif_data_size = sizeof(struct rtl8xxxu_vif);
+	hw->sta_data_size = sizeof(struct rtl8xxxu_sta_info);
 
 	hw->wiphy->max_scan_ssids = 1;
 	hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;


