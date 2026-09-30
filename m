Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5789534D916;
	Wed, 30 Sep 2026 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785788; cv=none; b=GiVm1jWwaAAgAU/guoU2ntvUe2VF2UTtti3zNTJWL+ZGIUMbkXaxjVT2bCRaFRCf6pmg/Fo5085Gol4kSUtJnWv9Cl/QBC40QOvj9gnR54d3HIA95uV2Hf4RPaPruJvaxolQTyQUzutA5xrxg6YePJ37mP4j81mvyLLppfmh7Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785788; c=relaxed/simple;
	bh=JnUPWoDQYIPammO3m1z5Ap6wqFu9dAhg/mFt4VUtBIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgicZlGL5Up4F4WIUOu1d/0gqDUMSKWnp9zQDoLmFcTcdlzVHsyq58qL/Pa0J0ElPrz6cdcH2tH/da7ez0Q04FSqUWvagZma6+UqesKeJ2Akd6QcHWtzqSQvn/qLdbR2fqDEsad/m3aQ6ScQpji38xO+sdUAPZ7xjvR+g03iMhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SZoA804; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SZoA804"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C0C1F00893;
	Wed, 30 Sep 2026 16:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785787;
	bh=IC33YqWUPjperlU+AFZy5rvN6M9po16ABHQQjSD63FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SZoA804pgyF00XoKJr5aiYe0AxCVktO5IylI2CHNTq9pufAqZfyQdhNqRlK5qaD4
	 FJiyfkGwI3Cf1gP2YNXiMMtYre4LACetBJtzKBaB/R/HLw7Xw5Co7TTJ83H2C+QEUZ
	 Ta3SY840/QF/1hfZNL2ToK1tynRRVoXsAO8la+vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 630/982] wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown
Date: Wed, 30 Sep 2026 17:22:46 +0200
Message-ID: <20260930152430.302883018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee28c190faab3..c8ee28928542c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -623,6 +623,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
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



