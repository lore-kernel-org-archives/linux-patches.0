Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF7D183CC1;
	Sun,  1 Sep 2024 16:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207590; cv=none; b=ZVHqalZnfx6b0U28qIrC6ixcK21azB2G+n0r1TKOMCBKc4v9bi2ypWWu5SWdc+dH2vaC3bJBHgGyjoyc+AzJyl9K7/Mu2xjf5DEE4ZbQJ47/OIaJWnCURN6RWY7335qA2LDiQSf/H/EqSqXtIGGdtynu7Y9nW79nQPo8VkVNW/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207590; c=relaxed/simple;
	bh=aR+BAOT6LpVoTB0bwyZ5iChhcoiWbNfMUO6RFLHg4JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ng54qv9hu4w0RFKq36yu4CuUWhUHPaLR9gY6ZV1cBr28qesuC5sse8Pzx3orAuIrZWvLvJikVsYYzp8DaCbCJ1oD56PpB5w2vkmZc83EHLest72QjUGLQXbNvlK1VeD6DAFU72+M7b186Be+r8st8eXuJK004OWwdcRjCmAMxQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJCAVVsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJCAVVsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED3EC4CEC3;
	Sun,  1 Sep 2024 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207589;
	bh=aR+BAOT6LpVoTB0bwyZ5iChhcoiWbNfMUO6RFLHg4JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJCAVVsmp690Z/wDO0pFxd57JEtFjJHqM5Q6s7hOmyr2eq0DsXtXOu9eSvNEUGQE1
	 M2vOfF7b3ByvcyBesB5krsgcgw90sOKY5MR19z60U/goDxHmaWjyqdRMItkuVpUmRk
	 f2iCi5UUCp1jdEmLzSSY/rVBh4Gb29/SXi5sCWow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/98] wifi: cw1200: Avoid processing an invalid TIM IE
Date: Sun,  1 Sep 2024 18:15:48 +0200
Message-ID: <20240901160804.379169053@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit b7bcea9c27b3d87b54075735c870500123582145 ]

While converting struct ieee80211_tim_ie::virtual_map to be a flexible
array it was observed that the TIM IE processing in cw1200_rx_cb()
could potentially process a malformed IE in a manner that could result
in a buffer over-read. Add logic to verify that the TIM IE length is
large enough to hold a valid TIM payload before processing it.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230831-ieee80211_tim_ie-v3-1-e10ff584ab5d@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index f7b1b0062db32..3ccb3a134599d 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1173,7 +1173,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		size_t ies_len = skb->len - (ies - (u8 *)(skb->data));
 
 		tim_ie = cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
-		if (tim_ie) {
+		if (tim_ie && tim_ie[1] >= sizeof(struct ieee80211_tim_ie)) {
 			struct ieee80211_tim_ie *tim =
 				(struct ieee80211_tim_ie *)&tim_ie[2];
 
-- 
2.43.0



