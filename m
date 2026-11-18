Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037473;
	b=xcMScOHSekZEp5ZuHVv9mvLx1V6q+dHWvbWe355K+HJzMzT+i/xnRH6wIqV/cG9uv33U
	 GsLu52ShugTcspOrH86yEeBtPYLktbguFlETN4wxLpIbf1ICQkbE/jaDXTxmr9rFAdvoo
	 U8IGkJc7ImErz34w6A0nvN9z8kT5v3aUV7xMjlZedsFsSpgz0m82DEm26ZRWqM/3yWeDq
	 4dPFX/WtSCv9Cqw38NRmfKzrZg9mxDXDvFBLqLSXpxwBITi88XlUiQqI15A5m11k0OLah
	 lqPXW4iEBwVGBy8oMFytjOiiW96FNH0VPfBUDUjsnZyLxSYjyacSh8K6Yva8OeZhuEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NO7Q6RJv3qPb0jIdtlu5hjpBKBgbzUrO6Rf8i/4SW5E=;
	b=xVKXVXwGzx04mO2ErPN51EifgOV+9bEnKQLyoMzC0KI90+6klcPsxbS3/WFeqh8Ni/bp
	 tbE6L6JOhwr3qfiLU+SpBqTlwz3RpgR3iivMvhElr/pH4lBCg4mwQJ2X7XLXZzekG5chY
	 wDUkBWvPOROcdObpEExWaVCIt0WMGR8xwvjcqx5oDR/0yRLb2lqmPOt60I6pnUXBHq5M0
	 gA2Xa2nfl/PmSd/avp+azRG2TvNH9W5JYzlbGkJJD5jbUoEq9rXMPStZ3396xnm9KsycU
	 iOPr3b5LSbe7w5Uh5VWhB4SnTudOVy0BF7L/R5pnkRnAR69VzXny6uexIqCWckPX12Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aowWqSE/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFAB606A31C;
	Wed, 18 Nov 2026 21:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aowWqSE/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8E31F000C4;
	Wed, 18 Nov 2026 21:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037473;
	bh=NO7Q6RJv3qPb0jIdtlu5hjpBKBgbzUrO6Rf8i/4SW5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aowWqSE/wYPh5idDAVcEiJXI5mWgVY2d3RckZ8X7HGM6sCGRMAF10kLLqbDHG1MmV
	 5jcFG/du62Sexm6pkUbuT24FiDW8ok8dg29rMLLCQ453/Q+iIQqX35ydtaSEAmfu1y
	 NwuAFCezKuGNfhchmSa3ZL2h7OVpU4Kx9EhK+YtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1409/3318] wifi: rsi: Skip TX aggregation setup for non-QoS frames
Date: Wed, 18 Nov 2026 15:33:51 +0100
Message-ID: <20261118150402.914631805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



