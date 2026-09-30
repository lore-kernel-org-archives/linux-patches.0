Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0204DEC26;
	Wed, 30 Sep 2026 18:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792396; cv=none; b=P7SuHyjfuaL6No2Y17FAb9qa1puZyuaXtMUApshnYAXOE7lT5bjE4c6C8x0pwmle8XYErulFWEg1cEPGKfoPzNCwgS4IOkK/pmrHJia2ozWJsftObfQmeo6Ll+v9V+mzzB3OrJmMgG/GEh6woBvU+YDa6KmFb6fwOM9Pdsrh4P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792396; c=relaxed/simple;
	bh=Pau6dnPg9xt0sNgob+6gY6phI5CR35ZO1OCajbhte4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+Q+nqqId3p/xZ2ml5rr+6NMS/qTK6cHHtb2FXQZogg2tJaNb/j/uPZSv48QAipShn8sYwrJglAZwWxWrXrR98F/mJ8tIRT95xhRtjBjtf7mkehiHzVzUg/44u7rJ/bGvF3Qs4o3AnaQISt/bYt6Zy2SY3YPp+ZoUYShIrU0D+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUXATnSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUXATnSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC85D1F000FF;
	Wed, 30 Sep 2026 18:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792395;
	bh=+hlE9bszGPJHJrREwBoYN13io/v0gAaQ1KlYWkfLJpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUXATnSJSJXEjIzlPfWWFhWFIVEJPnRNSpa6QLHFZbIlN/ViKij2bnXkEpXUCuiGD
	 h7Ep2QnTh1eyU4CA7v5lMhWKQgfF3H8EgqAhhMF8GU5jB0nXPe+Gs+gKOD4ycwKluU
	 3rfGNI1nOhmBcMXBU1wGMX37Kg0yQwN2mb6TYXqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 639/752] net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error
Date: Wed, 30 Sep 2026 17:28:29 +0200
Message-ID: <20260930152412.093293841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 08c6cb16532e5..948b0ada5011f 100644
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



