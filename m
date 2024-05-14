Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F2A6CDC9;
	Tue, 14 May 2024 10:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683940; cv=none; b=Pxe9ewNEgOEtMe6FseJIeCOh+EQ1RfSefYixRmW659TylBZYm9CABTTH7H4QsDP0xCUleUnReg37u6yNLxTv/vAyvZtLdp/E+jffzDX3UGNJNYjIbCQGc5gar+wCaNXEdgkI3Lm2ls8Zj7EZc0Lhbn42v8AEqzXASuFjkfu9iMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683940; c=relaxed/simple;
	bh=i9sZm8r95tpLh+BfyY1Ijj+iz26mwf4X+6ludpdkd4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9HMkgv0RS1s+JkqqcmW3hjtAJz0bhM9o1Ci3KeWMSM9OleSatJNqDMSWK4YE7KnpysWAXmhMzlZf2DWUoZ5sq9Z6PnpefhSzLcQPx8teBiezjiaNLRgx9HsKrdeiQrDTBSp7mwCk+tVrxf9qKp4IPrUPJ169albrqEeQhZH9v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrIqH29B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrIqH29B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0AAC2BD10;
	Tue, 14 May 2024 10:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683939;
	bh=i9sZm8r95tpLh+BfyY1Ijj+iz26mwf4X+6ludpdkd4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrIqH29B2mzSvvbdGym2j+vYiEpTC4nw+coAY9omkacN0XeeLifSM6nfOvGfp2o0T
	 w31xgQ3CSo3gIhcPLv/sYGN6M9gWn32Bi5n9loS6BiqIyxYbM8MTGshm5jyUOe9Rxz
	 ntJOPf0TwnkqgxIb/HMhlUIkyaWDnfvgWBkmCo38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.8 297/336] drm/vmwgfx: Fix Legacy Display Unit
Date: Tue, 14 May 2024 12:18:21 +0200
Message-ID: <20240514101049.829844304@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

commit 782e5e7925880f737963444f141a0320a12104a5 upstream.

Legacy DU was broken by the referenced fixes commit because the placement
and the busy_placement no longer pointed to the same object. This was later
fixed indirectly by commit a78a8da51b36c7a0c0c16233f91d60aac03a5a49
("drm/ttm: replace busy placement with flags v6") in v6.9.

Fixes: 39985eea5a6d ("drm/vmwgfx: Abstract placement selection")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Cc: <stable@vger.kernel.org> # v6.4+
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425200700.24403-1-ian.forbes@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -204,6 +204,7 @@ int vmw_bo_pin_in_start_of_vram(struct v
 			     VMW_BO_DOMAIN_VRAM,
 			     VMW_BO_DOMAIN_VRAM);
 	buf->places[0].lpfn = PFN_UP(bo->resource->size);
+	buf->busy_places[0].lpfn = PFN_UP(bo->resource->size);
 	ret = ttm_bo_validate(bo, &buf->placement, &ctx);
 
 	/* For some reason we didn't end up at the start of vram */


