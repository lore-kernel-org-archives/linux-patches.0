Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368571C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7CBC433D6;
	Wed, 23 Nov 2022 09:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194684;
	bh=lQH9xFpWR+Mk/N6H9Zij9AXQ4wneXUhWgo0ItBv2bO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pS+dim8jgO36i18XyvL793YswE/DAF1CQvB/LOKS5K04Th0WKBSA/7D9BYXqjjStb
	 ly2M0Yp7FC3S3AwOkdMBIpmaCFlF0U73bZq5KISXykIg7fjVxz1m1WQNvTaYZjI/le
	 FgP7j95oSNhNeLlFRNCIDrSKMEAcrtJC9ePuT6VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/156] phy: stm32: fix an error code in probe
Date: Wed, 23 Nov 2022 09:49:24 +0100
Message-Id: <20221123084558.129372731@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 56bdea4b0bd9..e643c21c1217 100644
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



