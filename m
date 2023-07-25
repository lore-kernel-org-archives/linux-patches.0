Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A1D1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE04C433BC;
	Tue, 25 Jul 2023 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285235;
	bh=6ElYaEWY4zATLDUsCxHfuSlAzzeJ3YypEbToYLLYaSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbxoICZAgRZrTmNdXg/I7GJ39GdsRpLgHcEYXWrF6C1xbZMtjeK6A3o0beV4cmyEZ
	 Wan7LBuYF6amOqZcyGRpRJJ3oMHH26nWTZzeg/v/sDgh7/BlP+4+Us/kqjW1ugMJ5C
	 pT9Va+GPMWS6hYwVXQ+CnZzBtLSLo2evziCC2GAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yang <lidaxian@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/313] usb: phy: phy-tahvo: fix memory leak in tahvo_usb_probe()
Date: Tue, 25 Jul 2023 12:44:46 +0200
Message-ID: <20230725104526.769531804@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Yang <lidaxian@hust.edu.cn>

[ Upstream commit 342161c11403ea00e9febc16baab1d883d589d04 ]

Smatch reports:
drivers/usb/phy/phy-tahvo.c: tahvo_usb_probe()
warn: missing unwind goto?

After geting irq, if ret < 0, it will return without error handling to
free memory.
Just add error handling to fix this problem.

Fixes: 0d45a1373e66 ("usb: phy: tahvo: add IRQ check")
Signed-off-by: Li Yang <lidaxian@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230420140832.9110-1-lidaxian@hust.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-tahvo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index a3e043e3e4aae..d0672b6712985 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -395,7 +395,7 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 
 	tu->irq = ret = platform_get_irq(pdev, 0);
 	if (ret < 0)
-		return ret;
+		goto err_remove_phy;
 	ret = request_threaded_irq(tu->irq, NULL, tahvo_usb_vbus_interrupt,
 				   IRQF_ONESHOT,
 				   "tahvo-vbus", tu);
-- 
2.39.2



