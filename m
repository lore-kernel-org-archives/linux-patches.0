Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023702BB17;
	Tue, 11 Nov 2025 00:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822158; cv=none; b=jJCtQxlyb1525Hmbn52ck1ph0X3RkbcFVxB1V73+eZvqouRiIFRug+yyl9e7pJ7uTNNPevPSt+irsBMLQQXNQc8kxlC25lt5uVcnnBzB8krW7OnRb5XmMS7JFcbw2xqlSbsw/FtO88szCaWhyRC7Hcf9JW4wDn6iwrND+lxe03g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822158; c=relaxed/simple;
	bh=cUf+MHKrEOly8t+mhTEH3xKjjDfoQYNV0gONBwzuaNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuaOL3CNmjZ/dpGuebsVEKIR0YW/CKXJXLoXuv4ZFUPOGQEKQWQuA3VSnpY9aNCrc1qBhLXY9V2pVXCb5HhREaFkBByJ9K/NCRvzhJTQSkv8WxgayyHwH1mS5+dGoazjOp8o+nYaSm4tC/dsRIL2jSEuWbqxTZ3CyHujTIKRoas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5wJy6zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5wJy6zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDEAC4CEF5;
	Tue, 11 Nov 2025 00:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822157;
	bh=cUf+MHKrEOly8t+mhTEH3xKjjDfoQYNV0gONBwzuaNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5wJy6zsngdcBdVa38M3A2B6b49+WGUzmRxwB+pIt0wekNtAN6Ck+OETHUOppQMKS
	 iMbJacZYOYn5R5gEgAxYYSEg3TywMwdUXpr9RRBTuRjU6iZlvrctiFAoOA1aPEMhB4
	 EbRqrtbnA0xgS9hTvjyuAPtMmGzaPFs3BIGhCsyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 040/849] wifi: mac80211: fix key tailroom accounting leak
Date: Tue, 11 Nov 2025 09:33:30 +0900
Message-ID: <20251111004537.408524141@linuxfoundation.org>
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
index b14e9cd9713ff..d5da7ccea66e0 100644
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



