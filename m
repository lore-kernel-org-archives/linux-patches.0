Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B80E262BE;
	Mon, 27 May 2024 19:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838123; cv=none; b=OuK7lGZjPeoxx+mK/ANU2ikExTSLO3N7tiV5UkZgzcBHoSQy7kPE3NPW9It2Z/ULgAwXxUEabj+4aE4LAfE5BGyYe/POCiTcv+eH/2tzteW9sOH4mltVFlshiX/e4drFxIc3x20FMWu6D5IfHADTtwRvb7e6+7K4sTE3dJb+wE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838123; c=relaxed/simple;
	bh=XdFg7IJWqZ+QJHGs66Nnwgd7hizAchVKiJngVy9oJCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKD6EIC1KvHfH3sZDXFAfE4RajHsifu1OGm0zuEUP9L+Cj3o3ZRRkWF2vzEzG0fSGu9yRy5wQ8kpWBvf37FEZrZ7tTBKVPp1xgI5oupdCgaHnnW1EbK2pDhPd8MwSIC4rkHujbfz2n9qDog37+UfbOQFq4VQWQUyA5PT6T26E3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5lTKDLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5lTKDLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25856C2BBFC;
	Mon, 27 May 2024 19:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838123;
	bh=XdFg7IJWqZ+QJHGs66Nnwgd7hizAchVKiJngVy9oJCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5lTKDLPMAiQCt/4yjljmo/T82eM/LJvt3LRTuDcLO3o0E4mIdXs4PInII5XwUkmC
	 rRqQfviuvH09dI0lnMsANFOmtjBjBhX4hkPp6yRasUVrv5hD+ei31plRyVZASK1Ifg
	 iC/VwKbDH1wCAqWc/Ofh8aN9iiH/LZhDtycFdtkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 276/493] wifi: nl80211: Avoid address calculations via out of bounds array indexing
Date: Mon, 27 May 2024 20:54:38 +0200
Message-ID: <20240527185639.325985243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index daac83aa8988e..4e7b517c78bfd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9148,6 +9148,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels, i;
 	size_t ie_len, size;
+	size_t ssids_offset, ie_offset;
 
 	wiphy = &rdev->wiphy;
 
@@ -9193,21 +9194,20 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
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



