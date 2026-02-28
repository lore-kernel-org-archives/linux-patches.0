Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4F1347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302454; cv=none; b=Hlbzw88wPN4K/f+G6AkODOLwtDMBuAOizsMCjdkBvPniP3txVrhO4HlvoNJ5rE3u5+LZTbsRO3HtQcb4y73vN4Hul6V6kOdYgJpPmavYwU5lqkiEBa28rT0QbOhBL495hLZjhLKk2tnh71B63n/BBbmT2dRtKtwFh3OXnsvKyZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302454; c=relaxed/simple;
	bh=xruD/J+asUHVaTQ2aGrlUyAmBC4IxUZSs7cB819fvzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpGq4zxshrqyyb//xJphv/IqeDYWzWYp6gx67R5Hgh8M/U2mNejoktthWby1ckypiRvwJXRVH2DV8ZhqnXHIt4X2GSqkSjMLVkjT9Pc5dmWgayHKpMx19BeRxKK6wcXN1BNiqa/3J6U3BlfF7XWZYJavbkKSEVo9ls9uVdfFCjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWB1s5Xp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWB1s5Xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D808FC116D0;
	Sat, 28 Feb 2026 18:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302454;
	bh=xruD/J+asUHVaTQ2aGrlUyAmBC4IxUZSs7cB819fvzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWB1s5XpSJ7YPjNS1ZOvhxIvUIRGgstdM99S9wAJJ9qMuGTeqrhbRWKrjyM2hGD++
	 +rWxG3dDvT9xE/bMzLLuCQDxU1T8FTMhtxEmb8EJbI7USGvA82lAZgNIvYPKGOWsaf
	 AcepxDgFDSyp48lZXiNz39lslb9Cf0tgC8AIdjJPsA5zDP2BNwmivJHrrft3qZHuAr
	 AkE2XcvSOaWE0/ayQjOTsFdZiDL9GqdrNfzYmrBfDukrx8PaXFszHBnQVyFVQQeJCA
	 X+RCI9oi4C4DWhB9YyBV5zSHiFmbguSgSAzYMSNzdCHO7yrPcIoEIP69hKFMkFwsXr
	 lfydM041Ghl2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/232] usb: bdc: fix sleep during atomic
Date: Sat, 28 Feb 2026 13:10:48 -0500
Message-ID: <20260228181127.1592657-195-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 9849e0c86e23e..9460ef0a7f892 100644
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

