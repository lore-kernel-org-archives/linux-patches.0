Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7A51684BE;
	Fri, 13 Feb 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990953; cv=none; b=HKR+sV4SUWwmJJOnEkRmTC5x5FloeRWYKer3f7NdMUXX3LDchStZEITqyLHFNlwX7XZcxZ/xx2RkZneu3nTyA60uW609ZOy5Re/uuzNH7C6ZRZzStvrDPFPDThERg8Y0KS4aAzQ8uymtE0HSrEPGBfGDyWy4aNzGgQ2F4sEQl0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990953; c=relaxed/simple;
	bh=Z0UOGPoDlIXhZftwurNL70UcKv2c0o1OkPhyfPJWE2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl5q9LUo5bBeH9+qrND52Aq3FvF0MnCnsHl3AEJqZxsVguR+sEiUCjpUebhRIkAxau8YpQKA6p9GrsGXBjCt9wDqLgDDKzSWQtzQP2vSHMEAqUXjcZlJCTpoIt5qbuPhWHPziituUV45/NZ6jx9CmacmBBWHLksDT6Y1W2mDkPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNsoirSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNsoirSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5ECC116C6;
	Fri, 13 Feb 2026 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990953;
	bh=Z0UOGPoDlIXhZftwurNL70UcKv2c0o1OkPhyfPJWE2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNsoirSb+b9tj7RI+C2d47UCJfmAiov1aMaYozCrSqFWcam415z4SojJI17b+o1fv
	 J/w6RBk345ygJYATVjybrmrCvlSAdcwBRLsG2htfPfi6YwNjLo+c6rx7SaBmK3M74G
	 /tXjX6WK31Ohxv4SOPSsK1PSDkK1ixyndxt/YliY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 23/24] wifi: rtl8xxxu: fix slab-out-of-bounds in rtl8xxxu_sta_add
Date: Fri, 13 Feb 2026 14:48:42 +0100
Message-ID: <20260213134705.569756232@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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
@@ -7903,6 +7903,7 @@ static int rtl8xxxu_probe(struct usb_int
 		goto err_set_intfdata;
 
 	hw->vif_data_size = sizeof(struct rtl8xxxu_vif);
+	hw->sta_data_size = sizeof(struct rtl8xxxu_sta_info);
 
 	hw->wiphy->max_scan_ssids = 1;
 	hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;


