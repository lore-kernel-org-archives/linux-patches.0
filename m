Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD82DEA67;
	Tue, 11 Nov 2025 01:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823736; cv=none; b=u4+x2bFwni5HxTauaBkGRqexicYZdaj8Q4LXlkFO3yEkkItnkdOUiDWIKq3zLeoFDff1LGWZjX6jJtu6B+uSZtV2Vg2E6/r2TjX4E4AcphcS/ueKKa2b/Z/jecTzaPNYyGJqP27ibvLfKGBU2GkmzqjcwQ2q+wDF/I2IHA0ErEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823736; c=relaxed/simple;
	bh=yzKQTa0gD7LRseAKfp5wmyoM5Ft5Jm5CgmlcfXvcbzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHV/6ofjoViYUaEEFByVJYp7niYylY6HuLM0mz8lCWPVrnwxwnek0uVy8DRZ7MdDeZHVGYQVS7MPk4WnK8abBqs7ofed4yDWYzt8I1Dw3G097B/99uDOzeefMfy6CVzzqtatjf7a27GlcNjAdaa1EodZ75ZHoWm8amkEzd2cudI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy54Q9N8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy54Q9N8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D7FC19425;
	Tue, 11 Nov 2025 01:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823735;
	bh=yzKQTa0gD7LRseAKfp5wmyoM5Ft5Jm5CgmlcfXvcbzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy54Q9N8/h2NBjzrrjAQkkQHF8bvs0QgUmbdorc5QiNGeZacZLW+7nIqipZyfUvFj
	 tulbRn3Tjh0OZNTT8BEdWXLvNfA7NJ6ESV3GFixp7VIL3NP0xVmVcilmEvEYkL1Ab3
	 lJtzWk7VvlWRTnNvkLfvPADUS0+zZ75mIpmPQKrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 328/849] wifi: rtw89: fix BSSID comparison for non-transmitted BSSID
Date: Tue, 11 Nov 2025 09:38:18 +0900
Message-ID: <20251111004544.349141162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit c4c16c88e78417424b4e3f33177e84baf0bc9a99 ]

For non-transmitted connections, beacons are received from the
transmitted BSSID. Fix this to avoid missing beacon statistics.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250811123950.15697-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 5dd05b296e71c..0f7a467671ca8 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2246,6 +2246,7 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 	struct ieee80211_bss_conf *bss_conf;
 	struct rtw89_vif_link *rtwvif_link;
 	const u8 *bssid = iter_data->bssid;
+	const u8 *target_bssid;
 
 	if (rtwdev->scanning &&
 	    (ieee80211_is_beacon(hdr->frame_control) ||
@@ -2267,7 +2268,10 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 		goto out;
 	}
 
-	if (!ether_addr_equal(bss_conf->bssid, bssid))
+	target_bssid = ieee80211_is_beacon(hdr->frame_control) &&
+		       bss_conf->nontransmitted ?
+		       bss_conf->transmitter_bssid : bss_conf->bssid;
+	if (!ether_addr_equal(target_bssid, bssid))
 		goto out;
 
 	if (is_mld) {
-- 
2.51.0



