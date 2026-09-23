Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8923B4EB853;
	Wed, 23 Sep 2026 14:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172598; cv=none; b=Ag6CCnJj/ZUrE6dwUDoWTCZgIBCCStZjsho19BgBb0Y5LEvnyUiZjUZbFfAbWjdFi0wroReCxRoCaSCvKbLlmNZwIfjK3hF/Gc6xRwDuxviCi9pm8shnVJKe4wiCGVGKESrCE0vh5IXh1AOYRYuwPbLs0SourqqpHVcwCjlTiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172598; c=relaxed/simple;
	bh=p0iwWaAXnnPOXhucXC+hZkZBAoiWJ267b0iAXxyWxoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N57ecz/6+nS3+QAIna3Cxjz/21E9S3acCHubjb/Rvvswv5l4r+rp2klPdzUQbm1sz63fqk9zI/iU0tJ6Iqla2/9IAke2jccWim2GyMOyAhMVqNz12TJ2Os/tTIIH53rRLXyUW8VFuy+t56M0rRURlkqzYHJYEg+rMsqZy2BpBgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFl62URV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFl62URV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847631F000FF;
	Wed, 23 Sep 2026 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172597;
	bh=p0dbSgMaL4IeG5/VHq8Ffc7SGRbOafkv8Sny8knrbP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFl62URV3K07AFMBttYHeeko42/3cD+AFDQOM37S0ll1oyTyt+rNfvqwbbkJRtAKm
	 dYytrNMjrtUc1XGNF8vrw++QeG+ocNxuTmj5Gm0JYY7vsuMDnbcz//VqNq+3yx5iFU
	 JzregvGjYHlSbglUuPFA+8kOOy/IGCNBk6wDFcvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c0e99a1aa85a286d7a3b@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 006/438] xfrm: add missing RCU read lock in xfrm_send_migrate_state()
Date: Wed, 23 Sep 2026 16:00:27 +0200
Message-ID: <20260923140644.929931923@linuxfoundation.org>
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

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit 42d100f5232f39b8ea7b00a7c2482325c7f032a4 ]

xfrm_nlmsg_multicast() requires the RCU read lock to be held because it
safely dereferences the net->xfrm.nlsk pointer using rcu_dereference().
When it is called from xfrm_send_migrate_state(), the RCU read lock is not
held, which triggers a suspicious RCU usage warning:

WARNING: suspicious RCU usage
net/xfrm/xfrm_user.c:1630 suspicious rcu_dereference_check() usage!

Call Trace:
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 xfrm_nlmsg_multicast+0x1d8/0x1f0 net/xfrm/xfrm_user.c:1630
 xfrm_send_migrate_state+0x870/0xae0 net/xfrm/xfrm_user.c:3340
 xfrm_do_migrate_state+0x1749/0x1e90 net/xfrm/xfrm_user.c:3507
 xfrm_user_rcv_msg+0x7a8/0xf30 net/xfrm/xfrm_user.c:3907

Fix this by wrapping the xfrm_nlmsg_multicast() call in
xfrm_send_migrate_state() with rcu_read_lock() and rcu_read_unlock().

Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA migration")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c0e99a1aa85a286d7a3b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c0e99a1aa85a286d7a3b
Link: https://syzkaller.appspot.com/ai_job?id=8977f559-3a7e-4bb5-b4d6-1196956260b6
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6266a92cf3020..980dbeb5a57de 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3337,7 +3337,11 @@ static int xfrm_send_migrate_state(struct net *net,
 		return err;
 	}
 
-	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_MIGRATE);
+	rcu_read_lock();
+	err = xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_MIGRATE);
+	rcu_read_unlock();
+
+	return err;
 }
 
 static int xfrm_do_migrate_state(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.53.0



