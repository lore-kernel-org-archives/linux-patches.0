Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80941239591;
	Fri, 17 Oct 2025 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713054; cv=none; b=infKh4iSRy9RjG2bF+mwgAWCqxbpyZOW1Sh6q0TNl8SLpWE04vfaCag/mHcg/jsodx2VKd7IirNaGFVgck9CIo0bb25aDsEvtDgiHiDQ86aqdIqe8yaAyxMe8GuxjyQI1d0vAVRXOOiDkUE3gEpOMu3fVvc6DnFPz9JhYutD4ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713054; c=relaxed/simple;
	bh=cbz7kgi7sd+fgeBulgOoLLyAkmFHPHJDnWojJMpX51A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXzLDOrJC0+9AJBuXZt7T2FI1SAhM2tfI3JdnJhj5cKAMShmND+7GUWMTUDRMBbZw6vjpe5TXIsPeid8OWirhsI+szFKyf2/IbBqDyScjLhv8BBK26gkMVm3bZ3xbVX6FityV7E09u02q3dm5xxg45kOrNT/8Gp+erTy7N8wgVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPMcM+Ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPMcM+Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA3EC4CEE7;
	Fri, 17 Oct 2025 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713054;
	bh=cbz7kgi7sd+fgeBulgOoLLyAkmFHPHJDnWojJMpX51A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPMcM+IpcF7MLvRn5RSdRUnjNtr9jcxg5/FqIzE48pFdWKb61YD6IQmY0TS9b6RkQ
	 V8YMopL9Aj0gSEFpUm7zj4Enho7ikkm2AnF2bGmADdpUKC8jO0IRoxK+delcVkZdaM
	 Zz+lGyAluGPAW98rOCXhbmljP3Ea9ZdnUdGuSQzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/168] drm/vmwgfx: Fix Use-after-free in validation
Date: Fri, 17 Oct 2025 16:51:51 +0200
Message-ID: <20251017145130.203005012@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

[ Upstream commit dfe1323ab3c8a4dd5625ebfdba44dc47df84512a ]

Nodes stored in the validation duplicates hashtable come from an arena
allocator that is cleared at the end of vmw_execbuf_process. All nodes
are expected to be cleared in vmw_validation_drop_ht but this node escaped
because its resource was destroyed prematurely.

Fixes: 64ad2abfe9a6 ("drm/vmwgfx: Adapt validation code for reference-free lookups")
Reported-by: Kuzey Arda Bulut <kuzeyardabulut@gmail.com>
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://lore.kernel.org/r/20250926195427.1405237-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
index f5c4a40fb16d7..d37cf22e9caeb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -339,8 +339,10 @@ int vmw_validation_add_resource(struct vmw_validation_context *ctx,
 		hash_add_rcu(ctx->sw_context->res_ht, &node->hash.head, node->hash.key);
 	}
 	node->res = vmw_resource_reference_unless_doomed(res);
-	if (!node->res)
+	if (!node->res) {
+		hash_del_rcu(&node->hash.head);
 		return -ESRCH;
+	}
 
 	node->first_usage = 1;
 	if (!res->dev_priv->has_mob) {
-- 
2.51.0



