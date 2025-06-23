Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC56B218580;
	Mon, 23 Jun 2025 22:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716409; cv=none; b=E6B7I43rJVgH3UI8Nqv6c5X9rq/hHbQpX0JsI9OrJmgVbIFu0MybWQnPwixpstyufFy3P8Ro5oTJvHjZvwxeHIImmh2PZ0TsI7LZCpckusTed+2V14Z6/xG3jJrZG5PaSZx0Pz14fwv8NpVqUnjW3xaGbrF9GGUfUJf0xAOL2cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716409; c=relaxed/simple;
	bh=4MxAW4MeKyKWlPTpyfJR4hKfpQqcofEev8TME8YUE4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiOYhEov6LT76aQJT874xX8DPk06evx/G8vz2eZHMG80W1IpwHtQhLyoS9anCSPQvr4LXqHzdkJBTkjoijQB1LFUpv0jh9RetOODsivCwDaoD/WeiPPOwM1TliGHw50C4ba9/zZ24LKVpIFzOv9rpYmuGlYXj0CcW1uf1E5wL4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqpthWWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqpthWWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455E9C4CEEA;
	Mon, 23 Jun 2025 22:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716409;
	bh=4MxAW4MeKyKWlPTpyfJR4hKfpQqcofEev8TME8YUE4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqpthWWxIxBzdJ2pnDIwwZKIBSjGA68460HL6rUBKSVvWGjyZ9NPnIh1eIr5ocwO6
	 HHAh4LH9pTA+QCqTprDig3NktkuBKmPoC714qAb8Ye28846F8hkJ+D2p5BzWL2KzOO
	 fQ3gmUbw3AhpcoRKg3Mf1yyPyrpfsvRHgA+9yfJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+064815c6cd721082a52a@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/414] wifi: mac80211_hwsim: Prevent tsf from setting if beacon is disabled
Date: Mon, 23 Jun 2025 15:06:26 +0200
Message-ID: <20250623130648.272700955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit c575f5374be7a5c4be4acb9fe6be3a4669d94674 ]

Setting tsf is meaningless if beacon is disabled, so check that beacon
is enabled before setting tsf.

Reported-by: syzbot+064815c6cd721082a52a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=064815c6cd721082a52a
Tested-by: syzbot+064815c6cd721082a52a@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://patch.msgid.link/tencent_3609AC2EFAAED68CA5A7E3C6D212D1C67806@qq.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 4a2b7c9921bc6..6fcc21f596ea7 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -1229,6 +1229,11 @@ static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
 	/* MLD not supported here */
 	u32 bcn_int = data->link_data[0].beacon_int;
 	u64 delta = abs(tsf - now);
+	struct ieee80211_bss_conf *conf;
+
+	conf = link_conf_dereference_protected(vif, data->link_data[0].link_id);
+	if (conf && !conf->enable_beacon)
+		return;
 
 	/* adjust after beaconing with new timestamp at old TBTT */
 	if (tsf > now) {
-- 
2.39.5



