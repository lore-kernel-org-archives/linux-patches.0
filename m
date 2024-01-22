Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40037185B;
	Tue, 23 Jan 2024 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968211; cv=none; b=Zt6d++IyjQ1++ieItdxWtZ5TAfaUtbh7xqzTZObYVovIoYkXTHXcr+8Yq+1YyxlsOKbwsoaLnsvTCMr6OXFEAUjgfldhblIIYfhKDezd9flw8W8oxMyyDz/ht40i62IpWdbYFf3U9dcLnWeuie8uA+K8S3jWOBEyQToa+H567zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968211; c=relaxed/simple;
	bh=UWRyCGisCrscxSajaNWLlriNVpqhk9C5aiGhaGbxdHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5St5BIhYI/zP0aIm0t9uAIu9YUSMk20tW7K+UY5NAE+oR1z9FTMlDePxZEJCnr6OyZmssXhVww9wWuyc3Mn3eddpRV8Ayf3/Ti+ogtHP3u8UMzFNz9JIsBgD1j+Q9dY0EClTD+yjWTv2zIsKA92VVv8BhdaYVcxXqd3a3CU2J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTyYWL3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTyYWL3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA404C433C7;
	Tue, 23 Jan 2024 00:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968211;
	bh=UWRyCGisCrscxSajaNWLlriNVpqhk9C5aiGhaGbxdHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTyYWL3qgJA+TF8yaLDKoRmphczSKThGxv7lfKpt8FSp8798me4eeCaweNsF6D89E
	 FU4mv/85/kKR/0dsl72XooqkreuBdSFsl5vRSrT9nZXtiGY2Do7hL693mE0GNkePPn
	 2r6yiIrLMTOtn3xVvB5kD3TSrsCa01ZhXvfBstIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/148] crypto: ccp - fix memleak in ccp_init_dm_workarea
Date: Mon, 22 Jan 2024 15:56:42 -0800
Message-ID: <20240122235714.287088798@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 453d27d2a4ff..56c571370486 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -183,8 +183,11 @@ static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
 
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



