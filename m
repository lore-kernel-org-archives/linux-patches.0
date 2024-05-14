Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0572312BF14;
	Tue, 14 May 2024 10:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682116; cv=none; b=gr23YfGOCiYSfgwcl4v/jeTgX8jeTLjafFzS5x48CcRLkjBh+sUnj4e/tAugQtTq2j114wfQMFgneJU0zxDoGn4ZwVJrmJB9XgUlBPe+XNTju63nlsB3UffZXfkGYmT2UXlyto+T73O344DU/7EAwq+5TDoWbZU0TIUb5S2IB30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682116; c=relaxed/simple;
	bh=hDWJt8FUWBUlexepRct/cRvbnD+gj1qOGIIBxpLXl9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUgZ7VUh8FAr3RkVU4W5cVVFMB2pbW4t/MW8IRJyIJ5SvOwEaDmI8UJXRmDaHvv3sg05IDqc/j/ZBGDOl+THjWlrGnS6BNdTLy6epD8Itx87S7peSy01zsTeJWQ2yOdPvbdcMQCA9AnF7nPflZqiV9bA+ePZ2sTrokXrEank3yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJxo1yJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJxo1yJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6CCC2BD10;
	Tue, 14 May 2024 10:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682115;
	bh=hDWJt8FUWBUlexepRct/cRvbnD+gj1qOGIIBxpLXl9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJxo1yJEgNTjuYFz7OiKQOvanGt6VkkqLNFsauLBELaLM96PwuP1WsKIokf0nLFO7
	 NsqAFs5wPq75XW7cxmGXlVaz/LLBsY+jRXqSSXU2f30/vWvR5soYMS7vPYD5gvL7zw
	 zZnijN8yJcROBnTcyMz4PGtJYTEZ/07P0fiV413E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 006/336] pinctrl: core: delete incorrect free in pinctrl_enable()
Date: Tue, 14 May 2024 12:13:30 +0200
Message-ID: <20240514101038.843808415@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index bbcdece83bf42..ae975e1365dfd 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2120,13 +2120,7 @@ int pinctrl_enable(struct pinctrl_dev *pctldev)
 
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



