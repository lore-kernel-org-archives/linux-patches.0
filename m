Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8383B27D1;
	Wed, 23 Sep 2026 14:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174411; cv=none; b=p1/Agf03B7ofDvizRueIN9Ype/FiTwdjd9CyweC5V+cXbJGWw5XU6K4shkAAJLIWHfC3B4l8ODAktbDGMuxwWRYz8E16Ji8CaI9QkJGrzzkhvXKp6MxiOJGrAJqnvCe41JD7C4mgDbfJOMlkMWy+CepDzt6i8Dz4a8IwXBZRU6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174411; c=relaxed/simple;
	bh=ghkUgZhRNxI6Wqo4tw/JtkUxEOLub8QzsYqYmczF8rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAI7kuYrxsKgxZx527K67zg2E/nlZW1fQijC8SHX5mnY7j3bGRVBM5bsNNVQirTBKIph/Q7gHtTZE3WrTwPMA/cDc7dCxmC9fUBS94eUtdfh76AVIecrxqAAxdg/288rbEigIodlB+w9oncD01MPNBoVE+EbooAcSEkR+w/IRhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSXjxWaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSXjxWaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D410F1F000FF;
	Wed, 23 Sep 2026 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174410;
	bh=IhvcuVx3a9uo9kRJLenC0gRusDs11U+4ZjrUC1EcYcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSXjxWaN73CnijPtrIm6g1z+hTB2fmG1dImvmpWePPAzKHSs2/98tlOYEM1GUVKDx
	 WYcxoPasuvAa7HOdJOWJxhPfFj+D80Qx4an0gPmuNehwREEYdlqO9a+FHbchEJjnlS
	 xDvIqbNgyh6lboGgXqTHqJ9eUn2qnwY6eSn7qE04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/398] wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown
Date: Wed, 23 Sep 2026 16:02:28 +0200
Message-ID: <20260923140645.350948912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 4504f3960dc4501c73be9f99eabda2e26e9db41e ]

On ifup, AP_VLAN interfaces get crypto_tx_tailroom_needed_cnt from
the AP interface, but it's never decremented again unless the AP is
also brought down. Thus, bringing the same AP_VLAN up again will
increment the counter again and eventually hit the sanity check:

  WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt !=
               master->crypto_tx_tailroom_needed_cnt);

Reset it on ifdown to avoid that.

Assisted-by: LLM
Fixes: f9dca80b98ca ("mac80211: fix AP_VLAN crypto tailroom calculation")
Reported-by: syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3ee5362db09487ea37
Link: https://patch.msgid.link/20260908122838.201719-14-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0c739af80f1ee..22ffae46f7cb7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -609,6 +609,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		RCU_INIT_POINTER(sdata->vif.bss_conf.chanctx_conf, NULL);
 		/* see comment in the default case below */
 		ieee80211_free_keys(sdata, true);
+		/* increased by AP value on ifup, so reset on ifdown */
+		sdata->crypto_tx_tailroom_needed_cnt = 0;
 		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
-- 
2.53.0



