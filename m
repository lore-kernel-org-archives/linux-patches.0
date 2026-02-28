Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9142A34250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301911; cv=none; b=GgXIAx4z+TT/OMIESBTp25qdXULklm9/z6PutGZ+AwbhBSjnVISX+c+h6Gctqv/08aVkw6DTwFtSOmPVaNgPJYCHNbY2I7gukWTCc8XD2o6OhqHFJLiAJCPtFViRrNTRVap6SUfz5ELnO9jKVyaSaB9bnhRjFulA6iXzpdZwMKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301911; c=relaxed/simple;
	bh=2gLHjR+IQhwLbWmifR4WqVbxKDM36B2EFT5IqySWgoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfEVOcJxXv3XIMS16m0TZEB28W+1wCE4Sm17tApEwaaxCBxXa9lzLAcqcdGdGZ7a8+Xldirbitq010X021ecXhQbmFbjYM+CKGBP1CT2ytkCejH2AEGNHZhxlCh/d3YQGd3+dWmPshZzMAkWe52cjZPHDz0rGloHgvix3EJODeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVmSluri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVmSluri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F0DC116D0;
	Sat, 28 Feb 2026 18:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301911;
	bh=2gLHjR+IQhwLbWmifR4WqVbxKDM36B2EFT5IqySWgoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVmSluriv2SRyeFLlQfLJsTjlOtepuhoHKWa6TdsybyESNhauBORMlqqCyeJRtdLC
	 ++mCsF0zZn64/C2Pe+a3+zg8Qhzt+LsOj46SbBB20CO+2qPOK2aLpeaY6ZZNmF7QtW
	 /ZH5v9rP6NZFItmgADrMipVo13hVQ9aQJvi33mZ/HixW4/Gl1s7DrC1HZ0dO2Fdat5
	 XvxB0tpbDbia+0wwQpl4xhrvmkawejuJK3k3BKsoyNkbdaYvTBZA42H+q0HqqU82qr
	 ZhLrlTWnnQD7Nam9COjUVZ1ay76nMUJr+RvLl9ISRuCnxG+jpRMQT9+NZi11rRL2wD
	 x87/YHKDtCS2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/385] usb: bdc: fix sleep during atomic
Date: Sat, 28 Feb 2026 12:59:25 -0500
Message-ID: <20260228180011.1568201-343-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit f1195ca3b4bbd001d3f1264dce91f83dec7777f5 ]

bdc_run() can be ran during atomic context leading to a sleep during
atomic warning. Fix this by replacing read_poll_timeout() with
read_poll_timeout_atomic().

Fixes: 75ae051efc9b ("usb: gadget: bdc: use readl_poll_timeout() to simplify code")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260120200754.2488765-1-justin.chen@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 5149e2b7f0508..7fded329076cc 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -35,8 +35,8 @@ static int poll_oip(struct bdc *bdc, u32 usec)
 	u32 status;
 	int ret;
 
-	ret = readl_poll_timeout(bdc->regs + BDC_BDCSC, status,
-				 (BDC_CSTS(status) != BDC_OIP), 10, usec);
+	ret = readl_poll_timeout_atomic(bdc->regs + BDC_BDCSC, status,
+					(BDC_CSTS(status) != BDC_OIP), 10, usec);
 	if (ret)
 		dev_err(bdc->dev, "operation timedout BDCSC: 0x%08x\n", status);
 	else
-- 
2.51.0

