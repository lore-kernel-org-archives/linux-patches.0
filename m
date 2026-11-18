Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038489;
	b=SxjfAD1sTsjghB6EDfwO4EWgZNSyiexjrx/wbaxysnnggfImgE/+WoRKtQRy9caqjvL7
	 lbhLw+deS7nWzJ+BvsXqWXZCY3E0qdcYEdjfk02fStLA954L5aWCUtA0yd4MsJT9r1Nbu
	 9OS30J6bEMyz+P5c0xG+ScMAJnkl4crk2/a5g5U8l6hRSC+9RRsP/6HMUKLmYXeeErrSy
	 pCzgMDGDFzrey9jEUL28Z2xQ1Suf0qwTaBLVqEEkQBdZhhqKP184GZgRPa02uqNwqyjEd
	 hg6UkdhmW07UNn4XNBvkpYse+NDxCMv4PJjIWwJ9fEdKykxTmbG+q5xSCU3oLocuIaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bAIgBRlLtlATvFziFCuAwgLuOyT32CDmAnZjs+o0x3U=;
	b=dgQ6GxXeY6eHbGmcuEOdSuBHFrgoHneNeS/SPxNx8E64HBbLQpHQ2ICzGyFCKwVJe3IW
	 9WeV0qkqhGDlGeVAQc6A2jEvcjLh73k7uIFKgDu/tUg/Ghg31rdla0MR9lRytVtwy6/ju
	 GJBlyaWFzHM5Cku36QogXjFUEH0aa+V41g377AUKIS5EaBlAmngh974J5anyuVDFZ6l1p
	 sV2ndViUHiR/3o5xX2lb7ggz/eTZqUUKQwLGAe72Z6gFSQBUMn2p2AgTS7P1Vns9rv38T
	 gtoEaZll5oyt6wiOCDZFxs92XMa1TxSaKyR7DttnCwTu2wvnjb4Z0ZMmm2UmxOanbUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1m0J1b7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615A5606A325;
	Wed, 18 Nov 2026 21:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1m0J1b7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67011F000C4;
	Wed, 18 Nov 2026 21:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038489;
	bh=bAIgBRlLtlATvFziFCuAwgLuOyT32CDmAnZjs+o0x3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1m0J1b7BTpvqG2QBdSXk8Axdu75DQaxb8yL9pD4ySvZvLekim8LfZsQwCMCu6G2o
	 3si5W7BgI3eSq9bCysthyq4335+evzHCB6cFlBadvGxrYccpjU/xS5lqO6yxKewTi4
	 7eCZFsR9+b1VBChqt+Hhb1qKgwWvKXfD9L43EL8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1761/3318] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
Date: Wed, 18 Nov 2026 15:39:43 +0100
Message-ID: <20261118150414.682780058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 6f165abe2b40ede71c98956cd74cd17c18505e75 ]

dmabuf_exp_wait_released() takes a reference on the exported
gntdev_dmabuf with dmabuf_exp_wait_obj_get_dmabuf() and passes it to
dmabuf_exp_wait_obj_new(), which drops that reference after adding the
wait object to the wait list.  When the wait object allocation fails,
dmabuf_exp_wait_obj_new() returns ERR_PTR(-ENOMEM) early and the
reference is never dropped, leaking a reference to the exported
gntdev_dmabuf.

Drop the reference on the allocation failure path so the reference is
consumed whether the wait object is created or not.

Fixes: 932d6562179e ("xen/gntdev: Add initial support for dma-buf UAPI")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260916170956.2086505-1-vulab@iscas.ac.cn>
[ sashal: adjusted context for kzalloc(sizeof(*obj), GFP_KERNEL) instead of kzalloc_obj(*obj) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index d7b56466bec5d..cf82ab2e3aa6a 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -96,8 +96,10 @@ dmabuf_exp_wait_obj_new(struct gntdev_dmabuf_priv *priv,
 	struct gntdev_dmabuf_wait_obj *obj;
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
+	if (!obj) {
+		kref_put(&gntdev_dmabuf->u.exp.refcount, dmabuf_exp_release);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	init_completion(&obj->completion);
 	obj->gntdev_dmabuf = gntdev_dmabuf;
-- 
2.53.0



