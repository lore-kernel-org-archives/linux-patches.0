Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137762EA166;
	Tue, 22 Jul 2025 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193712; cv=none; b=IEFFMLOQJ4eu2npl655vPNqmECmN7C31+SMVBpQNvgcU5mLdKdxXaDn5PZQKXtWFwYmdzKo8HHVlWkF/yHpxumOapQvcUj0ECQubDfm+agYCV9oUmCyFA3yTIDtMbQbb0B5sxQZXKm7F5m8oGellUf8uAzYudl3qHwuVkEMQObw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193712; c=relaxed/simple;
	bh=fBl+jLLN6ggiFmyf17lBYxgPjMCFT5qviGy8h2Mby+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avP0JyuZyjrY/C9U7FT5352MV6A6qZLZ2A2VwvVWVUMcmRS2lnKePYt0vIe4mY7mFzHhPMZf+KEP2yH4G/H2OQBL6nnfPakiygNelT/5rK9VhVpHbmC/Z89lh9hQve8ykl6YUv25GWzbaHMClCka4A9CCprTfNedwsXLsLGwYtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXxr5cPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXxr5cPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5DAC4CEEB;
	Tue, 22 Jul 2025 14:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193711;
	bh=fBl+jLLN6ggiFmyf17lBYxgPjMCFT5qviGy8h2Mby+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXxr5cPVllSBBvl8xLieerij96KZFaImWmvw2+guTJLyX29YLT3feA6DkNIUjTTjN
	 +sq+L1Y412KekmzHmF9tlBTO9oy7l9IauFV83EBfP7NSKyNXo8F2GT0LAOIZBAgLmu
	 nHLKcpG4opGPL5+mjv0xQoibVTrEgPgZaqZlXwMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 142/187] net: airoha: fix potential use-after-free in airoha_npu_get()
Date: Tue, 22 Jul 2025 15:45:12 +0200
Message-ID: <20250722134351.081474275@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 3cd582e7d0787506990ef0180405eb6224fa90a6 ]

np->name was being used after calling of_node_put(np), which
releases the node and can lead to a use-after-free bug.
Previously, of_node_put(np) was called unconditionally after
of_find_device_by_node(np), which could result in a use-after-free if
pdev is NULL.

This patch moves of_node_put(np) after the error check to ensure
the node is only released after both the error and success cases
are handled appropriately, preventing potential resource issues.

Fixes: 23290c7bc190 ("net: airoha: Introduce Airoha NPU support")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250715143102.3458286-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_npu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_npu.c b/drivers/net/ethernet/airoha/airoha_npu.c
index ead0625e781f5..760367c2c033b 100644
--- a/drivers/net/ethernet/airoha/airoha_npu.c
+++ b/drivers/net/ethernet/airoha/airoha_npu.c
@@ -344,12 +344,13 @@ struct airoha_npu *airoha_npu_get(struct device *dev)
 		return ERR_PTR(-ENODEV);
 
 	pdev = of_find_device_by_node(np);
-	of_node_put(np);
 
 	if (!pdev) {
 		dev_err(dev, "cannot find device node %s\n", np->name);
+		of_node_put(np);
 		return ERR_PTR(-ENODEV);
 	}
+	of_node_put(np);
 
 	if (!try_module_get(THIS_MODULE)) {
 		dev_err(dev, "failed to get the device driver module\n");
-- 
2.39.5



