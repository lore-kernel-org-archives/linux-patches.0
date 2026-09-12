Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D272356A0D;
	Sat, 12 Sep 2026 10:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208182; cv=none; b=esb6DB4qKEroc96DTikBQtqrO7xmP3NCgLedBoa0BEC9iLVqGl4uq7NxW/2c5Wq4boTicaGs5g1D7I2aa3nFBfkWIkSqm+YMNHs9U0yL2QNA3fYC7XmlGGLCBGX3UjOxPujORpHZtdQxTJvKw+nvCAlVyPehlZCuObWeJ74iDps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208182; c=relaxed/simple;
	bh=Bz3DeqTNJFfcmvT69cpYCgcSgLIG0Lep8ejmP/48ctg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeNy2oFM6hw4JoC9CyhhFx/VUWYS3LVV2rV6TXWrOU/seU8CsOHHAxRHxCsa76Ax/aeumDDc/SGWUJPxQqCL1uPLwOt9NvXqhOIoIGjihSEoVgUOsfE3hu+YSvrBceplEc/ZU+ZY22+Y0QKQnT8gnwF7RA0f4JQTBO45sGktu24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBX7yoUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBX7yoUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315CB1F000FF;
	Sat, 12 Sep 2026 10:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208179;
	bh=XzcxSvH6jyxQ2ab+uYaR2SxHcy9Mo8zKDy6FSpAucug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBX7yoUx7fsBPtqmUoYypbBwFDZxL5cWQ+MS8jAHq8wG0Up3MF1wlSCdMPK4lcmj2
	 2hwXO3ivITWWh2HNXES9S2v2kKB0F1b9yj8lx9yukEhTGkTdawbw+dYmhU8zrppnSa
	 Cz6Z6KKDwNQNk+cFjbtmNKFHh5wDPxQJrCPb6foA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0566/1518] drm/panthor: return PTR_ERR() from devm_drm_dev_alloc()
Date: Sat, 12 Sep 2026 08:45:35 +0200
Message-ID: <20260912065636.234911392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit abc1e559f8e5996eee506dfdc8e3781c2a1e04f9 ]

devm_drm_dev_alloc() returns an ERR_PTR() on failure, but panthor_probe()
always converts that failure to -ENOMEM. Preserve the actual error code
returned by the DRM core instead.

Fixes: 4bdca1150792 ("drm/panthor: Add the driver frontend block")
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260716140337.10679-1-osama.abdelkader@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index 4c202fc5ce050..687fa282b093d 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -1630,7 +1630,7 @@ static int panthor_probe(struct platform_device *pdev)
 	ptdev = devm_drm_dev_alloc(&pdev->dev, &panthor_drm_driver,
 				   struct panthor_device, base);
 	if (IS_ERR(ptdev))
-		return -ENOMEM;
+		return PTR_ERR(ptdev);
 
 	platform_set_drvdata(pdev, ptdev);
 
-- 
2.53.0



