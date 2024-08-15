Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C521A7068;
	Thu, 15 Aug 2024 14:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731750; cv=none; b=n9gnc4aZZP0TNfftF4u4JDHyNnx+tACt+9kua24dG5czjU2q64ngqMWu9MBx3430k3x+ZT0fYG/Q4KfIKrynPwDBw1EplBMzwrRmFMoO14bB+O1RVTEFuz/5dTatuqA/klbeY8qx1mx1HQ1kjgMF5FVmQ1vWt5DZMeA2XdtL9qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731750; c=relaxed/simple;
	bh=Cra+QBo703scIMkRQsp7zftBWVbtSDEvn+Vf6IzyjZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNNrUAAF6D6eeoA2v5LmHMopXI08wLrvanoSQ2cGzK06tV2YiHtMuw+8QimwZUMiMSoepAFv/v0HhYBNP/85ix4fP2IYp98e9xGn8CWyaL4S5Iq9E+3R1Zfgo818PXOOpVJ1yDmyAKcDzMdYiXF6IuJCeVarzmSrpa0G3TdgDzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=144/u83V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="144/u83V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179F5C32786;
	Thu, 15 Aug 2024 14:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731750;
	bh=Cra+QBo703scIMkRQsp7zftBWVbtSDEvn+Vf6IzyjZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=144/u83VBOOEXJwThaaqP7oDL3hojc646EpbmpKK0zX3fgSqyn1Sf/+AH+GHMrGCN
	 c+7kDksNkfOhyW0dFvaKD+t7yofRCT9MScbdII+TSkVSd08lgU9gJ2pw5conINfP7V
	 /pOJYxCVf9GtE7tWT+EtabGLm5jXL+A4+hZLSihY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/259] wifi: nl80211: dont give key data to userspace
Date: Thu, 15 Aug 2024 15:25:32 +0200
Message-ID: <20240815131910.459824997@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0d15dd68565cb..e85e8f7b48f92 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3723,10 +3723,7 @@ static void get_key_callback(void *c, struct key_params *params)
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
@@ -3738,10 +3735,7 @@ static void get_key_callback(void *c, struct key_params *params)
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



