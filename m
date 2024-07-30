Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCBA1CB300;
	Tue, 30 Jul 2024 16:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355251; cv=none; b=NkLA4weVomS5LTVuA7dIaqrzp6+1JQUjXGjSXNjR7ihugv6kbO/HEY/CzBCg6OpkAh6gLPKSmBUvjL88B+5d02BjMqNXdaakjNw+b9VGdJbq0G1sEihNcwt9O4isA9c6NLNHklPWy4eVqpWNMrG0KKAy5Yn/gMjVMll/wmlRWx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355251; c=relaxed/simple;
	bh=0WsrI0B0XK0tvPhLXFoIPs/Gus6gZIeGtEnE6d8HT8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1CqLmNOupF2XoRi8++k4JpZjf/8iC8PAbQin+q9RxsQVbzPHQTK8LRfMvuXNBHPtEZ+CGO1eCjR+S8HqMYkCr9yEXq9nAZLs4mA7r0eVV8NDUTAtHK3x8l3v5KzBO11x6ZEI3+8FBWYTnB7+fIwIWbxhqMl+C/wkVrQHwe9LeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUnW9mZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUnW9mZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E02C32782;
	Tue, 30 Jul 2024 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355251;
	bh=0WsrI0B0XK0tvPhLXFoIPs/Gus6gZIeGtEnE6d8HT8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUnW9mZi6Sb9kVhZIo0RkaY5yl1g8AC5kWYZdOb4HCfbt5A5yEtk/bsU1YkMwWqqu
	 I53DrGm6U0cfLwdnPTRYLqAb0XO1zoKlXBNQGFWfGJgR80lCLcjNgE6jorEYvNnTyI
	 Y1Ry/NCbK1yG2Supg7C1iLxdLZng323pE7zCp+PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/568] soc: qcom: pmic_glink: Handle the return value of pmic_glink_init
Date: Tue, 30 Jul 2024 17:42:28 +0200
Message-ID: <20240730151641.443790207@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 0780c836673b25f5aad306630afcb1172d694cb4 ]

As platform_driver_register() and register_rpmsg_driver() can return
error numbers, it should be better to check the return value and deal
with the exception.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK  driver")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20240510083156.1996783-1-nichen@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index 61a359938b6c4..71d261ac8aa45 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -376,8 +376,17 @@ static struct platform_driver pmic_glink_driver = {
 
 static int pmic_glink_init(void)
 {
-	platform_driver_register(&pmic_glink_driver);
-	register_rpmsg_driver(&pmic_glink_rpmsg_driver);
+	int ret;
+
+	ret = platform_driver_register(&pmic_glink_driver);
+	if (ret < 0)
+		return ret;
+
+	ret = register_rpmsg_driver(&pmic_glink_rpmsg_driver);
+	if (ret < 0) {
+		platform_driver_unregister(&pmic_glink_driver);
+		return ret;
+	}
 
 	return 0;
 };
-- 
2.43.0



