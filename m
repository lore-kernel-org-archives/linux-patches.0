Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2085A29827E;
	Thu,  3 Jul 2025 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555646; cv=none; b=JKJZr5w4rR+BQGTrwWhfR+rmM2zgF3UHsnk+Mpkj0qVV0T6FNVsZ3TxTzmDUtYQeTfW9j3AZOg8y/xgIqvdx3PD7J1xdD77dTdP3RR4QF/bfQDmVolptPHf68vqnYENcbpRmNw+rmhNTUx1TN0+0VBVMZ02RvE1/qiqJ8eeI0V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555646; c=relaxed/simple;
	bh=yHUBFFIXyrzNd+DbCkKcjffbBNqEgGl6LUcAAkPl6rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XS3nWAcF2kiEtsMLJWRs8U4eGoz+kqVOGewUtsVYgWZuqlhNWD3a9Rsbj0POgvgliDXLvAXU5skDcg3ZyxoBQCcKrmTSHqzR0QwlvCi+7ICv9JZZ8J1YEx5SH2I79KTWrvsdtj5DoDQKRyTNhUSjr3wzxPqy5fJD7dJwfC9zdz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5JXTwyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5JXTwyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3FDC4CEE3;
	Thu,  3 Jul 2025 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555645;
	bh=yHUBFFIXyrzNd+DbCkKcjffbBNqEgGl6LUcAAkPl6rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5JXTwyvoQuM0goohCBZpmHxR3v4J3C2vBaechOpDUJdiG5l2GMUnjrNhkAQDc2Ai
	 jFf9v8cgzA4XlSUQjpl0MgHQKQIs7HCSxxqsaDtMmBUFf3uLbwUtEN8rFVOFyQxJUM
	 uCEGXEqcoIfknOT+0L4EYDbL2wfqZ17Gc6DRGraE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1316233c4c6803382a8b@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Gengming Liu <l.dmxcsnsbh@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/139] atm: clip: prevent NULL deref in clip_push()
Date: Thu,  3 Jul 2025 16:42:21 +0200
Message-ID: <20250703143944.214139431@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b993ea46b3b601915ceaaf3c802adf11e7d6bac6 ]

Blamed commit missed that vcc_destroy_socket() calls
clip_push() with a NULL skb.

If clip_devs is NULL, clip_push() then crashes when reading
skb->truesize.

Fixes: 93a2014afbac ("atm: fix a UAF in lec_arp_clear_vccs()")
Reported-by: syzbot+1316233c4c6803382a8b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68556f59.a00a0220.137b3.004e.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Gengming Liu <l.dmxcsnsbh@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/clip.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/atm/clip.c b/net/atm/clip.c
index 294cb9efe3d38..511467bb7fe40 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -193,12 +193,6 @@ static void clip_push(struct atm_vcc *vcc, struct sk_buff *skb)
 
 	pr_debug("\n");
 
-	if (!clip_devs) {
-		atm_return(vcc, skb->truesize);
-		kfree_skb(skb);
-		return;
-	}
-
 	if (!skb) {
 		pr_debug("removing VCC %p\n", clip_vcc);
 		if (clip_vcc->entry)
@@ -208,6 +202,11 @@ static void clip_push(struct atm_vcc *vcc, struct sk_buff *skb)
 		return;
 	}
 	atm_return(vcc, skb->truesize);
+	if (!clip_devs) {
+		kfree_skb(skb);
+		return;
+	}
+
 	skb->dev = clip_vcc->entry ? clip_vcc->entry->neigh->dev : clip_devs;
 	/* clip_vcc->entry == NULL if we don't have an IP address yet */
 	if (!skb->dev) {
-- 
2.39.5



