Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C00751CF65;
	Wed, 30 Sep 2026 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794007; cv=none; b=H1+rAFyxnNehOERvid6tJJ1Lz/9TZx8q+8as+PrGuNOZiE8asi8QVPSFAZK290Y1bq2sjCUVQxMSX8RD/n33A6aqMMAsxjZ5m0vEmYy/jk1c6CXlLBrOmD+2r+rSOFSkEabE23kpKOdNjrrrPPSRb8qGxxKhbFCMbxgl2vwVa9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794007; c=relaxed/simple;
	bh=xlLgEGLPlUmMCpEKDmZrTjOxpprEM4dhxZzEF8HDLIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBa5k4aTg/M1+UfCwK6V0Yv1KWmUA8lKEEFepuqXztno/BmeGIEfS70pYCCPdKczFhXzJm8j0qU8A2ly6ysalZ97B0Ra+0n+uVlLfC2vvX0bohjP9J5js/nqkucKGjtcqfN15afiRRJJOwPT4SE5Pyuy1U0Q9wX6uhbTyCXE/yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIpLw5I9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIpLw5I9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40C51F000FF;
	Wed, 30 Sep 2026 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794006;
	bh=IEIChRiy+rZoiKEIlo4+Vot90FDWOj57HCSg/XeR5k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIpLw5I9Cclw/gYVUWLP8amVUCfSt7lafGdfoPji5OlZAOsD4YpBOFwt23dYRYa/u
	 elHsyr86+tzShwPv59fN9CnuMijCMWapuqNu3TrGKQLKyY0r3Y6BjQFOi8RmldrjqJ
	 7Rfs2KRPj0hbMVBdv1YAoDSGljef8ZTbsORLlx20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0014/1193] wifi: nl80211: reject beacons with bad HE operation
Date: Wed, 30 Sep 2026 17:11:38 +0200
Message-ID: <20260930152434.618717282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8b9a100e1a76c52988b31099b349fd95a58c8768 ]

The HE operation element not only needs to be longer than
the fixed part, but also have an appropriate size for the
variable part inside of it. Check this.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415144514.6217f5974fb5.Iff7ff6bcb159584e756d0f825c65860cdd53c6ea@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 545f7ecaad76f..79c3c065ab0c2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5825,8 +5825,12 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 	if (cap && cap->datalen >= sizeof(*params->he_cap) + 1)
 		params->he_cap = (void *)(cap->data + 1);
 	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_OPERATION, ies, ies_len);
-	if (cap && cap->datalen >= sizeof(*params->he_oper) + 1)
+	if (cap && cap->datalen >= sizeof(*params->he_oper) + 1) {
 		params->he_oper = (void *)(cap->data + 1);
+		/* takes extension ID into account */
+		if (cap->datalen < ieee80211_he_oper_size((void *)params->he_oper))
+			return -EINVAL;
+	}
 	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_CAPABILITY, ies, ies_len);
 	if (cap) {
 		if (!cap->datalen)
-- 
2.53.0



