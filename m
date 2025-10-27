Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E28D31E106;
	Mon, 27 Oct 2025 18:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590561; cv=none; b=Ay5+YUqnq3ty9z5zeIJOfzQQz0w7GrvqRitiowpEJnYWlMlpK56zk64dxAziURzVBNixWKWZm5LTu5HB44bThhG5k6gZRDAlSu/r9Z/QGfTqPNkmCTiFBYVts1LPLgNTlMDlkKICc/bvQSO7zbwLgQCbemJEkdoDJ/TqIFSH3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590561; c=relaxed/simple;
	bh=ZWOE/bu7vxRAOGPglNMnesNvrv5XrlHQjVaffsHDnyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6GnzoSn2cOMMoxtT9lACIOLwvEUnzXAQoTeKk9ufOTbApA0nreZwwzVaJ0wUqeb8dsu74Eo0nBitqxjuK5Y9rZHmnTNFfNSNLnlouGkQV5Pfel4TVPp04FRaC2H7J0N8paB3CFtIV6NhDZ6AiPHuIyLEl2CXVvMxz0zk55yEDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFWQseYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFWQseYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9457AC116B1;
	Mon, 27 Oct 2025 18:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590560;
	bh=ZWOE/bu7vxRAOGPglNMnesNvrv5XrlHQjVaffsHDnyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFWQseYY4DL2qacotxhyPPVThmrTL2Fp8gCuBnKVk1tmIMp2lw048v7XAst0zRHDN
	 gshWzpDjUfm20qoEgFdRfjpQf3WbKlKkoflkSzENoqyF9bjHgcM4KobGAJSyQRtR/2
	 wvo8iayb7kWIuxmZMq84XHeviBDn+GI2lqr7PT5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/224] drm/vmwgfx: Fix Use-after-free in validation
Date: Mon, 27 Oct 2025 19:33:56 +0100
Message-ID: <20251027183511.402158682@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f611b2290a1b9..a18b9bb0631c2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -339,8 +339,10 @@ int vmw_validation_add_resource(struct vmw_validation_context *ctx,
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



