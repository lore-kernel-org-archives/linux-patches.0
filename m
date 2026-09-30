Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03F551FCB5;
	Wed, 30 Sep 2026 17:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789182; cv=none; b=fTXu/2zxZUtx/RtTAEcBggMKKOx/blr5CK11mE6utvf3elbzK5ZWY/lXCV8X4UlXA5cZlCy2IokhIZMBEewh17irMeBy85d3yg31h4HqqiizxK1OyN1p9jVla3+1diwZxBG0nVZkVIsVKVlZ8s8JDOq4uO5/Ud9bQbPtCNtF/00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789182; c=relaxed/simple;
	bh=vFiuj91as/LPCQqyZqQovEPhTgFhUUcyIObBxFnJ04o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxylJ/CPE9IPTRWYgf1L8ACPU4WJko6E42FwA19eS9/ONemya0tNeJeYyGkHFN/OoflLp397599sf10DCuur+2Im/Qhj4YWQTycW6fu+7H51Ib74FKYnO4tTD5JdbWI3Ma+bDGDZo8HkQ3zToH346x7GeA3aaziNUPGar+oMaPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXayAb0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXayAb0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E381F000FF;
	Wed, 30 Sep 2026 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789181;
	bh=VETax4+ycpPaQ3ASta4NX4G4qbwC6qax2M19jyGk57A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXayAb0mJSzIBn/3n2crVTC2WZHUWMdyoSvo3IHeDvtcSs9hjbRj5H/EoQRsSbuc5
	 FRNJ+qBRysaM5iMxjm+HCSR5jv/S1DNCn3jCRGBL+5cCDK14xXh1ayFxc9vf452J0x
	 5fQusMR2KMJKUZBK44Kmo4RyPD3WQT13aLE1VHKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 386/877] net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error
Date: Wed, 30 Sep 2026 17:21:37 +0200
Message-ID: <20260930152423.011076855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d07dcffc2517e..15c2a6dffb8c1 100644
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



