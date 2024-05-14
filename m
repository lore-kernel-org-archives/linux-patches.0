Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774C943AD7;
	Tue, 14 May 2024 11:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687236; cv=none; b=sRanvzpV1H3iE5WQaaXRnkG8fZJxf0GhBsk146KY9EzZ3RQ0zI6+hzclbvMx+5eC78XCjBaGux87dUNY79AIUp91su+OBV7A8hr1PLBtwo60jOvocwgWUko+wXMxYTyO+NpMLxSAe25POBdk21yUhnp4+oj1EWz8gnmtvcTfEQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687236; c=relaxed/simple;
	bh=bKKZ8MMYkhfj8LK/zZNY2Y7dgby2G3NAgoG2jAj86ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIDg8wSVPksHmDuYLguHHnfECMAQALD3uWERDix5gOZp0QI1g9K4loKIfMOtgdaGrc14LQmNVEt+t/dxR332pAwn6AfZgY3dIfVFT2+rN2yjajbRWRAakUTgHqoPk4Jiahe6FBhOtL9jSqTCPOOGZhABx46WaBdO9N++K/14M3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcjd2Urb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcjd2Urb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC679C2BD10;
	Tue, 14 May 2024 11:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687236;
	bh=bKKZ8MMYkhfj8LK/zZNY2Y7dgby2G3NAgoG2jAj86ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcjd2UrbgTuTi5DPQnfIV7VE6dnjOA2GyaiYPPhANMNRcLidxqoF4Tqj+sSBLv37a
	 4yF8B72VLgcvjsuMhKLyZjtHpHkW7cFIy3AnP6gsWKr+PtTpcllPNLVqdjzjBJl5TI
	 vK0dl9bnwwpj2ONYVgfvzAgcRtCbkuFNxmerltls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/111] pinctrl: core: delete incorrect free in pinctrl_enable()
Date: Tue, 14 May 2024 12:19:07 +0200
Message-ID: <20240514100957.478282950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4d52494369935..4d46260e6bff3 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2075,13 +2075,7 @@ int pinctrl_enable(struct pinctrl_dev *pctldev)
 
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



