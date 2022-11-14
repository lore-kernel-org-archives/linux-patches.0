Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD7D4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5BEC433D6;
	Mon, 14 Nov 2022 13:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430855;
	bh=HKOyfiP/I58he1Psu7+tyTI09Py1gXG6NJjIHfNrdts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUTjgarimCwlc2DOpr2MUjC8iIGQQXIE5lnuXvGGjmBc3xV7UhTrmamjj35rJhQ5b
	 eGOP/j1ey4a3zARgqBXlZsVn4ezp4GvF4QQBd2q5hRYTSOibVldzYhMAomT2VU/Lvj
	 cil5mKyVzMBem99nbQQOI+6hFRLPORP7M3hNcfKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 016/190] phy: stm32: fix an error code in probe
Date: Mon, 14 Nov 2022 13:44:00 +0100
Message-Id: <20221114124459.499422915@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index a98c911cc37a..5bb9647b078f 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -710,6 +710,8 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		ret = of_property_read_u32(child, "reg", &index);
 		if (ret || index > usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
+			if (!ret)
+				ret = -EINVAL;
 			goto put_child;
 		}
 
-- 
2.35.1



