Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ECE4ABBC1;
	Thu, 17 Sep 2026 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660937; cv=none; b=YEl3Y9isAgdYo9OC0UqIHKlGdncPpeC25K5zTF+0nDln7fg5KszIco2u+sxQXiMkVP+LBJjw6TIURq+vKEP+k7PwAhFnBtIjy8fWI+4nQpU2URoAMV3GaIRokHOc9SRU64H3RF8ay6Wf3085m/1A3t+tZTxkvh1hGtBKtQGGs2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660937; c=relaxed/simple;
	bh=Ia+ShxCFUvXt/vfw29E54OEJ750hEOtbOHk5EzfMLHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI3drlgv/I+OOxREub47dtQUiavJsopGovDr3wB6QHBrz+nnknEQv6C5vuZShMjge2GudYKrW6XtF99fZEY0g7tLZXAmN7kcTqqjGymGdC78mUmObGxMbX9X4nva0XFQq+enGmwEi3Lvh0APc8f+VI3OMUmzx5dSoIuGnbDGfDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShYb2ilR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShYb2ilR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EDC1F000FF;
	Thu, 17 Sep 2026 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660935;
	bh=UMBWfrSW51/KCYVcK3qiuJkx3wvogGCSqV/nATVhWjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShYb2ilRVmLFZH+b1W/BKNOtF9AYUIrhnEzOMWncbP1umfv7j5TBSyOtsbscCuIK8
	 HRD9m25nUB7GbJFiyqofB7oy4yvyU+uxtoreaAuH93MOJulYp8lsp+OHQwOBzXAXOi
	 vNiESMZ/Fbe3910+JqQJd14GPaO2oj2QrHJpmemE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0027/1250] wifi: cfg80211: reject duplicate wiphy cipher suite entries
Date: Thu, 17 Sep 2026 15:57:02 +0100
Message-ID: <20260917151552.662060567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

[ Upstream commit 7187d145d9042b037e4f10538f70cf95e380219f ]

Duplicate entries in wiphy->cipher_suites do not describe any
additional capability, but cfg80211 currently accepts them and leaves
individual consumers to deal with them.

One such consumer is the WEXT compatibility code, which appends a WEP
key length for each WEP cipher entry it sees. Repeated WEP entries can
therefore overflow the fixed iw_range::encoding_size array returned by
SIOCGIWRANGE.

Reject duplicate cipher suite entries in wiphy_register() instead.
This keeps the cipher suite invariant in one place and makes malformed
wiphy descriptions fail early with -EINVAL, rather than relying on a
single cfg80211 user to handle duplicates correctly.

Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260413123000.1480661-1-n05ec@lzu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6a9ba151b09fe..b565f777e5561 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -781,6 +781,24 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 	return ret;
 }
 
+static bool wiphy_cipher_suites_valid(const struct wiphy *wiphy)
+{
+	int i, j;
+
+	if (wiphy->n_cipher_suites && !wiphy->cipher_suites)
+		return false;
+
+	for (i = 0; i < wiphy->n_cipher_suites; i++) {
+		for (j = 0; j < i; j++) {
+			if (wiphy->cipher_suites[i] ==
+			    wiphy->cipher_suites[j])
+				return false;
+		}
+	}
+
+	return true;
+}
+
 int wiphy_register(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
@@ -913,6 +931,9 @@ int wiphy_register(struct wiphy *wiphy)
 	if (res)
 		return res;
 
+	if (!wiphy_cipher_suites_valid(wiphy))
+		return -EINVAL;
+
 	/* sanity check supported bands/channels */
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		const struct ieee80211_sband_iftype_data *iftd;
-- 
2.53.0



