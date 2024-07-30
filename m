Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FDF188000;
	Tue, 30 Jul 2024 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355448; cv=none; b=vASXud4SLSpavBOBqBDtj6y/WWQpjr8vI2F4OPcZKDmq8kd02dokglPVktnoz1V0pEKWtKScmekIPdzjbpcoSUijHQnynyT5WhnD8cD+iU0LcLbVFXz2fokpTJekoQdDNGE9bxH8Slh8K2DgE/kQlKIEP0LovXenjxSUUZK6CLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355448; c=relaxed/simple;
	bh=ie/4MSq+snrkFokIyXghSPOCXWjz4Hf+rPjxlik1kig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1XHd/mJLZGhHKRziNoNRsrNlqlzbhIme/RDjsUsYH+xSuD+J9kw0ClXPKuHH0HmPmw6l6p9xsH5iaKSmqgxwmtT2LPyC0iU8S3iU3xlNQ61tT1itfjgMj/eR9AASwJTziNOY2ZQSYBTfz7Jyk6LaiDDY5H+6XaOYdRbWGzucGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AFRJPU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AFRJPU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE473C4AF0A;
	Tue, 30 Jul 2024 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355448;
	bh=ie/4MSq+snrkFokIyXghSPOCXWjz4Hf+rPjxlik1kig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AFRJPU3i7Boihksw9kyuuM/+c2JQY1BVY6+4HqRIYeuWKoiML/H9NOtnzGvq0Fbb
	 A6dnILBQ/iVaokqy7Z4Nyk5Iu9P61wuBpjmIMAFNS6+FH5LhrOs+8+rlIAzeUGJFpq
	 yaHo91v2YbsMWpOYeJqp/eDI7OOcRWESo2cKhhJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 056/809] soc: qcom: pmic_glink: Handle the return value of pmic_glink_init
Date: Tue, 30 Jul 2024 17:38:52 +0200
Message-ID: <20240730151726.858572577@linuxfoundation.org>
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
index 65279243072c3..9ebc0ba359477 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -373,8 +373,17 @@ static struct platform_driver pmic_glink_driver = {
 
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
 }
-- 
2.43.0



