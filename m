Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112397DA7D;
	Thu, 15 Aug 2024 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730333; cv=none; b=A13UM20eMUXZmTwxnkYEJpvxFq49F+Yf5bS+ALid+UZ0hrN8MznZEbDGhgW88w+wsCLDr47lzsMzXAJV1TEQVXaVvOY2saQVrHAJ94RTQ8wRW8DjnAqYHQKDJn0IcOQw4mOEmaNqVOiw3hT+Z1+EkPd6KRoY2NA5punHCCfLj8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730333; c=relaxed/simple;
	bh=1RV8mZPY/7ITaLx1U0hu77RPfwexntD0v+MHvaSRCuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7RomkraB3kKflHvIP2Oriy6I8tq9XVJk5uIL/6Dzh09L91GZpbY7EILrTnleE9kA2v67j1YsrMVlMmm6iE8lthRrnuxSxBTXKf6dBt1SHBTJacLuEfo4H3s4O3OGC8CI8J41/+t7kR4A2XIJaSFydNFqRacJWqqWxPSUshxK44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUPENUiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUPENUiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D62DC32786;
	Thu, 15 Aug 2024 13:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730332;
	bh=1RV8mZPY/7ITaLx1U0hu77RPfwexntD0v+MHvaSRCuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUPENUiwnLbU7w/jj23Z2awc2+JxjIJDaV8NClcrlGcmM2+Hb3ZT7+rIxF99KIsnn
	 JAct+XK6l4mfh5AigIuJ7g4T915f5ZIk2zZyBHieF0CbfaZo1hXdtrL661eUXK540o
	 sSFhqBh2S0PDAjNdTJvEkPOjqrNor/uuLWUE+mww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 376/484] wifi: nl80211: dont give key data to userspace
Date: Thu, 15 Aug 2024 15:23:54 +0200
Message-ID: <20240815131955.968607379@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d758ec5655892..9ff4c8f1a1829 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4137,10 +4137,7 @@ static void get_key_callback(void *c, struct key_params *params)
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
@@ -4152,10 +4149,7 @@ static void get_key_callback(void *c, struct key_params *params)
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



