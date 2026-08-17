Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7D3DB324;
	Mon, 17 Aug 2026 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980154; cv=none; b=Jl9FuUl1lz+Py2/ON897la6LNWavE1GUhSXildcW4ouLzpvdJssUc35bplq5cH4lI/QQH53NICxGkbX6lpQX/NsA1ShCaghX5GtOsQhWNfpKj9mBwm8R5hdnqjnjyoMR5T49qI4knE+91vlHNagNSGaaQlSlMMONUBBI7UKkYS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980154; c=relaxed/simple;
	bh=lUHdZjc3gF1yDL/gXX7uDNC7Lo8fAhfHECdsyN37Zs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkrDZxqLrPcbdxmV9CkPfbv6fCoT44D+u5oQyUsXhDyUaFj8VtQ2M5eUG2O5imaytDT7n3+Gs7zc0Usso67GV3o5yfNbIYkahZxKFCB0ZDRAb6CXGLrk+3BAOn4lc0A+MuseKUHLIgnqGrIgB2aSHVa8JRQ8AF1nGEUtVUDWiCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLo/0YQT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLo/0YQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5461F000E9;
	Mon, 17 Aug 2026 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980152;
	bh=YdfaqtmGokrXVoKlhoslomA/x6OmOIOQz09QJBno9qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLo/0YQTMO0ZaCJwHLK17hHzYRcrTLvZls0HJa4TvYI/q31VkhCF6MEKFx4bmjSvI
	 4Sn1sTNanP/AhgR9N3TIHzmPbn55K53SyTb4w9kkUx1H+GIV7SBA0SIfruEksq6RJc
	 CgL/n6MNaeCBR6ZIutazqRXihUnxA7Rlp/sfyg1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.1 473/609] drm/vmwgfx: validate DRAW_PRIMITIVES header size before division
Date: Mon, 17 Aug 2026 15:32:49 +0200
Message-ID: <20260817132559.796981211@linuxfoundation.org>
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
@@ -1577,11 +1577,17 @@ static int vmw_cmd_draw(struct vmw_priva
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


