Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F0F350D4D;
	Tue, 26 Aug 2025 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218982; cv=none; b=bYL1r6sKHHaHPxdeWHW51ZImJJ6hdfAkisKiKsrJ0jXffIH89VGUrQILyIdnNZi30Mi+gFtGur2Fkalc3iJakjAFQe9nQ/pd2wsnfUZtScY7NATnUx5Iq5jU5048dAkKJuUJkOJlUOcfVx2pkPyr93V/GzI6Rnih0j5i8FEDxbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218982; c=relaxed/simple;
	bh=fiT3rkmoAGnDFKheszxzAZjxbrQ7LYMj09f/FvoGnpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ1pftEJYOdWQcvoNK3/X2wECqGVCGy4BlAbqAN/Z3DefPPli+HYTJHHs9KPI54FtEezsSWEKjD8J8hpDimHuNMZ35CQl4t3Ih42aT8XEe3irxHcRqw+YJ6nOBcqQ2C+a/ZAvibJ4+pEVrwt+dwGjZHNPPVXm0dowZ5aodAtFsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpnkHafd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpnkHafd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59746C4CEF1;
	Tue, 26 Aug 2025 14:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218982;
	bh=fiT3rkmoAGnDFKheszxzAZjxbrQ7LYMj09f/FvoGnpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpnkHafdFH3IiAKq5TtM10Q5GceHf3WUNK9GXyxew5R7xFGz4amJ+piUhnl+roCsK
	 uPiE0VTujBGDaAekuv7wXhIuiqh1wGlst8Undg/3qpp1ebVl+k8WB4Ib78x74yLMQX
	 ciqJ5F/tk9KnXI6sza8toMW1P0akDwN/X5GuZgTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/403] wifi: cfg80211: reject HTC bit for management frames
Date: Tue, 26 Aug 2025 13:08:53 +0200
Message-ID: <20250826110912.564709702@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f9462010575f..ea75459ac272 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -598,7 +598,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
-	if (!ieee80211_is_mgmt(mgmt->frame_control))
+	if (!ieee80211_is_mgmt(mgmt->frame_control) ||
+	    ieee80211_has_order(mgmt->frame_control))
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-- 
2.39.5



