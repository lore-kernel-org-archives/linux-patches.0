Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DD04078DC;
	Wed, 30 Sep 2026 19:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796753; cv=none; b=IO7MP+9aaCYmSM08/1aI7BOsKDrEu4+kKiNuFhj0EkJiJcGjJGPmp9GIbv+5qdbb9uWQ3UctpEqLBdT2K1vFANXSf6OaLCaq0oAlBP/jbpQ5frYjo/AIqygB8Sl5Zf7NQWVUq2dT9uWKKj0M1sVmQhdYomKQEydFwIVDeZlpPd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796753; c=relaxed/simple;
	bh=4TZ1w8bP0x5OinW1bmx3tnqoFuvIcXL/ucox3QesF6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8SYOpadFBeIxEpABG9io2ouoTevPUQjjdv8tQxUUceLg/ddzf3jAo+y4Wd6+fJLml0MIR1vd4sHq+9/MOUUWqhWwBio1SdNrSRWskGhnzpc1EWDGrqe2OEXbXQoqCRvh+iGJwzuOeujdaayqNk0IzzHR78klcLCQ4ARck5G4oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOqj1t6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOqj1t6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC3E1F000FF;
	Wed, 30 Sep 2026 19:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796752;
	bh=D6zZpTIdQ5iRJT9+bN8t88VtzLiiEt7E/cIn0nz2xBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOqj1t6SX6ucs1tJizJ2hK41d4LluREDAnIImSxfZJPrI+Vce/a+m/zn7ogiW/ekx
	 OKK1mBGHwG/JxcVku37SXzYEnRz3NU9a3YAb7fV+4aGRt/StPh5bODi7Uw8VX/su5i
	 Y+jJh8s8bpwncHbtvb2eYyfKQGZeTWw0XmYdNkSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1024/1193] net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error
Date: Wed, 30 Sep 2026 17:28:28 +0200
Message-ID: <20260930152456.985218393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c33a9c9ddb5a..13412d4d24da7 100644
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



