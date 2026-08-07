Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3613B4746B7;
	Fri,  7 Aug 2026 15:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117705; cv=none; b=GB3MNFGh5LmrU4A2b0upPoNOIGlyqjkTDHwocod6zKYLUe2WmWtM2buSnHb5CNUm1ltK/ePZu8NwdlFa46xxOAg4ziloi9r9+uFJPEMPHVJjXGYApsAmILK+1hxyYUMXNUQxB8e1/zHPekLcKc5UsZ13BbRRqcpeZPHxQOfXaAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117705; c=relaxed/simple;
	bh=Z0OY0u7ylO0SIPJqDz8d2435wSGYX7LuTB+K79axPFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG1J4IHuR4MQuh5Atrost8c+VE/M+axovAyNNjNS21PF0bFWVyMVrwOoSRzx9p3vb0e8eClzlDmgvHdXMGnjv4eV3apOZrqRQguDydvSM94Ggbs8xj3gUUAxbyXnQipDMtfjpLN7HvarhApin8yu4FcK36S14Im17iHwc/MC1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpM0c5NB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpM0c5NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FAD1F000E9;
	Fri,  7 Aug 2026 15:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117703;
	bh=yfqz6CWY9Frc+jf3irBT1ka7z8fhWSOJA3dKvG2T3Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpM0c5NB5QbuieHZvVgdUC36J5udG90JpmQN1VeO00ncqOHKa/SVbMZksekrYw+uJ
	 bEUGQ2fyKg2Ry6ePNKjbGzDD83B8huShSkiXjk/QRhw1pyGy/UDZEidciGBcAHzY9D
	 LydU8u50qbmDNZrhFoJS9/E76NkJcjhwRWuQY3e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 7.1 413/438] drm/vmwgfx: bound DMA command body size against suffix pointer
Date: Fri,  7 Aug 2026 16:40:09 +0200
Message-ID: <20260807143436.768689123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1510,6 +1510,12 @@ static int vmw_cmd_dma(struct vmw_privat
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
 


