Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7A51A6190;
	Tue, 30 Jul 2024 16:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356957; cv=none; b=ZP97v3sC8apnVZ/1FJxAdZt7xfK1z/FWIfyE8PjSlPh1SxVtQJfA75vmxWccoQN5nf3ZaLTEiECBCkqerWa+ZKi7VMj4A6yJS9zlYHPSXGyz+gnxstOHjzoB/narqY6QvmwOnfAkXAGxUzvO6UlYuQ4NamEr8OErpxV0wUZJKdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356957; c=relaxed/simple;
	bh=0/RRps6FRvznxa/Op27otYrD/dfMxLg7Mga0otMmB0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPy3QmCB0ZKIlh6jxRARVYeTD7UXs0rhO7A5DDJGYAl7jUz8hSLchzEv5kaeKpC0CeMJia4lzRwcuKYbA8BySy8/MgFYR6C6ghT8cWyNE2DsJ0T8MseFtI15pLkApU93xvwXXnjpU096CRzLH3AV3n2eng2YHGhPw/WfVnpPs/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKiwF0YB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKiwF0YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06BDC32782;
	Tue, 30 Jul 2024 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356957;
	bh=0/RRps6FRvznxa/Op27otYrD/dfMxLg7Mga0otMmB0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKiwF0YB5owPqg0YXsbAlM7Bs7uL00aD+6lPPUNmP/1oz9Q6SMdcZgLXKAbJ4wvKJ
	 FBbNUvvd2gaQ9xuqsCrqOOvCHHBE54Coa+E5QbxE28ufKHClO8kWxoWG30Gu9hdC8W
	 St3iYyaPXeuX1MPMf0vtRkWwK8574j0SWxPeBbtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/440] pinctrl: core: fix possible memory leak when pinctrl_enable() fails
Date: Tue, 30 Jul 2024 17:47:58 +0200
Message-ID: <20240730151625.420878408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index db5fc55a5c964..3b6051d632181 100644
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



