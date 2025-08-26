Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECF51B87E8;
	Tue, 26 Aug 2025 13:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215317; cv=none; b=a4nKf5SWZWyHTzBl5EIbv5Z3iloWu1iJbzPsyZG1Mecb1TvLSXW/1sMv6s+8cqALXrCWagE1f29u8kVR9g7lqJNmsCgAjjiwhldaPoVR3yw15So/TnkTqV+vfbHieoAz7DWitBjfr02zp74a8gjBGmQxIwutiLoNprrnCwHK7F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215317; c=relaxed/simple;
	bh=CH9O5/e1nRbRILaLcV9kfJu0rnoAkR30jBiT24QGGSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leW+2ias6oendeAIy4VbF9H405Wcu71ysXxMV++zDc27r66XpVOaCLTOm1yYHAJpoqZ45VvrSl64hewM6ZTTdMVijVgBfy/7Y95ENv6dO8t2ULrYm97EO2nRTotSYmIrmloAezUcU5gMj3MDpI5Pm32fnAJrXn2+TqaR6uFsj7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uu8W1bFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uu8W1bFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B1BC4CEF1;
	Tue, 26 Aug 2025 13:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215314;
	bh=CH9O5/e1nRbRILaLcV9kfJu0rnoAkR30jBiT24QGGSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uu8W1bFeJ2zOjpM9i+yz/U4o7rttR99F/uQK2BJ73QjE2yECSKN27GQQ3a/ED5TNL
	 aY3JGE9/tYFvLrJ5KkYiYKorM0lLv9/+ha02XhRHnzvLanfB21I7P0qxPZAxotTjbn
	 js/eyUKVzUwzaZMY0k4Hs+Rtx3cp3xNgHX7Sc5Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 468/482] ppp: fix race conditions in ppp_fill_forward_path
Date: Tue, 26 Aug 2025 13:12:01 +0200
Message-ID: <20250826110942.383361247@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 0417adf367a0af11adf7ace849af4638cfb573f7 ]

ppp_fill_forward_path() has two race conditions:

1. The ppp->channels list can change between list_empty() and
   list_first_entry(), as ppp_lock() is not held. If the only channel
   is deleted in ppp_disconnect_channel(), list_first_entry() may
   access an empty head or a freed entry, and trigger a panic.

2. pch->chan can be NULL. When ppp_unregister_channel() is called,
   pch->chan is set to NULL before pch is removed from ppp->channels.

Fix these by using a lockless RCU approach:
- Use list_first_or_null_rcu() to safely test and access the first list
  entry.
- Convert list modifications on ppp->channels to their RCU variants and
  add synchronize_net() after removal.
- Check for a NULL pch->chan before dereferencing it.

Fixes: f6efc675c9dd ("net: ppp: resolve forwarding path for bridge pppoe devices")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Link: https://patch.msgid.link/20250814012559.3705-2-dqfext@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 67d9efb05443..cbf1c1f23281 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -33,6 +33,7 @@
 #include <linux/ppp_channel.h>
 #include <linux/ppp-comp.h>
 #include <linux/skbuff.h>
+#include <linux/rculist.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_arp.h>
 #include <linux/ip.h>
@@ -1613,11 +1614,14 @@ static int ppp_fill_forward_path(struct net_device_path_ctx *ctx,
 	if (ppp->flags & SC_MULTILINK)
 		return -EOPNOTSUPP;
 
-	if (list_empty(&ppp->channels))
+	pch = list_first_or_null_rcu(&ppp->channels, struct channel, clist);
+	if (!pch)
+		return -ENODEV;
+
+	chan = READ_ONCE(pch->chan);
+	if (!chan)
 		return -ENODEV;
 
-	pch = list_first_entry(&ppp->channels, struct channel, clist);
-	chan = pch->chan;
 	if (!chan->ops->fill_forward_path)
 		return -EOPNOTSUPP;
 
@@ -3000,7 +3004,7 @@ ppp_unregister_channel(struct ppp_channel *chan)
 	 */
 	down_write(&pch->chan_sem);
 	spin_lock_bh(&pch->downl);
-	pch->chan = NULL;
+	WRITE_ONCE(pch->chan, NULL);
 	spin_unlock_bh(&pch->downl);
 	up_write(&pch->chan_sem);
 	ppp_disconnect_channel(pch);
@@ -3506,7 +3510,7 @@ ppp_connect_channel(struct channel *pch, int unit)
 	hdrlen = pch->file.hdrlen + 2;	/* for protocol bytes */
 	if (hdrlen > ppp->dev->hard_header_len)
 		ppp->dev->hard_header_len = hdrlen;
-	list_add_tail(&pch->clist, &ppp->channels);
+	list_add_tail_rcu(&pch->clist, &ppp->channels);
 	++ppp->n_channels;
 	pch->ppp = ppp;
 	refcount_inc(&ppp->file.refcnt);
@@ -3536,10 +3540,11 @@ ppp_disconnect_channel(struct channel *pch)
 	if (ppp) {
 		/* remove it from the ppp unit's list */
 		ppp_lock(ppp);
-		list_del(&pch->clist);
+		list_del_rcu(&pch->clist);
 		if (--ppp->n_channels == 0)
 			wake_up_interruptible(&ppp->file.rwait);
 		ppp_unlock(ppp);
+		synchronize_net();
 		if (refcount_dec_and_test(&ppp->file.refcnt))
 			ppp_destroy_interface(ppp);
 		err = 0;
-- 
2.50.1



