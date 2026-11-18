Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041299;
	b=RcAQpXT0+FrRJfKs/6PZvWhGW9brYQl/KDX/3JSY2fXpJonEWYnPYWos1Cka6ybrOTTI
	 mI1cllMiUMVzqXRKPwngsaA/bNQEiayKs/DdJIZIl5O6+x3Ka0zuUjh5Nc9nCe18yxvwl
	 cpjldu7our83kC+PF/PqhlWdbViX6wx/q/8JCoStZdYoZXjreokAYSYxYzp4vHEhYDEkJ
	 50HkmBCq7gWYdzTfx11NukbhG0TXkgcaMyJ6dgnjvnL//9onCVH+jGzO3pHPV83nRjonT
	 K0c26aOc4ofJfktWbBXHAWU7N5eDS6GLr9FeY/u2GJzMtc5VBhDWZd/rj9CP/b59SPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=or+fO+EakdW+cK/HUFUSWxYaR4aOnFbk/bpDT3hr+Uk=;
	b=27A8zB8NNGX/hEMeOA3elsWJik8GMt+Erdfg/7IXk5nT2awzHOtgunf0GebQL6tCcfc8
	 yKcbRGDVD1NZhyKGdgWzii8XFXUj5I5+uIo1CpAYmWCxyPQyjbERyrE2MaT9QNjcBQK7B
	 KpooXFixnu4fixSntAUNaeW5CUWartUbrMr8u9I4h0byuOUWWNdbSBVgOUYZ2iyR7gpbQ
	 /rwSUvKbF8n9Ma4WPlnpUQFzl3RPQAhfBAkkHfJGWSoMDkY+wW/qKY2//nkuojZ7BB4eO
	 AF+ZHQKIfwjVB+c+7AFecY2oAdpFzFGMkimWP5UtJZz5IY6XkxFdQhX8j0ESaskauFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0uBsJ+i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6C606A325;
	Wed, 18 Nov 2026 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0uBsJ+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E961F000C5;
	Wed, 18 Nov 2026 22:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041299;
	bh=or+fO+EakdW+cK/HUFUSWxYaR4aOnFbk/bpDT3hr+Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0uBsJ+iwYcfSpYMCuLtzmURqXYaIWdEItufb6wcclKJZ0oJLEPP5b2X4aYrBWDv6
	 7nLKdlfZ50Onz/Im2ORFLs2rVZsODn9nsx5ssaqE1cPRheei23Ia0O6QJWOauTcQ0c
	 9C+vU3DXlLX2lY7m1gdp7UIdsnwNvJK91abciZRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2713/3318] wifi: mac80211: kill wake_txqs_tasklet on unregistration
Date: Wed, 18 Nov 2026 15:55:35 +0100
Message-ID: <20261118150442.264311641@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8ea4f50c3426aaaf3f4c118ee2c2876326ca5db5 ]

We never kill the wake_txqs_tasklet so it could be running
while the hardware is being freed. Kill it, late enough to
never be able to restart afterwards.

Assisted-by: LLM
Fixes: 21a5d4c3a45c ("mac80211: add stop/start logic for software TXQs")
Link: https://patch.msgid.link/20261005224950.3fdb8d0ff377.I851e79ac625c4926e211642ee7a7e458728b0ad3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f0ffefe822241..853540106ad50 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1531,6 +1531,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
 
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
 
-- 
2.53.0



