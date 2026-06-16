Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65294508E4;
	Tue, 16 Jun 2026 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628035; cv=none; b=Z1bGQRvc+X1SMlpPvy2+93DjOgpbsiQUwJvgGtQTI4Q5H5JDes2nYQKI3wV91TzHqG9aFYzxxu5m4cnmD25dKIxJlgaPnyYW2x42324dhXBPksh+mCTm2GK/WeOuOOEwk9y08fgm8PvbKsSHp/VhpDR47eT5uJ0fO29IQ+Mbukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628035; c=relaxed/simple;
	bh=wk09peq9g0ZK3oh1ZE9tqBSAxIyt45nhM2Lcmw5wNq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jxhyrkuxc4y1aq6q2Woaw+6YItFZCEA0motGUcPvJ6lLzVivZWloNavvKI2vDzEk5zyLsxuz3CCq6ilApiGNFWIrljyk0mJ5eW/KbSgXfQkdlkhHa6DjI8hFmklAqRVg1xhLb2Q1yGiIAP/DcjseFGjOMfG+zteDG1/MC8Oo0Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHidoiHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHidoiHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462271F000E9;
	Tue, 16 Jun 2026 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628034;
	bh=M87UNBmT1thkUbOQ0L7vyjwOtZUriW+SP2tVXqATYck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHidoiHHfsD1JgBQ+BtVjiMneiimC4pJKpmPLsFIGNLK7Lybov8XgGDTurYVYQ4Ta
	 lJJVqAZJwHiDrYFxr/JG1lWUp4GW/pnbhkwg5sp/by6ezYSGz5gH5NrD2olEc5lXyY
	 MylAeQAQClrdTCNeJkM3iYSgZpLxf5XsrPbmrfYU=
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
Subject: [PATCH 6.6 019/452] tun: free page on build_skb failure in tun_xdp_one()
Date: Tue, 16 Jun 2026 20:24:06 +0530
Message-ID: <20260616145118.819027264@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 88b704b5d0b26e..9a4192d6a4cabf 100644
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



