Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70E2DBF75;
	Wed,  4 Feb 2026 15:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218996; cv=none; b=dnvjLCfrpB7ag1yG1eStv7l9p5HwSktcJbDwJfajjj1A24+xFXYFkAHo7p6fcb/QjT8NIUpfzfCMcoIAwpgOQgRll0tEi/7ywxOpMqLzappCz1RXgKXyvw+I4H+EfS54kvF+WRBlVX5E7CKOK1IpK1lbRw7QVMWdCMYhpzrGpU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218996; c=relaxed/simple;
	bh=4rXIjqdgeBh9pYF036l2UQaA1Ma3ZFh6mTKgfyGexIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJ70ATf71One0Xr8L09oN6QdBOCraLvPY30qNFwN65SllelYO0DH1OWUC3wE086hR8BWOzyKmzLfgfc5+0CbHwk32Yt/Ri9DnGJ/MTerBBSKrPBAz/lCTufIf8tO3h+lbX/leAdLifD7gfNIRyGw8xP+Kgkcwr1f867BE6BBdrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4V0th/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4V0th/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E320C19424;
	Wed,  4 Feb 2026 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218996;
	bh=4rXIjqdgeBh9pYF036l2UQaA1Ma3ZFh6mTKgfyGexIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4V0th/SRPWtJyQa7ftNMR/grrVQ8ZhW6Ta+WTVv1ejUAV1QFcKZnaqXLM8FOjx5p
	 qblggd6xo4BrrYM21Lw+2oIkJBMpEL7h2i4r3spUykVRq9fN38Pgg2rZzVHIB6QD30
	 7VDHeX3mbheDp0cLpbCPPMWpiSWV2gEdmDyHWw/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruikai Peng <ruikai@pwno.io>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/122] wifi: mac80211: correctly decode TTLM with default link map
Date: Wed,  4 Feb 2026 15:40:19 +0100
Message-ID: <20260204143853.195982515@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 1eab33aa63c993685dd341e03bd5b267dd7403fa ]

TID-To-Link Mapping (TTLM) elements do not contain any link mapping
presence indicator if a default mapping is used and parsing needs to be
skipped.

Note that access points should not explicitly report an advertised TTLM
with a default mapping as that is the implied mapping if the element is
not included, this is even the case when switching back to the default
mapping. However, mac80211 would incorrectly parse the frame and would
also read one byte beyond the end of the element.

Reported-by: Ruikai Peng <ruikai@pwno.io>
Closes: https://lore.kernel.org/linux-wireless/CAFD3drMqc9YWvTCSHLyP89AOpBZsHdZ+pak6zVftYoZcUyF7gw@mail.gmail.com
Fixes: 702e80470a33 ("wifi: mac80211: support handling of advertised TID-to-link mapping")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20260129113349.d6b96f12c732.I69212a50f0f70db185edd3abefb6f04d3cb3e5ff@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 21c73a65f73f9..dca47a533392a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -8,7 +8,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2025 Intel Corporation
+ * Copyright (C) 2018 - 2026 Intel Corporation
  */
 
 #include <linux/delay.h>
@@ -6190,8 +6190,10 @@ ieee80211_parse_adv_t2l(struct ieee80211_sub_if_data *sdata,
 		return -EINVAL;
 	}
 
-	link_map_presence = *pos;
-	pos++;
+	if (!(control & IEEE80211_TTLM_CONTROL_DEF_LINK_MAP)) {
+		link_map_presence = *pos;
+		pos++;
+	}
 
 	if (control & IEEE80211_TTLM_CONTROL_SWITCH_TIME_PRESENT) {
 		ttlm_info->switch_time = get_unaligned_le16(pos);
-- 
2.51.0



