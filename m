Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E55F2D8DC4;
	Thu,  2 Jul 2026 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010420; cv=none; b=sJTWRfMX87RE5/qNmWEDmAlzLSrhpjxLfJ2Zpo8dcBoDX1HaDenocXPkOvG5gChH/pTMLbHyk1d48w3HbUt+/VyOI35EBgb/no2T2PGDBz/xk8/8VkbHcwDHetmUO8Trsvx8wQDqNmdVgx7PxdtVNRhWGzeLbUVu490DJxlLMBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010420; c=relaxed/simple;
	bh=Vox3uD9hQXadi1Ewr5VlYB+L4dtt/cgiaZBP9KM2nJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3p2m5R38MLfWkFN9pui+mdcS1huspfbMCRDqh3rDMSh95YY5ViqLS6m/GE0eZMeF1B9KT401mi+nXFCMEqANvCAhTjGmPX+JcR2I8Vx5o4k4vPpDnFJRKI9ypMAFCikuUwjxQ3yO6be2l0k/YZ8+4iyN955/c+1svphR/9nhPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOU8+ZhB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOU8+ZhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848211F00A3A;
	Thu,  2 Jul 2026 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010419;
	bh=goGhLwjhYXjMkgnDzzN32k8b3u+8RgRyneHxZwwNkhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOU8+ZhB8M3LfLiISqjjxiJvwerUAFgYAAtlFz1gt77uO+oyGcRcYD1YGyu2O8OqX
	 G5Z1Jf4IQeiixmVlaRaHFNv9KKC26K1Y+D7QwBVOaLLgzyj+c3raFiuf1ecLpyXjru
	 MsZdKIUWFKgjjIrkVl6L4xloQX7XkkzyyBVUZY6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/204] batman-adv: tp_meter: initialize dec_cwnd explicitly
Date: Thu,  2 Jul 2026 18:19:18 +0200
Message-ID: <20260702155120.781013069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit febfb1b86224489535312296ecfa3d4bf467f339 upstream.

When batadv_tp_update_cwnd() is called, dec_cwnd is increased. But dec_cwnd
is only initialixed (to 0) when a duplicate Ack was received or when cwnd
is below the ss_threshold.

Just initialize the cwnd during the initialization to avoid any potential
access of uninitialized data.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 750e5e9d3dc9d6..f6ccb639744a2a 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1055,6 +1055,8 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	 * soft_interface, hence its MTU
 	 */
 	tp_vars->cwnd = BATADV_TP_PLEN * 3;
+	tp_vars->dec_cwnd = 0;
+
 	/* at the beginning initialise the SS threshold to the biggest possible
 	 * window size, hence the AWND size
 	 */
-- 
2.53.0



