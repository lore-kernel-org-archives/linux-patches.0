Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E239623D7CF;
	Wed, 25 Feb 2026 01:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983387; cv=none; b=Ejmituzh7qqEVkUEuPYIyAORKluTkpzfpBmXP5XRg+cIQ65Z+uEzQqULrMQzQkudZl5SxRIezDzqJBsB0lSPZjwxmIutatoRV2/V4bW28K+LzCE3Cos9GBQc8gbBbYnG1gIHZv/KLqOVfF+4lyKrjufwKen6/UJNav4+ckRQIkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983387; c=relaxed/simple;
	bh=Sibthw0gokPqJQ8KszWAhZ1vPJm7G13GfhWc04E8pUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqVBnDlInJMdvPeqxJZOD6MgxPwdh2X8o4+8+oJ7z9o7qgKcVqnpIEyhnEUxK9+HzE+oeTGoOd6e/zuuen7yoZBj/t7ALibqhv/MMFX8jZVK8YSkCzUhbHeq9wZiyi87GUHWq7vhJWcc2z6IxuwouggV/ROuie65rm/mSsoYuOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxJr1du+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxJr1du+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C674C116D0;
	Wed, 25 Feb 2026 01:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983386;
	bh=Sibthw0gokPqJQ8KszWAhZ1vPJm7G13GfhWc04E8pUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxJr1du+mpOnR280leKB7ygj8JH0HoQhTeXrjlYvCIqnIbidFkdmgPNuagVNCEdzc
	 CYXRLRKKicaGLuDsES5CSuw6/1+jeH64WCIkXzXLR0nxzcW3uwnEvWRVBQe4CFht5W
	 i73ec0gTcqwXUD0DNSP2L7ZEpMBJTv1YNkHrXfFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 510/781] fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
Date: Tue, 24 Feb 2026 17:20:19 -0800
Message-ID: <20260225012412.314092550@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



