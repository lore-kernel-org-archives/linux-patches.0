Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1320F1DFD1;
	Sun,  1 Sep 2024 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209528; cv=none; b=PBT+nK8DzPlmr+MlWFJGxMbK9KCNo2x5qvloqVVUZFzzikSoO/HDCpRmshaphv5yx2B3BICOMjxaLykkaDvHy41mZS/Q1JuCOGaHjqeGEi1JadjYQLPE7Y4vKJbeCtLJk8Kx3OFgAZrkjLGeTAVdEtbGx2SE4vQYxDa8+PYi8Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209528; c=relaxed/simple;
	bh=BCPHmGgopEnyFAIEKroo1eRcg+sy7qeykBNFcBOs1uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdDmez4poY02dwfYjh6mwanIQkxK3wXDjq5tN1y0tMWUXbF4Dl5ccj8u6dyoP2T3i8+JOZDvWAm0qelgrYw7F6AACCYhpYF5QOceV6gva3mMEnmJH++t9l/IisfJEG/6uA1ENqnNJRXldfeoAyMJyvHgDvXqcdnST6u82iARJ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLGj3GmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLGj3GmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D53C4CEC3;
	Sun,  1 Sep 2024 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209527;
	bh=BCPHmGgopEnyFAIEKroo1eRcg+sy7qeykBNFcBOs1uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLGj3GmGmWMrBpF6z4DQp1oJxEo46T3W40Uf33fo6n2iQnLXBXms9Wye1FtG9h3sh
	 G5GLvc/yyTNeEa4oAjwySRhahA0witrLL5G/SwCAc+c7dUAvukHGVExvUq82b1EU+P
	 AeC+eMh04LGe7aZJFVxnDk2ZgfqWBuTWjdFUFvZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/151] wifi: cw1200: Avoid processing an invalid TIM IE
Date: Sun,  1 Sep 2024 18:16:33 +0200
Message-ID: <20240901160815.345977021@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 400dd585916b5..7ef0886503578 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1170,7 +1170,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		size_t ies_len = skb->len - (ies - (u8 *)(skb->data));
 
 		tim_ie = cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
-		if (tim_ie) {
+		if (tim_ie && tim_ie[1] >= sizeof(struct ieee80211_tim_ie)) {
 			struct ieee80211_tim_ie *tim =
 				(struct ieee80211_tim_ie *)&tim_ie[2];
 
-- 
2.43.0



