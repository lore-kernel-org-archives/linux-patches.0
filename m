Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FCE1714D9;
	Thu, 15 Aug 2024 13:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729620; cv=none; b=lUbcPx9/xoT+tRpNCQCV6PgFzSlKEpJBLiKB4n5fhS4sUfCqVXvRC4qWqvdoBzQcF0G9Idaj/0TRpKr6Ez7PEda/KYcCAU+nqx6VldgtFm956uoIPYi7ktMu0nXv6p4jzCdt6uL4vl65Jpg0rn+HT8mF/tG2gFdc0DF7pDurPGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729620; c=relaxed/simple;
	bh=4uqR8v+ohzKwGDQ9TnzVFfc11Ewv6ibORF+eSE6+LhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hW5GYgLsPsvTmEmrVFap9aAzBKrQHHhl4eoghKpEUPwruGuHQdohUPYyEeCye0G6CUiBwuJU0Lu4o0oaHE+IrI0SSRgTJti7hlLpPTY9o8T4CBheNWU3bYKHIy6bYG9y+9JknQ2q8MxYTePeDY5uvpZMg8mlR0eOA2x4mYNBl24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIrH5g/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIrH5g/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8609FC32786;
	Thu, 15 Aug 2024 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729619;
	bh=4uqR8v+ohzKwGDQ9TnzVFfc11Ewv6ibORF+eSE6+LhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIrH5g/Ro3b8wKGbiVZltgYuTqEVgTe9gNWI64QJxKFQGWhxot8pb+aE7gfgmxJDZ
	 mSIWAsoTYWhcADRZ62dDN3B6i+b5mC5FIj9U9ovyiTFrjI6Rz0Ox1o88ESzTVHMRqP
	 X/nJmfM3Mw65jbk2kzDFT/fWDDlqxjSdT9pqtJ7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/484] pinctrl: core: fix possible memory leak when pinctrl_enable() fails
Date: Thu, 15 Aug 2024 15:20:13 +0200
Message-ID: <20240815131947.401945803@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index f567805cbde8e..8f4cc52b2a066 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2062,6 +2062,14 @@ pinctrl_init_controller(struct pinctrl_desc *pctldesc, struct device *dev,
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
@@ -2142,8 +2150,10 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
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



