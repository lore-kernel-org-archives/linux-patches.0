Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48ED30C143;
	Thu, 30 Jul 2026 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423578; cv=none; b=gKl9nMHP9mVAyiJXlrjzf6kvcboeA0/3I4WUovYZ0WfFpyd0ojWpApbWuCvbB1Ey2H9wQhkywFRl/h7J+tKCJaPf092dUREnGoBaa3Htqb3SUSPrgB7W3dmIypnK0927Mvtjy0JYn1M3sTguH2urM62Sv6IHBRxRwWKTNEzXiOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423578; c=relaxed/simple;
	bh=G4TpZ0hHH/mYAwGLO7I9oEemkv+1oCC3Quq6sLI+48k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twB20E25AmWfXum0E8fv9JmbIP4I8JREUmCA88bm+2ralnW+n+CfYZbup0dhf2HdjyyrGqdSY29n8oG+f5zAjSXKWArazi99tpZgcz/xwuKVCM30zQiU2mWtug0ByOK+pSWoyzn182HzV4jhOr4lx0VVgbw05zSwBnZQH5xKri8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yjz1LuOc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yjz1LuOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CD01F000E9;
	Thu, 30 Jul 2026 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423577;
	bh=xj/u/9A9D7+b5J5Wl7jl8ZxG16kacMR2Zs5KXU57XSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yjz1LuOcZEnLlYmA9Fp0kEcjRBd6fD1gUNa4aSrCUEhaokf9g6o5Ql+bAdJ6tttyy
	 ediLC8WrkG44hSesbRCcMGoe0UIexKheEB7VJWc6T2FWotuH8TD/pSZQskWe7XrbTX
	 erhVj5VRMbY6N7DYJTRac1TAPrqUW1+5lPOlerus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/675] wifi: cfg80211: derive S1G beacon TSF from S1G fields
Date: Thu, 30 Jul 2026 16:06:46 +0200
Message-ID: <20260730141446.744120807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 27d5f99dbb2289..af1e2ce1628dae 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3326,14 +3326,15 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
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



