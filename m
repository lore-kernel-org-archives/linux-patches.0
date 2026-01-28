Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA3023EAB7;
	Wed, 28 Jan 2026 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614351; cv=none; b=fcCf4cuEKYZ+MTWKppybA14+xEREBMBHijRR0Th6zmi1rtJgdgZ1tq3RpWDVKPyNjkNQdPq0oL6mzAvRnGc3Laeco1utNOtMf8ocIphFvXihgQp2mUvcSMi9wVPNF6MKBqYPnuRf7jNZ615zFS8EFrsvJ/VAaDLgkTORL6dLilA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614351; c=relaxed/simple;
	bh=zOiO/owIhBkG335VNECLQ6by/L/1jVB7BgP6/1WpxKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNNFkS5EI+M5MjaUN2ztuCgb4cy5kg19Ix5IwaKL/byUtHGDh5y6UZICcYbhvbRRybI3CrZ9xjeiKPiyYVc+aXzOb1NpoC5Gkgn+B6xrvHguZlACyJvfsqv9QBQKx66zdXQU5RoAgScsNGyxe56vc62FR2cpXVpER+FhcbDdb4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJJMsNkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJJMsNkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F15AC116C6;
	Wed, 28 Jan 2026 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614350;
	bh=zOiO/owIhBkG335VNECLQ6by/L/1jVB7BgP6/1WpxKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJJMsNkrT6pDyM+lTSe69qNBAhzb1c/o4EotWFgvx+eLsji2kEPGuqOvNBhwmL5cJ
	 XWtz5YrB7mmlFgb5Q4w3i8fCPwh0B3524R6NMgYj2t8QUkB9Dmy6aEHUUuCY4Cxbqb
	 zilAiZNRUz8Bb43K+PUHueCtwapOkBK2UJlbB0S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.6 077/254] drm/vmwgfx: Fix an error return check in vmw_compat_shader_add()
Date: Wed, 28 Jan 2026 16:20:53 +0100
Message-ID: <20260128145347.465387371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -923,8 +923,10 @@ int vmw_compat_shader_add(struct vmw_pri
 	ttm_bo_unreserve(&buf->tbo);
 
 	res = vmw_shader_alloc(dev_priv, buf, size, 0, shader_type);
-	if (unlikely(ret != 0))
+	if (IS_ERR(res)) {
+		ret = PTR_ERR(res);
 		goto no_reserve;
+	}
 
 	ret = vmw_cmdbuf_res_add(man, vmw_cmdbuf_res_shader,
 				 vmw_shader_key(user_key, shader_type),


