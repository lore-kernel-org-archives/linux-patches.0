Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E86134AC;
	Mon, 12 Aug 2024 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480031; cv=none; b=CE6zl7a2cWtdVXW6rSsier+btQkUdQbeI4cgwjUV6ce6CltbAYg72wCQ4TcaSKiEJaySc8zQWn4NWAn3vWOwXjq4y55iu3CJsrwB3hIzUnh7j5js1CI55/XL5p7hVZVygOdGZ4TEs2L4YL+ssRpaFQ1yXf1NO7aNuBywCY8ytxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480031; c=relaxed/simple;
	bh=W8F7T/4JKJatPdiXEBt9CSGXhrpmCswJXBMb+RPhZh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2UQxgjYGAvR07E7v/skeYm/dBpCDQZDVAU4gVOoIZjQ42f+crQ/Isj82WF8+7IF+GnqLJkjFPH2ld4olKDsudNinEb72r0myyVq5wdVcTwG8hv22q7VA6C294fUs0eQ+WK9hyHzH9juDQYYJbCC1wnOQnPZ6YaYT6pUY2IZYMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4Sa3syz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4Sa3syz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570CDC32782;
	Mon, 12 Aug 2024 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480031;
	bh=W8F7T/4JKJatPdiXEBt9CSGXhrpmCswJXBMb+RPhZh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4Sa3syzLPDiSuAkv3oMc7BxtEO9GnuNx0hrFkYj9AFplw5w5y/GXjM25X8iPYJFP
	 OZ2a3oIM0gBUWIZCO8f2xxajufTkrGygMftOw9nEYgc55aefPkVVc9TeHqGN8b5POg
	 9fGmhWzdBmaMAf/slfT2vR//T4h2PSh3xm/EHQ2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 075/263] wifi: nl80211: dont give key data to userspace
Date: Mon, 12 Aug 2024 18:01:16 +0200
Message-ID: <20240812160149.414710229@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 07538be6805ef..c2829d673bc76 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4485,10 +4485,7 @@ static void get_key_callback(void *c, struct key_params *params)
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
@@ -4500,10 +4497,7 @@ static void get_key_callback(void *c, struct key_params *params)
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



