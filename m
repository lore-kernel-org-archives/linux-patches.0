Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE781CAA4;
	Tue, 14 May 2024 11:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686108; cv=none; b=XWzbH5fpQuVxOIZ5kmv/l1B6Cb1pdgHqNXHLXAktCwu4gv86fPc3SnsjMKl/GQ4Yu9/Z4Sw8p6ju7t8Rci2o8QQ60RZOuJfB+Vl/7ITg969zZG4Pxvoup/3H4ExwxPyy6kW3hHC47OpMmo3Nu2Dy+lQKQ+2WicjmPd27KKrUFMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686108; c=relaxed/simple;
	bh=39Mm08c/fA+MtEfjZHI6mld0tc1pV+jG0mGCE2FMV7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbvwrbPm92ZfM1u07nlYPf96KdrxKsWv8uU2SP4tlRa6kJ3pJuXGBm2J6I0sq7XEArk+tZJ+hbVWMEBg0qF1A5j5XIO2dTjKieNY2yPQ6vh1vuNMfutrNhsq1GsKC0wMy9wPA+TsUMJb8auhoVUhpcQFxIJc+qc1xkXEM2BFRuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00Z357FS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00Z357FS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CE6C2BD10;
	Tue, 14 May 2024 11:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686107;
	bh=39Mm08c/fA+MtEfjZHI6mld0tc1pV+jG0mGCE2FMV7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00Z357FSELyhHEX1f8xc/F+Gun8WMJMcantxkemd7Aj2PFAfym83lN2z3OE3Pz8pP
	 rhSgUkCVTI7GX8GXMuNjGPXo/pEwtUa/uUoO4yz4U+mIqWocw/IHYZNwGE48QlpLTp
	 ULAuDvitexQAPmTACF96CPLIoaXWH6f+s1NOEvdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/236] pinctrl: core: delete incorrect free in pinctrl_enable()
Date: Tue, 14 May 2024 12:16:26 +0200
Message-ID: <20240514101021.251071259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5038a66dad0199de60e5671603ea6623eb9e5c79 ]

The "pctldev" struct is allocated in devm_pinctrl_register_and_init().
It's a devm_ managed pointer that is freed by devm_pinctrl_dev_release(),
so freeing it in pinctrl_enable() will lead to a double free.

The devm_pinctrl_dev_release() function frees the pindescs and destroys
the mutex as well.

Fixes: 6118714275f0 ("pinctrl: core: Fix pinctrl_register_and_init() with pinctrl_enable()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <578fbe56-44e9-487c-ae95-29b695650f7c@moroto.mountain>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index f1962866bb814..1ef36a0a7dd20 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2098,13 +2098,7 @@ int pinctrl_enable(struct pinctrl_dev *pctldev)
 
 	error = pinctrl_claim_hogs(pctldev);
 	if (error) {
-		dev_err(pctldev->dev, "could not claim hogs: %i\n",
-			error);
-		pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
-				      pctldev->desc->npins);
-		mutex_destroy(&pctldev->mutex);
-		kfree(pctldev);
-
+		dev_err(pctldev->dev, "could not claim hogs: %i\n", error);
 		return error;
 	}
 
-- 
2.43.0



