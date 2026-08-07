Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1766B2F1FDF;
	Fri,  7 Aug 2026 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115731; cv=none; b=IBxcWd/N3Cae8u+NzyixicieOABOVjgL/eevPVCIQiQjHGLHh0XaKfPKY4YVvbxsoAkH/kV7Jds1HdDKFHr6q1fjnhXRMeesJKd1lo81mbEyQL7eGivhczNR1LZ+MsvlQMwyE5nfcSigdxDcH5c+I60sTpqHCu5vXyMMP8k6FI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115731; c=relaxed/simple;
	bh=NN0sF+wguAiNUhLI4xGwk9aAQH5dMtZ5UdblYDDoKLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYkf0FlwtpTzYG0CeaAbilnTs1bNEV8ROR2Necaxpbr75Ubzj/6oDLeXW16OPMDj1QgX2JcTVP1h44Aqtr6FKsVhOzSrr969Et9dyIm1mB8Q+0UmWLjw3Npc29yNCicY8+l43iB+E5LO8Qgy2n48R3pYRGl/wEEgXnq0gC6i8fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejF+qYp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejF+qYp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717241F000E9;
	Fri,  7 Aug 2026 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115730;
	bh=hbJzd3V0WFeYESEhIgGZN65p1p628dFi01MjawX5074=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejF+qYp+bOdAWg87pXE6YlnUKtMRGLoHTML2/hYkMxD2GAWLUz5hNS1vE1khm7kkQ
	 FGqERl/lCwcX+E/5lkicBKlxP7bHayo2sboMTcpI5AZG7dowo1BanNifV4YbYbD8U8
	 HazNwFjt1t82sAQ/jbcDO+f84U4l1nbUJwsLFDXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.18 335/396] drm/vmwgfx: validate DRAW_PRIMITIVES header size before division
Date: Fri,  7 Aug 2026 16:38:15 +0200
Message-ID: <20260807143431.515283178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -1571,11 +1571,17 @@ static int vmw_cmd_draw(struct vmw_priva
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


