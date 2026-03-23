Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E26A3B38AB;
	Mon, 23 Mar 2026 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275124; cv=none; b=s6c0hHaMT3WYe20302LQOrpoR0eU3jfWi2gxRSQt2vpFp8qbK+DHuhb8fzj5Y+KC+GSo88nhZjs5uPY4AOlWaq9eFr2NbmpqucRF7cm3e8qNV629mkGM+y8A6gxDxrSh5aPjxFVlpA764ffMLtDGJ2MQTPv83zNWL05/gP0QoOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275124; c=relaxed/simple;
	bh=TxJ2kHfdLrp9rzZ4NnjXtlqtCYRuraOsrrmHgKpaMs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1AHF1ArjMJpx76oXJJLaVcU1WrOfv8A01d0xsOMyVa2PXvzj040KiuNg0ai5PE0p5ANpQa+fd7ur7wdWXDpxzUM/+vXB/E2boHaV3HKg9bTHpccYps/lskAY2yZa2jO4Hq7wFWhDwf6UXVg8UhuoeTzvPVU78NBVwMmp1yz5jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fA8YyF7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fA8YyF7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE358C2BCB1;
	Mon, 23 Mar 2026 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275124;
	bh=TxJ2kHfdLrp9rzZ4NnjXtlqtCYRuraOsrrmHgKpaMs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fA8YyF7Yns1J647uYICfgtCwiZE4M6ptrJ/Y2txZIsxcUdulhl0uQXgSaJHiiYuyj
	 5ZGTEEeu6fFCj7kaPl0Fkqp4UkYeZGqieoUrNzUtHJR6NPzUoR8Ht+F7x0ajz1741R
	 2TIscvE9pq0kox7DjRzq5eEPwjjByDOv8SBRDeVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/481] drm/vmwgfx: Return the correct value in vmw_translate_ptr functions
Date: Mon, 23 Mar 2026 14:39:44 +0100
Message-ID: <20260323134525.318682372@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 5023ca80f9589295cb60735016e39fc5cc714243 ]

Before the referenced fixes these functions used a lookup function that
returned a pointer. This was changed to another lookup function that
returned an error code with the pointer becoming an out parameter.

The error path when the lookup failed was not changed to reflect this
change and the code continued to return the PTR_ERR of the now
uninitialized pointer. This could cause the vmw_translate_ptr functions
to return success when they actually failed causing further uninitialized
and OOB accesses.

Reported-by: Kuzey Arda Bulut <kuzeyardabulut@gmail.com>
Fixes: a309c7194e8a ("drm/vmwgfx: Remove rcu locks from user resources")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20260113175357.129285-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index d8cc99ef7e2a0..34b9161ec7e81 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1156,7 +1156,7 @@ static int vmw_translate_mob_ptr(struct vmw_private *dev_priv,
 	ret = vmw_user_bo_lookup(sw_context->filp, handle, &vmw_bo);
 	if (ret != 0) {
 		drm_dbg(&dev_priv->drm, "Could not find or use MOB buffer.\n");
-		return PTR_ERR(vmw_bo);
+		return ret;
 	}
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo, true, false);
 	tmp_bo = vmw_bo;
@@ -1211,7 +1211,7 @@ static int vmw_translate_guest_ptr(struct vmw_private *dev_priv,
 	ret = vmw_user_bo_lookup(sw_context->filp, handle, &vmw_bo);
 	if (ret != 0) {
 		drm_dbg(&dev_priv->drm, "Could not find or use GMR region.\n");
-		return PTR_ERR(vmw_bo);
+		return ret;
 	}
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo, false, false);
 	tmp_bo = vmw_bo;
-- 
2.51.0



