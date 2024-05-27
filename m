Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DFB17E90E;
	Mon, 27 May 2024 19:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836835; cv=none; b=nSWoFu9ATXW68kYk7XHYzmapyMcdfLAPvA6iXTWP+WNd0zHfbm56017qCOYIADWRQyo2cXiLMJw/Fhgx/Ku1xmVefifJBHenEwr/Ny2hdKj+/K64YtT/8t+jniAFoA1KyTX5tGIQpowu+B9Qony6zGn5FUcezHUWPOzK9vwzcUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836835; c=relaxed/simple;
	bh=FrVSxpt0lB85UXrmP49Px0ibt5X+mAisowTsqdUIb04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3+GGBwnyvipeXyPf5nv3I3CaI7lSHZn6xGzzFKCpUOILWw2HySTyAF3pSTNWGW5Kg9j8RxdXUmU6mOaO8AQiJCxwS1inueYDb3d53r//2q5dLKGIGgMssrBAEw6PMYO14WrDl9N59BQVI0OszcPvBeShHfnIjmDyxZ9zTJW1PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/qr4Szx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/qr4Szx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB77C32781;
	Mon, 27 May 2024 19:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836834;
	bh=FrVSxpt0lB85UXrmP49Px0ibt5X+mAisowTsqdUIb04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/qr4Szxp78u3D7604NehDnf6eislldCEBdM0eLSy16B1ZQV+Jv9U/zbYV3/V2ASs
	 t9Hg3NDbhLZ3kfV0jrMdD2+eeDUh/fGUsTmtx2FbPiW2Wy0cmRgGT5YOH6IFzx0NEy
	 YIxYBK3GCGHrgKgMZEWb+UgUD4ezoCklZpcg/7u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 206/427] wifi: nl80211: Avoid address calculations via out of bounds array indexing
Date: Mon, 27 May 2024 20:54:13 +0200
Message-ID: <20240527185621.542630420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 838c7b8f1f278404d9d684c34a8cb26dc41aaaa1 ]

Before request->channels[] can be used, request->n_channels must be set.
Additionally, address calculations for memory after the "channels" array
need to be calculated from the allocation base ("request") rather than
via the first "out of bounds" index of "channels", otherwise run-time
bounds checking will throw a warning.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Fixes: e3eac9f32ec0 ("wifi: cfg80211: Annotate struct cfg80211_scan_request with __counted_by")
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://msgid.link/20240424220057.work.819-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 30ff9a4708134..65c416e8d25eb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9162,6 +9162,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels, i;
 	size_t ie_len, size;
+	size_t ssids_offset, ie_offset;
 
 	wiphy = &rdev->wiphy;
 
@@ -9207,21 +9208,20 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	size = struct_size(request, channels, n_channels);
+	ssids_offset = size;
 	size = size_add(size, array_size(sizeof(*request->ssids), n_ssids));
+	ie_offset = size;
 	size = size_add(size, ie_len);
 	request = kzalloc(size, GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
+	request->n_channels = n_channels;
 
 	if (n_ssids)
-		request->ssids = (void *)&request->channels[n_channels];
+		request->ssids = (void *)request + ssids_offset;
 	request->n_ssids = n_ssids;
-	if (ie_len) {
-		if (n_ssids)
-			request->ie = (void *)(request->ssids + n_ssids);
-		else
-			request->ie = (void *)(request->channels + n_channels);
-	}
+	if (ie_len)
+		request->ie = (void *)request + ie_offset;
 
 	i = 0;
 	if (scan_freqs) {
-- 
2.43.0



