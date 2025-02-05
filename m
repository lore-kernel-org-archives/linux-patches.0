Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF3117BEC5;
	Wed,  5 Feb 2025 14:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767137; cv=none; b=sSjBbcPvBaBIOK9n96Z01w0rH16QIHpeg4TlspYxuu4doGQZbNLnfMjZL52suHyk41VPE9b+rPA+JIeObnbQb4AK1KJMp0IJgYeUdxqh7+JOh8/HTlOCxjJSYMyXLwBtUY8FZnjiSSAHWrM1f2EDpUK3OTEd/83JNC2XeeZVK7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767137; c=relaxed/simple;
	bh=T57sr4pV1tPnGoRWa4VLHE3fbTiFyF31UhwTsUz7Hcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZU1Hg8AwvuXAzrWVDe1IftF4uZiTsVOKxyF8rZTivZr+1fDwuMzOD5lWcZkyfqHIPzErIn286LTRbAenZY/VUPuObH8SXOoSMvWFy9VryxC3QHRI+WXRKyYD+zN3xiryrPLvjQBnWV8EQq1tqweEyLpqWhbaLCQWGy9m1UMFuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bh+J/e82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bh+J/e82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7317C4CED1;
	Wed,  5 Feb 2025 14:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767137;
	bh=T57sr4pV1tPnGoRWa4VLHE3fbTiFyF31UhwTsUz7Hcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bh+J/e82e9d7s9/mM4IBKTDYbUVXoBgwCmp9G2EOE9p863kH/dDXT796O7Kf0oB2C
	 G95vt9agfLA1CAFoZDgLQFBi08XBn/0A1vVFFGiLh4bxi2zmYq7Oap9b8aU66NFdh4
	 q54ZsTboEG/hClRWJ8nOX0MYuqI2241UTWcq8D1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 411/590] media: marvell: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:42:46 +0100
Message-ID: <20250205134510.991630426@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 11f68d2ba2e1521a608af773bf788e8cfa260f68 ]

Add check for the return value of clk_enable() to guarantee the success.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
[Sakari Ailus: Fix spelling in commit message.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell/mcam-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell/mcam-core.c b/drivers/media/platform/marvell/mcam-core.c
index c81593c969e05..a62c3a484cb3f 100644
--- a/drivers/media/platform/marvell/mcam-core.c
+++ b/drivers/media/platform/marvell/mcam-core.c
@@ -935,7 +935,12 @@ static int mclk_enable(struct clk_hw *hw)
 	ret = pm_runtime_resume_and_get(cam->dev);
 	if (ret < 0)
 		return ret;
-	clk_enable(cam->clk[0]);
+	ret = clk_enable(cam->clk[0]);
+	if (ret) {
+		pm_runtime_put(cam->dev);
+		return ret;
+	}
+
 	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
 	mcam_ctlr_power_up(cam);
 
-- 
2.39.5



