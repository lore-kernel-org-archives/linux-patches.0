Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B331DE8AE;
	Sun,  7 Jun 2026 10:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826901; cv=none; b=l8Z0U2zvTgLZuRYut8VSj+Znx+bLcsa5IsPmf8Z78BXGdwgVy/p98wjCyZkpC/Jx7GU8+xTeb51w6aeAECVko6NbXAHK/WbMyBBis/y8Q6NDc1UQy5fGDso6h/UlSWNY+m09XNcN2/iyrNTSJoPG9NgxRfELwiRAhcKhp+TgpvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826901; c=relaxed/simple;
	bh=dthdD0YVtdznP9G7nZ3hAKPdS+oNOp/8BUoE1LrJka8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFdNM3iQgCEcOh75jeL0Fn094LshFwCWfZ9W+OZ04DtBo8wz/N05VxsPFk6rH/yNq0wnH80ccjA3DTx4w58TTZ4NAxvMH4c3XUksqaCM3lgeEnRYw5Fx6/TKLcWnp9C4O3JAa2ARhCTCJ5ZqCCpvdhRYImN+GRXsTSAAffvv+2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cn8PJoTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cn8PJoTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBC11F00893;
	Sun,  7 Jun 2026 10:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826900;
	bh=6wxvKocIRDQujnBE/8Dj7Y776HbLph+kHlyQmSeW7ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cn8PJoTZio7drpwozVwexy6RywmZFxOKVpDqpZeTig6Q0nBgCwZBoIYTsvbiRE0HI
	 3IqGtPtoEadHWwSDzYh7WPOzQuOy9gre9D5YhiNCzhjbaripwzCxxf1FUpzIdhwreo
	 L5Qz5lYqHO4JquB/QkO0pDEPq60Q0zJYBGotYEHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/315] tun: free page on build_skb failure in tun_xdp_one()
Date: Sun,  7 Jun 2026 11:56:48 +0200
Message-ID: <20260607095728.271355546@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit aa8963fdce667a42fb7f0bdd2909fadcab02f9a8 ]

When build_skb() fails in tun_xdp_one(), the function sets ret to
-ENOMEM and jumps to the out label, which returns without freeing the
page that vhost_net_build_xdp() allocated for the frame. As with the
short-frame rejection path, tun_sendmsg() discards the per-buffer error
and still returns total_len, so vhost_tx_batch() takes the success path
and never frees the page. Each build_skb() failure in a batch leaks one
page-frag chunk.

Free the page before taking the error path, matching the put_page() the
other error exits of tun_xdp_one() already perform.

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260521163312.1479805-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index afba37965ce3b7..9a767da38c71e7 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2437,6 +2437,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 build:
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
+		put_page(virt_to_head_page(xdp->data));
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.53.0



