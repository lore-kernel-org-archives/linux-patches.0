Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD691A6166;
	Tue, 30 Jul 2024 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358107; cv=none; b=BDtRP2FQ26t/27mxgw0Qk1ftG+/HfFLocb+35dfHNraW40LXUCceyea+StUGZ9tmCPfUwcM3UBbgE19RQWpu0COE0cz55eNLbxKtvRu4EYbBLQVlxIVhKp1EJZ0lzGBEBz1YE4dW8dtgr8NM4S09Uzg+4XEXNfiFKk7434qxoGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358107; c=relaxed/simple;
	bh=GzvxVMbs5PgDJO9ke3uFE9GQNAK0kFbc4wRSUrS73eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpClrCOjC38pHB855VnUbxH3VruhpisOuRnYspx8Hki9Fd3IQIrZ3mQGgzjofFEbIDRfYQvZdY8bo/ZfTpRfTkOxOkSbNsaEL/UtJdYrFXMTclcMv3H1FM50GsSZ5qIrm8NJSRN4bGmas+LzYBa3/L8f8HFaMOgYOwDBqJWDdEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ov7KxUua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ov7KxUua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30FAC4AF0C;
	Tue, 30 Jul 2024 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358107;
	bh=GzvxVMbs5PgDJO9ke3uFE9GQNAK0kFbc4wRSUrS73eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ov7KxUuaUUp2rR5eWqquBShPALH6bp30TFL072ZzCfApscP0DRi9JWFgBCkywQoK8
	 4xpax8uUkJkTxqzrZKuRlgikqEQqUY9trnF3l+LHSi5bNE2PUbTR8+E8obJ1sFw0Mx
	 bw4FKeBsotBGLJNONvIU8Zvt8Nr3NCz/Q4yI2uPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 326/568] pinctrl: core: fix possible memory leak when pinctrl_enable() fails
Date: Tue, 30 Jul 2024 17:47:13 +0200
Message-ID: <20240730151652.616748522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index e19ee66e027bb..88ee086e13763 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2072,6 +2072,14 @@ pinctrl_init_controller(struct pinctrl_desc *pctldesc, struct device *dev,
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
@@ -2152,8 +2160,10 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
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



