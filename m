Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585395;
	b=5ZTgF2GO2mNkxSLkyew24wm4HIm/3tHNxKENe+BFNkrAc0xVuBg7GGSIAPgYSkWl//c9
	 q94p+J67jSZcOxBzPpTwvANtIQNjSgfF054TCIFKsOS6PoTXwGO2w9ayDF3FUvxZfV/2M
	 hSm5qRwrFDBoRH6+1/CUgJMbH8tfS+nYP8mnmSwXEfHP52h3jm76KFtfiJdo5fNB+rVv+
	 lLYHPdtD8Pk9pMeNYdKgEb7PbPV9Ui5a+pPhNkWIDi5VHalrsTRARARh0pIp8lVNPo4s5
	 JROUXfaP4MWexG1vHX/c0uIELHSrpaQfR/VSp3Q75+E4OqJ9jStEj+sH18C6v3UC8aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YSipebtJEBWXVAyXUyqxV4gKX8ZEEUyBm+M8XG4xU/8=;
	b=B0lVFo8sVIsiXHxu/CB7VAhPkqB6yoEPctXTa0AOH0rcT8m9K9RwUloC5X1XXeTd5oZK
	 iqdIN9EDh1FyrkM653ojjHe0aRWdDZha1c9SRz5K7b/Iy1SSdt5jjKYoxKY0mghArPiWJ
	 xa5VyweuXKKT/ZNXOu5guqXvjFGThsydoxiAkACqpmRJqiCrRjd0jQUTV002iBaMzs80b
	 h+Szu5EcprzAlppwkstkLZgN/ihV0vLC6hXRB5u7ib97Btn726fkP2UBskS7nE2un+H88
	 Qxizl/fVYtfCKKqI+pkY+jB3oOt2wYagwVy0GYhniq8wkK8F/FutpsIPlkICq1jxUNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvxeofiP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4C4606A882;
	Fri, 13 Nov 2026 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvxeofiP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCF41F000C4;
	Fri, 13 Nov 2026 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585394;
	bh=YSipebtJEBWXVAyXUyqxV4gKX8ZEEUyBm+M8XG4xU/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvxeofiP541+WXm3dm0Yp/s2gn9iFQxTDKZfhu1df6gB7xd0bRbv4mmy+CrDz/lkz
	 XcuUAL5AZOxBTcOn+/nlYsbl3oM9r4LvPJ/RVoZ4crJnaqhRCCSjbAXSayUYFNcHX8
	 vPu2v+s5d9ybCnUbwyNzWcMWb8C9f6gZePmnd8Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 066/507] wifi: rsi: Skip TX aggregation setup for non-QoS frames
Date: Fri, 13 Nov 2026 10:46:10 -0500
Message-ID: <20261113153755.780558813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 71f756a4c064b0312f46617c20893ecc17c332e4 ]

When transmitting a non-QoS unicast frame to a station in AP mode,
rsi_core_xmit() assigns IEEE80211_NONQOS_TID (16) to tid. The station
lookup succeeds, allowing tid to index start_tx_aggr[], which has only
IEEE80211_NUM_TIDS (16) elements. This causes an out-of-bounds read and,
if the value read is zero, an out-of-bounds write.

Only access the aggregation state for tids below IEEE80211_NUM_TIDS,
excluding the non-QoS sentinel from TX aggregation setup.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 19844c0a9a19 ("rsi: data and managemet path changes for AP mode")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261015072010.742369-1-a.kazinsky@ideco.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index ead4d4e043280..3281fc94e1078 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -458,7 +458,7 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 			tx_params->sta_id = 0;
 		}
 
-		if (rsta) {
+		if (rsta && tid < IEEE80211_NUM_TIDS) {
 			/* Start aggregation if not done for this tid */
 			if (!rsta->start_tx_aggr[tid]) {
 				rsta->start_tx_aggr[tid] = true;
-- 
2.53.0



