Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2F635F61E;
	Sat, 12 Sep 2026 07:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197279; cv=none; b=ppyXaPg5sxN4t61CIrI6dljDcfNcxWB2DIFbcmVF1ulH5pGKUYfuLgbhzEHcI9r5Wk/C0KLhi9onwx0+lka8Tm4l5diysd2JvODCfkPHst1ii3MWuJUv+ggd5qiWw+5ebKIfY8cJ/gDv5MW9GfHfKXzB6I4s3npP0YLhyVplB3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197279; c=relaxed/simple;
	bh=6qdk2XCrtrdEVlvHzz+G5Itn+QvzJ4UuLr1BFp+A6rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZAsKCEL1eq2GQkGe02DPA/dTJ3fz398qfXC1y8pp/x7pX4khrj7hYqV8GModlTiwmdhob7y1dS4kF48rQv9I3OIppiORcqyAu0DmvqhCSVyYtZsjJ9ysqiE04WynXmp9ZcAsPRAyBvC7yNJYjcvVjEKmEueYKSZNGUCk09AhXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elP8q8cB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elP8q8cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A881F000FF;
	Sat, 12 Sep 2026 07:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197278;
	bh=9QimYMBsSk7PdBFNVS/1EKgCHMzaeXUm5iH+4AbDGJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elP8q8cBMSCoyy1XM4yOJI40mKrG9Zm1k4qPjyOJHIsbS0H5bjojeovHIEthZicBL
	 mYl5+aXwcEvMNcWAtJ0fnZR54/I/5imvLs2CUaAscDlYBLAOX/TwXOwq+j6dQhRJ+g
	 GQewpvsAiTCVRTxKzmoR+7Dx4dUOoGHAOnLNTzsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Min zhang <zhangmin2026@yeah.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0089/1815] clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller
Date: Sat, 12 Sep 2026 08:30:39 +0200
Message-ID: <20260912065651.094685481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Min zhang <zhangmin2026@yeah.net>

[ Upstream commit a8036f4591542de4b38ec81d3e2ba47bc0b2652b ]

Using devm_kmalloc() does not zero-initialize the allocated structure.
Uninitialized members in struct hisi_reset_controller may contain garbage
data, which can cause reset_controller_register() to fail unexpectedly.

Replace devm_kmalloc() with devm_kzalloc() to ensure all structure fields
are properly zero-initialized.

Fixes: 97b7129cd2afb ("reset: hisilicon: change the definition of hisi_reset_init")
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Min zhang <zhangmin2026@yeah.net>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/reset.c b/drivers/clk/hisilicon/reset.c
index 93cee17db8b16..c3b7daac93132 100644
--- a/drivers/clk/hisilicon/reset.c
+++ b/drivers/clk/hisilicon/reset.c
@@ -91,7 +91,7 @@ struct hisi_reset_controller *hisi_reset_init(struct platform_device *pdev)
 {
 	struct hisi_reset_controller *rstc;
 
-	rstc = devm_kmalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
+	rstc = devm_kzalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
 	if (!rstc)
 		return NULL;
 
-- 
2.53.0



