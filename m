Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3154D2E7373;
	Sun,  7 Jun 2026 10:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827248; cv=none; b=ViSRaJsewAVoHVprcBjyzbkoVNn0UGMF7K5iVLDsV0Odjs2fc9nKVL8lG7cXrlj/d8tNxHkp1DGAJdw8TnIl3+D99k99RIkVmx3IYhiuyDrehI/Yjq7Pcj2Xuq7pC1V9lmgmaGc/F3B2AI3SJgntnjTw61WWcMVviKiQJ9a0Rsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827248; c=relaxed/simple;
	bh=V7TXZifOFZ72pepOKsvBNHLk4FvnQFuWP/x4wdAJPKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE4uaoBTmNwiSk2nppzaQKaZ5nYzmJzmdUy5Ux5n4GoWfr7ySTPm5punTl7jQ3IXS0vVLIAt+dMTmrwah5CslaYPZ32CThvhJtie2qlYIZFcBHm5dHcyRGvq0bLn/CY24NcSR1buYk7TFNRiZlHjPTeRK4qddTi1vtWi1+TMbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyA7Ulfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyA7Ulfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AA81F00893;
	Sun,  7 Jun 2026 10:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827247;
	bh=nTLk8kCMJTWBYDYlVuRXYfyZl+5qcH8uhrTdXNBEIC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyA7UlfoRhDWxKd+Nks5SbgFW2LewyqBYF0gu/hnYgp7DdGWhppwkCcJjfs1wezPw
	 IqSag4SkqRqumh6jL2EcFkGeLKpb4DUlYnwQJlnraCQgr0VstsGnkcbz8qUn5jwv47
	 UDb8VskQr2jFloqwA0HlQSQUVqc0CacdipkmvCIs=
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
Subject: [PATCH 6.12 035/307] tun: free page on build_skb failure in tun_xdp_one()
Date: Sun,  7 Jun 2026 11:57:12 +0200
Message-ID: <20260607095728.963783983@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
index 19c33d21bab947..d53e60823bf1bb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2505,6 +2505,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 build:
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
+		put_page(virt_to_head_page(xdp->data));
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.53.0



