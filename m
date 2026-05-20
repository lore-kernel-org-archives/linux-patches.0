Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670F33F9F21;
	Wed, 20 May 2026 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296773; cv=none; b=qNNHIjj4Ul3sNLlcyvpCf0pu1nMm5toQ/Kkjw41Y7NSWUlFvDuF7TRfFPi3HJaqTIDio6XBXoL2NDzj5BiqzdaS9lg++XtNT+tyxSYsKbZ8uW3312Vrt5JiYlxLnrykFkZg64GKm3vCjL23jsbYhsR+RawjFoi8gieW5KoXBiDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296773; c=relaxed/simple;
	bh=qzktxVn48n7Q6yBEVDDONem0/GCKeHsr6lgOO9GrtM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMLNBihfqsTtrsHP9vRWIJZ4JoLsog9GhFJk9SWj6N711HoX6GgzShCcKbG0BGmBTrM6qaIWD75fKSXndEYpj2Z/oR7cp0Rs3N6KWZMlDO3DG6shtgWFWj4AqwbDBmYowbWvau/rlucCbL8B/iLTOWIw4L8gLg1vLACnfKmcWsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0J1sxEan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0J1sxEan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC101F000E9;
	Wed, 20 May 2026 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296772;
	bh=2N+L67Gf+lpCKrTQTJHw7ucLWmwhjqkNsa/QVvPYE7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0J1sxEanfhHm0q3GHaNLUhkghwn/RWy49QVBRukCSJ6pMJuc+TSEceNUxyXmXoABb
	 e3WFB+lxrL/OQKQ497Ad0ReKlyGz61sf6cHglgmJFbHk1AYgy+fvnC2/QyYs+E+8gj
	 uLUr2EoeCY+rqd96V4/8t4umL+hAwzQovWfS57eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0927/1146] netdevsim: zero initialize struct iphdr in dummy sk_buff
Date: Wed, 20 May 2026 18:19:37 +0200
Message-ID: <20260520162209.217416503@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Z. Ivanov <zlatistiv@gmail.com>

[ Upstream commit 35eaa6d8d6c2ee65e96f507add856e0eacf24591 ]

Syzbot reports a KMSAN uninit-value originating from
nsim_dev_trap_skb_build, with the allocation also
being performed in the same function.

Fix this by calling skb_put_zero instead of skb_put to
guarantee zero initialization of the whole IP header.

Closes: https://syzkaller.appspot.com/bug?extid=23d7fcd204e3837866ff
Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
Signed-off-by: Nikola Z. Ivanov <zlatistiv@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260426201434.742030-1-zlatistiv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e82de0fd31579..8f6d0a09e1761 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -829,7 +829,7 @@ static struct sk_buff *nsim_dev_trap_skb_build(void)
 	skb->protocol = htons(ETH_P_IP);
 
 	skb_set_network_header(skb, skb->len);
-	iph = skb_put(skb, sizeof(struct iphdr));
+	iph = skb_put_zero(skb, sizeof(struct iphdr));
 	iph->protocol = IPPROTO_UDP;
 	iph->saddr = in_aton("192.0.2.1");
 	iph->daddr = in_aton("198.51.100.1");
-- 
2.53.0



