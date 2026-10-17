Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F173909BC;
	Sat, 17 Oct 2026 18:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260709; cv=none; b=k8oAScVnsFDi5xi+g+K/Ad6VOm6YDjbk+4Knuqf2b4/yXMgXi7zOdEIqkTfsYue6dw7D++J2uXshlbYdZRzYL+D3HzPIDrJVoxUL7foSOpvq2acyONaBcrjbUqBS3AHZLlBfRTyhf0q4XOklBcdQ9Y3TIX6P/z7sGMLzeJMRmTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260709; c=relaxed/simple;
	bh=oZDJl2XpWTrO9JldEKcj7ctnTvAFHpk2TXfOwirbkmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/IQFiuUnG4bL8q2gKvj0JmJwHsMbqQwN/3w2oJowzYNCzZbRE6zy1Ez73g0bQNKqQhi5G17hbTxiGjDN7rSPqrmHkSV93ZdP/aVsxCh8EIG7LJzzs6XS3ooj39yGsUmvw1ulLE8zKvH+f6RR2UT2rBQIOvM1/3893F/TPlG3mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlWl9KQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlWl9KQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF27D1F000C4;
	Sat, 17 Oct 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260707;
	bh=XkLFXViFXneG+UpvpdUCZJVrb7uRKip72Ih2OMziwbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlWl9KQZtvuVUT0OViwQkFwILb/J9nw3yRssNFIhRGQKuVNASOj71+f64m/Z6xbiu
	 ETLL1V8UkVXQAnJSZibq0Xhvxikcf3KAGsIfqozaiqcBzmQrbxcF78D0RaZVXRAjUc
	 eKLwJygHeVKXCMNIekS2rGLFUukteWjxZyMuIxQE=
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
Subject: [PATCH 6.6 1583/1674] wifi: cfg80211: reject duplicate wiphy cipher suite entries
Date: Sat, 17 Oct 2026 18:04:15 +0200
Message-ID: <20261017160511.720980063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 164277e81234b..da355e5975ca1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -697,6 +697,24 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 	return 0;
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
@@ -828,6 +846,9 @@ int wiphy_register(struct wiphy *wiphy)
 	if (res)
 		return res;
 
+	if (!wiphy_cipher_suites_valid(wiphy))
+		return -EINVAL;
+
 	/* sanity check supported bands/channels */
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		u16 types = 0;
-- 
2.53.0



