Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A7B1EE001;
	Tue,  3 Dec 2024 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239422; cv=none; b=JuAagcpfGGBGSNB/2M4o8crXEwUsdvTGhZzA2NbAfTVAVZ6AUfNDynuHU/EnOzVElzVB1mQUwURWB+dI5brcG6l0I+uJQO149KDcB/c1weoItdPtRwRJsML7cgxq0XkYpP0zRKnKKwJXjt/fFH7dautsIgOiTkLP4SN95Dm2BW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239422; c=relaxed/simple;
	bh=qDKq1ofY+2Z8uvuOx9TylThoHj/p3NJzZrIXXjDGWQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbekqD2NNHlyls8h6sGkatlVB+lEErZEubNvVh5JPlFRy++QpCLcv0hx9uQ2cesVGxugvObRFgcyFdrWdcxk5kGf3PAQR6UK7YcQjDERnz39XAlaRuXk3m4SaGrJvEojz+lxxnDAQjDDeOCXytyUL6nUdXcza9eZYPhs9bVks6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLnMkN/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLnMkN/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185ACC4CECF;
	Tue,  3 Dec 2024 15:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239422;
	bh=qDKq1ofY+2Z8uvuOx9TylThoHj/p3NJzZrIXXjDGWQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLnMkN/rDZ7u0HxuSe2XytYAk0JQmgwiDGHNO5cpHzvb5SsDgbkXDz8XVPl4IP2/0
	 KT2rsVCmb7RkezGO0vwBmisLtVTt8tOsgqdK2+wpeSES+oKSWSKkFhdffv+S+AY2UV
	 2sUHtLM0lnjpBwYC2uEVkixbf0zgsAUCa++l/URw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 607/817] phy: realtek: usb: fix NULL deref in rtk_usb3phy_probe
Date: Tue,  3 Dec 2024 15:42:59 +0100
Message-ID: <20241203144019.627611979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit bf373d2919d98f3d1fe1b19a0304f72fe74386d9 ]

In rtk_usb3phy_probe() devm_kzalloc() may return NULL
but this returned value is not checked.

Fixes: adda6e82a7de ("phy: realtek: usb: Add driver for the Realtek SoC USB 3.0 PHY")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241025070744.149070-1-hanchunchao@inspur.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/realtek/phy-rtk-usb3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/realtek/phy-rtk-usb3.c b/drivers/phy/realtek/phy-rtk-usb3.c
index dfcf4b921bba6..96af483e5444b 100644
--- a/drivers/phy/realtek/phy-rtk-usb3.c
+++ b/drivers/phy/realtek/phy-rtk-usb3.c
@@ -577,6 +577,8 @@ static int rtk_usb3phy_probe(struct platform_device *pdev)
 
 	rtk_phy->dev			= &pdev->dev;
 	rtk_phy->phy_cfg = devm_kzalloc(dev, sizeof(*phy_cfg), GFP_KERNEL);
+	if (!rtk_phy->phy_cfg)
+		return -ENOMEM;
 
 	memcpy(rtk_phy->phy_cfg, phy_cfg, sizeof(*phy_cfg));
 
-- 
2.43.0



