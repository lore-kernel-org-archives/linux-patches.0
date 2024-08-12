Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EEF186E38;
	Mon, 12 Aug 2024 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478868; cv=none; b=ur0WU5U1X1q0Y73iF6tIIHl1A8+lxO4fyp2lEXclFMCbQK2+ozA6BgBSun80nYpm6h/RYtKPcI5D1ixT3gf3v6slg4202sRFI2jFgUs8t2aA5AVZthH8mlPMc5WqKrUBUhtBzy2bZzGFmN0YTUhg+TVBG+4Gx+uoZr4g9UBa9fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478868; c=relaxed/simple;
	bh=W/EN7Ay7Q8RU1H3emWcpBEYOaGLZYdgVpQOo6Dm6yB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AM1eu1fd5BiQV/M2SMN6R4UgeBkvcqDaVgjaR9Mp7ERPgM3gPybm2m9SQrynom0ndk60FtMspmP6ZIA3Ozs06jZP2HvG5OkqeeHvTsHHDBN9e8AuY3ulw8ygulHoHoAjjbG8FxHY6JqrPGp6S84W7VoIUHG5XHiseOwr1JtqkTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6i0dJFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6i0dJFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36664C32782;
	Mon, 12 Aug 2024 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478868;
	bh=W/EN7Ay7Q8RU1H3emWcpBEYOaGLZYdgVpQOo6Dm6yB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6i0dJFwvrN7Ldja1QgWnHyPIdnYcoN6P9ifLmSSULCc3ju6hPF3vVJkLlhIL38kq
	 6N/ZnaGSTcuafnDbCFaY70ahcHTLGptKK8IosEiCxEd9cc3l/9NJ9fCd00x8fzV9oy
	 nDH9CyfL8+zJuHsLxibZ22uh66BzfO3mszJyk+gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/150] wifi: nl80211: dont give key data to userspace
Date: Mon, 12 Aug 2024 18:01:51 +0200
Message-ID: <20240812160126.328418424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a7e5793035792cc46a1a4b0a783655ffa897dfe9 ]

When a key is requested by userspace, there's really no need
to include the key data, the sequence counter is really what
userspace needs in this case. The fact that it's included is
just a historic quirk.

Remove the key data.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240627104411.b6a4f097e4ea.I7e6cc976cb9e8a80ef25a3351330f313373b4578@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 603fcd921bd22..214eee6105c7f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4421,10 +4421,7 @@ static void get_key_callback(void *c, struct key_params *params)
 	struct nlattr *key;
 	struct get_key_cookie *cookie = c;
 
-	if ((params->key &&
-	     nla_put(cookie->msg, NL80211_ATTR_KEY_DATA,
-		     params->key_len, params->key)) ||
-	    (params->seq &&
+	if ((params->seq &&
 	     nla_put(cookie->msg, NL80211_ATTR_KEY_SEQ,
 		     params->seq_len, params->seq)) ||
 	    (params->cipher &&
@@ -4436,10 +4433,7 @@ static void get_key_callback(void *c, struct key_params *params)
 	if (!key)
 		goto nla_put_failure;
 
-	if ((params->key &&
-	     nla_put(cookie->msg, NL80211_KEY_DATA,
-		     params->key_len, params->key)) ||
-	    (params->seq &&
+	if ((params->seq &&
 	     nla_put(cookie->msg, NL80211_KEY_SEQ,
 		     params->seq_len, params->seq)) ||
 	    (params->cipher &&
-- 
2.43.0



