Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8351714A8;
	Thu, 15 Aug 2024 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729345; cv=none; b=Yyri+OG5VRKDwPzPC9F1bf8G7mWfQwZmc0Q6OAml9/zfGCo/KSqO267ZK+VIHWA1wy6GWIS7iealybd7l2OvO9pE8c4pKkxCdQ+jRRrpGI1VM8v+nBksI49lOeL6xA4vRD+zCiJgikcp2j+WoJA9YUqqCVqyeXLWGhp8Xei6RIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729345; c=relaxed/simple;
	bh=TDevdhlGkRXWcWRSfoNOxs7kYEoi4ExwiHrpNYygCew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqc9McL5asf4IoIwVGAdD61Kq7l0Y2xx+LlmvHSY0C/SfV5PEJfpWBJJScIbpyGqP//zUJKX/IsKddM+SUfa+Vblwdv2dZBuBPk2l5TJrCIVhxzaIbELdRdts/vkSa8shyvTH7/lSg/XGJ/NMECFnBNHNpvN5M2rz0F79OMcMXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/KldgMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/KldgMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A40C32786;
	Thu, 15 Aug 2024 13:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729345;
	bh=TDevdhlGkRXWcWRSfoNOxs7kYEoi4ExwiHrpNYygCew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/KldgMbGZcEVZnF24RpMQbyxiDGrIaRefNYJ310mmT9KdLiTTsN6r6L74VgAa36p
	 2QwnB7B9cMFTE+JXxFSOUvcksUBVpy/iyYmVpWK7/xDagFPgGrByNT4lYvT7lbnnHw
	 UZhW4FesPU0WVPgIT3sZ+OR9rCMZK/CNqT4JBl/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/484] wifi: cfg80211: handle 2x996 RU allocation in cfg80211_calculate_bitrate_he()
Date: Thu, 15 Aug 2024 15:18:39 +0200
Message-ID: <20240815131943.641684079@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit bcbd771cd5d68c0c52567556097d75f9fc4e7cd6 ]

Currently NL80211_RATE_INFO_HE_RU_ALLOC_2x996 is not handled in
cfg80211_calculate_bitrate_he(), leading to below warning:

kernel: invalid HE MCS: bw:6, ru:6
kernel: WARNING: CPU: 0 PID: 2312 at net/wireless/util.c:1501 cfg80211_calculate_bitrate_he+0x22b/0x270 [cfg80211]

Fix it by handling 2x996 RU allocation in the same way as 160 MHz bandwidth.

Fixes: c4cbaf7973a7 ("cfg80211: Add support for HE")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://msgid.link/20240606020653.33205-3-quic_bqiang@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index a879d6b310a90..6ebc6567b2875 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1383,7 +1383,9 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	if (WARN_ON_ONCE(rate->nss < 1 || rate->nss > 8))
 		return 0;
 
-	if (rate->bw == RATE_INFO_BW_160)
+	if (rate->bw == RATE_INFO_BW_160 ||
+	    (rate->bw == RATE_INFO_BW_HE_RU &&
+	     rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_2x996))
 		result = rates_160M[rate->he_gi];
 	else if (rate->bw == RATE_INFO_BW_80 ||
 		 (rate->bw == RATE_INFO_BW_HE_RU &&
-- 
2.43.0



