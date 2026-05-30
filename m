Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBFA29B799;
	Sat, 30 May 2026 18:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164635; cv=none; b=ENUw/qDxUI655wPUl4TFX7UEza9YiIDp/UR58TFkp9L+5Vll/bx3i9TBKTU83TsaffkP9ipK+HIOPvruXN7DxETwMc9+vg8Qj7E51Zdtahtuygy4gPmyxaTHp7F/djv3LZ6hnL/1I3B4ls94gIgcJbtYLSYfRxz4YhR4NcjI8QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164635; c=relaxed/simple;
	bh=/T/3DMjGQhmHUSgckRtgHu/InYaY94JijIWbqu6Z0nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz60B2dL6qhLbmbQrw2ABPmPjaIANv/cGUmz2WPcgwiXZdIH4M/VtelJ6a2RvAcdUCcH3PLddzN8Vp7E0kBuQpy7gYuZuzi7DGYt6T/oxrh85y5uqBcCjtOEDiX/2xYyfNCkPHGE64nuFpGwZetYtEoc5LlNBKxC0+OEsumrnbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qouEoV+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qouEoV+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0201F00893;
	Sat, 30 May 2026 18:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164634;
	bh=ulJ9hI2yVVvoqMUNTGi6Ft/VP2KIPCQFxs6ONV3ICDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qouEoV+aWxbxaBEs9Bdjs8F2GHc3x9Nl2HmO5hbO+0UikzLhwfWUEZvUW9bhsbq9I
	 Fn9FCpUCaKW27WV7eTDdWgiMwRcRvWXMLdo24xGWAklhR/gbmDjqK8KtFYf4ZJzWaH
	 1hugIog/4VERWlXWpYr66boFSVR1eXQxvMa1qeuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 613/776] netdevsim: zero initialize struct iphdr in dummy sk_buff
Date: Sat, 30 May 2026 18:05:27 +0200
Message-ID: <20260530160255.846997240@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index d8f91bc38f406..3136ff369acd4 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -674,7 +674,7 @@ static struct sk_buff *nsim_dev_trap_skb_build(void)
 	skb->protocol = htons(ETH_P_IP);
 
 	skb_set_network_header(skb, skb->len);
-	iph = skb_put(skb, sizeof(struct iphdr));
+	iph = skb_put_zero(skb, sizeof(struct iphdr));
 	iph->protocol = IPPROTO_UDP;
 	iph->saddr = in_aton("192.0.2.1");
 	iph->daddr = in_aton("198.51.100.1");
-- 
2.53.0



