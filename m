Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0174E36D0;
	Wed, 30 Sep 2026 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788412; cv=none; b=ohooCNXvNj6LwQxUBGlNlwxth3eUO3mR4aW+Pr9q0yraEWtcTIjtZALFhsPlvddaxXpIqY83WuUBSW8OabrxRtX3bzC5tDS1BDev0iZ+3ki9L/pmCjvzs6LdPTFsJLjbtsgfgaTjpz/P6fl2OpiacK+y+R8KXFy7iP95ppAOhDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788412; c=relaxed/simple;
	bh=TfeLR8JtoidwdsBVM3Ne536ss7BcV6wkCiPhBvocveM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiRzRrckHYy2dLzj5vdANZED8+ZWITdlmtuHvrzl/4ejsMTIa/1LO6RRVjvQNQFtNMl7Njg/vpq3h3QUMCVJzi2k4C8CY1GmqS1/1ERyk+4p+Gt4xE9UTliPq6hqeDjnk3dBR5i9LU0d02a55OweWpKN3ownN89xzGX4wrZ30Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1IUtsfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1IUtsfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F92B1F0089A;
	Wed, 30 Sep 2026 17:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788410;
	bh=aQo1eMhdIpvBvJ6/+9/fg3BeycxMtIz3y+NShIrKZKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1IUtsfpbtG+GLOa+7IiGTJgapdYxHLzp1Dw90MB/FIdVVJKI2s2uHKdAQurY0D2r
	 r7VdU81SFMIopbIHBfbJYa2tOYElincwaRHXOon+s/V7gzRIILkwBGusV1oZO+RSn6
	 AKszV71J92eL7sWGhDObcHIu+Qtv1TYEBWPP6KYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/877] wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown
Date: Wed, 30 Sep 2026 17:16:21 +0200
Message-ID: <20260930152416.250996721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 3726dded1959a..14a80583956c1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -618,6 +618,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
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



