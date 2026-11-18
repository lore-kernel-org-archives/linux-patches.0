Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053946;
	b=j9LUxq/B6RPI3vzFGQrxKNWPU27Oh2FXF/OINj+6RGDMXHy3cbDJwcvFh1E9GnIEeZ7v
	 MLWIuXS5bi+heMRUiEhNeCRb6ngB4RIaiuP4G+igUdg6ZHfd5/CUevUqh7/5tWM89t7gQ
	 Kb2UK6HIUc7ZS49jz4AyHSTztYLICzVLThrTsxY+dGN/g+Noq4aJGJkb11ESr9Rbcao9j
	 jG/BzGqEqj7pa/fOqE9kCtfXM5ZL/5FyTSZr6exrjMUJhsR6Fm+bb3B/cF1cpZHbFsQYr
	 bC3RX/k/uwQ2iwIrI/t+Jv6fs5VbJJQcFjBEwt/i/RjDnWfQZIs0GJBBMRCwUbpxOPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZZo46pFuduUHN+Audg6ZC1ubzlCjCObtJR43rOU94Kg=;
	b=eEDJ4reTwH8RsC3eOe7lv/dT2NdNy3qXdOXmlnSREt/TV7BVxwHEYcluzjt9o1Jm1r81
	 17J1OATn4+4bjcPDRvKGyOMx0+2zK6ZsqwcHV55Gfj8mFTFJ/EqSsSm9GgQ8VyaYje703
	 FfHL2ZApzRQu6AIKduPHCey3IujZbj5buvurjwXXExM/3W5w2f7waegtnDUQ+lH/KpE07
	 uH+c4P8YhCweKbnVyKoTaoTIpfZjIAhaSW8Z6F4uEOamRDtSqlxXo/W3qx/18/IDXuijY
	 xRo1u1ZenNvo9fFd78aeKuWEVJygNJIS+wUWTxq8aox3Jcuk2/Ew/6sqMhPQBmV7g4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zg/4UH0b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95378606A325;
	Thu, 19 Nov 2026 02:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zg/4UH0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAF51F000C4;
	Thu, 19 Nov 2026 02:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053946;
	bh=ZZo46pFuduUHN+Audg6ZC1ubzlCjCObtJR43rOU94Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zg/4UH0bqpjCcTiVCdYnRiNyaq1Ju53rx/a3h5K2U+7BGkgsVGO4qjmUjJ+lRxOQs
	 FgUOJcyB1EyddEfmnnO/x+x0OlCFCHhdwGU8sVuz6/PbZbdOxS7p2Nr+l7E+zDxgKc
	 EPyA5QknKX85Dt03NiXCWN3bmYDmV+eAIArRpQIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1099/2214] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
Date: Wed, 18 Nov 2026 15:46:15 +0100
Message-ID: <20261118150056.160874060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted allocation context for kzalloc(sizeof(*obj), GFP_KERNEL) instead of kzalloc_obj(*obj) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 398ea69c176c1..8ed7aba6a6734 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -102,8 +102,10 @@ dmabuf_exp_wait_obj_new(struct gntdev_dmabuf_priv *priv,
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



