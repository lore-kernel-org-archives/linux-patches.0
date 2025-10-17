Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C092330B26;
	Fri, 17 Oct 2025 15:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716408; cv=none; b=ujhSjXH8i0Mip2Jg+igkLy7R/7H7aoRJaHU5pkgJnmqbcmHp0sJmrPaNL46TGxQZmLAjOJmUZO5AAlsY6zVaWOXbc1ywo8X1+7j24UAtRAFwv6ixnhXYp2KF9EIV4hMUI7qRzOrHxvn6DnxZkFMB/tWOSY9AnKRK2j/twqwdVeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716408; c=relaxed/simple;
	bh=46o7K7f1sdce3gE2ddfG7LmANUWVysKZkkSTBcKdn0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhMdvdrNPtan09vhDzr5mD5Yw5p8er4AhYHMc6ybV6wA5Wcg5v8aLEgFx8UG1N9DcENbQwCnA0wZW1Q+2CbmKtFPlgBcN6lIz9dXr9wTvNtogSiFoO6Ax8tG+cim1T2wxFpjFX5ZNQqbhbyg2m1ZNCWQcYtyMODRm1Sge7nwI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9glP2LH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9glP2LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB591C4CEE7;
	Fri, 17 Oct 2025 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716408;
	bh=46o7K7f1sdce3gE2ddfG7LmANUWVysKZkkSTBcKdn0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9glP2LHDilPp5zdvGSbxGjwBTw7KSwXKvxuB92WyfHe5gngPrPNUGAJfR05eP05+
	 gGfTSZOgnEwBVNOHKoev+l8CR9lypUNaWTZHMoHZ7mCZLLkrAPr7FUGvPzCUjAyYvs
	 kQnY659H0HfMbHNAZFah2CYDAM4plQOPojKOyj9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/276] drm/vmwgfx: Fix Use-after-free in validation
Date: Fri, 17 Oct 2025 16:54:01 +0200
Message-ID: <20251017145147.883882121@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 41b7417cb5d3d..4633bd3081852 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -343,8 +343,10 @@ int vmw_validation_add_resource(struct vmw_validation_context *ctx,
 		}
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



