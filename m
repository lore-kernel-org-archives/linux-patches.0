Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5171A76A2;
	Tue, 30 Jul 2024 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359651; cv=none; b=jQHWjNF70F/GomZ4qOfrNQICuLCG1mWduyvvq152Mv6TM05RAqoPKZg1dheTrosyMcj+1+EwMYg5S+y31PYO87EKMvD4G9q/NNtIPC+J+JbDWk2kETE/tO3yCyOlKpgjnlQl0jK/Tn7qYfwzgvM9W0pYao/fo87n8qc5okCzKeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359651; c=relaxed/simple;
	bh=sFqNY+DBUb6Jx5X5F6f2j7ZqbxtfjPPBpM4+Ajazxlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=calsaI7kRwMcdIyuyDq+DMy+BWHHbMp1Dm4ZPlZcJRoBdpMe/ooZNFCDt19GJ6Rhcgjt33cW/8Spf+CZKdUr1lwrSam/jUespS88bdeJN8YtKnzmqMdpgYqnbpnFzypREkEoqQ9iYQc1Sy0kIi78C2CbHtkFmF7KDQcTsSyZS0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdeTSWfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdeTSWfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6F5C32782;
	Tue, 30 Jul 2024 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359651;
	bh=sFqNY+DBUb6Jx5X5F6f2j7ZqbxtfjPPBpM4+Ajazxlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdeTSWfZ9G4uWBp/VPUNEbyxr2qQx/dHrgl2+pdlTFXcaJKi6HHyjEVrn7ZX49v9V
	 SIUvkAek29WSju6TxV9/bK4BclXMNIzOdJNgZeNsQs+Vq7PtIF3pSDnSu2GVWzl+/3
	 lfqmt52W3zU3M34pqKuZ07kZXDyJaZ2/8oInzLDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 491/809] pinctrl: core: fix possible memory leak when pinctrl_enable() fails
Date: Tue, 30 Jul 2024 17:46:07 +0200
Message-ID: <20240730151744.131121955@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index f424a57f00136..4438f3b4b5ef9 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2080,6 +2080,14 @@ pinctrl_init_controller(struct pinctrl_desc *pctldesc, struct device *dev,
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
@@ -2160,8 +2168,10 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
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



