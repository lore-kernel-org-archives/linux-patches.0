Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED19F449B23;
	Wed, 23 Sep 2026 14:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172961; cv=none; b=QJ3XhtYbZGYJ/hmupVmsozTxqaZS+uzMHQPi1P2aVgEk+jOiGagK5u1MtsFYn1MwY7J8v4wXnXWcXcmXdL/GmV9eOSg6hQFHIAgwDmPLhpsh3uY/g27lmZo0ZoMLTVvvy5D4+hcBbYnGJXTFtbi0RJZNm5HWgfbgrBvJnW4nSJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172961; c=relaxed/simple;
	bh=i8QtYxCukWaky1ak5A+4d1JY/fsd+MtbRHOrDt4IyOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO806q4J9dhpMrUjmshon+2nMO6pp3n7dyaTvbV5fiZkPy1Cc5GQ+1MGKH66tNxHcKRjgAU45297vgnek7mEu/9GlmC1zyrSBk1c8LqwLutuCooDHEGEnHDlKBT65nrpDbjqom4maAE/pqKi/+JZmaddw2wXiTgWRUbxvk+XgjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5BsmqZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5BsmqZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D331F000FF;
	Wed, 23 Sep 2026 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172959;
	bh=XyhLIdRmNW96CQvcCBiftRpVUmNQCOn5+chJTRY/GWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5BsmqZHsI6wGJh7yUyb7L5cjjnDdGT/SoQ4rp17+O0Y2i3AsRcCJkorHduH1kS1/
	 ZKQeQVpCwbD+Tccc25WrdtF+Tlh0jc706C+dGO3uIiMXZ0m9KZhZa6yU9vxwvwGN1N
	 omkY0Av8Qn8zBl5Hnpc67fWnLMgsO6vI6gTxuUlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 083/438] wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown
Date: Wed, 23 Sep 2026 16:01:44 +0200
Message-ID: <20260923140646.933504942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ca66eb493ac7d..889c32fd8de19 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -616,6 +616,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
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



