Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD582F0C74;
	Fri,  7 Aug 2026 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115961; cv=none; b=cV7CASYbTzNjxDLlGv5SIYtnzihvHK14uZ+WXcwR6EzG8SjHOyXgKOD5bsU6OY8zd0pfcnrZELeLDPv5H89bVyIDYB4WenZtq06+ixfgWU5CacOaxz9G17tgbwsoSGlPygEzA/REAPo+OyGiVGO+9oRlnqrXp115NoTG7oQCIoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115961; c=relaxed/simple;
	bh=UanAnWc2iC6tlBjdyDDPpsBgKu1ZPa6GqEWS99etbtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4wqD9GoS0NGk9leLq44W2mvOhMso6Uc151CXPXFKT1Nnmy83zNZI9j/OAlfce+jgTXfyszaa8Y+Wbd142GSUuxw4aScLgaTLlxOKk3aV8HhhH4gy0bM0oPgg7nrXG1Assetvl3JYPsHz3hwCB5rS3Ed1hYnuub7hnwchlizHDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mezVNPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mezVNPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BE41F000E9;
	Fri,  7 Aug 2026 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115960;
	bh=Xe0qfVnplMgmWzIZo5vVwoVuBXam2qBSI/HaIPCVOB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mezVNPl+Vm8ZLgmNu12VPnQwwVZttymrdBnvXWoAPKXqs6/7dZrkVcCQwlf1Ndc5
	 YTlWFW48MfMB4wxA8yWDW+VjYUxG4qhctP1id8ZxMQwv/NiAiuXd+iZfGGpS/B6RSm
	 ZPBxzsNmUgrseeB3s5MDQwfSNzJvjG2Hk6KBxd+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/261] wifi: mac80211: validate individual TWT params before driver setup
Date: Fri,  7 Aug 2026 16:36:58 +0200
Message-ID: <20260807143416.699308935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 0502d5077e419427d80f4d46ba95d0067f5fb916 ]

ieee80211_process_rx_twt_action() only partially validates a received
S1G TWT setup frame before queueing it.

An individual agreement can therefore reach ieee80211_s1g_rx_twt_setup()
with twt->length too short for the full struct ieee80211_twt_params.

The individual path passes twt to drv_add_twt_setup(). Both the tracepoint
and the driver callback consume the complete parameters block, not merely
req_type. Do not pass a short individual agreement to the driver.
Broadcast agreements remain unchanged because they are rejected locally
after accessing only req_type.

Fixes: f5a4c24e689f ("mac80211: introduce individual TWT support in AP mode")
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260723010928.76551-1-enderaoelyther@gmail.com
[edit commit message to not overclaim lack of validation nor
 understate driver impact]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/s1g.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index c1f964e9991cd..9914390ff31ff 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -100,6 +100,10 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_twt_setup *twt = (void *)mgmt->u.action.u.s1g.variable;
 	struct ieee80211_twt_params *twt_agrt = (void *)twt->params;
 
+	if (!(twt->control & IEEE80211_TWT_CONTROL_NEG_TYPE_BROADCAST) &&
+	    twt->length < sizeof(twt->control) + sizeof(*twt_agrt))
+		return;
+
 	twt_agrt->req_type &= cpu_to_le16(~IEEE80211_TWT_REQTYPE_REQUEST);
 
 	/* broadcast TWT not supported yet */
-- 
2.53.0



