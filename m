Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CF125B09B;
	Thu,  2 Jul 2026 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011465; cv=none; b=YNzREvtGUDC0lvirJgnFya4weX6CDBut3RTq+LDSS4MHvsdoSpLC1ZaTVqyx9Xyo1dxfrTfcdY+DKyW6PcPl5l1MqVIn7kUT+Xn+iKaHRMgklwE/94Dp93ULtDRD1A/3e1hoZs157xDosEygKieCun5MgskreD6YDNjq7vPHyKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011465; c=relaxed/simple;
	bh=G3Ql91aFGWLQD0gXpBd/K/w3zkr+qNcVlmD5Pp/lGKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7cAfA6kSXfEE08A2OIXA0/5zeaOv951KnUwG6buUIZTycIRVJTQPYRVQkPF06rB9rwuZtobeX9n1q6dD86i49wxhMV2FRt5uXeZbAodT3xXNgPhhO0Vtukd57Yzyh4VlpY74suw6rtbmT1TljRo8HebefDwXRnAHd1KsXcJFqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRTweHWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRTweHWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B601F000E9;
	Thu,  2 Jul 2026 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011464;
	bh=K/WmHHKYuTT/9HklduH9BqBKedDjIrR2IjxK1OKg9oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRTweHWhYCrJty6bVkKkWU8Cjjv22we5xjkZLiRoHyzCCqwRAAv452Wv67YjjMiDr
	 yo42AkWGApUzZ/TmAug4qudsNUC5EIFylo5YjaWhYw8Gdvil17Dmjcal7E4LT+uppC
	 2PMo9JrosxP9GlJwgfxhQGDqskFQJx0BFbzHIZSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 011/120] batman-adv: prevent ELP transmission interval underflow
Date: Thu,  2 Jul 2026 18:20:07 +0200
Message-ID: <20260702155113.196428639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 5e50d4b8ae3ea622122d3c6a38d7f6fe68dfddca upstream.

batadv_v_elp_start_timer() enqeues a delayed work. The time when it starts
is randomly chosen between (elp_interval - BATADV_JITTER) and
(elp_interval + BATADV_JITTER). The configured elp_interval must therefore
be larger or equal to BATADV_JITTER to avoid that it causes an underflow of
the unsigned integer. If this would happen, then a "fast" ELP interval
would turn into a "day long" delay.

At the same time, it must not be larger than the maximum value the variable
can store.

Cc: stable@kernel.org
Fixes: a10800829040 ("batman-adv: Add elp_interval hardif genl configuration")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/netlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 78c651f634cd39..1d144d8cc0928e 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -917,9 +917,15 @@ static int batadv_netlink_set_hardif(struct sk_buff *skb,
 #ifdef CONFIG_BATMAN_ADV_BATMAN_V
 
 	if (info->attrs[BATADV_ATTR_ELP_INTERVAL]) {
+		u32 elp_interval;
+
 		attr = info->attrs[BATADV_ATTR_ELP_INTERVAL];
+		elp_interval = nla_get_u32(attr);
+
+		elp_interval = min_t(u32, elp_interval, INT_MAX);
+		elp_interval = max_t(u32, elp_interval, BATADV_JITTER);
 
-		atomic_set(&hard_iface->bat_v.elp_interval, nla_get_u32(attr));
+		atomic_set(&hard_iface->bat_v.elp_interval, elp_interval);
 	}
 
 	if (info->attrs[BATADV_ATTR_THROUGHPUT_OVERRIDE]) {
-- 
2.53.0



