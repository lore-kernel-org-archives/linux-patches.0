Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0FB148311;
	Tue, 23 Jan 2024 00:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969144; cv=none; b=kQnbvaIpe6xlbKa/CV46BG6N5dAiyiJt5D4ZVgOV6zYzkvl7zMhWfZumYUMCocd1spDql8e5U0QEEM0t/JZUbDdG4ZY1dua+97jNnehSmcUXlWnCVwBFkI4gYCXUP567uuQ8FjJsTRdzEl/IhVk9hLBTsyBA0WrjhnsXuEWLRsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969144; c=relaxed/simple;
	bh=OVfRMAiEua1gz2ytz5PN7o5OinXIDpLypplU0o/q0l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7R9nOX7f7r8vpx2DQOOWt86tZ1HfVwckMH2BDHo8Qucg03fGf7y0hA5+SKutElQur97ouoOZKpcwShimqWFNq8hzJRlHTzYVFy51no7471NGCTisNHhrVRqZyKQlAgX1g6Wu+j27Jd+gtY6WrZZoZOVVxZalyVQPx7eNJGKj2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ic05gzbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ic05gzbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A07C43330;
	Tue, 23 Jan 2024 00:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969144;
	bh=OVfRMAiEua1gz2ytz5PN7o5OinXIDpLypplU0o/q0l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ic05gzbv/0HsGyc/LueJPMn7qtP7Z/My8FEgV4//MqMOjhIYOzpuS+6sePAQPjgNp
	 jffKw6ocvGDSaaFM6zTbcIHW423PouMP6LeZWU+gTWVS9aEa2hcqFU3Y5TjzB1P0HW
	 Xponl7AssMVdZ3qpr4ZOtP64Y90DLTp5uQqw95Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 050/641] crypto: ccp - fix memleak in ccp_init_dm_workarea
Date: Mon, 22 Jan 2024 15:49:14 -0800
Message-ID: <20240122235819.639369484@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit a1c95dd5bc1d6a5d7a75a376c2107421b7d6240d ]

When dma_map_single() fails, wa->address is supposed to be freed
by the callers of ccp_init_dm_workarea() through ccp_dm_free().
However, many of the call spots don't expect to have to call
ccp_dm_free() on failure of ccp_init_dm_workarea(), which may
lead to a memleak. Let's free wa->address in ccp_init_dm_workarea()
when dma_map_single() fails.

Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index aa4e1a500691..cb8e99936abb 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -179,8 +179,11 @@ static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
 
 		wa->dma.address = dma_map_single(wa->dev, wa->address, len,
 						 dir);
-		if (dma_mapping_error(wa->dev, wa->dma.address))
+		if (dma_mapping_error(wa->dev, wa->dma.address)) {
+			kfree(wa->address);
+			wa->address = NULL;
 			return -ENOMEM;
+		}
 
 		wa->dma.length = len;
 	}
-- 
2.43.0



