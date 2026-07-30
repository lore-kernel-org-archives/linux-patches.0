Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDFB33D4E2;
	Thu, 30 Jul 2026 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422681; cv=none; b=iNRMbILBM1DWNePnehPQ/BFxHdxvdXdNzN/dxJBTz3/fJEvUtBSdbAmahvqmF2BB6+GSNidJcAX00AZZryuY2xgbOTx9hO7bDCnsrEtsWgUQw0x6i7HEy1i20od4tvWNg2fwY4X+9t/IDl2O/5VwlNdSwCGb5dxoA6wB6JxUbqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422681; c=relaxed/simple;
	bh=GtF8J5jkzt7l0JDZkhFRPaTaJR7zFVZK4lL6LxjWp7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpUeZes/wM8G3QoJzC5cn4Vqnk8eQnwvPpP0cNU6XFfgsfil/FD7RuhHzmY8nwr8QdnMx5MCdbTsg2NdZglvmQDtZv5kYiVR1aukqppEclWD4UIBWiswjrbOJ5RLt7AXXlukGDucoEAiOwERMFmwAZcZsSoH8uSuvIFHJCnUZvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOWxiicu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOWxiicu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F1A1F000E9;
	Thu, 30 Jul 2026 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422680;
	bh=RSH9LuNy+99/wMHo3KtZJxuyWrjdGUfP0nS3SNmlp9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOWxiicu5CLr3UbjHmWmS5nGI4xf/W7qnZSYylYXhIqql2CWQDpHwynWYEJywKO9r
	 g0K3xi3dsBbqKg1A6YWvFMtgU1HPqrzn83dkOR4uikepC2f+z7yQLtfYRmvDpyKLIp
	 r6H2tZlDRdjPYkitvs0BHkcKqtifBUfL7WTkpYsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 522/744] media: ti: vpe: Fix the error code of devm_kzalloc() in vip_probe_slice()
Date: Thu, 30 Jul 2026 16:13:15 +0200
Message-ID: <20260730141455.370175970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit e8f319eae96a3d718e810d52432020a2b77f5f60 upstream.

In vip_probe_slice(), the error check for devm_kzalloc() incorrectly
uses PTR_ERR_OR_ZERO() which returns 0 for NULL pointer.

Return -ENOMEM for devm_kzalloc() failure.

Fixes: fc2873aa4a21 ("media: ti: vpe: Add the VIP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/vpe/vip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/ti/vpe/vip.c b/drivers/media/platform/ti/vpe/vip.c
index bd34c982b427..cb0a5a07a3d4 100644
--- a/drivers/media/platform/ti/vpe/vip.c
+++ b/drivers/media/platform/ti/vpe/vip.c
@@ -3490,7 +3490,7 @@ static int vip_probe_slice(struct platform_device *pdev, int slice)
 
 	parser = devm_kzalloc(&pdev->dev, sizeof(*dev->parser), GFP_KERNEL);
 	if (!parser)
-		return PTR_ERR_OR_ZERO(parser);
+		return -ENOMEM;
 
 	parser->base = dev->base + (slice ? VIP_SLICE1_PARSER : VIP_SLICE0_PARSER);
 	if (IS_ERR(parser->base))
@@ -3502,7 +3502,7 @@ static int vip_probe_slice(struct platform_device *pdev, int slice)
 	dev->sc_assigned = VIP_NOT_ASSIGNED;
 	sc = devm_kzalloc(&pdev->dev, sizeof(*dev->sc), GFP_KERNEL);
 	if (!sc)
-		return PTR_ERR_OR_ZERO(sc);
+		return -ENOMEM;
 
 	sc->base = dev->base + (slice ? VIP_SLICE1_SC : VIP_SLICE0_SC);
 	if (IS_ERR(sc->base))
@@ -3514,7 +3514,7 @@ static int vip_probe_slice(struct platform_device *pdev, int slice)
 	dev->csc_assigned = VIP_NOT_ASSIGNED;
 	csc = devm_kzalloc(&pdev->dev, sizeof(*dev->csc), GFP_KERNEL);
 	if (!csc)
-		return PTR_ERR_OR_ZERO(csc);
+		return -ENOMEM;
 
 	csc->base = dev->base + (slice ? VIP_SLICE1_CSC : VIP_SLICE0_CSC);
 	if (IS_ERR(csc->base))
-- 
2.55.0



