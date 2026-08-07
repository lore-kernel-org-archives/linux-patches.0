Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E973D31AAA8;
	Fri,  7 Aug 2026 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114441; cv=none; b=Z4KNUIDRmlCfUwmC0MRz/szOYKyV3KHTFvK8zbu0wV0hlXnBYHzWIS2nCglHV7m1dYLpAQnKm1+GPdfgwr9tHjfTe6+V8lhOFVNgjCXS8rY+V1XqtSqzh+a+Z8xE2Br/psO533j/ocuEWGVM3fOMPKVW0yuk8jFcbbzpA0cSxaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114441; c=relaxed/simple;
	bh=jq/KMK+ULZFOUtVQAoYgtgBK2FZOU/sHRvecHEe3A1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZL9EIbYGkMiHl39cSZqfEGjbwCtUbPX9ygnTeJ7aZy8dvcdR9fp+O/ZnqiiRhsUYXmqMmR7XtU9mKB1ngWKvTeJMfn/4BXkj/nI06ql2BrA0DsMGKmEzRkIh/jwJS/Gv/F2G0z6f/x6xzne3uo4F1zcEyjLnBWRCIWGW457EdvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JP/C5fUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JP/C5fUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62871F00A3A;
	Fri,  7 Aug 2026 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114439;
	bh=wd4cchk+cWmMWbwxCu1nR9FGOhzokRhttYbEg9x4pcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JP/C5fUFCR9xrtr1u4tQ1wp1YyukDqLRbEJfj4RlUqwgjdG+0FYLPW9nAz5N2pvXR
	 l4OuyLGT8pi1aD6F0/qAoRzDliQ6hEx74N0VmmGS8FCHIEgLto/gWoMH3l7ZpyLjau
	 Otvn1doGN5Map2Yd5RruS8opAj7p+awyp5aH/GxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.12 262/337] drm/vmwgfx: validate DRAW_PRIMITIVES header size before division
Date: Fri,  7 Aug 2026 16:37:45 +0200
Message-ID: <20260807143424.224814801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

commit 85891d174707d8bddcec7a888fb4e1d17def34f3 upstream.

vmw_cmd_draw() computes

	maxnum = (header->size - sizeof(cmd->body)) / sizeof(*decl);

where header->size is u32 and is taken straight from the user-supplied
command stream.  When header->size is less than sizeof(cmd->body) the
unsigned subtraction wraps to nearly 4 GiB, producing a huge maxnum.
Any user-controlled cmd->body.numVertexDecls then passes the bound and
the loop dereferences decl[i] far past the end of the kernel command
bounce buffer, producing an out-of-bounds read of kernel memory.

Reject undersized headers up front.

Fixes: 7a73ba7469cb ("drm/vmwgfx: Use TTM handles instead of SIDs as user-space surface handles.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-7-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1589,11 +1589,17 @@ static int vmw_cmd_draw(struct vmw_priva
 	uint32_t maxnum;
 	int ret;
 
+	cmd = container_of(header, typeof(*cmd), header);
+
+	if (unlikely(header->size < sizeof(cmd->body))) {
+		VMW_DEBUG_USER("Illegal DRAW_PRIMITIVES header size.\n");
+		return -EINVAL;
+	}
+
 	ret = vmw_cmd_cid_check(dev_priv, sw_context, header);
 	if (unlikely(ret != 0))
 		return ret;
 
-	cmd = container_of(header, typeof(*cmd), header);
 	maxnum = (header->size - sizeof(cmd->body)) / sizeof(*decl);
 
 	if (unlikely(cmd->body.numVertexDecls > maxnum)) {


