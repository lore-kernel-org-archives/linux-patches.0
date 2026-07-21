Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9923346D543;
	Tue, 21 Jul 2026 15:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649000; cv=none; b=myg9Jtl7nGjVHEGImTjlWq2A6MOjc/FJVWrmv83UcTDDoh+8W9Z7dyURJAJzEP8j+xTt/l0uKnrjL5+t2C/W9r6xmH7jKBYpyMi9RJhZeQPWo4JDoZsq1eMEdqOE0/HsFhuHzgt2DVj/9V4YlfCR2SV3RdPMVLM/7l39ZItxh2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649000; c=relaxed/simple;
	bh=cgPQ4BUKv4hXubAxxxoPlpTQI1f2JIysYaTTDvRrXR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmemXcIIjtTmG+32BJawm1Jbxg2LG8xLcA1YV0KCFUtOjiWJLkpET2+2U6m6M7NkOOSmtc21Y6K5Gro6cYmmIdaR6g0Hn9Jf9sCv6mcMIJlAai9rbzoC+qjbFb5liQmDuUn0I0LkLjzAAR2tvl8Y4DSE45Yg/X/6GlUqDhDbFz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2Ckpitm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2Ckpitm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFFB1F000E9;
	Tue, 21 Jul 2026 15:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648999;
	bh=NbhPG8HW5ucMHF0ey3DZLJKXdecXCLoVhJLRhylfDjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2CkpitmyoQpD4aTS9sqpB1YTtZGNLvo8hY0vnZTaXb4zoeM9im7ctnc6h9iWd9+8
	 KvSLAkIucflxP8W4Y0gXRtp8kZTI5U3Nbw4KTwzS4rTaaeGy7ZKzyQwV++ItcFgDjS
	 HVWjJWhsaYgbRFZSEu68Ltv8cA6UOhZtjCAGScgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0369/2077] crypto: ccp/tsm - Enable the root port after the endpoint
Date: Tue, 21 Jul 2026 17:00:42 +0200
Message-ID: <20260721152601.393159742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Kardashevskiy <aik@amd.com>

[ Upstream commit 50e506201bab875545c7a9443bd7e1c71804e553 ]

The PCIe r7.0, chapter "6.33.8 Other IDE Rules" mandates if selective IDE
is enabled for config requersts, a stream must be enabled on the endpoint
before enabling it on the rootport:

===
For Selective IDE, the Stream must not be used until it has been enabled in
both Partner Ports. For cases where one of the Partner Ports is a Root Port
and Selective IDE for Configuration Requests is enabled, the other
Partner Port must be enabled prior to the Root Port. For other scenarios,
the mechanisms to satisfy this requirement are implementation-specific.
===

Do what the spec says.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index f303d8f55991b5..46f2539d2d5ab2 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -58,13 +58,13 @@ static int stream_enable(struct pci_ide *ide)
 	struct pci_dev *rp = pcie_find_root_port(ide->pdev);
 	int ret;
 
-	ret = pci_ide_stream_enable(rp, ide);
-	if (ret)
+	ret = pci_ide_stream_enable(ide->pdev, ide);
+	if (ret && ret != -ENXIO)
 		return ret;
 
-	ret = pci_ide_stream_enable(ide->pdev, ide);
-	if (ret)
-		pci_ide_stream_disable(rp, ide);
+	ret = pci_ide_stream_enable(rp, ide);
+	if (ret && ret != -ENXIO)
+		pci_ide_stream_disable(ide->pdev, ide);
 
 	return ret;
 }
-- 
2.53.0



