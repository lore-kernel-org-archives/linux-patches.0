Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A983845D8;
	Thu, 30 Jul 2026 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425434; cv=none; b=aqTBRSo88a8Xa5Q0THhyrsdO4UtgOKvtJtqF3G1XjZ2bSEHGIAce+RZvoFusheGl5r++/oWQrWfiM/juwPw/Z8pgqJvWayovJWQbtMVo8rCjBSIwr5q/UEcdhB+fdFqR2DWMTu404JiB/njDt9Qvl9LBla0yMq0ymL7mihKbvT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425434; c=relaxed/simple;
	bh=wdj+36Uit0DWgUViN4PIPrx44rPS1IPokqcFi9kY9Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvihCygQizANwCxpHlSfeU6e2SoNnK9S/EhHzh8GOacvB1TLrH2t4Us9BxYJAQmPc4xW69MU8sNt90Dyn4Tkx95BNBcQ0w2D5iWDqRUt3Dh+XB1eto+S2wInNfcBEOZstkuppFvQomX8HLs3ASqAa6Gy79v+V4ssG/W8388Pr4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjgYdQ+V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjgYdQ+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08651F00A3D;
	Thu, 30 Jul 2026 15:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425429;
	bh=rovBqw/BMF9rXMjox357KqIlBN0LLRGG+ENg8cSMy6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjgYdQ+VeJWjN+X821pepV7IiiHQ+kEy4l90ulxpBUu7rJEOlzHy/N0LGdBso+tbO
	 C4SjgSCn3vUkqw7+FR2YZZgxvf4C2HIT0Qab9lzyNPSdsv6OrN+/VsvBZvqleeKd9q
	 NBsQTsq7lJIcoVHaOqQ29PrRzz/Hin0XwrYwlT9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/602] wifi: cfg80211: derive S1G beacon TSF from S1G fields
Date: Thu, 30 Jul 2026 16:07:38 +0200
Message-ID: <20260730141437.389110090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 4e5a4641e7b4763656336b7891d01359aaf363cd ]

cfg80211_inform_bss_frame_data() parses S1G beacons with the extension
frame layout, but still reads the TSF from the regular probe response
layout after the S1G branch. For S1G beacons that reads bytes at the
regular management-frame timestamp offset instead of the S1G timestamp.

Use the 32-bit S1G beacon timestamp and the S1G Beacon Compatibility
element's TSF completion field when informing an S1G BSS. Keep the
regular management-frame timestamp read in the non-S1G branch.

Fixes: 9eaffe5078ca ("cfg80211: convert S1G beacon to scan results")
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Tested-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Reviewed-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260611161943.91069-6-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 44973529687486..b249f29454f9e1 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3262,14 +3262,15 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 		bssid = ext->u.s1g_beacon.sa;
 		capability = le16_to_cpu(compat->compat_info);
 		beacon_interval = le16_to_cpu(compat->beacon_int);
+		tsf = le32_to_cpu(ext->u.s1g_beacon.timestamp);
+		tsf |= (u64)le32_to_cpu(compat->tsf_completion) << 32;
 	} else {
 		bssid = mgmt->bssid;
 		beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 		capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
+		tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	}
 
-	tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
-
 	if (ieee80211_is_probe_resp(mgmt->frame_control))
 		ftype = CFG80211_BSS_FTYPE_PRESP;
 	else if (ext)
-- 
2.53.0



