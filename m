Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C50613FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOwER6lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AABAC433C7;
	Mon, 23 Oct 2023 11:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059247;
	bh=ESw/XkAAX5wyRKq2cv2DvrqRN7RdDW20Tx/nbAEuU+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOwER6lmlneB7XWGOaJxKihBlLkOKxn844+t4wcbglpjQEKiw2EDS+v7JG2GlQm9d
	 AXMbnXR9FnWQozO8WgA+armtAb4v39PpfPIhoJldFJdSqoBsqm+0mcOV53aRtJdgLe
	 8P/nfcP/JS3ISlMUxbww55znsCeDlqpSd+c01jbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 113/241] wifi: cfg80211: validate AP phy operation before starting it
Date: Mon, 23 Oct 2023 12:54:59 +0200
Message-ID: <20231023104836.643884757@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit 5112fa502708aaaf80acb78273fc8625f221eb11 ]

Many regulatories can have HE/EHT Operation as not permitted. In such
cases, AP should not be allowed to start if it is using a channel
having the no operation flag set. However, currently there is no such
check in place.

Fix this issue by validating such IEs sent during start AP against the
channel flags.

Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://lore.kernel.org/r/20230905064857.1503-1-quic_adisi@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 705d1cf048309..3d286f3a60e60 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5910,6 +5910,21 @@ static void nl80211_send_ap_started(struct wireless_dev *wdev,
 	nlmsg_free(msg);
 }
 
+static int nl80211_validate_ap_phy_operation(struct cfg80211_ap_settings *params)
+{
+	struct ieee80211_channel *channel = params->chandef.chan;
+
+	if ((params->he_cap ||  params->he_oper) &&
+	    (channel->flags & IEEE80211_CHAN_NO_HE))
+		return -EOPNOTSUPP;
+
+	if ((params->eht_cap || params->eht_oper) &&
+	    (channel->flags & IEEE80211_CHAN_NO_EHT))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -6179,6 +6194,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		goto out_unlock;
 
+	err = nl80211_validate_ap_phy_operation(params);
+	if (err)
+		goto out_unlock;
+
 	if (info->attrs[NL80211_ATTR_AP_SETTINGS_FLAGS])
 		params->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_AP_SETTINGS_FLAGS]);
-- 
2.40.1



