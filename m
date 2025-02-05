Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB56D155327;
	Wed,  5 Feb 2025 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764876; cv=none; b=DOcxS8CTXl94Jb5z91dE6ZZOnQ7Gg29PFXxMyjhJzwCcyeP77OaPp0moKoBsLRmgo24QERikvJHoXntwrerNXG399SUchPCcxdGFsuYBXLzATPSDRYSJbk0EKDsfolJaM0Za8z0/kYNnC1/pZhoMBtaNh5uWAp45jhmi3iQnX9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764876; c=relaxed/simple;
	bh=npLKsjQf4WDrybGphrDITE5Jth3pLfY1rtgi982Fza4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVrIp9gWj6P9UucD8dxm8vBdNz7EXVUV84YmBnLRZQBJOqSh5Dp7gSVeJ6UffeAaj+9CvdH3EZdmDuPFheWHxTho09fejyoDnf54d+KExHro4E5zx7tg1YGjm6i5fLAX1RdFkr46N/mzDbuG0KpqNYG1ZAQ8Kbd6wpL81oP76II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luLt5KeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luLt5KeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59141C4CED6;
	Wed,  5 Feb 2025 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764875;
	bh=npLKsjQf4WDrybGphrDITE5Jth3pLfY1rtgi982Fza4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luLt5KeWZZsFSFhnmds8whHB8DUGvNFXI6PM1JqurhEvA0YNqojbshuXGNCCPRXxG
	 Suyyj55Fw+/qkZXzKmmac1LjcXqBN0BtnzkoBtCk4bP9cHu3JNrlz1BWy5ihRATZHe
	 WWomF9K7c2r3i1YDc9/BkExgcZQfluLY6pkB4tLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/590] wifi: mac80211: dont flush non-uploaded STAs
Date: Wed,  5 Feb 2025 14:38:40 +0100
Message-ID: <20250205134501.595573235@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit aa3ce3f8fafa0b8fb062f28024855ea8cb3f3450 ]

If STA state is pre-moved to AUTHORIZED (such as in IBSS
scenarios) and insertion fails, the station is freed.
In this case, the driver never knew about the station,
so trying to flush it is unexpected and may crash.

Check if the sta was uploaded to the driver before and
fix this.

Fixes: d00800a289c9 ("wifi: mac80211: add flush_sta method")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250102161730.e3d10970a7c7.I491bbcccc46f835ade07df0640a75f6ed92f20a3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index d382d9729e853..a06644084d15d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -724,6 +724,9 @@ static inline void drv_flush_sta(struct ieee80211_local *local,
 	if (sdata && !check_sdata_in_driver(sdata))
 		return;
 
+	if (!sta->uploaded)
+		return;
+
 	trace_drv_flush_sta(local, sdata, &sta->sta);
 	if (local->ops->flush_sta)
 		local->ops->flush_sta(&local->hw, &sdata->vif, &sta->sta);
-- 
2.39.5



