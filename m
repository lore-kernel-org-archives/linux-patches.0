Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FC43242D6;
	Wed, 21 Jan 2026 18:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019768; cv=none; b=crmzSaIZzcbz+7dBiY3Z+YtaaxA1UThz7zuV7nWCX6eXhOY7gtM2s31JLEUunCR3WzGQ/cGUZ6eZpGK6u4T3peqzTw8Jr3N7zotUdtjYC+hsTST9GOlPo3OSMGYuNPfG3VaKQ/+zzv4MvWdxfOoAU87fbALcHg++yPBdJ4dj2z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019768; c=relaxed/simple;
	bh=6j3PStNgt5UPESoHmc6xfIb0Lg3dip3ISwBO0C7ubcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxPgLsQIxLw2c9gxA/vFoYMRQ8FuOhSsNZaxS0V+tA4rmLKVgtGMePpMM472ao8212uF1tv5o/dyX3GVDL9IssDmN6LPpm/+9NEbpF58suwejjcJKk6jQg6QxGBXg/5dwNchnrjNgoQPL0kEzZ0zeF+TDV8aW3hXMFcuPKUT+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uC1YYu/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uC1YYu/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7C8C4CEF1;
	Wed, 21 Jan 2026 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019768;
	bh=6j3PStNgt5UPESoHmc6xfIb0Lg3dip3ISwBO0C7ubcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uC1YYu/86CTvXu//4wvG8gae9RPdbdJdzpckcn1my50Btb0WM3BZPww0+8LJvI7Yk
	 +ya4LgU8Bz9xjBZ7X1AYHPLVwPCop2aGd+YjTnJUEr8Ks18+SHW9VVrCkRzllvNxWe
	 5iX8wJYyw9laEw0IYMXNAr2lFUwieCs6oASXLakE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.12 103/139] drm/vmwgfx: Fix an error return check in vmw_compat_shader_add()
Date: Wed, 21 Jan 2026 19:15:51 +0100
Message-ID: <20260121181415.156971197@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


