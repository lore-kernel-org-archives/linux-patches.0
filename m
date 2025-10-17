Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5CF33711C;
	Fri, 17 Oct 2025 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713545; cv=none; b=nYCYxE4mqeF5ITah8VbxJVaH4FYzXGMhUxrJDKV2HYgVBY6tTynqTk4L8m+mnYMB0J4jBKra2ILuWML1m2jIKAPNnb2SbPagy4Y1CenPx5I2ZEPNNdp2esOsVUVHM+vzo+gVGXQhtq82giT5iId4VPm/KWk5Rd7ZxanDoCM3bdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713545; c=relaxed/simple;
	bh=oJKrRTVNnxNRnYQTrWFN+DM8ubyA56rt+/Xch87EzHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UK3/4+3EYSTxyuN2WhqM3mnwTMjx6IP0JsbWZE/2eQRRwoETamlvo/9g1xeJH8FQhC4aelW9tE3tlXfhgEOb6Rq+mgXd2NFtdLbFPlFJ9C2dhrHI7AXSFt63lJrr7QLZyVLObsJ5NO8n61htb494BdF49e+90htcfUtLfUpq1PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XK9BL8BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XK9BL8BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379BAC4CEE7;
	Fri, 17 Oct 2025 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713545;
	bh=oJKrRTVNnxNRnYQTrWFN+DM8ubyA56rt+/Xch87EzHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XK9BL8BGuEsX1Rm4sddLY0knlTmUr7CtrA5POcIQDrHBqZNKBc3Cmi/7vo9XCDUIi
	 9rzYcmKM3zZa/XldsUypg6Ar9s8xIUsz4SNvaPsPfcYXD/yLKyegw/b+4b4MSAIqPs
	 Wuk957WEEX74JD24x/7B42x/+iIo0zoSig/4MBVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/201] drm/vmwgfx: Fix Use-after-free in validation
Date: Fri, 17 Oct 2025 16:51:35 +0200
Message-ID: <20251017145135.998133296@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aaacbdcbd742f..a4a11e725d183 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -326,8 +326,10 @@ int vmw_validation_add_resource(struct vmw_validation_context *ctx,
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



