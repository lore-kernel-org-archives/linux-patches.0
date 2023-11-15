Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D606E3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9AqhBXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E4DC433C7;
	Wed, 15 Nov 2023 20:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078520;
	bh=FkCUWr8lS6i/cC10gN/v0rWWHGPqujPXQQhuqYntE0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9AqhBXhECYJlpYLGcKGbVV++YP+hSwnQGQkEASS+/VPOBUDIcmz+c0/V1l/g9bi7
	 2F79z0CyQ39GWu+sNnVpGR+aevcoY1TmlP/LJfuXoG9aylBYK9fWCQ7t1GrVFUjzk3
	 te9gGLYT8NjWRBWjUFzitg3C0tsUR693ubT2SMSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 372/379] fbdev: imsttfb: Fix error path of imsttfb_probe()
Date: Wed, 15 Nov 2023 14:27:27 -0500
Message-ID: <20231115192707.166889109@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 518ecb6a209f6ff678aeadf9f2bf870c0982ca85 ]

Release ressources when init_imstt() returns failure.

Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: aba6ab57a910 ("fbdev: imsttfb: fix a resource leak in probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imsttfb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index e6adb2890ecfe..004e7da9e70ba 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1531,8 +1531,10 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto error;
 	info->pseudo_palette = par->palette;
 	ret = init_imstt(info);
-	if (!ret)
-		pci_set_drvdata(pdev, info);
+	if (ret)
+		goto error;
+
+	pci_set_drvdata(pdev, info);
 	return ret;
 
 error:
-- 
2.42.0



