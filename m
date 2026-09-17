Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F264F4023;
	Thu, 17 Sep 2026 17:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667212; cv=none; b=UlPbrO/JYwsMeWgbA1xcIX/43zIEmJ63z5xnIRulbbeCp8fWOxSb6IqVgSHZdPZBM/q2JBO0ld3cVo8tMPFzht7Rh+rj9ixWSpkzgCZ4JDTcjKst4YkNjPGtl9TAQoVeUxYtp0/99Cb5hfZ1ZsiMEKyeltBLD63KiwmSLyrL2Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667212; c=relaxed/simple;
	bh=03Z8NH5vmY/Y8kjAgsr7fI6Ik8acO27zw1s1vCuJfEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHT88GsM0yV1wqvhK/3l/vh0BawcEMZz+/Cl+M4PudDb70FrVzz7jokoE0N9QxLAvvhz7oafXrLOxxANRG+jSorozGtPssaVm9kZNELZq7vi+PQyouPElOhkZPbwoZ9LWu9y0rfQeNlyxHpkf2oXkbRu+WnihBqnXguSm1RFhoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTBz/+dl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTBz/+dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1495E1F00893;
	Thu, 17 Sep 2026 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667210;
	bh=a1SA8kijuWDXOdEVtWNF+FbOlnxE2Dp6iINDnQGHPnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTBz/+dlszD2A4tvayGcvX7PKJuBMQQZsY+gpefNMjhhq5FbZhpYvyW2RmFby62m9
	 94WRgm4pqGLdYcfjER57GwmNoYQVaseRoD5SduIuxajpeGR6nlPSMH1VmRPks7Lqhs
	 9lFOM6JrltjdI/mrJqhJd3POYqG4WKrnYme8dpvo=
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
Subject: [PATCH 6.12 0018/1102] wifi: cfg80211: reject duplicate wiphy cipher suite entries
Date: Thu, 17 Sep 2026 15:59:21 +0100
Message-ID: <20260917151539.885491040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5bc3e12e7b2de..8f7f84c5f440b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -729,6 +729,24 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
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
@@ -860,6 +878,9 @@ int wiphy_register(struct wiphy *wiphy)
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



