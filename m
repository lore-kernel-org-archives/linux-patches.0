Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF447320F;
	Tue, 14 May 2024 11:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687610; cv=none; b=NeRjUJLZCVpZm8VOz3xG1JwbhYuiWnCuMPGozsCfLt5d/P64bvxPTQkZBCm8yRl/46KeUgz1zTsRjWHwUYNnq5Gx8c90pDL2AzzCr4t2RzFtgmPiVco874/WSAFRzSaimwRgQviIIdoSXyfrQnf5igMHxwbV7AroY5v7F1MLpmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687610; c=relaxed/simple;
	bh=ofUL9t1KjvXTWiPdaQ+5P2XyvckyUIDtj0DdiCWzFc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOEaCzNgZYYa5V5vzjOKVHHRaCSbJovGQS8GAF+kxGXvvDaFMp2iYskqbNfWsYxrpmHGz+e4NJYNbKIFBIF55XJI4MCiyj0jMaanny/j6pvVCbR6d7DqoVbP1h901td3bX0A71OkvmJSKeFvYdH8rht6pDrfljo5T2M8vDL0FqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5227cdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5227cdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBF1C2BD10;
	Tue, 14 May 2024 11:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687609;
	bh=ofUL9t1KjvXTWiPdaQ+5P2XyvckyUIDtj0DdiCWzFc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5227cdqX4i440EP3fXyMOFWMM878b6F+cIjuty2F3pHZcG1DfyFBkCxhQwf7iRpq
	 NxVSqfLOFzk30/lwBMfBJQwMTr4WC0pACrx443L4G63+pRp90Z0cbMS2Xf00VfQQ9E
	 lG+K6TL+6yVUeKmR75H7M8AbdjCc6O1Fzh22mO2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/168] pinctrl: core: delete incorrect free in pinctrl_enable()
Date: Tue, 14 May 2024 12:18:30 +0200
Message-ID: <20240514101007.150611784@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 456b72041c34f..1c906fc68c1df 100644
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



