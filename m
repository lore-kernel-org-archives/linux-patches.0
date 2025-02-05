Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC0C487BF;
	Wed,  5 Feb 2025 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765858; cv=none; b=g0fonZUuVJU2GqIUeGJGZ7HJQ9htYweNjye1T/glFAkuNt+td1DBvnu5get5W51Gy1ostjWmqKgqUIKarXKkpun3uhH0mO7vKlH2YAMxtjMgTgkjrGA3Ac5efuenscnSqIGl7EAvTgMARudK4iFhHomZUIRfx2Vz6/QmxY6RqlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765858; c=relaxed/simple;
	bh=zBCWHrAqzjmogURmjEJA1M1x046Ux9k24EJm2ipqroc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAwZw9jtXnuXXMwBDL/7F9O4hJGSFFds/wAflEvaLs8Yro9DNHifC0SiqXnT63rxjeOnO0XMqh7GAFZJuw+aHfSxPliqI/4M7E91klY+T0FDvoIkAndT5ygIG4RN0kIgJH9TBKGDNWZ8CudcOrHUUhadEN7K0wTzrQ+KOW8FXbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGItvwXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGItvwXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A8FC4CED1;
	Wed,  5 Feb 2025 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765857;
	bh=zBCWHrAqzjmogURmjEJA1M1x046Ux9k24EJm2ipqroc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGItvwXDq+0J/XSsXq/45iTfnoQnGCHUGYmHm4Ze1fVfCzR3In0nKcYwyctV1rm28
	 LGmtyth5XW/AK3u475V8qjUCO7yMru1DsOYE5El89XvlayBWtyPLfaQVS9a8KWsCgi
	 cHO0hwtF7Aq3Ond/Kl0vps6gs6mhlZPf1SCeleR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 220/623] wifi: cfg80211: adjust allocation of colocated AP data
Date: Wed,  5 Feb 2025 14:39:22 +0100
Message-ID: <20250205134504.642312714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 1a0d24775cdee2b8dc14bfa4f4418c930ab1ac57 ]

In 'cfg80211_scan_6ghz()', an instances of 'struct cfg80211_colocated_ap'
are allocated as if they would have 'ssid' as trailing VLA member. Since
this is not so, extra IEEE80211_MAX_SSID_LEN bytes are not needed.
Briefly tested with KUnit.

Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20250113155417.552587-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ccdbeb6046399..abca3d7ff56c9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -857,9 +857,7 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
 			if (ret)
 				continue;
 
-			entry = kzalloc(sizeof(*entry) + IEEE80211_MAX_SSID_LEN,
-					GFP_ATOMIC);
-
+			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 			if (!entry)
 				continue;
 
-- 
2.39.5



