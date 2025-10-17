Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA262F12B0;
	Fri, 17 Oct 2025 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715070; cv=none; b=SicjAbe7Zwiu6RHhVcmh02mW41R1bs50g0vbsw/WZnvlW9P00m1lXTmJ7WJ6mgti/9vnzXIKXzLIJrXznKadKyCk6gJ3t9ULjYP5jSNPR0zekrfmfAn+CQjRirsKuKoVwiMDQ+ONlkybVVVG/6zAsRCoDxkOdIhRRL9xESdVpWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715070; c=relaxed/simple;
	bh=9L6OiiQQSimbIJjAF3KE4ce9v/7g09pCzZiLHMpV9HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNp7JboTl7LpQVPt7p6hjsJb/umMjcB8wQW6LFpZ6GfCO8c3LFVhmDrh/W1+fBenv1y10x6eKfbNrwXetsTOGi3B1/2vEfQcR6HaBjGL2PDLtbFT1QMEtAYvn5NoZ3CoULmio97+IFqRvNZoaN0aUcHOfkqkh2kg0PJcnmm5Wyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAwbJcgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAwbJcgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B79AC4CEE7;
	Fri, 17 Oct 2025 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715070;
	bh=9L6OiiQQSimbIJjAF3KE4ce9v/7g09pCzZiLHMpV9HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAwbJcgMAmRg1b8mRGi8OaI/p9Fno78ogkD0qbaVlEIJhe7HbmuBLy0MHofqB/eC5
	 5DX4MOpvGpBTlChPpf690y+sWu/PT52dfARJ+4dL7/ux7Mzs2EboyVjDZBaLF7Ve89
	 Y7byJmVF+zsi/x9GmNL1w9wp15wkb6H2yPX76VjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 086/371] drm/vmwgfx: Fix Use-after-free in validation
Date: Fri, 17 Oct 2025 16:51:01 +0200
Message-ID: <20251017145205.050501808@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7ee93e7191c7f..4d0fb71f62111 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -308,8 +308,10 @@ int vmw_validation_add_resource(struct vmw_validation_context *ctx,
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



