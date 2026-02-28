Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AE9313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301105; cv=none; b=jVYFye3UxtuCUpCeW9BeXFLahPvRRZgZAG8uaZ4rJEpn/iYBVwBg2nUe5HfIEwJjE2bZavjIghb/Ou2vYFvG6iSOQ6hWX+EYqQogqkNkgap5VDJ3IC0bhweH+4SOKzATqhhRZ73cV/VBUvLUKT1dke0d14hhWSoRIWxPT1tIerI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301105; c=relaxed/simple;
	bh=AUe5vBVA5jG55GygOCkHge8Cj6p/z5JMUvLJNrIcjJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k81yWKbGI26iobnDfCzryF13ooI5x9+dTrtUt+/Znq8rMtyzPJwHWxsGOuQF+JG+HK50OIeTxhudwmxIYZMki837ZuhExPnY6cVQPvUYYrUsoyXBcqzbhEqQ7JHV6vtIYJ/Rr6ZA0hMT6kECSK/F9E0Gufx9Mge403THMQA06H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PM9SY1Iq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PM9SY1Iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFCAC19423;
	Sat, 28 Feb 2026 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301105;
	bh=AUe5vBVA5jG55GygOCkHge8Cj6p/z5JMUvLJNrIcjJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM9SY1IqNY8NTl7vnqSFg2cOOjA6mg+NSj0WbYFvavBzRD3WkE4OAxFefnOEFkZqn
	 ZynAuGsMH3Pks6gBaEb6UutfkNNJxb/tlDpr1mK2DZDxILB16KQymeRmvl75tuEQyS
	 1Ru3whlCs8zUdEwc+PdgEqq8KOioacoQL9ltjP5XFjL2em/lvB70oV/8U9qwnv/h8z
	 qcP5UzHnXxiR88rwP76CPvubwB7+s0k56nkh0o+dhJVnavaK9FJSbwV0PLR5IJrSEf
	 pBWy0lGAQ5wPk3DtmZWlwSczhxzluTQRU8Z1Mpog46ZVJ5zfbUEnGyVs61NkbDveWB
	 +dYRrvT/XiIcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 259/752] wifi: iwlwifi: mld: fix chandef start calculation
Date: Sat, 28 Feb 2026 12:39:30 -0500
Message-ID: <20260228174750.1542406-259-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit d2fcdf36554316cc51f7928b777944738d06e332 ]

A link pair in which both links are in 5 GHz can be used for EMLSR only
if they are separated enough.

To check this condition we calculate the start and the end of the
chandefs of both links in the pair and do some checks.

But the calculation of the start/end of the chandef is currently done
by subtracting/adding half the bandwidth from/to the control channel's
center frequency, when it should really be subtracted/added from/to the
center frequency of the entire chandef.

Fix the wrong calculation.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260111193638.2138fdb99bd5.I4d2e5957b22482a57b1d6ca444e90fcf73bf2cab@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
index 241a6271d13d6..bf70e71aa5143 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
@@ -851,9 +851,9 @@ iwl_mld_emlsr_pair_state(struct ieee80211_vif *vif,
 		if (c_low->chan->center_freq > c_high->chan->center_freq)
 			swap(c_low, c_high);
 
-		c_low_upper_edge = c_low->chan->center_freq +
+		c_low_upper_edge = c_low->center_freq1 +
 				   cfg80211_chandef_get_width(c_low) / 2;
-		c_high_lower_edge = c_high->chan->center_freq -
+		c_high_lower_edge = c_high->center_freq1 -
 				    cfg80211_chandef_get_width(c_high) / 2;
 
 		if (a->chandef->chan->band == NL80211_BAND_5GHZ &&
-- 
2.51.0

