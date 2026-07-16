Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F89414A0F;
	Thu, 16 Jul 2026 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211157; cv=none; b=PJHLMSYwo2dZVxDqQqbQJnBNNTEmH4E+UzvnihsCVBktboNeKDNsrNVtUwH9fwwKeRFE3AG/1IsZ5H54mKSHIgm+SZbJCSyb3Ib9jqqad+GyWvCBa8rfB8sas61TjZ8buuIylAK9JYVn2u4kin5qJcLApbL6yY4T7hKDmp0JJbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211157; c=relaxed/simple;
	bh=9/HVFGZ1Lt4hxQUoGojRnr4ZP+0Csd/6brT+GXO2++s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fODFIfxqChKsoxnthHEsLetAjwTuiwX/uMUX7wyVgzTKREJj4MhyvWOJtWuRvDvOUpeum3JzjvTkJZDn734dierFh9HMUEhRuUtJTJtWw8Amp90FQrWQeCKD2dO+a+GgHrwWoIr2WhT/NtNk6/Us4Gfz6RW7VDMxRXoE5jSrUiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZ6YqmVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ6YqmVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2020D1F000E9;
	Thu, 16 Jul 2026 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211156;
	bh=iZ29sg2b37lPzaZEe63qX/Plq8+Wb+2j0AV8g7Vdz5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZ6YqmVr0CHD1k4pKxq3YS/qCrkL8ju2s6IOlV3naY8Ui3JK0nN6UYcR3L9y6OAjZ
	 c0NDzr8v/I4WGLH7WQV6oZq3Q7lppKCpp7IktrpFGgsU4HCbFjFE1trh6qkP1e/v2z
	 9szL6RuIrj5/EaxHXBwFYks0seIuOQyA6VBdu5mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Paul Cercueil <paul@crapouillou.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 6.18 319/480] usb: gadget: f_fs: Fix DMA fence leak
Date: Thu, 16 Jul 2026 15:31:06 +0200
Message-ID: <20260716133051.720811634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

commit baa6b6068a3f2bf2ed525a1cb37975905dadc658 upstream.

In ffs_dmabuf_transfer(), a ffs_dma_fence object is kmalloc'd, with the
underlying dma_fence later initialized by dma_fence_init(), which sets
its kref counter to 1. Then, dma_resv_add_fence() gets a second
reference, and a pointer to the ffs_dma_fence is passed as the
usb_request's "context" field.

The dma-resv mechanism will manage the second reference, but the first
reference is never properly released; the ffs_dmabuf_cleanup() function
decreases the reference count, but only to balance with the reference
grab in ffs_dmabuf_signal_done().

The code will then slowly leak memory as more ffs_dma_fence objects are
created without being ever freed.

Address this issue by transferring ownership of the fence to the DMA
reservation object, by calling dma_fence_put() right after
dma_resv_add_fence(). The ffs_dma_fence then gets properly discarded
after being signalled.

Fixes: 7b07a2a7ca02 ("usb: gadget: functionfs: Add DMABUF import interface")
Cc: stable <stable@kernel.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260609152905.729328-1-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1684,6 +1684,7 @@ static int ffs_dmabuf_transfer(struct fi
 	resv_dir = epfile->in ? DMA_RESV_USAGE_READ : DMA_RESV_USAGE_WRITE;
 
 	dma_resv_add_fence(dmabuf->resv, &fence->base, resv_dir);
+	dma_fence_put(&fence->base);
 	dma_resv_unlock(dmabuf->resv);
 
 	/* Now that the dma_fence is in place, queue the transfer. */


