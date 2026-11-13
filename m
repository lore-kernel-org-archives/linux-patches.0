Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590709;
	b=uLoIuQpia0Z9COQg9LXe8PZ1b//KPoYD7sU1QWTuOkW/85ZTx00KMGwIAl8JmWb5pDrP
	 GspOFLjebRYlIplSi0PfBK43nHlC91O4RA83wkgC3d+1RXzLIvX9HvL5RqivWXDXjH3KS
	 4WosQMNVrnLT3fRFfN9uMd/2SOFDQGZX6sJC3unzRoXvhSmu+7J/B+gSD9Ac5OZvEwnbZ
	 h8t38YTEtePWsPzr2aG77KbyKVfutYCVuTLFET9FOCjx+RvqMglj4mmIlqy3KhZsaFMkF
	 aHTMKEefXADvOwDNZthIiTX41B3l+llEEtaWyoUtM/q6/PX9nSFtmAySKXNQqf8I3dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/j0QuOKX5v1Ie0fqQH1P3af/ofzeKoFVBmcFJ2st6A=;
	b=M+ObVK55HFfzHGeDuISJ614yM4Eko7w4lRF0F7MHaraQxUi3FFHpeXCgsPnuPSi1X/D/
	 eMVuJ+10qZPaCxfKnPqjGCcK9b0af1OLI3svZpdBOUJIfl6L4tRXLqImy8p9X6BeYhIJA
	 CrtIbVZ4QbaKmu4XyNMdJbu1NIpbc4BsAVSD48gogSab+wGmN5EeKdldgvVwl5UugSjVA
	 3Y2SSrjBeltyZ8VwaO1DQ5jeF/nT52i6i3jZozcvMTfi5xQnKh8GkuLbxSzXBpB72mPQG
	 QaLwDXgmAmFlLagvxVJrnLKzM9ocm2DvBvWdAeoxMym+w/X89p16Q3DRP8cEGES3jOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cf/wiGLI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D831B607A5DE;
	Fri, 13 Nov 2026 17:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cf/wiGLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A811F000C5;
	Fri, 13 Nov 2026 17:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590709;
	bh=2/j0QuOKX5v1Ie0fqQH1P3af/ofzeKoFVBmcFJ2st6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cf/wiGLILKe94fxSH52o4Y5kerJR2Z+hAidPY6acGFlFJvf/CcdGxyBk0YfW4IrBY
	 6+jVBgQxZIv1N/9AsItrulmN31gJhuSKXkqlU5CGtYb87whX/StEusVcuSCtHXtYes
	 vC6zVV1qLeceFGRpLn7HWFUHPWv5bQsuO/8qw/z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 619/686] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
Date: Fri, 13 Nov 2026 10:52:32 -0500
Message-ID: <20261113153842.844543741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained kzalloc(sizeof(*obj), GFP_KERNEL) allocation context instead of kzalloc_obj(*obj). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 550980dd3b0bc..5d38506a14f44 100644
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



