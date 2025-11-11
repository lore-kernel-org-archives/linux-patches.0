Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB88246333;
	Tue, 11 Nov 2025 00:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822330; cv=none; b=Ps9SQHVAFawII5atlFZyPA2BRmX83mlxKYYAm4PAt7xtWVYaWcgXGE8NSWj0CZXqOb3XRQQnakUVD84xrvR5U6QwmUB/bCQLIkTWTyK3HBU7ux23GImt7ZzRq4AngHu9ncsxkv+0tc7W3ARKNULn5/CfE5YiD1yA1iEpM0nUKLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822330; c=relaxed/simple;
	bh=nlaUf78gJ4IIKy/scYtFEMXqd9ty01SoPDjIsSV7Z+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zc9dliviwsMg/5Tq4V4/cLkz9dm69qqOlW/+3oHamf1xF+H6rvHirDC34ocFHGBFJ4/eek5SCHx/ZlyD6TXo3nTQZhBr2osdEokmwwN5LpJZIUIWPmNHGMpHBTEjD3RagCuVkUHSrBjczBtvS3zpizlEyw+qLAOqD+TY+gb2agQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ofi3gnxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ofi3gnxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E379C2BC86;
	Tue, 11 Nov 2025 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822329;
	bh=nlaUf78gJ4IIKy/scYtFEMXqd9ty01SoPDjIsSV7Z+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ofi3gnxqwgM5Qr15avKG7Cen3QUWU0+NGyLvl3YN++WvkpRrYKCLIk0HBgp6ym2+Y
	 5aOoyePSHnAcNwgavE2afCevrCR9JypZOuwgHuuPErKWICGQ1rraASOZ5JRIKJt2AN
	 NXPyjSfFi6Oy11mLtFFmuztBFxY5OYGOD+aWU2Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/565] wifi: mac80211: fix key tailroom accounting leak
Date: Tue, 11 Nov 2025 09:38:04 +0900
Message-ID: <20251111004527.512340069@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ed6a47346ec69e7f1659e0a1a3558293f60d5dd7 ]

For keys added by ieee80211_gtk_rekey_add(), we assume that
they're already present in the hardware and set the flag
KEY_FLAG_UPLOADED_TO_HARDWARE. However, setting this flag
needs to be paired with decrementing the tailroom needed,
which was missed.

Fixes: f52a0b408ed1 ("wifi: mac80211: mark keys as uploaded when added by the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251019115358.c88eafb4083e.I69e9d4d78a756a133668c55b5570cf15a4b0e6a4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/key.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 7809fac6bae5d..b679ef23d28fd 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -508,11 +508,16 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				ret = ieee80211_key_enable_hw_accel(new);
 		}
 	} else {
-		if (!new->local->wowlan)
+		if (!new->local->wowlan) {
 			ret = ieee80211_key_enable_hw_accel(new);
-		else if (link_id < 0 || !sdata->vif.active_links ||
-			 BIT(link_id) & sdata->vif.active_links)
+		} else if (link_id < 0 || !sdata->vif.active_links ||
+			 BIT(link_id) & sdata->vif.active_links) {
 			new->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+			if (!(new->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+						 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+						 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+				decrease_tailroom_need_count(sdata, 1);
+		}
 	}
 
 	if (ret)
-- 
2.51.0



