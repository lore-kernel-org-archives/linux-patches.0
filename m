Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E107A217722;
	Fri, 17 Oct 2025 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714170; cv=none; b=gKxQHRyQ3jsKibucsOdk3t5/rbRVDnMZVSIV6ncziy+As8Ca37uhRButAcAeIS8Qe7GDrYIhMw6HCl2cRisZT/PYDibYJ2gVL3PpXa9HOr2yLQrmCuc+BNdN8fp+vWXKBdUPng+b8CjgQT/jjz53KhejC/hlmMfwau5J86yl0Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714170; c=relaxed/simple;
	bh=o/mhResQYr2xJzPDrxIsGfkstOkW/n06l1wJF+RhohQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5FinRP2bTKktGv5cVmtPU0KwUW+xA34kreYxBWupbuJiknzHmEXe7ekvooZTPCcMcDs5aV+1S/ESt8ZznbbzgknIPPcvl3wut6rBxpb1V97THsImaoaogEa6MSPkCxoTcKDpz4IcGmNPTwILeHnrCn3EsH5uyVb+SkrW8OPFTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YE+BWQTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YE+BWQTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67072C4CEE7;
	Fri, 17 Oct 2025 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714169;
	bh=o/mhResQYr2xJzPDrxIsGfkstOkW/n06l1wJF+RhohQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YE+BWQThzFXAXYu3kZ4KqCYDiiwQqbM2Ts4tMovCICtzaqELK2Lamz+3IJiCKuxvg
	 usiKcsLKHK7wxiQKB17xhXRKFLXP2cLbesPcyhLSWso9xKixZiOFEkXoSQf+95iGj9
	 SMRCZFhgSdZeIRUfTRTQONGrRSThPh6EsxND18d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/277] drm/vmwgfx: Fix Use-after-free in validation
Date: Fri, 17 Oct 2025 16:50:58 +0200
Message-ID: <20251017145149.010394099@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
index e7625b3f71e0e..c18dc414a047f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -309,8 +309,10 @@ int vmw_validation_add_resource(struct vmw_validation_context *ctx,
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



