Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB692206AF;
	Mon, 18 Aug 2025 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525304; cv=none; b=B9Jy72/KgR+n1BlZCCqoHtT7wkkG1Ygd8PV2iS5Qo6ZPk4xjDmL6Cvs4c1+8YcGt3gkxs4DaY4Fz7gH3VOiEWDz3LpdM9mZqoErCTfS2Fjxcpt97OXK58H4otH/pH1rJ1WrUrqCWiYYhHo/LniiICbWwj77WD5yDVr8vLOyUCIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525304; c=relaxed/simple;
	bh=8/M4K48cwk7BnnBFL7p9/1sJ0KyZgez5BwiTI901APQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhdC94z/6ni/ngEJwoufJJ2cvmPLxU68zHXM1HFM6z+/0xMwwEqi9fiHLbVY/ArcISFhzNmE+g1p34Hi30DQEbVuOn0XhQwP5LmQVos2lE6Qi6w7GXI1MzNeOLjREa5AW+/czIHCe3QeZ+0YbRC3qd/Dms5ceYbg25HDkSc2jGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2laN63Vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2laN63Vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FECBC4CEEB;
	Mon, 18 Aug 2025 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525304;
	bh=8/M4K48cwk7BnnBFL7p9/1sJ0KyZgez5BwiTI901APQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2laN63VypY5YoHUSzwXzwWkW69gT7vzqR8dV34S+s99ZZXm6VYR6Y9I/ycUqvkvlH
	 gVmNaXYPoU/V29Z6m3yF4xpYzOnNFptlaZzukF+qEdWbdWuos74Cn9Q6H8BKvBGEgF
	 nMZHFsDC+vn1YMPaWkKbVDCAG2mdV6Hy4P+E2kvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 221/570] wifi: cfg80211: reject HTC bit for management frames
Date: Mon, 18 Aug 2025 14:43:28 +0200
Message-ID: <20250818124514.320576148@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit be06a8c7313943109fa870715356503c4c709cbc ]

Management frames sent by userspace should never have the
order/HTC bit set, reject that. It could also cause some
confusion with the length of the buffer and the header so
the validation might end up wrong.

Link: https://patch.msgid.link/20250718202307.97a0455f0f35.I1805355c7e331352df16611839bc8198c855a33f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 05d44a443518..fd88a32d43d6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -850,7 +850,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
-	if (!ieee80211_is_mgmt(mgmt->frame_control))
+	if (!ieee80211_is_mgmt(mgmt->frame_control) ||
+	    ieee80211_has_order(mgmt->frame_control))
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-- 
2.39.5



