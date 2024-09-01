Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2411C68C;
	Sun,  1 Sep 2024 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208762; cv=none; b=jrEJsbGXiSYTaThYbyioaluTDqiLESpjR+tkSQxr2b1OIr6c4biMoCmZB6zt5kv5C1ZX9yEGZYpAMRT1u0b8c9JU4t37GVXM24UXOd/vki+r+WUZaPXEfwi8weCy3QQaNwAPBmlWFCCOKibqCbvd4WX7aRQV8YtVrjD+qwABbk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208762; c=relaxed/simple;
	bh=sqyWIrv2cINvnnhHsZGrlHMH1umfn5s2QCblyGPWweg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRCKXqJYP3cXQT7PqWktrMH8wliOwe7VaRsh+v0mgnHQF6z6wKfM8SxufX9TVUCkq4RxXZ9Gob8w7cil0ztR5pcX5BNVyu4QSJNhFeGm4rmO8O3wJlT9hvPdm3GiQ93pGrGK7hBcmhgUGekXDHCABb+hYHiXHjYqnK34vAWKlLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9k/aqAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9k/aqAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEBCC4CEC3;
	Sun,  1 Sep 2024 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208761;
	bh=sqyWIrv2cINvnnhHsZGrlHMH1umfn5s2QCblyGPWweg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9k/aqAcZ8FLuAKUlPutt6b3T3BgyId9pJTuqytDv4Oxa5yvZf9dpLfNgnlH+dtVl
	 FzVe3RS1uYxIbmI4USe16RhfLf61D5x/UmGcLsmGWzDGKtlW/eeaUbRJ5S9NmZaU8/
	 +SptrPOpthoq7+S6HplZWp5qAclBgDFuXiQkRhwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/134] wifi: cw1200: Avoid processing an invalid TIM IE
Date: Sun,  1 Sep 2024 18:16:18 +0200
Message-ID: <20240901160811.313772367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2dfcdb1459441..31f5b2d8f5191 100644
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



