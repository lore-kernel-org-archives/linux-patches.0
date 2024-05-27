Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9102168C4;
	Mon, 27 May 2024 19:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837563; cv=none; b=BXDgeoSbR6wSI47uMknpwHWbmQxAhGBGBUVwk5ziS2a6ad1+iiXzw2e6gXOc2oh15sLylQdDsw79ZIVs2evLsugbILyU2G6AgnT84M1ZK4jAmE4Xd32wTi8ztIz+EczLgPmqGqdwnrKyjS6nTCTcYGVDP8e4TJ17Hm325zvhOWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837563; c=relaxed/simple;
	bh=LtbExZG8+kxB8qViEIX2beTpsNX4/X1XCL6NJIVnzdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLIiM2aX9vaG44R5Dx9g57BOQq+TueMVuLRCX70BI0rUAo0NUxAjkSDpFxsCIZWmJ4ufUe2F3T71Z8pWymagA94GwRznB7H+cYXnOH9EVOYiu6SLKrzOLz8PZN6x7mgxB8ZSXl3zJACuM+GZtb3REIZC9zdd7WXLZ5ZfFuQ/MjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1wo7KYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1wo7KYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B534C2BBFC;
	Mon, 27 May 2024 19:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837563;
	bh=LtbExZG8+kxB8qViEIX2beTpsNX4/X1XCL6NJIVnzdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1wo7KYoYd/7f1neQDZpjg1cZOPQCHRKMeFhYqq2C6J2ZwCF/l8wRGWRAFSc9fpJX
	 iBhEXmxP4yXnK2Yed+4GA48b3V9BT/dj87o+wlRXIBU3/1J27DpWaR51sHnVbuSm76
	 t79oYHeXASsZPGO/hpV/111/17LVn3Ufnf6TP+sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Kinder <richard.kinder@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 042/493] wifi: mac80211: ensure beacon is non-S1G prior to extracting the beacon timestamp field
Date: Mon, 27 May 2024 20:50:44 +0200
Message-ID: <20240527185630.225513263@linuxfoundation.org>
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
index ac0073c8f96f4..df26672fb3383 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6184,7 +6184,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
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



