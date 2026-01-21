Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70803A9DAF;
	Wed, 21 Jan 2026 18:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020442; cv=none; b=tlIFcEBb1j0icgy3aPAsPUfLIfUd/16RsLTf7AxT48Aei3m26oDhuriDNkzDfJDIGvRlQ0yqci0ZJbgjxMDaUwA425dHKiK5xMylCz+f6CS/QE1stY4ypouHXlVHsugDnj9u9SZuwVxEsDMXwtaSMY078aCnqNOOAzeaKFmApUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020442; c=relaxed/simple;
	bh=559f2EPHPkiIa126dhmr/amE9znrwTEvxzAmzSGwwrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IylvN561EZjA2Bm0ONA6upXtN6WKF5epjAH/VG1UqUae6ejLcWe+XDs7wwdjs1UKda6XERcHKuY5KcxOnml36IrWdL3lYbotDAseEGlAP8AGJ9drUWEwfgLi4C6HoNFVuIfqU2wG9rBQT5XqLsvUvFfzunb5jIAeVcfx7DXkqH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noKcpbXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noKcpbXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C080CC16AAE;
	Wed, 21 Jan 2026 18:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020442;
	bh=559f2EPHPkiIa126dhmr/amE9znrwTEvxzAmzSGwwrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noKcpbXlIpyv7JOEKH8+SPdIUkCugYuqu+WhgxOBgPIo5pZUkl9LUeJ751DCPVVIv
	 Py2FGF4urhA6Vm84lJKzB4OVxCsHX/m6t9TrCuQMcsg7sfkujBvjhBbI2qi4cAEzFY
	 LGGS9eSvxVPdIiIGlzi2GJjBDu/6L2QBouH9hh/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.18 159/198] drm/vmwgfx: Fix an error return check in vmw_compat_shader_add()
Date: Wed, 21 Jan 2026 19:16:27 +0100
Message-ID: <20260121181424.274007633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


