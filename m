Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10175130E27;
	Mon, 12 Aug 2024 16:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479293; cv=none; b=EiqrDOwLJcI0ZYYSgT7l3qq0Uzcru55Hc+BkhcPAUyqT4o4r4y7/UTx1W8TKUcmUzb0kiMbU1PNBycY0VnUQw3u6jTWiwy5cK9kFNnOVrQ8Y+Nkuf2QGsMIc0iaj0jj9CsEWT6NreiJ328dp4UQqV0nK0WkkvemBpaby3b6beo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479293; c=relaxed/simple;
	bh=dCf37IKVRwUrFBNSDEl1oAh3kHE0s4dIGL4il/JcWbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A//s4FAZZLAJq8zjbLZ9OQruUlQZPfXcETYZicn9LkJaVWuagGCmLA/BpPkwnGbV79HJB3rdigkUHUrFEkZHBD9gWUss8q13f5JLxi8ALmrZS+n2BXQAEKKtCc9ALB8Tfnu+pt6YnW4/of+/CKTdmy1RqFxtZJqNItl3hH34cs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFRYMmCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFRYMmCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4E3C32782;
	Mon, 12 Aug 2024 16:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479292;
	bh=dCf37IKVRwUrFBNSDEl1oAh3kHE0s4dIGL4il/JcWbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFRYMmCpilS2ERXqq6K/mP2CIgU0+krFKOEE3yx9dt47hXIjL6rRsVPkNMPBMQYMR
	 i6OEqIYVgyIbHuAibIU6eK/pKkgGJxe8r0nEF1nDjJRm/ya5HvEoLfOq6emrviPbmh
	 GOkfmXBgoz3CR17bf+xEgIDYku1OlAkg3FIyyHkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/189] wifi: nl80211: dont give key data to userspace
Date: Mon, 12 Aug 2024 18:01:38 +0200
Message-ID: <20240812160133.765507151@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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
index 053258b4e28d2..be5c42d6ffbea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4473,10 +4473,7 @@ static void get_key_callback(void *c, struct key_params *params)
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
@@ -4488,10 +4485,7 @@ static void get_key_callback(void *c, struct key_params *params)
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



