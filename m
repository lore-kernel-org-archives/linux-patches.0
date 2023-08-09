Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C18317756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475E0C433C7;
	Wed,  9 Aug 2023 11:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580130;
	bh=FtIzSWDQE8vom3x5/PwCFwG7/RepasDKglpbFRbWtO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cToc++jtPmYVvX9oFth2+DxM3u5kG8bYzpx1a5YXlypj1Wroh/pzzvkpHxjwwURy3
	 LgeptLd9eJH8G6Nd+Rri0WumI90uQ8u2dZS5P06royI/x3l5oPMAsAuS/5/uiGzprO
	 JMKXFxDICFxCYYKQey1ppAxDlIL93RJHKdJVvwaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 207/323] fbdev: au1200fb: Fix missing IRQ check in au1200fb_drv_probe
Date: Wed,  9 Aug 2023 12:40:45 +0200
Message-ID: <20230809103707.617102119@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit 4e88761f5f8c7869f15a2046b1a1116f4fab4ac8 ]

This func misses checking for platform_get_irq()'s call and may passes the
negative error codes to request_irq(), which takes unsigned IRQ #,
causing it to fail with -EINVAL, overriding an original error code.

Fix this by stop calling request_irq() with invalid IRQ #s.

Fixes: 1630d85a8312 ("au1200fb: fix hardcoded IRQ")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/au1200fb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index f8e83a9519189..593c390e98629 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1744,6 +1744,9 @@ static int au1200fb_drv_probe(struct platform_device *dev)
 
 	/* Now hook interrupt too */
 	irq = platform_get_irq(dev, 0);
+	if (irq < 0)
+		return irq;
+
 	ret = request_irq(irq, au1200fb_handle_irq,
 			  IRQF_SHARED, "lcd", (void *)dev);
 	if (ret) {
-- 
2.39.2



