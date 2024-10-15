Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B721C57B1;
	Tue, 15 Oct 2024 12:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994034; cv=none; b=nQ8okFpVk2yYN0Q/bBcXo2XisgSekfrnpFTSW/mvMtC8HNOm0y+wO7Nl2DfzZyfsIAK7qKqv+W1OiNLmMV5136yoC0p14skaGe169V/A8hbi8aZyFLiz4jaVPMxriwsw8aD9MtAzNoCMuguXXv/PgybriZSMymmAgP6mZRAnRRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994034; c=relaxed/simple;
	bh=SyGFj0RwwP+htyWm1Kdo5UC9wrsfJJPvb0mvb7gVkgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZvy0Z5KNVZhW0T6oC8i+xN3E63tS4WVhtDVv/s9jDRV8M8y2rEKte5/TLYfyC9ZhtU5wzTSOqryT+mwP6sCq/7pok/4CnBTAZbuC/ZGxB4hFWhHOoFlh+n668VPSBEYpdf91+QCTKq0ONic/ZM3kmFvaGnaAFJM8+YePIaDU1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPxg7ZdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPxg7ZdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39118C4CEC6;
	Tue, 15 Oct 2024 12:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994033;
	bh=SyGFj0RwwP+htyWm1Kdo5UC9wrsfJJPvb0mvb7gVkgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPxg7ZdFjYCj/MGxZ5U2bIAxDdn4lsHP2VIXPYi6lEDJwXvt7b7LMULEV7UQA46dD
	 zOuDd3sdNj0dw7TfsKBr8U2By2tc14UYnhI51utTivzF3qngv5m3F7gmVkPrXTUtGV
	 UidrDDOD7nlUTsl1DCKSOVVFA67d/vRuTjTvf4r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 556/691] i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue, 15 Oct 2024 13:28:24 +0200
Message-ID: <20241015112502.407022427@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 0c8d604dea437b69a861479b413d629bc9b3da70 ]

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: 36ecbcab84d0 ("i2c: xiic: Implement power management")
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 678ec68f66d60..caa27411cf6fe 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -893,8 +893,8 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	return 0;
 
 err_pm_disable:
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	return ret;
 }
-- 
2.43.0



