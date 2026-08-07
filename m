Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15968331200;
	Fri,  7 Aug 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114443; cv=none; b=uYwZxnXUY0BI+crb2QSVs51zOxdOXKfeNIsS8wvgRMA60TfP5iboNkXjcsxTJ0Fav7PQKMCHT88UhI8Qi4/huozymUwqPce12GHxOTb3p76OM2+KzZ0b33Ajodo1Ci5V+JANiCAJujudVNoICLJ97qgAAXz9nClVBhTRMKLHbzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114443; c=relaxed/simple;
	bh=w4ruiQfTmPk1/D9/35sk1SaIVG40H70ub3nq+muncpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJmv540jmD/X9GMXuKfccjgdioP0+0relmaLObHAWhaCoxLUiDr2kaYwaoTWegMRguUanrYWIyIh/f2iILvcn0P/uRulyZFACsBVIHmfSEDeb/KRlzKUf/C9pIvdEZp2HzZk2itFebyGNHPtXgLGBMMT4mQufCPOdqM/Af7DDAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBF8XRBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBF8XRBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5371F000E9;
	Fri,  7 Aug 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114442;
	bh=bffFOLoh9WWLOBq4S3OjdBMFp1BXJ3nRDR9D7hdcKnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBF8XRBq22soA60xYuqVI6LFdsHIFZBnuVt/+34U8FpyzgJ2D4AICq6pvNnRb52Vq
	 RVFA7hlvQNNpbT115hz2vs4NcZkgJNl6++QbE2lV0pmzhmSfqb/ANR1QOjSqrIgUpQ
	 s9WegaNqMZRDvBaDw4Ky3+3p1y8giKEpF4LU4IQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.12 263/337] drm/vmwgfx: bound DMA command body size against suffix pointer
Date: Fri,  7 Aug 2026 16:37:46 +0200
Message-ID: <20260807143424.246950845@linuxfoundation.org>
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
@@ -1528,6 +1528,12 @@ static int vmw_cmd_dma(struct vmw_privat
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
 


