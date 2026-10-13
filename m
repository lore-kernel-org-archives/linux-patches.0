Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788FA4EFFB5;
	Tue, 13 Oct 2026 12:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895250; cv=none; b=bMxWes0rQSTw3EusteQS22OjZH2SQYITTY1pADRI+e0SQ1zGx1uwO9XrV09PPDzntNkMlthY2E+5bq+/aTlRt8tsLLZLX9NW5FLlucOA3TE7511PzM2ndPZhatciTJENk0vnzv65sj+uMEDC4cyyo2ZZEKVo4CYyE/ycF1UVBN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895250; c=relaxed/simple;
	bh=SBf9icO7BN2STNfmgnnFSpP58l2byvSZ+ZfRLlXUmGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzRlMErSVUBEQzm6h5ve4VTy5X8B+kNLO+LPDeXSVc0LJq2O+YeAoNPR9BPFgS1vBftHQY532dPT+NwKwnHN9RLTW7HkGq4XcIuCg0W0GgiwoxPizwYRKGR9q2hAdBVYPWoGwuMZcmFn4RRlBWt/I5QU+9RBDBJ8FUjiVY2FMA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djrZYpbF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djrZYpbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11FE1F000FF;
	Tue, 13 Oct 2026 12:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895249;
	bh=2O1uxS26Q4c2hva2J3ma/F1bGtw0qAGpkJbmt94miSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djrZYpbFYzhWCHc4mfjwqY20qgf4IBMPPQ5lR52vNi4b66Tzu8hjNE+iiii3nbFXU
	 jphHa/AMuOwcIyBT3adVqxvyGSmXtj5hx9+r0YhuPfy9BrzkjTButzY5Deg2FWucy3
	 l70adh0rukSSraGNSNaYDQj1VMqOimVkr4Zfbvpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ruide Cao <caoruide123@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 210/497] wifi: mac80211: reject invalid 320 MHz CSA bandwidth
Date: Tue, 13 Oct 2026 13:36:17 +0200
Message-ID: <20261013112912.877066864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Ruide Cao <caoruide123@gmail.com>

commit 56e236759f0a8dc910c2ae7cd3c161f298ee5794 upstream.

The HT/VHT channel definition validator can receive a 320 MHz
bandwidth indication from a received CSA frame on a non-6 GHz link.
It warns for this unsupported width but continues with an uninitialized
vht_operation.chan_width, which is then read by
ieee80211_chandef_vht_oper(). With panic_on_warn enabled, this lets a
received frame panic the kernel.

Reject the channel definition before entering the VHT operation
conversion. This preserves the existing CSA fallback while avoiding
both the warning and the uninitialized read.

Fixes: 21c3f8f95554 ("wifi: mac80211: refactor STA CSA parsing flows")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/bd68e360e06135c750397cb6be003a01a834a179.1787222001.git.vega.cover-letter@nebusec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/spectmgmt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -111,8 +111,8 @@ validate_chandef_by_ht_vht_oper(struct i
 
 	switch (chan_width) {
 	case NL80211_CHAN_WIDTH_320:
-		WARN_ON(1);
-		break;
+		chandef->chan = NULL;
+		return;
 	case NL80211_CHAN_WIDTH_160:
 		vht_oper.chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
 		vht_oper.center_freq_seg1_idx = vht_oper.center_freq_seg0_idx;


