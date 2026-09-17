Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D2839DBD4;
	Thu, 17 Sep 2026 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671366; cv=none; b=WDSmFwjbGIezLdedAbMAF3M3JOisnc0g4325Rr7AURKAb2GyOUpQqJBZ6pCnUSdVKn/7guPw2LD2UhfQuadEVszivfmjpHKzkaPBlZTj57xfe14eYNA5BHNcUhi2xfFFsTLlzeet+W/jvQ1CUoiQo62pqeeejbqfLfMB2bSFoxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671366; c=relaxed/simple;
	bh=ZE8q5N+cwN6TKzeuWVwzhf51d8IGYHdEScz87oIXLa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwtto3wNEL1wQ+NWq5CCKi1GMN5RSETQflBFsYDgn4V3U+4OrExmXdiG2s8YgXdoR0gxItAMbIXOE+WA1UQa+OY+jhF/QDk50iLhrxugjKIP14PAbRM/9sSDS6M5dKm5Q0zl95DdKgP1AJUJ1iEuH6BQ6xWq9J022j+QJJYzXrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwIcYOjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwIcYOjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593E71F000FF;
	Thu, 17 Sep 2026 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671364;
	bh=RyJ+go/msiurJFboCsvOubOSnUYq9WpevgR/l2bOlkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwIcYOjZPJA9eL/3vS21+7U8uT6OnVAHff5l2xBGK923ykUMJCBj1JyWhyqXzYCG+
	 0brPQE+GSUTaiqgiPJCZ+s5K1kQoKV0ox7X44W6S5+pREPI3z9OtJ9qeSwqFauWl1w
	 aADHFh7Nexd50jCtiRB1X0QH5xm7rfR9LLNEr//Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0951/1102] net: appletalk: fix NULL pointer dereference in aarp_send_ddp()
Date: Thu, 17 Sep 2026 16:14:54 +0100
Message-ID: <20260917151604.532344778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit 9e7f36ab5b7bf68463faa5f7b926fea8f35597bb upstream.

aarp_send_ddp() calls atalk_find_dev_addr(dev) in the LocalTalk fast
path without checking for NULL. When the device has no AppleTalk
interface configured (dev->atalk_ptr == NULL), this leads to a NULL
pointer dereference at the at->s_net access.

 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:aarp_send_ddp (net/appletalk/aarp.c:552 (discriminator 2))
 Call Trace:
  <TASK>
  atalk_sendmsg (net/appletalk/ddp.c:1715)
  __sys_sendto (net/socket.c:2265 (discriminator 1))
  __x64_sys_sendto (net/socket.c:2272)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Add a NULL check consistent with the other callers of
atalk_find_dev_addr().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260514123806.3085961-3-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/appletalk/aarp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -573,6 +573,11 @@ int aarp_send_ddp(struct net_device *dev
 		struct ddpehdr *ddp = (struct ddpehdr *)skb->data;
 		int ft = 2;
 
+		if (!at) {
+			kfree_skb(skb);
+			return NET_XMIT_DROP;
+		}
+
 		/*
 		 * Compressible ?
 		 *


