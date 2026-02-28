Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F369135AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302761; cv=none; b=JB2gh83RLUOMSqI6v8ihz3vqTt7WewwMQT2AwLxXdmoppAex7LnkoByElF/xw/L0clN3yv1G5gjrB44aMYELetZPEGeVE7Hf/ZBvNStAhxWoyGW899sQ5Rqh1S/MWADmi85+TE2g8GGXd0s/rjlA/fmRkNzlAIi/+imAtB4GX+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302761; c=relaxed/simple;
	bh=QdGCVtes2RiwIYhghycboJt7Tos68ExvR675zNoTOHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSmymZaZdWYxWXFMVB99obwqoe4IJZT8pgDVPHIfx0ap2zKxGoB4Wc84QPA8TjvlCdgmKsV9jN48tF0iEmaforhHXrVgsnnSfGgXG3m8fwbX3hti7scfC8RbdsEt9Mdi2YsUKbcziuUHjBfP+Io772bUEqPp6Eh5ZkAjnRvhzeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qktGuk4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qktGuk4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4733EC116D0;
	Sat, 28 Feb 2026 18:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302760;
	bh=QdGCVtes2RiwIYhghycboJt7Tos68ExvR675zNoTOHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qktGuk4cS8F481lhHGS07bkIDRB2ENrh3e5mcDnlRCCMtKXiHm+ZMZtDv7nhs3KTb
	 6Bsn6MnnYer8BbNI1U9C94qhIvK5fuTBL64duHIG4PuIIPW4BnU48toLFcUMmp4R8Q
	 IOmkEm+jbzE9vgNDLBmbDZGXxo14XtnhYD33inhXLpDA9GLYJySXKs0yQ/9cBPrrLN
	 UamqTkc+Y5HFSHP141S0g/wOAllifns3Pkbw9yuQGbH1Jql7ZDWWjN4FO22wOgEAYN
	 oQUDLvc6/5sbkdYQgmq6LqwaZGrVHBgLLig8MMhfMwbyI7x2cd73OOnztu3Ldm9nUY
	 0i7MlNiOxjSPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/147] usb: bdc: fix sleep during atomic
Date: Sat, 28 Feb 2026 13:17:19 -0500
Message-ID: <20260228181736.1605592-131-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index fa1a3908ec3bb..69d11b703c8d0 100644
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

