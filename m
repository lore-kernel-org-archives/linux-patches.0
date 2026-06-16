Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEE8478E26;
	Tue, 16 Jun 2026 17:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630376; cv=none; b=JC6ZhCKVNisgHm7y7uPk/YIqokduTp3xvrjShJFt/a24J2tqFJ7Ade/gkr3TlC5DZGkI0D1Tnzou+x4a7/SvDU+RNSQuHYaFAdq4Mk8r1tShbCZo+UdiqihlAMsb+ANCnv0JTw04pjyFxja0FRVAdVAIxRE3G6sib8W95t6wm5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630376; c=relaxed/simple;
	bh=VA26rDv73i5JsHXw9CBoUfnfHBD8BlJ+ITPZIbMmv70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggV9ojiQgjCO9o9uhF2ydD6SR0wdLNAROvD9lhHo/WhTIRTV2gWMFQ4T6Y/3mym5C/xYEjH/FOtQPuQypTLKl1H/6qRjUtp5Mfe96DgC3Ge3AlpNf2D60Zd5PY8HGEqLrgapeKE76tOI04FkAWYYKhHIqfJTAOKLwc/ClJ0ggxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0l2ytzT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0l2ytzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D051F000E9;
	Tue, 16 Jun 2026 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630375;
	bh=hA5dl94u79G7YGAx3179tYfwb9Y9lhZMOfGtlymCzI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0l2ytzT53yFMUZS30kom7pG8mGJkIXONn3slBSN3EcXB7HngJ+EcGnXoXbbcdWjF
	 6coCh9X6SOhraMebVqQQPsqF7uxJ+g5w6NxEC0JRehh64rfrdjxF7V+Hx2XmEI6enN
	 5eZLGK295Gs0/N7/s0AkyfNxw78xKJyk25rHUUrk=
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
Subject: [PATCH 6.1 017/522] tun: free page on build_skb failure in tun_xdp_one()
Date: Tue, 16 Jun 2026 20:22:44 +0530
Message-ID: <20260616145126.328005499@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1ad6af74de7c3f..e8f8c7d5df29ec 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2494,6 +2494,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 build:
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
+		put_page(virt_to_head_page(xdp->data));
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.53.0



