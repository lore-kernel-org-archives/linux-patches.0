Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6525F574;
	Tue, 23 Jan 2024 00:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970501; cv=none; b=UqquzqPhkvTqsN6Y45VCh0asSLAGupnGYhcIlxBHhdlJoYcsvRvj1C/Iiyno7+PxT9GO3t/WOG9kpXj7hY+PiJPU9MPEFH1+MAP/ha88G1Y7tzLvfXt6MnlrbslffLDj2kTJ3Bby1bJeYysFk3XmV9fNZFPzJRzj74sFNSLqFG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970501; c=relaxed/simple;
	bh=t3NLT5Rc/t78/jemK3dQvnz4XIDK6v8HwVkzNqJlf6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXnYy8zIslIgEtbQYcOaUXCNCgSoXr/TOKoNgKbj4pN8WT2kTj7WEKUfcEas5tu+IraDi8ubeiMjDLOMTQZK9WKflra8cJF7Ca8CLtq+xKidDmZszmDmgegzKirtzGeN++CdZaQgN0nCCPmxdKZ8E7lMI6SGs1wqr6H7fgPajVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9ZNuobh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9ZNuobh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8089FC433C7;
	Tue, 23 Jan 2024 00:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970501;
	bh=t3NLT5Rc/t78/jemK3dQvnz4XIDK6v8HwVkzNqJlf6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9ZNuobhF9C7VZmt4ggLvXdpb4BZ2yprckIbgI3t6UfrXVtTzzGTP69f9L0SH9KoX
	 g02g+MtUfmrscvLHu5Fa5aVlW4DyJrwj0IlOFceEISvd6WltownIlVgcXkFDiwIcgu
	 CHAwQRdJc7EU4tNH1aTkg9oDzq6aC4Dp2C0ES3f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/417] crypto: ccp - fix memleak in ccp_init_dm_workarea
Date: Mon, 22 Jan 2024 15:53:24 -0800
Message-ID: <20240122235752.861539484@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



