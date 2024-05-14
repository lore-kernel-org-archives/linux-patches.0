Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B6F26AC5;
	Tue, 14 May 2024 10:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684253; cv=none; b=e1PGJrhftdLI5PLmi2xVc2m9gKa1YNlhCxo90S6vwBVW8sar39ZPKIrYuHERYTNtTNiQYay7hUCqUsGfhISpm2QXEIgSfyN2yIclpWPIIMBxJq2qTeEpff3A/Ey1yQwsPxrj7HKjUA7x/yF9HH2e8BgLKcsreK+3hmlHLdbOI8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684253; c=relaxed/simple;
	bh=KnuWkvQDk5yaEcSVpgqkwHrIIBgPbw0hqGKWlHrFxYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f62d7BeAYbsA46zzxizutT04P15plbxLJBvGZGV8tbmU+5YYtKvbxfuNlE/iQtqrFJTYuJc6V2paD+1jWy98WvzN3dLvsXuMNGZ9QT7wnQrMLQoHcCJ8DgJ82HjiTcGDl79/NGaFZPSYaWb5AY4VCoywoADCMMdOwIdXyJBXFgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrzW0JtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrzW0JtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DECC2BD10;
	Tue, 14 May 2024 10:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684253;
	bh=KnuWkvQDk5yaEcSVpgqkwHrIIBgPbw0hqGKWlHrFxYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrzW0JtDhT36fca9zHzRsSDBtLT/+z26iUM1+O/CZw2LHKS2iZ+96pqX3RNHR/fM/
	 RfWCXwUmhkauZK9UFqohDNhTU6rWucQO6Qjn/y5IXxsrFE+oIhbK253hCV39txlv9R
	 o/gXbbnKMUmwv9KTywRIMt4d+7VKtHUc9Z59fvyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/301] pinctrl: core: delete incorrect free in pinctrl_enable()
Date: Tue, 14 May 2024 12:14:45 +0200
Message-ID: <20240514101032.773905527@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 184ec92241ca8..9e7b3e6c79cb1 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2116,13 +2116,7 @@ int pinctrl_enable(struct pinctrl_dev *pctldev)
 
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



