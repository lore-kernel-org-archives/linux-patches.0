Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8CF1A3029;
	Tue, 12 Aug 2025 19:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025863; cv=none; b=ZiANuqWI+k4JirJcEmirB5TUkpbdfW9EL7pUrvVVs8Fr2oAMJnV76kMrRMiUT99xHF5ZB4v2SzUBeHAorRbIJalFBuFz2xTk4D/OJ8Yv0lWFFHU/SktdsZWzMegF7sPqZ/Ktxe9yyWwQqqdw8ahlV9dAsPRHILI9stCs5DFYPeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025863; c=relaxed/simple;
	bh=un4sE5Aoim2MJwjam80op8ry7Cd39jBUaRaZeAwFmkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwsUAscMrLcgO0aRt8/USJBln4nUGopYlURTeNYZogU/pUlmYMzj8PYqw3UUKaAv1GsRy/HD3lZQ/stSNcmRcq7Z8elUy7Y7SL1dv7qvAPtC8eN/gm6oHZNlFmeCrJMOVVw8qQvLtMlvBr5aMeNSbuLuJciuCEqVKD1UZEo6YJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tPYQUe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tPYQUe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B80C4CEF0;
	Tue, 12 Aug 2025 19:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025863;
	bh=un4sE5Aoim2MJwjam80op8ry7Cd39jBUaRaZeAwFmkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tPYQUe7qf2v8uOlQ2D3OBWmpX6+MSHXmgeQLuAsf6TJ4uUVmkSSGjXpbfaX3hB7y
	 8TLvxfyPRMv0B8NL/ytQABjki19OxD5TAcybuiOVfetD3fRyRF/io7YuIkjxrCgnq/
	 ikkRbHC3sW3BUbn0HoSDVodmCUiC7Jg/DMfeXAMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 167/480] wifi: ath11k: fix sleeping-in-atomic in ath11k_mac_op_set_bitrate_mask()
Date: Tue, 12 Aug 2025 19:46:15 +0200
Message-ID: <20250812174404.411208041@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 65c12b104cb942d588a1a093acc4537fb3d3b129 ]

ath11k_mac_disable_peer_fixed_rate() is passed as the iterator to
ieee80211_iterate_stations_atomic(). Note in this case the iterator is
required to be atomic, however ath11k_mac_disable_peer_fixed_rate() does
not follow it as it might sleep. Consequently below warning is seen:

BUG: sleeping function called from invalid context at wmi.c:304
Call Trace:
 <TASK>
 dump_stack_lvl
 __might_resched.cold
 ath11k_wmi_cmd_send
 ath11k_wmi_set_peer_param
 ath11k_mac_disable_peer_fixed_rate
 ieee80211_iterate_stations_atomic
 ath11k_mac_op_set_bitrate_mask.cold

Change to ieee80211_iterate_stations_mtx() to fix this issue.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250603-ath11k-use-non-atomic-iterator-v1-1-d75762068d56@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 4763b271309a..9514e95d5020 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8734,9 +8734,9 @@ ath11k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 				    arvif->vdev_id, ret);
 			return ret;
 		}
-		ieee80211_iterate_stations_atomic(ar->hw,
-						  ath11k_mac_disable_peer_fixed_rate,
-						  arvif);
+		ieee80211_iterate_stations_mtx(ar->hw,
+					       ath11k_mac_disable_peer_fixed_rate,
+					       arvif);
 	} else if (ath11k_mac_bitrate_mask_get_single_nss(ar, arvif, band, mask,
 							  &single_nss)) {
 		rate = WMI_FIXED_RATE_NONE;
@@ -8803,9 +8803,9 @@ ath11k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 		}
 
 		mutex_lock(&ar->conf_mutex);
-		ieee80211_iterate_stations_atomic(ar->hw,
-						  ath11k_mac_disable_peer_fixed_rate,
-						  arvif);
+		ieee80211_iterate_stations_mtx(ar->hw,
+					       ath11k_mac_disable_peer_fixed_rate,
+					       arvif);
 
 		arvif->bitrate_mask = *mask;
 		ieee80211_iterate_stations_atomic(ar->hw,
-- 
2.39.5



