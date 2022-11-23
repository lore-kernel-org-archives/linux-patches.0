Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107381C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8CFC433C1;
	Wed, 23 Nov 2022 09:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194190;
	bh=dkSONJRuZ+uNCCJ/twALFMAw+ruZ3ZJUdYeK9FiHtWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtLS/XXYSXHhwB4sG5Yv0v18md4xRWSyOizTHYHKJqME2n9Q4KP57zHuVOdWVbybJ
	 yOZV8tQDVnh0tFY0iBc8kJIfLKV3Y4fR5mNEL7bOQGlgd0g7yuQFBmFWQHs+3rZnYU
	 +pb4RyV/HemBmrPIuPtmZqS4oPTzYkYlzDb2iG+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/114] phy: stm32: fix an error code in probe
Date: Wed, 23 Nov 2022 09:49:48 +0100
Message-Id: <20221123084551.914105871@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ca1c73628f5bd0c1ef6e46073cc3be2450605b06 ]

If "index > usbphyc->nphys" is true then this returns success but it
should return -EINVAL.

Fixes: 94c358da3a05 ("phy: stm32: add support for STM32 USB PHY Controller (USBPHYC)")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/Y0kq8j6S+5nDdMpr@kili
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/st/phy-stm32-usbphyc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index 1255cd1d9a60..5056662d2927 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -393,6 +393,8 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		ret = of_property_read_u32(child, "reg", &index);
 		if (ret || index > usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
+			if (!ret)
+				ret = -EINVAL;
 			goto put_child;
 		}
 
-- 
2.35.1



