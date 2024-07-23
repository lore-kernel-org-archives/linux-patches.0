Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B410C13D896;
	Tue, 23 Jul 2024 18:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760101; cv=none; b=b3bQwj6kqlfniAYmeBX3DYRIn7E3TsJ4Ie5uROy3f/mLxn99Fv2jaXPQOnsZXibP46poAlWGmuWSsqX9SC65iRUREGrsB+yiDZcflHt1OlyGH23YM0hvYGGwKLNLF1Dqusjgf1gLm0UUgeSxfPOfSY6P0THptZr76LM3Rzj2KpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760101; c=relaxed/simple;
	bh=Pm3Rt/piY2pWyNbie01Dzusgm2DjtxOVKbZ7wcpENIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI6+BdMxhsSPeiShHQoCUOkWiMpMDE7vIShgHC+X5lhiPb3Zo066hSzE4oaRv1HSS3YrJHflFJlHKWasd77MYqgzpazKiI6HX9PYXPTrZkkZGyypfVMcR2q+8o7w9NiH0UbRKiB2zzmKw97gtVwg3wtP49QrLo9KRAUKQjrlTXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/CE+OSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/CE+OSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EC9C4AF0A;
	Tue, 23 Jul 2024 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760101;
	bh=Pm3Rt/piY2pWyNbie01Dzusgm2DjtxOVKbZ7wcpENIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/CE+OSgtjMXt8h9AxGJcGC4PdYWn8hBeetGB5oLk73zLiwqw8lrcSO8Pyp7p1rYQ
	 Qu27VXjhcHF8hQuJsgo1C1Yq1w24GzanoEYhnYyIUONxrzv+rrZgoXyXtRx5q0qR6l
	 tzZsgP9b4sl005CyRfCcOplXfFcMsy8D7ymaBzcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Kenton Groombridge <concord@gentoo.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.9 072/163] wifi: mac80211: Avoid address calculations via out of bounds array indexing
Date: Tue, 23 Jul 2024 20:23:21 +0200
Message-ID: <20240723180146.251270085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

From: Kenton Groombridge <concord@gentoo.org>

[ Upstream commit 2663d0462eb32ae7c9b035300ab6b1523886c718 ]

req->n_channels must be set before req->channels[] can be used.

This patch fixes one of the issues encountered in [1].

[   83.964255] UBSAN: array-index-out-of-bounds in net/mac80211/scan.c:364:4
[   83.964258] index 0 is out of range for type 'struct ieee80211_channel *[]'
[...]
[   83.964264] Call Trace:
[   83.964267]  <TASK>
[   83.964269]  dump_stack_lvl+0x3f/0xc0
[   83.964274]  __ubsan_handle_out_of_bounds+0xec/0x110
[   83.964278]  ieee80211_prep_hw_scan+0x2db/0x4b0
[   83.964281]  __ieee80211_start_scan+0x601/0x990
[   83.964291]  nl80211_trigger_scan+0x874/0x980
[   83.964295]  genl_family_rcv_msg_doit+0xe8/0x160
[   83.964298]  genl_rcv_msg+0x240/0x270
[...]

[1] https://bugzilla.kernel.org/show_bug.cgi?id=218810

Co-authored-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Kenton Groombridge <concord@gentoo.org>
Link: https://msgid.link/20240605152218.236061-1-concord@gentoo.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8ecc4b710b0e6..b5f2df61c7f67 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -358,7 +358,8 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_sub_if_data *sdata)
 	struct cfg80211_scan_request *req;
 	struct cfg80211_chan_def chandef;
 	u8 bands_used = 0;
-	int i, ielen, n_chans;
+	int i, ielen;
+	u32 *n_chans;
 	u32 flags = 0;
 
 	req = rcu_dereference_protected(local->scan_req,
@@ -368,34 +369,34 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_sub_if_data *sdata)
 		return false;
 
 	if (ieee80211_hw_check(&local->hw, SINGLE_SCAN_ON_ALL_BANDS)) {
+		local->hw_scan_req->req.n_channels = req->n_channels;
+
 		for (i = 0; i < req->n_channels; i++) {
 			local->hw_scan_req->req.channels[i] = req->channels[i];
 			bands_used |= BIT(req->channels[i]->band);
 		}
-
-		n_chans = req->n_channels;
 	} else {
 		do {
 			if (local->hw_scan_band == NUM_NL80211_BANDS)
 				return false;
 
-			n_chans = 0;
+			n_chans = &local->hw_scan_req->req.n_channels;
+			*n_chans = 0;
 
 			for (i = 0; i < req->n_channels; i++) {
 				if (req->channels[i]->band !=
 				    local->hw_scan_band)
 					continue;
-				local->hw_scan_req->req.channels[n_chans] =
+				local->hw_scan_req->req.channels[(*n_chans)++] =
 							req->channels[i];
-				n_chans++;
+
 				bands_used |= BIT(req->channels[i]->band);
 			}
 
 			local->hw_scan_band++;
-		} while (!n_chans);
+		} while (!*n_chans);
 	}
 
-	local->hw_scan_req->req.n_channels = n_chans;
 	ieee80211_prepare_scan_chandef(&chandef);
 
 	if (req->flags & NL80211_SCAN_FLAG_MIN_PREQ_CONTENT)
-- 
2.43.0



