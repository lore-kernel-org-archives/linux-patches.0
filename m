Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73CB627F2;
	Tue, 23 Jan 2024 00:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971086; cv=none; b=brGGbjPICDr6kv7MPlnK5yK6az/HgGOW6SpsI5QWx0j867gBKXmk5i1kCcOYbLbZ0RhvkDgDNhGggKtZ5llHY7iqCFSB046AQuPAF38mZIfrqIxn1MS1g08y0fr3yronnY2ICg+vZznQa3hf8Ht6bDUvmEqpOFz4hvXjRKIyV/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971086; c=relaxed/simple;
	bh=kI0Gv9MYb9r7+g0qBRCvzryxNzHgKAxjUYgGrky2hFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gm7tXQUXUaS2bGZmemuJLDdtWEQ0nxe+QkS9s/yq9HhzAHo9x3W5iZAnjoEYQ9hL3b29CO+/B1od955PJUwUdqtXhd95857fqULPDauhPLEA2E/3QG6+PnyoMTx1EMZGuZevtfkaspxdxU2ovQ+McJ43zUdJkEtANipfyogw5wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5W4zPkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5W4zPkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8CAC433F1;
	Tue, 23 Jan 2024 00:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971085;
	bh=kI0Gv9MYb9r7+g0qBRCvzryxNzHgKAxjUYgGrky2hFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5W4zPklcZmdOYHfxDZBISEMnT1/Fuei08JnGlHLqf8bIUliBshT1I3ipsGuqDVgF
	 tyQhP7LAv452uURIh8mMRm8/hvpWP2oyVy2SI0Ve2+HQOe6JvCspLTR47Z8Q6md9ay
	 HIccAwauWY2C04cc9FFwz36t4bt8pLf4K+YzRsh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/286] crypto: ccp - fix memleak in ccp_init_dm_workarea
Date: Mon, 22 Jan 2024 15:56:31 -0800
Message-ID: <20240122235735.308520465@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c15625e8ff66..7e2fbba945cd 100644
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



