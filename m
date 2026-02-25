Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6932C2F25E4;
	Wed, 25 Feb 2026 06:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002636; cv=none; b=hhkFphhMQtXtOLivkoDU7XP7htXqhXsYashq1dKzW2fg4gDUbvJWPFveNDPQo6J3VUngwCLjj/dINyate+Csgwzx8/am1chK/dYihJctWPS7FmlxDoGCufSTrzUJZgctt8nKapBZMYJOXouBnVsIK/ev8r6/l2qEreBSiIajWs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002636; c=relaxed/simple;
	bh=/X+To6IdPKrACDRbafurFz7yPJIGGFgYkKDGRCBa3BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oC9Pxqb1JTMynU+bON1qk7JFfFnXvIdf7JMzKJQWC9MMkqTnYmq1DGbUQ7+Fo4q67C1nxERcQmfQrsH1fpq/5FAK0ZNc19ba+uHaWGhgC45CN46pMDmFQFgT1xBHlSGsipnzAUmoUURssENyqotu3UWobwhTyuueeLT7OrYRLtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2/yJ3aG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2/yJ3aG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2356CC116D0;
	Wed, 25 Feb 2026 06:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002636;
	bh=/X+To6IdPKrACDRbafurFz7yPJIGGFgYkKDGRCBa3BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2/yJ3aGzwuD+6q2sw2xIkXD9gdL8WuBiuuhYQveeiADqMb8YwSChhRx3ZxazYRQ0
	 fhK4K57SnrWuYORfBsdSRB1a1GOOr6POCE0dnVM+0l47TqGWSent8ELbLuCAOztG2h
	 tHkFJHapzGiSDbDoQh6oJmqBNVovwyb+AJOx82Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 401/641] fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
Date: Tue, 24 Feb 2026 17:22:07 -0800
Message-ID: <20260225012358.284225466@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit ce4e25198a6aaaaf36248edf8daf3d744ec8e309 ]

In au1200fb_drv_probe(), when platform_get_irq fails(), it directly
returns from the function with an error code, which causes a memory
leak.

Replace it with a goto label to ensure proper cleanup.

Fixes: 4e88761f5f8c ("fbdev: au1200fb: Fix missing IRQ check in au1200fb_drv_probe")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/au1200fb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index ed770222660b5..685e629e7e164 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1724,8 +1724,10 @@ static int au1200fb_drv_probe(struct platform_device *dev)
 
 	/* Now hook interrupt too */
 	irq = platform_get_irq(dev, 0);
-	if (irq < 0)
-		return irq;
+	if (irq < 0) {
+		ret = irq;
+		goto failed;
+	}
 
 	ret = request_irq(irq, au1200fb_handle_irq,
 			  IRQF_SHARED, "lcd", (void *)dev);
-- 
2.51.0



