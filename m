Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0C21AC893;
	Thu, 15 Aug 2024 14:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732737; cv=none; b=oouVhzP5DLc0SKb/saEjV8EQHFbgI2DQXZUBPYUQdhojLO1fu+GKVt624l7LITkj+FpCxz+zqPlJzGekAhSz3lzerk+OEu7DjWfEPBpk4zQnfvxWMKLNFDVAkwUIubofP2HXOWLB2LOniRiWNxl47J0oQ3nrWLpbRstcm4y+5fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732737; c=relaxed/simple;
	bh=DrIo/oSUV9g1c8D7MpOPL8zXuNIiSvlxQP1OGj/iTdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdAhR5/xeHkgNzhCDCjcLKkCLm0CPhP3c881hcHylpvuytupPLYPrCjKx1DRlw+KwWs4/lzv2PNTfpnxa0AtjQHNZeWzyeVsrnufH/mZmVxV91Bv2QnOiwr8rPEyucVTrhxsLuhaU/G2+8EQs+1OLb7D2q44nD/NoR0Q2MReCBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uarbaSTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uarbaSTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD124C32786;
	Thu, 15 Aug 2024 14:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732736;
	bh=DrIo/oSUV9g1c8D7MpOPL8zXuNIiSvlxQP1OGj/iTdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uarbaSTpFQHIhr8Ib2mcL6Vck2NHB6suxiUInswBAdnE1jtENPBvhwRzhvoGdjl2Q
	 uoBZf5Xqj795nazNpSA1Y5oLEd+ueneyHDqV0OsbC4t5O/yGXeftTBSSXWr9h4xgWq
	 WJF/ftGZCgqnF38EZH3gpVYWkGvlJYdSi4PxLkN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/352] wifi: nl80211: dont give key data to userspace
Date: Thu, 15 Aug 2024 15:25:36 +0200
Message-ID: <20240815131929.886108226@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 846e40dc00bb6..f9ad7de710cb4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3968,10 +3968,7 @@ static void get_key_callback(void *c, struct key_params *params)
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
@@ -3983,10 +3980,7 @@ static void get_key_callback(void *c, struct key_params *params)
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



