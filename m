Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9DF19EEAB;
	Thu,  6 Jun 2024 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683117; cv=none; b=dJIE8Vcr8sz5B8HHSqZyyV9Pethp8fxEZTq/N3YSbs3LmnHyAwLi4UkndtV6WDqYVmpH7EdlZyRESAuG1eYr+7/4Q54CzJoGSQnqXL+NgvmXen81Ht7QP6R9/vbXMNUhkGj/+gMRf08v4ZefLrfrs3UOvftuWzNlVyzovM+KGi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683117; c=relaxed/simple;
	bh=dQR0M6UQucM3Y29CnKnyk/j9XpmAKhulvvpKCyriXM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiBva8Mrbt+MpKHFOGs7NDdZKY2NkIRmzUeGJyVmEOyiS810gbLYoIg+wSD44698brXIhmqrVU21HQo94LrDGlL7OViZ6BYcsYLqtzmcfyvEtDlTuXtHDhGGRkMKtFkTjMRzx8jX08KN8XqHAzpiSrlh/Onysdqva0YZl83XhR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGZaOZE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGZaOZE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AF5C32781;
	Thu,  6 Jun 2024 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683117;
	bh=dQR0M6UQucM3Y29CnKnyk/j9XpmAKhulvvpKCyriXM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGZaOZE04T2ugy5OthroJp5Rsr/huIdFOoDGfJxq5q6pbE2wICNYAC1i7SDBky/Tj
	 YdkU54OtP3QXCqqTYlE6gCTFPFcGC+Rcw2OqLmu9g1dymOUQfMdn6+2liSKbx7+YCS
	 p9KzPCjykCyIYnDZSD3Oy+yZncBD/Mpc3bGAj3Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Kinder <richard.kinder@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/744] wifi: mac80211: ensure beacon is non-S1G prior to extracting the beacon timestamp field
Date: Thu,  6 Jun 2024 15:55:07 +0200
Message-ID: <20240606131733.579484969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Kinder <richard.kinder@gmail.com>

[ Upstream commit d12b9779cc9ba29d65fbfc728eb8a037871dd331 ]

Logic inside ieee80211_rx_mgmt_beacon accesses the
mgmt->u.beacon.timestamp field without first checking whether the beacon
received is non-S1G format.

Fix the problem by checking the beacon is non-S1G format to avoid access
of the mgmt->u.beacon.timestamp field.

Signed-off-by: Richard Kinder <richard.kinder@gmail.com>
Link: https://msgid.link/20240328005725.85355-1-richard.kinder@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cf01f1f298a3b..42e2c84ed2484 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5979,7 +5979,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 			link->u.mgd.dtim_period = elems->dtim_period;
 		link->u.mgd.have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
-		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
+		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY) &&
+		    !ieee80211_is_s1g_beacon(hdr->frame_control)) {
 			link->conf->sync_tsf =
 				le64_to_cpu(mgmt->u.beacon.timestamp);
 			link->conf->sync_device_ts =
-- 
2.43.0



