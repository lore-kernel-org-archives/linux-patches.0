Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C763E0C5F;
	Mon, 17 Aug 2026 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976225; cv=none; b=sm1XjUox3SDfUsr/ZR9soInR8kTYwgzwPX10KgCVkmtDNZeOSIIcfgZwk0jump3yyP7YIoJTl1rTaDCeC7z0EGoR0xaTlT3aATh8gTXBpKza/ag1kmN/dRivEG5iqUMgH82vSrhzQv0bxyIoWKOvX7lFEDs+JRb1AsQYiSJLiho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976225; c=relaxed/simple;
	bh=SVzo9PqhFoIHXpwncwFT1PD8i1H6vlLAv0RR1GA2T8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVvyPd6hVAI0bPRxG/i+pYPfc4hBp3i14Pfr2CQTkDpKoT2KqvM+ao8RfxBbGfiH1JsnMTtKqz1a2BhFi+VBr7TyUGraEqrLFz9+hyM8wPuUrAsblt2OxPGrhJOjDJ+b9WDLCK/XUp6CR5W0gkqZX7ReUN4HsjNIZx1fVAdlxJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uea3Wkkm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uea3Wkkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EA21F000E9;
	Mon, 17 Aug 2026 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976224;
	bh=1nbMteINseR0pKdtjJo4R++RK+fxfLURrgsaPTkXdRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uea3WkkmsXg15NpVjyPs/9Pha390A1YD3MDmGw12cEB96gcJSc4j6m7CN2+gCEVnx
	 Y/yt23YheS+PUysb8LyfRvLnmQT4Xy+XHk40jLeXNB+iCn5bDxHQ2sblyBV0sOI/hm
	 7R9iEKrWcIW07CxTG4GFh1sjmHiID+mzgewsdDxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 5.10 300/389] drm/vmwgfx: validate DRAW_PRIMITIVES header size before division
Date: Mon, 17 Aug 2026 15:32:19 +0200
Message-ID: <20260817132550.762550708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1590,11 +1590,17 @@ static int vmw_cmd_draw(struct vmw_priva
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


