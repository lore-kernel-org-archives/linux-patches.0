Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E3B2E06E4;
	Sat, 12 Sep 2026 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216171; cv=none; b=o5nB/IIheUpdG0oWHiYg3z447gY1RPmg82qlmB6nCZlMbkDOnGwsKkZlRAHo3Bexh6HPVa6T4N9seItCNFlTh/JXu7G+5QmAVjSbAPZGiwIu6fYoIyh67uT5JEL9ldrKnRXIfBn6jrBeuC5SewebXVpV1f9RD0azY4lRm+//mUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216171; c=relaxed/simple;
	bh=6m9DrxWY9zKMVech8btSpXEGMD0qonG2Hjo1TJSTISo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTcyjYHek9BTQ1shTg0vVmKl4uP3cH8Vm9Qu+/o9hnwSVvceLuz6RAOwi46jvWckTdMbmx9FwpSFPgiLIrEvgp8w279FuNMZLDYc2C/NxnD4fMm5W3sSRF/jZ3z8x8uv2uA8JmqU/tlL/IDj1DPC7sd8X8LBZSMPAIusgVEF0TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXBhFcwK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXBhFcwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8401F000FF;
	Sat, 12 Sep 2026 12:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216169;
	bh=DI16IMXimEw4qfjs7sDX0rVlH50bW+HSaUtuso49Cqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXBhFcwKGcweupd8YUMU/Iheh9xQIi+WQ/3vJjz3fCG2q21fX36RWNojbtWa3L3Hv
	 +BOkEvz1vo4UJf0bF2S1KliSGGLayolCrhZU3f5uC8No9R1KOzh2FgoKZmob9f1LCg
	 ylZ+z9RYHvN0ZTiHbad94YA3MIKQGfUjY0PzwqAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0681/1376] drm/panthor: return PTR_ERR() from devm_drm_dev_alloc()
Date: Sat, 12 Sep 2026 08:51:47 +0200
Message-ID: <20260912065622.725025450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 9d4bf7406e246..46aa5ed815896 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -1427,7 +1427,7 @@ static int panthor_probe(struct platform_device *pdev)
 	ptdev = devm_drm_dev_alloc(&pdev->dev, &panthor_drm_driver,
 				   struct panthor_device, base);
 	if (IS_ERR(ptdev))
-		return -ENOMEM;
+		return PTR_ERR(ptdev);
 
 	platform_set_drvdata(pdev, ptdev);
 
-- 
2.53.0



