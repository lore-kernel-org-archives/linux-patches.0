Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDA74CC63A;
	Wed, 30 Sep 2026 18:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791929; cv=none; b=GhbzZc9xKzaJK5kTwXr0Lz631LK6z6dEkXxLfsCaFlxxToE1E5r4t8AKHR6PVcYxs2XRBBMcSEh1REQgeMjn/seZmKRqVooVIZ8D9qejYEEX6K98oAJV5fdw09uSuckTb4T75OYbMDyTjWAR2vBcmRfZw0VYkUeLzPD2l4gNtjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791929; c=relaxed/simple;
	bh=bzeNdJrwWCXQi19ggnb94p+YJk/pU2LswlAQCUR47dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9d35sdyqKF30+zruqucIEcSYDyp+Hq9HF+eHFsva7cCRsXf1gnSEySahzWyFjld6m/OtNRLecA9OsMD4aj4EHeatix0kEmZAJ7Xc3TQo4ijKfEeVDr0yG1W+kKwbWCvX/qqhVo/zKE/afeYyJdtAQysf1yJnZ3GJmObu6f+nlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnsmRvR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnsmRvR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2E51F000FF;
	Wed, 30 Sep 2026 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791928;
	bh=H4niQcnGHv8a4TulfgZjbIeRTndNUYa6UPduXFwWeAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnsmRvR/YCjVEHnO8guLIggAbzAjSXLTFM6PK9ZVBqiz0I4iNvyCARJlICm3i0S1b
	 pjrgFS5j1mlldD4j/fyQJvBE0zXKAi6AtS5zIkBWd/i8m3/DykRWQOLfPjLuOQ7jhk
	 oe4O7/RWMqpLcpirRhI5hb7NlDA02xY1CYyNTX4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 476/752] wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown
Date: Wed, 30 Sep 2026 17:25:46 +0200
Message-ID: <20260930152408.573320142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3b2d51df5d947..13a1e119dce0e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -512,6 +512,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		RCU_INIT_POINTER(sdata->vif.chanctx_conf, NULL);
 		/* see comment in the default case below */
 		ieee80211_free_keys(sdata, true);
+		/* increased by AP value on ifup, so reset on ifdown */
+		sdata->crypto_tx_tailroom_needed_cnt = 0;
 		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
-- 
2.53.0



