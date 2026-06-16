Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8A935292A;
	Tue, 16 Jun 2026 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633970; cv=none; b=YMlAr70ZlxoEXHeYTy4AImiyz9ARnV+x7jexQIr7LQlLVm7KlWsGFM6racAsNvBCBE+MFUf16gc3nWlnjIIRNYlRbxnbo923IaBq9YUmX4eyuD2N5MSEyZUtAkdPVln9dla9tzf044ga862Pyyw8dELlP1LXlneSKNI9FW/nkiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633970; c=relaxed/simple;
	bh=wwRV8p461imdW1w306IjmqXg5IrwFKLKOf4wAh66DnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C//7mlZpXJQt0OLhci8Fvl21DpZVejybaVkpRhSaWXUia3/NkWNOBC+9eRBZ7q6kVhh/vjVdJMazHbjTEIxvrgtee0oWRHgdXvUjOzRfF4rsFc3lOOKVDVVyD+cdLse/URkMHOQYTbwjYMEhqg6X+Fs/gCrOZiW7eyQDzzXdgzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkzrh5j2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkzrh5j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756841F000E9;
	Tue, 16 Jun 2026 18:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633969;
	bh=9teiSd6F75jgX7+fQdh4JVNwXFr3J1rYG8Kn34HuVKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkzrh5j2Fr6ie/OW7/2WgwotKwQiP+caihYRNycxXOG8bid8d5aB0EIhhA+veEP7v
	 9zAiV/K1+sdBNdpjM9Y/qp0u+7jKeihS1q1AzGCt09JWS4Efskf09YRhqBXA907sMO
	 m5Evsln94KSPJiFusZoBafXDNEIvBJ7fdNrpZOhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/411] tap: free page on error paths in tap_get_user_xdp()
Date: Tue, 16 Jun 2026 20:26:55 +0530
Message-ID: <20260616145110.080425920@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 3bcf7aec6a9d16438f2cec29f5d7c8d5b8edf9b2 ]

tap_get_user_xdp() rejects a frame shorter than ETH_HLEN with -EINVAL,
and returns -ENOMEM when build_skb() fails. Both paths jump to the err
label without freeing the page that vhost_net_build_xdp() allocated for
the frame. tap_sendmsg() discards the per-buffer return value and always
returns 0, so vhost_tx_batch() takes the success path and never frees
the page; each rejected frame in a batch leaks one page-frag chunk.

Free the page on both error paths, before the skb is built. This is the
tap counterpart of the same leak in tun_xdp_one().

Fixes: 0efac27791ee ("tap: accept an array of XDP buffs through sendmsg()")
Fixes: ed7f2afdd0e0 ("tap: add missing verification for short frame")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260521163230.1478627-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit 3bcf7aec6a9d16438f2cec29f5d7c8d5b8edf9b2)
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a08adca412b41a..3a91972485cc36 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1143,6 +1143,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	int err, depth;
 
 	if (unlikely(xdp->data_end - xdp->data < ETH_HLEN)) {
+		put_page(virt_to_head_page(xdp->data));
 		err = -EINVAL;
 		goto err;
 	}
@@ -1152,6 +1153,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
+		put_page(virt_to_head_page(xdp->data));
 		err = -ENOMEM;
 		goto err;
 	}
-- 
2.53.0



