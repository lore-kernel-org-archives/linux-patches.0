Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3E2EC0B0;
	Mon, 17 Aug 2026 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975411; cv=none; b=SH+9FjtMpVkT7SlyknaFSFCvzV9GeuAxy+QA8c1qVayED68MUBdo6z5KoKn1gjLtD8Rf0BmKp8+0lRDloR77/EWp+Qr9tp1qQufGCG1Rq8CWEe8X/7lNgWv9tgVa9YM3hnclqaE2VkyQpHxCXpsYVyVpICZhS+vOTE5TxyiEy0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975411; c=relaxed/simple;
	bh=jTiFNABc3C0u0RDtspr6I73LJ0tFgExVTNQs7AHmPFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D75qz69n8cWdk8xWPL+8tPbBxif+TxOs8a2lRUkd/W36+DWZbuz9QqBEFOFGmoCOfXKHiB+jXjyadOeaAGqhvOtwVIo+9+a/neUiNzd0Ct6yqzOnkcIoIGHApTkyYnqtxiVTlLYnDZk4I4xernNaz9EzDItWmiyY/kXmf/UPEJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oD/Nq+Rb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oD/Nq+Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0601F00A3A;
	Mon, 17 Aug 2026 14:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975410;
	bh=MHuLznvupON0q7MvnszgocJE5Po+glhDrsNw3CJvh0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oD/Nq+Rby6LsvaDJdqpwJldxkUGEkqWBhYpvQUfJ+R5ZS+5Ma9oC+FkofKoatOhDg
	 fYkZTmoVPjizowXqBtd2yj3fV/FkEAkT50Gdzrmt82LrzBfb+GKzU+1FG/xrNT4hWM
	 HrDQLQRFgZS6w7eQAkjo7gxzb2FTg1AD2nJ1FGv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramon Fontes <ramonreisfontes@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/389] mac80211_hwsim: add 6GHz channels
Date: Mon, 17 Aug 2026 15:27:38 +0200
Message-ID: <20260817132539.634700804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramon Fontes <ramonreisfontes@gmail.com>

[ Upstream commit 28881922abd786a1e62a4ca77394a84373dd5279 ]

Advertise 6GHz channels to mac80211.

Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
Link: https://lore.kernel.org/r/20201227031155.81161-1-ramonreisfontes@gmail.com
[reword commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 10a2b430f8f0 ("wifi: mac80211_hwsim: clamp virtio RX length before skb_put")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 74 ++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 865bbe0293436c..d8b997859de063 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -311,6 +311,12 @@ static struct net_device *hwsim_mon; /* global monitor netdev */
 	.hw_value = (_freq), \
 }
 
+#define CHAN6G(_freq) { \
+	.band = NL80211_BAND_6GHZ, \
+	.center_freq = (_freq), \
+	.hw_value = (_freq), \
+}
+
 static const struct ieee80211_channel hwsim_channels_2ghz[] = {
 	CHAN2G(2412), /* Channel 1 */
 	CHAN2G(2417), /* Channel 2 */
@@ -377,6 +383,68 @@ static const struct ieee80211_channel hwsim_channels_5ghz[] = {
 	CHAN5G(5925), /* Channel 185 */
 };
 
+static const struct ieee80211_channel hwsim_channels_6ghz[] = {
+	CHAN6G(5955), /* Channel 1 */
+	CHAN6G(5975), /* Channel 5 */
+	CHAN6G(5995), /* Channel 9 */
+	CHAN6G(6015), /* Channel 13 */
+	CHAN6G(6035), /* Channel 17 */
+	CHAN6G(6055), /* Channel 21 */
+	CHAN6G(6075), /* Channel 25 */
+	CHAN6G(6095), /* Channel 29 */
+	CHAN6G(6115), /* Channel 33 */
+	CHAN6G(6135), /* Channel 37 */
+	CHAN6G(6155), /* Channel 41 */
+	CHAN6G(6175), /* Channel 45 */
+	CHAN6G(6195), /* Channel 49 */
+	CHAN6G(6215), /* Channel 53 */
+	CHAN6G(6235), /* Channel 57 */
+	CHAN6G(6255), /* Channel 61 */
+	CHAN6G(6275), /* Channel 65 */
+	CHAN6G(6295), /* Channel 69 */
+	CHAN6G(6315), /* Channel 73 */
+	CHAN6G(6335), /* Channel 77 */
+	CHAN6G(6355), /* Channel 81 */
+	CHAN6G(6375), /* Channel 85 */
+	CHAN6G(6395), /* Channel 89 */
+	CHAN6G(6415), /* Channel 93 */
+	CHAN6G(6435), /* Channel 97 */
+	CHAN6G(6455), /* Channel 181 */
+	CHAN6G(6475), /* Channel 105 */
+	CHAN6G(6495), /* Channel 109 */
+	CHAN6G(6515), /* Channel 113 */
+	CHAN6G(6535), /* Channel 117 */
+	CHAN6G(6555), /* Channel 121 */
+	CHAN6G(6575), /* Channel 125 */
+	CHAN6G(6595), /* Channel 129 */
+	CHAN6G(6615), /* Channel 133 */
+	CHAN6G(6635), /* Channel 137 */
+	CHAN6G(6655), /* Channel 141 */
+	CHAN6G(6675), /* Channel 145 */
+	CHAN6G(6695), /* Channel 149 */
+	CHAN6G(6715), /* Channel 153 */
+	CHAN6G(6735), /* Channel 157 */
+	CHAN6G(6755), /* Channel 161 */
+	CHAN6G(6775), /* Channel 165 */
+	CHAN6G(6795), /* Channel 169 */
+	CHAN6G(6815), /* Channel 173 */
+	CHAN6G(6835), /* Channel 177 */
+	CHAN6G(6855), /* Channel 181 */
+	CHAN6G(6875), /* Channel 185 */
+	CHAN6G(6895), /* Channel 189 */
+	CHAN6G(6915), /* Channel 193 */
+	CHAN6G(6935), /* Channel 197 */
+	CHAN6G(6955), /* Channel 201 */
+	CHAN6G(6975), /* Channel 205 */
+	CHAN6G(6995), /* Channel 209 */
+	CHAN6G(7015), /* Channel 213 */
+	CHAN6G(7035), /* Channel 217 */
+	CHAN6G(7055), /* Channel 221 */
+	CHAN6G(7075), /* Channel 225 */
+	CHAN6G(7095), /* Channel 229 */
+	CHAN6G(7115), /* Channel 233 */
+};
+
 #define NUM_S1G_CHANS_US 51
 static struct ieee80211_channel hwsim_channels_s1g[NUM_S1G_CHANS_US];
 
@@ -548,6 +616,7 @@ struct mac80211_hwsim_data {
 	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
 	struct ieee80211_channel channels_2ghz[ARRAY_SIZE(hwsim_channels_2ghz)];
 	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
+	struct ieee80211_channel channels_6ghz[ARRAY_SIZE(hwsim_channels_6ghz)];
 	struct ieee80211_channel channels_s1g[ARRAY_SIZE(hwsim_channels_s1g)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
 	struct ieee80211_iface_combination if_combination;
@@ -579,7 +648,8 @@ struct mac80211_hwsim_data {
 		struct ieee80211_channel *channel;
 		unsigned long next_start, start, end;
 	} survey_data[ARRAY_SIZE(hwsim_channels_2ghz) +
-		      ARRAY_SIZE(hwsim_channels_5ghz)];
+		      ARRAY_SIZE(hwsim_channels_5ghz) +
+		      ARRAY_SIZE(hwsim_channels_6ghz)];
 
 	struct ieee80211_channel *channel;
 	u64 beacon_int	/* beacon interval in us */;
@@ -3187,6 +3257,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		sizeof(hwsim_channels_2ghz));
 	memcpy(data->channels_5ghz, hwsim_channels_5ghz,
 		sizeof(hwsim_channels_5ghz));
+	memcpy(data->channels_6ghz, hwsim_channels_6ghz,
+		sizeof(hwsim_channels_6ghz));
 	memcpy(data->channels_s1g, hwsim_channels_s1g,
 	       sizeof(hwsim_channels_s1g));
 	memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
-- 
2.53.0



