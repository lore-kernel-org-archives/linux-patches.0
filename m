Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB2A516178;
	Wed, 30 Sep 2026 16:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787196; cv=none; b=R1rXhHK/zut54sMnMJn8hdHYsY0AO53nCIqGPCadBJP5rKdtqxcf2lMhwaOO57ouLVzyoLlLLOP4jxI/p2Zf8+UnozSWk9AE2uVZ91SuSNNPc0hD1XNuS6OeSoLp9sY7p37OFBS27eyKyCavtyIg8Tep/P7wF5r9WYkR9hpZfrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787196; c=relaxed/simple;
	bh=we6s5xzMexCVA2A41+uFvCT+D/iWkOR5LeDnGDd7Xt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otADu/7Iq26/5VxTaFJQIk8XdpexF7KTpYi1SSTw0pclDODRLgbZ9M98pazMEVN6K8FSzU+jGu1iOyZhyEplcwwDgvElmuDyAkhRVdmZYxFC1sw/ogHrG3acjbXyu9hMuSsEFlcY1knTcIaH8NFyynEndLVOw0OA5bzH7UhIg30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uclFTeQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uclFTeQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF411F000FF;
	Wed, 30 Sep 2026 16:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787194;
	bh=4QSSmyT4rCxr/HNw1k507mPHUEl8jRO0GJtYle0RnK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uclFTeQHNX2LJ3u0cnGsc0K8HG2m4qDR7v2MCRyw5efHk02ukdVo7X+8e67mb2gQs
	 Ck06eSzT6ImGEu7nLG1QmJnW6PHIawtQRt4wt8xPe0Vdy7yW7bRA2YZz4OfLn6x48O
	 1K6d+XjNsv+i0pY5ewMYplVkZXnDhbNvgAL1bcz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 144/457] net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error
Date: Wed, 30 Sep 2026 17:24:09 +0200
Message-ID: <20260930152349.160876528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index eb8fc2ed05f45..4f9e20468bbbf 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2225,7 +2225,7 @@ static int netcp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to enable NETCP power-domain\n");
 		pm_runtime_disable(&pdev->dev);
-- 
2.53.0



