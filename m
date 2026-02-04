Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656FC1E520C;
	Wed,  4 Feb 2026 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218990; cv=none; b=TISiAyPFDtDliUEF+7OE5zNerxophjolXiE367SL83SwFpOFKXE9YA0EKVuOf1N+7SLUYxL/O/EBV25uPIpS/QlL+ieNR3YCDhgHPf7enIuJiJqeQFFG3PDbnNIxzal1INOFWygSdPxH7rxJgbiApHZTJbDfliNw7JyQVVo+AJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218990; c=relaxed/simple;
	bh=mDOAlQVeArNbws+JEPXAr/VFQbyn5+Glqv3uuAiVqdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9ezd7oJUTkyxQkppq+4la+TPYnDvgWvBH0Hfsqv/gV/JgQ7x7n00++mPzCJKZYhZoi5DlZmhmhpOFtW9li7LmyZ3365WPDkJEvJ8zok9wEp3gRboWrXRR35vnrFl6K5XSfDxL2n33+ykWj/rrVAeTlbOhRouOAw8dkv2XokpBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xhmu4uqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xhmu4uqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDBDC4CEF7;
	Wed,  4 Feb 2026 15:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218990;
	bh=mDOAlQVeArNbws+JEPXAr/VFQbyn5+Glqv3uuAiVqdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xhmu4uqnwNHQGxGb4F3nWH+P89JQkUwk99y8zU4OGzebrsMGQEyjamGI2xd+ksT03
	 nm0AynPQqt5RbniSR+uBimuZyyQpRp9u8QxY0Rh7a+upt6t+r4b0uUS52NURL3LXTR
	 2cLhYTv4TwInV0xBPn8XaRFGEWeOuMSs4613RgLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/122] wifi: mac80211: parse all TTLM entries
Date: Wed,  4 Feb 2026 15:40:17 +0100
Message-ID: <20260204143853.124338264@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 3fa2886d11d4545dc0dcfd0759ffbd03f88b5410 ]

For the follow up patch, we need to properly parse TTLM entries that do
not have a switch time. Change the logic so that ieee80211_parse_adv_t2l
returns usable values in all non-error cases. Before the values filled
in were technically incorrect but enough for ieee80211_process_adv_ttlm.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260118093904.ccd324e2dd59.I69f0bee0a22e9b11bb95beef313e305dab17c051@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 1eab33aa63c9 ("wifi: mac80211: correctly decode TTLM with default link map")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f3138d1585353..d70163c0b9e32 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7014,10 +7014,6 @@ ieee80211_parse_adv_t2l(struct ieee80211_sub_if_data *sdata,
 	pos = (void *)ttlm->optional;
 	control	= ttlm->control;
 
-	if ((control & IEEE80211_TTLM_CONTROL_DEF_LINK_MAP) ||
-	    !(control & IEEE80211_TTLM_CONTROL_SWITCH_TIME_PRESENT))
-		return 0;
-
 	if ((control & IEEE80211_TTLM_CONTROL_DIRECTION) !=
 	    IEEE80211_TTLM_DIRECTION_BOTH) {
 		sdata_info(sdata, "Invalid advertised T2L map direction\n");
@@ -7027,21 +7023,28 @@ ieee80211_parse_adv_t2l(struct ieee80211_sub_if_data *sdata,
 	link_map_presence = *pos;
 	pos++;
 
-	ttlm_info->switch_time = get_unaligned_le16(pos);
+	if (control & IEEE80211_TTLM_CONTROL_SWITCH_TIME_PRESENT) {
+		ttlm_info->switch_time = get_unaligned_le16(pos);
 
-	/* Since ttlm_info->switch_time == 0 means no switch time, bump it
-	 * by 1.
-	 */
-	if (!ttlm_info->switch_time)
-		ttlm_info->switch_time = 1;
+		/* Since ttlm_info->switch_time == 0 means no switch time, bump
+		 * it by 1.
+		 */
+		if (!ttlm_info->switch_time)
+			ttlm_info->switch_time = 1;
 
-	pos += 2;
+		pos += 2;
+	}
 
 	if (control & IEEE80211_TTLM_CONTROL_EXPECTED_DUR_PRESENT) {
 		ttlm_info->duration = pos[0] | pos[1] << 8 | pos[2] << 16;
 		pos += 3;
 	}
 
+	if (control & IEEE80211_TTLM_CONTROL_DEF_LINK_MAP) {
+		ttlm_info->map = 0xffff;
+		return 0;
+	}
+
 	if (control & IEEE80211_TTLM_CONTROL_LINK_MAP_SIZE)
 		map_size = 1;
 	else
-- 
2.51.0



