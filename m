Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB5147C7B;
	Wed, 19 Jun 2024 13:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802703; cv=none; b=iVNpesXE0GDo36xpbuRl5/NCjxv73W9kc1WEcd97r6NzGR8JIxkv9Sh6468flc2K18gheMGr3PAL9X0BI1IZK8UylqJWiZy17nLJ9qFVpfXgUWssMh6+ltmcVMJ0WBE62+64ARRzBQE6BSAPba0utrJHoG/ejqTJEpnJGhbinZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802703; c=relaxed/simple;
	bh=D0sILxWCFRjBig6K6bKh5JXJqo37PtD2JYbrASP0rvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCLrCU5Qb/ss4tJGPW97krq3iizzfgQJSqgChhCsyDZ136hiRYTjaWJOXPS4/ELsIcqU+TzpVNrFf9gadpZ77eToKUWooYO8LX1gkoUz9IMYbZAgFjBO3Q0sluDMRtTXwYK6QcRrkFdosg4IiRBttTETzsuUDF8Mfhv5du9Wu+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmU7E/q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmU7E/q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C734C2BBFC;
	Wed, 19 Jun 2024 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802703;
	bh=D0sILxWCFRjBig6K6bKh5JXJqo37PtD2JYbrASP0rvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmU7E/q/0LM22y8DDznSgKlMlV8kvx+1h6OADTeXtMG9rrY+6L+LjAxRT2xdi0Klr
	 SCs9ocngG7WXsQt6XNk7FByrraK5cI4jBlNhR99hx1Rwv+7K1xi9c9StPgwLPeCzfR
	 h5b1xBqbdKtwC9Vv66h4iaulIPOi6Mq+AtfH+I2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lingbo Kong <quic_lingbok@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 019/281] wifi: mac80211: correctly parse Spatial Reuse Parameter Set element
Date: Wed, 19 Jun 2024 14:52:58 +0200
Message-ID: <20240619125610.588028218@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lingbo Kong <quic_lingbok@quicinc.com>

[ Upstream commit a26d8dc5227f449a54518a8b40733a54c6600a8b ]

Currently, the way of parsing Spatial Reuse Parameter Set element is
incorrect and some members of struct ieee80211_he_obss_pd are not assigned.

To address this issue, it must be parsed in the order of the elements of
Spatial Reuse Parameter Set defined in the IEEE Std 802.11ax specification.

The diagram of the Spatial Reuse Parameter Set element (IEEE Std 802.11ax
-2021-9.4.2.252).

-------------------------------------------------------------------------
|       |      |         |       |Non-SRG|  SRG  | SRG   | SRG  | SRG   |
|Element|Length| Element |  SR   |OBSS PD|OBSS PD|OBSS PD| BSS  |Partial|
|   ID  |      |   ID    |Control|  Max  |  Min  | Max   |Color | BSSID |
|       |      |Extension|       | Offset| Offset|Offset |Bitmap|Bitmap |
-------------------------------------------------------------------------

Fixes: 1ced169cc1c2 ("mac80211: allow setting spatial reuse parameters from bss_conf")
Signed-off-by: Lingbo Kong <quic_lingbok@quicinc.com>
Link: https://msgid.link/20240516021854.5682-3-quic_lingbok@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/he.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/he.c b/net/mac80211/he.c
index 9f5ffdc9db284..ecbb042dd0433 100644
--- a/net/mac80211/he.c
+++ b/net/mac80211/he.c
@@ -230,15 +230,21 @@ ieee80211_he_spr_ie_to_bss_conf(struct ieee80211_vif *vif,
 
 	if (!he_spr_ie_elem)
 		return;
+
+	he_obss_pd->sr_ctrl = he_spr_ie_elem->he_sr_control;
 	data = he_spr_ie_elem->optional;
 
 	if (he_spr_ie_elem->he_sr_control &
 	    IEEE80211_HE_SPR_NON_SRG_OFFSET_PRESENT)
-		data++;
+		he_obss_pd->non_srg_max_offset = *data++;
+
 	if (he_spr_ie_elem->he_sr_control &
 	    IEEE80211_HE_SPR_SRG_INFORMATION_PRESENT) {
-		he_obss_pd->max_offset = *data++;
 		he_obss_pd->min_offset = *data++;
+		he_obss_pd->max_offset = *data++;
+		memcpy(he_obss_pd->bss_color_bitmap, data, 8);
+		data += 8;
+		memcpy(he_obss_pd->partial_bssid_bitmap, data, 8);
 		he_obss_pd->enable = true;
 	}
 }
-- 
2.43.0



