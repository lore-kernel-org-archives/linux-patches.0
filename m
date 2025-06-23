Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AD3C2E0;
	Mon, 23 Jun 2025 21:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714350; cv=none; b=AmbYo+NK8qmCnZwrcxJUf4Uf4KcSL0Qd+IFMeaikHbSBDYkLyQvgtFdI1jwvBmdqyFv8iVkFVbQBlbVm5ro+PO3IXU7X2BznstVWZ+SVOO5aL3DTwNX/gk0SkdrSCN02OClqmPbM/7uR8VHJUnqczXjbG59IPWRJCQl+SxKdpcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714350; c=relaxed/simple;
	bh=klkUarTT3Wd3W4AIl7AWtKC6SWraMO/dLLKsCkhhyDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6HFRtba1Mvh9cHT+tfuL86DQ55Be/WR7jwHTIuzdAvHuTR4eYQCOnV38wt+dEOXiteDhbAUOf/xnhlvaSUDh7TOMUbCuBvuPeZisTBRmZWuqdfgXnQ2NdCv5YryOSgfHVQBGCm2Ubfi39uyqpZQENwIeT+67l/d9aHkZEACC+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxPdDMqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxPdDMqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4975FC4CEEA;
	Mon, 23 Jun 2025 21:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714350;
	bh=klkUarTT3Wd3W4AIl7AWtKC6SWraMO/dLLKsCkhhyDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxPdDMqxCLg+w4i9qr7u0up1EQI3Z5qNuVpGIvviK0t4hKJp9oQ0GqKtWlqppyCGh
	 i4g8QniSh6WOicJt0lx9HfMGyDswCXj0UkaFD2dntdQSC3fe0CVjducZ2HdjkO8wEA
	 TTDthoP5v+igTUxrW3tLPjkLwH6KXLPksCMazu9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+064815c6cd721082a52a@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 385/592] wifi: mac80211_hwsim: Prevent tsf from setting if beacon is disabled
Date: Mon, 23 Jun 2025 15:05:43 +0200
Message-ID: <20250623130709.600393053@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index cf3e976471c61..6ca5d9d0fe532 100644
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



