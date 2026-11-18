Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059672;
	b=xubqRjCOcVC7ihMoOI7FqyBB0//dCGLJ3PrESLMOsLC9blg9skiVroAgr145BZpAMLKf
	 8QfBxKGfrYMsMP6N7qgH9EHxv3dL55HVbe5t9dKuqZT03U9VBvc2UioPz4sHNp/VJ/gt+
	 CJwZHGkFnxqBSi9tuy1aUGppqNlcKTOlkCQXKjH6jNYlRRHZC+V3F2DQ/WSHMoReMRN1V
	 qQv6qmW3tNVwh7IRwgZZCsDU3AzLcMQNxvnFYPq/hlOSsag4JoHbwJs+Eoe/BMRUuQBQj
	 77J3Mav2Z2ZkIBKWuel1iiy+2tGo3A4KpBNL4LNhupsk97boH/n0tHnW4udGHE1bdiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6UX9ELLXrDDORPMoXn1L3wxWydb4rDO3q6lEnNc9IaY=;
	b=19FOZt6VTuFtVwxmm3ivDKaddspbZvPxoRBOW7K7sPJafVF7sifx4yiSZ0LfGWdjrTP4
	 hAouwMpxM1zO/rzDxsIMAQgOMMv0GcGqPr/4iStuEYgV5QmQBar47uWhq9siQ++Jts82/
	 dDN90rOsbUFI2cf/AEgC5JcprLjLtPswNqAa0uFqtayCNX5v7FiIPgoGoveeE+TIhvSKK
	 BepH8KCFjaCcAdyoZAwOqlegYml7hOVFigiKkVR19lArd/5fOVaAOBHxqUcevaVHhav/t
	 MsvKjm7mYC064gV8mfEZHWDZyhc3waWNdJ8O6KD0GeOjyiO9cNd+R73aK07Alr63y8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnHvn1mX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739EB606A32A;
	Thu, 19 Nov 2026 03:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnHvn1mX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2861F000C4;
	Thu, 19 Nov 2026 03:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059672;
	bh=6UX9ELLXrDDORPMoXn1L3wxWydb4rDO3q6lEnNc9IaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnHvn1mXI6NZ69BIB7RAdnN8WO8AruvzjpWl1PHZ1VdvhWdkYJazFVXDu7oBbVtu2
	 h0zUrPR5IveSNCVTg/zRCxIlPOku2Pu3BwS/YvcnoPqevNbTGxn3BGt4sWIRkFo/Zc
	 0s/2lbagr6WhvnhEibHwvrvkUdzKl5rLiFk90woY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0924/1848] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
Date: Wed, 18 Nov 2026 15:49:22 +0100
Message-ID: <20261118145955.485274207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



