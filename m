Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001C0357CEC;
	Sat, 12 Sep 2026 10:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208394; cv=none; b=QjarxrDhXkHEWuxRzLjLoom1wvfG7X8QFn4TvLZB8dwmRrkwXsQdi8lgzZ03yP4L8hf50eVBEuzxgS1EdnaFS7QQWBg8Nf2TufvpL4QgN9ORS1EH5cM+3WgkktWo2oPIonsfCSTIrzygltV+4iiXTA7yKJayGj+CYWNuAjTJo2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208394; c=relaxed/simple;
	bh=hhtn3biyHmP2F1w9oe/UfabYTW8F/keVDswM8ku6dBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fg1pidk96Fxd2OS6c/CSUvqvKnVPn6n8AlaGp+756rMv4Y/kboUh1+dSzNdZCiovhL9iWT2oWHIdBRT4aaKLNKAs0eTJuTZ37S8OCRuuSUJuMR9ACNIAL3uifX7ySj64AQNNhXQ6xTYOUu48eRvkvIpH9iexcS6QNWOxP9eOtcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EK+7EpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EK+7EpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDF81F000FF;
	Sat, 12 Sep 2026 10:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208392;
	bh=Ddxl5GZKd+VZcuP1D3qdTmBXTpYyiN0CfWJ7Bla1+Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EK+7EpJWqljOgYSkV5K+eQcplLLbW/zNjnI7MU4C1LfwuItqIKBI5k8GF/pBrztq
	 iB3o00PMXSp/jrtJ8dneSCyKoyj+mBWgchqE4uzkxKOqEn04mYBMEdTjsUplzYkROq
	 urCu+hE6kxKGKW8LJzEXLEg0hZ2hJfw7c/6l5g+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0609/1518] wifi: mac80211: fix per-STA profile length in cross-link CSA parsing
Date: Sat, 12 Sep 2026 08:46:18 +0200
Message-ID: <20260912065637.204345932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 4a0bd262df757b25fc4e2a53c947317c119ced4e ]

ieee80211_mgd_check_cross_link_csa() starts parsing elements after the
fixed per-STA profile header and the STA Info field, but subtracts only
the STA Info length from the profile length. As a result,
ieee802_11_parse_elems() is given sizeof(*prof) == 3 bytes beyond the
current profile's element area, and data following the profile may be
interpreted as belonging to it.

Subtract the fixed profile header as well. The preceding
ieee80211_mle_basic_sta_prof_size_ok() check guarantees that the
corrected calculation cannot underflow, and
ieee80211_rx_uhr_link_reconfig_req() uses the same calculation.

The call site currently states that cross-link CSA parsing has no effect
because the broader parsing is still incorrect. This patch does not
address that broader problem; it only makes the per-STA profile parser
stop at the end of that profile. No production allocation over-read or
user-visible failure has been demonstrated.

Fixes: 7ef8f6821d16 ("wifi: mac80211: mlme: handle cross-link CSA")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260728111326.63087-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9ec4125c06d19..8d782c8782f98 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7303,7 +7303,7 @@ ieee80211_mgd_check_cross_link_csa(struct ieee80211_sub_if_data *sdata,
 		prof = (void *)sta_profiles[link_id];
 		prof_elems = ieee802_11_parse_elems(prof->variable +
 						    (prof->sta_info_len - 1),
-						    len -
+						    len - sizeof(*prof) -
 						    (prof->sta_info_len - 1),
 						    false, NULL);
 
-- 
2.53.0



