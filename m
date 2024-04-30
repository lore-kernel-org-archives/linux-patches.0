Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D680612D767;
	Tue, 30 Apr 2024 11:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475259; cv=none; b=WSVBEpHA+ot/+GSbJQhedQnr8dIiKf4GSIrW5K2qVKdOXOZQNRmlZ0Z44xbPIvZi/IV5r+ZCXobNXwHmwbtraVVDRbXtg/mNeAA+iqyaWuzKA1CsJcRY79LyvymbM3m2zTNDUghBcr9mpyJbkVDyuCIpN/MW0+y/3URiC4dC6F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475259; c=relaxed/simple;
	bh=2VQtkqPgdbLe/5qT8SbM9evbz9SC2+9K0bD53wNUq/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1TYGhOJOJy5XtEK8vjGv9YwpK2Ec5o15DDkddXklmAOMv4c3QhzSi9H2caXSW5DqljWFl6l9Afp8GjwG6VpgHo6QQ0azhUd3sjsKWNpigedpZVJoqfKZ3HJCN+CXfoUYQGZuSohlGO7JPG77MCS84r0inla3N8jVspasA6HRlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtdgB4iB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtdgB4iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D17C2BBFC;
	Tue, 30 Apr 2024 11:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475259;
	bh=2VQtkqPgdbLe/5qT8SbM9evbz9SC2+9K0bD53wNUq/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtdgB4iBuf4PRIvKM8kvSEuUGLJbKLNkg7RIrlH80iwhYrQAMgJDa+lc7RAsMasBp
	 Snv++CN1MGmFYuT3V7Zmh0NEiQtNzkmbLoojXaDnYVfnyUBtuTgWSsB0CEFTd3cSXR
	 VSoaCAfAlBjKN5yWnCqem34uvrAFa1B9LJMPQWwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/186] wifi: mac80211: fix unaligned le16 access
Date: Tue, 30 Apr 2024 12:38:15 +0200
Message-ID: <20240430103059.282973448@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c53d8a59351e4347452e263e2e5d7446ec93da83 ]

The AP removal timer field need not be aligned, so the
code shouldn't access it directly, but use unaligned
loads. Use get_unaligned_le16(), which even is shorter
than the current code since it doesn't need a cast.

Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240418105220.356788ba0045.I2b3cdb3644e205d5bb10322c345c0499171cf5d2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e3e769b2f2ef1..6e574e2adc22e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5859,7 +5859,7 @@ static void ieee80211_ml_reconfiguration(struct ieee80211_sub_if_data *sdata,
 		 */
 		if (control &
 		    IEEE80211_MLE_STA_RECONF_CONTROL_AP_REM_TIMER_PRESENT)
-			link_removal_timeout[link_id] = le16_to_cpu(*(__le16 *)pos);
+			link_removal_timeout[link_id] = get_unaligned_le16(pos);
 	}
 
 	removed_links &= sdata->vif.valid_links;
-- 
2.43.0



