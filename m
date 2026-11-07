Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064574;
	b=16OK39nzQgaNuu8HPudLhtgw5DQ/g0tgFFI0UowP9HacnDqOSY1r6mKH3jAuP+cPiFkY
	 i1BBVpnjwWB4awvFNbIjNWGo+o9NlAnE98n082XeY6PwFbqgGy/s12RFPiZvRoZjPsAKb
	 +7iH1uf0kWpcuMFDE5aKEr4yR8qkWbZ+ivF4JHiBmj95ZQHxLJTEWFfiD95WoBQE2nSm8
	 51jVHsi/rY8+qBcFWoANjibmOQHrmlxq97Ml75MAV1pqXzjT+Ky4TqzgGnfUw+Xh6X2EJ
	 peiK+IKOfsKRgUmtzxRM/N2b10Y8Akhxb58SrFjd6D1guq6swRGlotlCVLK/Q3nrjrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C36JQyU67sdYP3/Cr+VQN7t2+bMfaljcBVBdC9wsWyw=;
	b=yTqnSootnhult0Nt0wYmBboCaoL/QjiL0C86MtKa3mPqP4NBj31bA4tfe/766XZN92r8
	 +TccybaW45TJyXGVxUwwxt/6KHD0T1sInP1/4hYPn9pHdI7nmwkm1529TZ31ccx4gls6O
	 J1EaDtSY0s5tXZNqwkUML0hpgz5Ou4VRHJIc2NQ5Z/F8Wi4imDv+Em209qyFgOwMbCF3M
	 4FYMqAMO8SwPeY1jKS/Ag6YzplJYtQHGBLzsBdTmPSBIx2a5AtnV8XdEmHfddKz59ucs9
	 KJZ8OqSYOSSc2Br4jQ4N+G8FYmIT47zz1O9hBmK5AiiUu0MCX1Ci3/OI0Gpdb5Pze/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3sNmBJX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAD9606D83D;
	Sat,  7 Nov 2026 15:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3sNmBJX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73601F0089F;
	Sat,  7 Nov 2026 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064573;
	bh=C36JQyU67sdYP3/Cr+VQN7t2+bMfaljcBVBdC9wsWyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3sNmBJX6aRSYLghG4qnagT/ps2Om9euc48PYsVKC169632fFxldC5lFAOx/RWgdy
	 Kzey/8VDGbeFiYFwJR5TiEXrsmuqnRR+m6JWiYGPw0QOOpJqsbCX5F0/xzGh07zL3j
	 t3sDlOwA48+pKYn8X3N3Br8Skk8BH/CjtspXW0/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0594/1257] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
Date: Sat,  7 Nov 2026 08:48:10 -0500
Message-ID: <20261107134955.735693953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 83b0df4608941..df1883aca850e 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -96,8 +96,10 @@ dmabuf_exp_wait_obj_new(struct gntdev_dmabuf_priv *priv,
 	struct gntdev_dmabuf_wait_obj *obj;
 
 	obj = kzalloc_obj(*obj);
-	if (!obj)
+	if (!obj) {
+		kref_put(&gntdev_dmabuf->u.exp.refcount, dmabuf_exp_release);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	init_completion(&obj->completion);
 	obj->gntdev_dmabuf = gntdev_dmabuf;
-- 
2.53.0



