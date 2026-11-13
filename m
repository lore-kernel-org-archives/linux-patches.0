Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591530;
	b=T9UwTzoRmKpBogn9iezFcjLcbOZnc7JNDg3tX3V+eFWovCozDEozcPkR+Qx/16oS0jup
	 MuHCD6x7zveq0R+tunq8Xn78zJgBC7QV7ouqP53QKKqqiK9Fkxn+sNMjawO8Bc2sXliJX
	 QlyibwidhdLcXHJZWlARe93lyzvCPZE/WW22J7Fd4nMGergMeQ1s2k6lN7jf5fQf+UaTr
	 8gyLu9fjxflogIGhYRVRfnfkqdGLDdV5N80HRTSpKhiXBCbDzWRnUeeabcforfNja2sJv
	 qfDvDn3JkVHEye49MGaxpsAcNypyv7wcHuSTH119dTXzgzIVy17rUaVrYR8Q/P6medQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ei4E7FPm/GxJ1Re0ZBcB0NCE1KwCETAP7/ZuGuhKJZE=;
	b=esh9wcrUjVx/1Qs8z7609JatZkeCa7IJ2P9UFRVCgxk9TnTRizdCdpOvhfpjJ6yWWcxx
	 famugk+SyL2OBN0xVuJDPaGg06xP51jSRoGvBAIbOG3F1WLhny8MYpRSu3OOtGY34KiJ9
	 BoguIvUVSnAlFT3TtdNkXPu+ueVS0i6As8NcPZfFu1G3r9Fv3Do+Fl6vnAyGlgHw+laqq
	 KkRsWiMbenl1f7N/k1eyRp15cNxNB5aVE6pKI/eFoQRmuHVYL3valMrCNW+CaZOwjaS64
	 aQO6+1MM6D+w7GShJihPE5fVLsf6CSsSDrV/llQSkjNdLOnV4qwmgBspmE6m+Jx/BSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nThE4VkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8851607EE4D;
	Fri, 13 Nov 2026 17:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nThE4VkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187371F000C5;
	Fri, 13 Nov 2026 17:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591530;
	bh=ei4E7FPm/GxJ1Re0ZBcB0NCE1KwCETAP7/ZuGuhKJZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nThE4VkZnRO1grxzTozpJcXJX5zgXCqyoRUYkGsaBa4oJjvPg4fgEf/ZpuWT0ONl/
	 UW8RMue7DoZducS1XZqUG7obQDHSYYXzYfKkUc58pRbN9IWXKPkI3BlTsEu35kTbox
	 LIbpgy22nXPxVt2A+DU0DBDq80dpPbnfTabxjStE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 587/670] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
Date: Fri, 13 Nov 2026 10:52:31 -0500
Message-ID: <20261113153831.733009823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted allocation context from kzalloc_obj(*obj) to kzalloc(sizeof(*obj), GFP_KERNEL) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 5ab973627d183..1072e781f12ee 100644
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



