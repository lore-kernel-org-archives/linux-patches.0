Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035F32F363F;
	Wed, 20 May 2026 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299415; cv=none; b=n/+PLZKfMneVNsE6/5eyQGp3QUggp2gtwQ3ODvTmDFfBa30Cnwt0PiXihYC1iKONvU2xS2v0ZMRDJ6Maj+12blYN4EI0j2nWCazmMTdwiVKmNNiOnxoBRcfJO70SqnsJZcsZJo/W94pqQa1ogb6d6VdfH4vqXXGgEDbZCcL9qhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299415; c=relaxed/simple;
	bh=By95oAWtBYsI8gOK/X9DdUU50cfWQ8ulK1ghoMSZGrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZnMYwOnwp5fkNX3+00FgGtTmoCg/QHy1yRnFmlT4pAkz4EpWNBC9JypQhsm52xG/4pUgntmQhEbWngKd++h8i1t0AdKZ/aWJBD4pSM9s7JshArO5Ffex1Ng9tn2WRtL3eXX5/XjOEgHMDTqsCizGvMN9kTRvlo6YZ4uqrSuhuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DB0kwlhG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DB0kwlhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEF21F000E9;
	Wed, 20 May 2026 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299413;
	bh=rPS+h+PcT9GlnmKtvk4k/RoSocRnqE0LYf7TEQiAfkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DB0kwlhGGXVTvvBG/KdUML6gxS0ZIbdpL2LfL4cpcCqsh1WPGTLyplQ67Ubbcov25
	 R9K8XD0XwsiC7tOv63DSmGAJ+S5WSgXeLIGH/a///9XjDYmHQN/lw7VkKe6Y67B3A7
	 OBodLh20d+l0R4qxvh4Rpr0cqPLGKur4bqmmDkPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 764/957] netdevsim: zero initialize struct iphdr in dummy sk_buff
Date: Wed, 20 May 2026 18:20:47 +0200
Message-ID: <20260520162151.132508262@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 56a47c060f2e1..4064c488439b4 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -773,7 +773,7 @@ static struct sk_buff *nsim_dev_trap_skb_build(void)
 	skb->protocol = htons(ETH_P_IP);
 
 	skb_set_network_header(skb, skb->len);
-	iph = skb_put(skb, sizeof(struct iphdr));
+	iph = skb_put_zero(skb, sizeof(struct iphdr));
 	iph->protocol = IPPROTO_UDP;
 	iph->saddr = in_aton("192.0.2.1");
 	iph->daddr = in_aton("198.51.100.1");
-- 
2.53.0



