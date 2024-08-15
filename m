Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D0C17C995;
	Thu, 15 Aug 2024 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732286; cv=none; b=VzBZVngI2cmPWq2m2S0/ctdQeAgD1yoDcwx96fo5tQBYEy6zuhXxeQLuQ5Er9+V8EIWh6zyioRrZho3R3SYIXzxro0nXRoSkuE1HZHgdTJwjoZVB7JDOvldsJnrKfh79J+XOoXInYAb/B9LmNriUfYqQHskXJJC1BXlyu8PHHrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732286; c=relaxed/simple;
	bh=JZWiOiv+Qr9Cenb11AD5dhsCVaNusFEe0kWdNzv5Fh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQ4OznsXyEwB0w9WP1PMiF9Zu3xP9VrLt21SOfatpe/UMnpblnYv1cSbOH7k7Th/l3sr0+IEx6JP3RV7M7BKn6H0GRfS72DYG2dSKTLurF/EIZt6/JevPhhxbSOiNTJs/m8t3TmKjPEWaDXf4xlZHyAtst80c2kOZiB0qmAvymQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmg2suun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmg2suun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17ADFC32786;
	Thu, 15 Aug 2024 14:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732286;
	bh=JZWiOiv+Qr9Cenb11AD5dhsCVaNusFEe0kWdNzv5Fh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmg2suun++XWFygZpTBHriO5D0VaBTkb4M3aeCCcWyCZTysMfoU23Zvg5j9m6gcwN
	 Kj/mWA7bvXooQbEEGZOPwB0dBNJicwSejWCRfAqzdzDpXKJev6OvVpX7lI2AGHKou0
	 Y+buh6P27/HFM3Jos3RqPQKjvKVhOIIPGdQ8NxLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/352] pinctrl: core: fix possible memory leak when pinctrl_enable() fails
Date: Thu, 15 Aug 2024 15:23:01 +0200
Message-ID: <20240815131923.700062869@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ae1cf4759972c5fe665ee4c5e0c29de66fe3cf4a ]

In devm_pinctrl_register(), if pinctrl_enable() fails in pinctrl_register(),
the "pctldev" has not been added to dev resources, so devm_pinctrl_dev_release()
can not be called, it leads memory leak.

Introduce pinctrl_uninit_controller(), call it in the error path to free memory.

Fixes: 5038a66dad01 ("pinctrl: core: delete incorrect free in pinctrl_enable()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240606023704.3931561-2-yangyingliang@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 3d44d6f48cc4c..8152d24e128a3 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2039,6 +2039,14 @@ pinctrl_init_controller(struct pinctrl_desc *pctldesc, struct device *dev,
 	return ERR_PTR(ret);
 }
 
+static void pinctrl_uninit_controller(struct pinctrl_dev *pctldev, struct pinctrl_desc *pctldesc)
+{
+	pinctrl_free_pindescs(pctldev, pctldesc->pins,
+			      pctldesc->npins);
+	mutex_destroy(&pctldev->mutex);
+	kfree(pctldev);
+}
+
 static int pinctrl_claim_hogs(struct pinctrl_dev *pctldev)
 {
 	pctldev->p = create_pinctrl(pctldev->dev, pctldev);
@@ -2119,8 +2127,10 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		return pctldev;
 
 	error = pinctrl_enable(pctldev);
-	if (error)
+	if (error) {
+		pinctrl_uninit_controller(pctldev, pctldesc);
 		return ERR_PTR(error);
+	}
 
 	return pctldev;
 }
-- 
2.43.0



