Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6769DDDAB;
	Wed,  3 Dec 2025 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776495; cv=none; b=A3hbC50lJFAfMDaBmJyL15dqzIXK/fjMQuZQhH6EnV8F2SXeKEdWvhhAWqidY8GUe1+bRcbFwlxdUIpqNb7+MvfKGZfbiv/rVZ/ROaxZL9R+fvnhmhj0RfkPfagAxc13kKJvRd+BiING8fl4UbxyQWneyVY6X0wX2+lREweJDtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776495; c=relaxed/simple;
	bh=3kjUvPTyBE2Rf0L8niTtEU0PxSmPlGoObF2/tK9knYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wz3DsPnhKJqGxhGfUp4SqQ7SRdry9iBxLZBXGSGH5lpZbY4182jKziXYCcnY6Tf34mn9LxDbdtyxtueKbIsEOCGV3ZRbgHWO/7uWLFb6ofzV/wj8zqdKn5ugJLIh9+3IF86gjwtwWUzkhX0ZVqnvL2TJDTijIxLFnn+iNyWoWt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBeHnhXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBeHnhXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD46C4CEF5;
	Wed,  3 Dec 2025 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776495;
	bh=3kjUvPTyBE2Rf0L8niTtEU0PxSmPlGoObF2/tK9knYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBeHnhXcahj9ub4bp78UmCLCoskoWzlM+U0sEasXmwmVM0Zhnm/56g8AfrBaZkc0E
	 gxTJNWYZyH22Do1jDH57DggW7nmIP9W9PpDvOj29/RR3p8Utoiv3rXKeH5PRMHs/F7
	 s4+zK0ThBu+qsAR/SXSxCSoj7hmnLCI1gjyumaeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Keshri <rkeshri@redhat.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/300] drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE
Date: Wed,  3 Dec 2025 16:26:42 +0100
Message-ID: <20251203152407.960633068@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 32b415a9dc2c212e809b7ebc2b14bc3fbda2b9af ]

This data originates from userspace and is used in buffer offset
calculations which could potentially overflow causing an out-of-bounds
access.

Fixes: 8ce75f8ab904 ("drm/vmwgfx: Update device includes for DX device functionality")
Reported-by: Rohit Keshri <rkeshri@redhat.com>
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20251021190128.13014-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 987633c6c49f4..17d7f172a9e0f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3622,6 +3622,11 @@ static int vmw_cmd_check(struct vmw_private *dev_priv,
 
 
 	cmd_id = header->id;
+	if (header->size > SVGA_CMD_MAX_DATASIZE) {
+		VMW_DEBUG_USER("SVGA3D command: %d is too big.\n",
+			       cmd_id + SVGA_3D_CMD_BASE);
+		return -E2BIG;
+	}
 	*size = header->size + sizeof(SVGA3dCmdHeader);
 
 	cmd_id -= SVGA_3D_CMD_BASE;
-- 
2.51.0



