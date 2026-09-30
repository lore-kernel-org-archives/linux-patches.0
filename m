Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36072514770;
	Wed, 30 Sep 2026 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786428; cv=none; b=bIF0yijEBq/NXZQqsUnefVJHVkSKQuBayp8+9E6UkYpmOPp4gTCcmJeVd+XUEsNCtLwJKXqowyqiXSKzSs3AnHdpx/ihuuWYONmdN4d7FRyWaqV7bvcdC3lwVU2geTqZhVGDUwLVn6+uzk0mVKgMiiXoCppEIFXTovx0cqD4lzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786428; c=relaxed/simple;
	bh=oUUVVai8WZPZB+Q/PeT2XQNPmt8wzzGWkwEXPN27Axw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWc4JCbFTB74D3ybdCanNuYmNjuMnZ4klmfbXoLOMA6YrRcntgLRNJ5BHzeYpPlpbRwt3DLdLkcepExacFioEUguXW4Hr31TNG/XnAaxlGGNN5NQS1VND11EOCTwlZeuUmN69PdHgPlwJsBdeA4T3QKc9QEy0+R4TUMI46nf8j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXLTzyI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXLTzyI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7211F000FF;
	Wed, 30 Sep 2026 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786427;
	bh=2e1lE7kL12EsqZhrpVeiw5OJKT/DqZGweCAIBBfe630=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXLTzyI+uz1X4VUilQ+k+3WLFg2N1sOpDXb119pxUdS1TK4TGaiGgyppWG/fAHrvb
	 cQdMYAJxvkUjaW5b866gwkJefm0HC32GVB0qjV9iojiwEHm2uSGH4w4XAOdfQShCFm
	 bsgCeg4H6VN4VwSGZMuZkzJl0e76Ken0EHTH39MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 858/982] net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error
Date: Wed, 30 Sep 2026 17:26:34 +0200
Message-ID: <20260930152435.174968251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit ac4334522e4ba4a3b6710dd5d4cc98092824b8ca ]

pm_runtime_get_sync() leaves the runtime PM usage counter incremented even
when it fails, but the error path in netcp_probe() does not call
pm_runtime_put_noidle() to balance it, leaking a reference each time
resume fails.

Use pm_runtime_resume_and_get() instead, which automatically drops the
usage counter on failure, fixing the leak.

Fixes: 84640e27f230 ("net: netcp: Add Keystone NetCP core ethernet driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260918042804.13101-1-phucduc.bui@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/netcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 6c0c9b795c8fe..21bee6a5172a0 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2167,7 +2167,7 @@ static int netcp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to enable NETCP power-domain\n");
 		pm_runtime_disable(&pdev->dev);
-- 
2.53.0



