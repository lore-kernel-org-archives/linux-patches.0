Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F1C27F749;
	Wed,  4 Feb 2026 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216833; cv=none; b=RqKjou1Se0j7DH+G6X9zuJN0UZ1zFU2CD28oIQ448clfn9GHDUfrRpZi6MgJsmQTkLyItNKzu8olgnxNWXixhf5GKUiV9Yvn7BR9VQYaLoCfwtcUJ+Q4ImaUTChsXhuM8AeZE5cgHwn+PcoY9Igy8neIbHMgb96xfFLSnudPoSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216833; c=relaxed/simple;
	bh=obOeYeZZS44CaKTsJMvt1y0uXH+tPMkBbGbjL+Isnp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4jg0Hy9otYee8bsPfDI9DRmsiPFIjHb7OL1sfj6/GQHXGkP4P0sVP8TA7YY6BOtJ5QX3a5j7Qs8kuaFv9Fl04AintU3a4UBffBfUcSGcaLfXaEzMCcfkUY/BjSBi87V2NaffqYgl2eMHDy2UiqjIeKutsyggOKu8pFMNsPcVlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1hbHlEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1hbHlEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BE7C4CEF7;
	Wed,  4 Feb 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216832;
	bh=obOeYeZZS44CaKTsJMvt1y0uXH+tPMkBbGbjL+Isnp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1hbHlEehK1iWJXLbHianHG93PLFQqAq7v/xym6IwrJWqNQgp2Z60PJufp19F8+5w
	 b8vmtFNmn4bYg1W2kWWAWsW0f1V8JvUm4DGvAE9wFzeVAeAsaF2YcOwFNom2rRaHU2
	 pcnJCVjdQixlnnOmXhdU1Cg9PlXUExd/0eso9wXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 5.15 044/206] drm/vmwgfx: Fix an error return check in vmw_compat_shader_add()
Date: Wed,  4 Feb 2026 15:37:55 +0100
Message-ID: <20260204143859.799556924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit bf72b4b7bb7dbb643d204fa41e7463894a95999f upstream.

In vmw_compat_shader_add(), the return value check of vmw_shader_alloc()
is not proper. Modify the check for the return pointer 'res'.

Found by code review and compiled on ubuntu 20.04.

Fixes: 18e4a4669c50 ("drm/vmwgfx: Fix compat shader namespace")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20251224091105.1569464-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -996,8 +996,10 @@ int vmw_compat_shader_add(struct vmw_pri
 	ttm_bo_unreserve(&buf->base);
 
 	res = vmw_shader_alloc(dev_priv, buf, size, 0, shader_type);
-	if (unlikely(ret != 0))
+	if (IS_ERR(res)) {
+		ret = PTR_ERR(res);
 		goto no_reserve;
+	}
 
 	ret = vmw_cmdbuf_res_add(man, vmw_cmdbuf_res_shader,
 				 vmw_shader_key(user_key, shader_type),


