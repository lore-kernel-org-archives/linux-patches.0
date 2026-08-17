Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6432DA759;
	Mon, 17 Aug 2026 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980156; cv=none; b=cwzfdvk6a40m8WEEdkusgJF+NApUvPo/Sed68tdqlyRuwfwfxudXeQ+mLlhGFO3byEy+JwDDoszbe1vfAH9waesAYjcnUtIP1qAUPAl6txp2sO8ACbqWm0rTPlrjOI4OfcmfiSpLJ8cFCpDmit7TcKqJuAFQNjugxJUBBw1gBGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980156; c=relaxed/simple;
	bh=rPi7mkJkkqOD+eaMxe64bfSxi9WzGl+zKvBdXXcLHig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMiA4cH0FinShjcEyWPoXbDX4twP+D87q75R7t6nvjXwFa/mW76V9QPCeDmhuwuOar4/cDi4tCtPysLo1deIE4hZNZKePe3uI6bJuB3LVMdqFqD/1awz7IvOQxNCCRpMO+lNOdcG+bqpPnCuULxDYkpHujXi/NnTUzDwiS7w72I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzq4KtVQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzq4KtVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B5D1F000E9;
	Mon, 17 Aug 2026 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980155;
	bh=WM0MZyRrnZNjkfZBt6ws/KDHv6k2iFduIu5BKfS8JVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzq4KtVQeW8JEvN/V8hStpgHU3OiIwZTzXXnWBK8uUv4V9s0Ft5g5FURWUTQJ3Mbf
	 2mMbR3iegfiWZ0DCVbJ6L3pNu8VVPjMPzkCoPsey0nfKDiXKGEImnqbugrvsimchrh
	 WAiOYrp2nXmLIv/YS5jgIi5asNPt6CZo0uJjj314=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.1 474/609] drm/vmwgfx: bound DMA command body size against suffix pointer
Date: Mon, 17 Aug 2026 15:32:50 +0200
Message-ID: <20260817132559.826148844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit f4f1db96bfd68b81053693ba53405b6f510ac16c upstream.

vmw_cmd_dma() locates the DMA suffix at

	(unsigned long) &cmd->body + header->size - sizeof(*suffix)

without checking that header->size is large enough to contain both
cmd->body and the suffix.  An undersized header makes the suffix
pointer underflow back into the previous command in the bounce
buffer.  The verifier later writes suffix->maximumOffset, clobbering
verified fields of an already-relocated earlier command -- a TOCTOU
on the device-visible command stream that lets one command rewrite
another's GMR id, surface id, or other authenticated fields.

Reject the command if the body is too small for the suffix to fit.

Fixes: 4e4ddd477743 ("drm/vmwgfx: Fix queries if no dma buffer thrashing is occuring.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-8-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1516,6 +1516,12 @@ static int vmw_cmd_dma(struct vmw_privat
 	bool dirty;
 
 	cmd = container_of(header, typeof(*cmd), header);
+
+	if (unlikely(header->size < sizeof(cmd->body) + sizeof(*suffix))) {
+		VMW_DEBUG_USER("Illegal SVGA_3D_CMD_SURFACE_DMA size.\n");
+		return -EINVAL;
+	}
+
 	suffix = (SVGA3dCmdSurfaceDMASuffix *)((unsigned long) &cmd->body +
 					       header->size - sizeof(*suffix));
 


