Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4809D225A38;
	Mon, 23 Jun 2025 22:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716669; cv=none; b=GD3Zaek7s4y7gxHnPTn/y1+6foVrO8lc/d7wPGMYoExjZM1UyMpCLf9hnhX90Znwhws0HuhtG5OB8vRSd33wH3Kv2buVjHu8nqQAez2H7/1TSjoseOwGyNMWOk6QYJSAFCXNbMGtYmutaA7GhWuHu5tSLGaLnIP8cgarxnV6Jww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716669; c=relaxed/simple;
	bh=HQOwFkwRQVrT6P53xN04uMNYXTJDNVCJpMBlnJEt8sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bic+7WsXBnm93scdyh1WTXy4MYP68mmHmX2kmYAsWsxE74NpCNzg0ib7bx8Eu4Wj/9O1Jj1QKHc5hD96PILUev72se/SSbRqOWiZ7PMaXDhA/OBG87Ik4hLyazhOOJAvxLHi9XOoOzZ4z39ZHFB4YpquNJ8ApcnnQq88Vtprd7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M96jvaZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M96jvaZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F8BC4CEEA;
	Mon, 23 Jun 2025 22:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716669;
	bh=HQOwFkwRQVrT6P53xN04uMNYXTJDNVCJpMBlnJEt8sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M96jvaZmLQ8NkUIvUuEbUlq7kElqKcKNEZf/JXIaxvjV6z7H5CnwwK39duzeBMhiZ
	 nwRoGJW03LdSCgYH1MduPtdFFI2DTTBQmFXlxlWjCkZhjDEeMMoH8lCVCapkMba/5Q
	 D6Ni8kzQsQxDrMKPExgh8lY9HrdTZcaOh0ty/erE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 546/592] eth: fbnic: avoid double free when failing to DMA-map FW msg
Date: Mon, 23 Jun 2025 15:08:24 +0200
Message-ID: <20250623130713.428755419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5bd1bafd4474ee26f504b41aba11f3e2a1175b88 ]

The semantics are that caller of fbnic_mbx_map_msg() retains
the ownership of the message on error. All existing callers
dutifully free the page.

Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250616195510.225819-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 3d9636a6c968e..0c3985613ea18 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -127,11 +127,8 @@ static int fbnic_mbx_map_msg(struct fbnic_dev *fbd, int mbx_idx,
 		return -EBUSY;
 
 	addr = dma_map_single(fbd->dev, msg, PAGE_SIZE, direction);
-	if (dma_mapping_error(fbd->dev, addr)) {
-		free_page((unsigned long)msg);
-
+	if (dma_mapping_error(fbd->dev, addr))
 		return -ENOSPC;
-	}
 
 	mbx->buf_info[tail].msg = msg;
 	mbx->buf_info[tail].addr = addr;
-- 
2.39.5



