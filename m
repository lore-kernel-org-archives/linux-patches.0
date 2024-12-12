Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A6453365;
	Thu, 12 Dec 2024 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023668; cv=none; b=feyCIA/Dxw9hpioEQolIoO/9j7tSUajAgw8RWqzuKgNKq7ol6sttI2Z9iPw0+4UGj35vX4Y2+/zYMnLWX8sNgqhmloz508rierlDPUH60uWmmcCwPO7U7YKBpIrDhEeXd7763++8UBSZuejMa8ibSXOYDgV1eVPRvFMwXjnjteY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023668; c=relaxed/simple;
	bh=2ZA4HxqYfmH0GetntLTnsvl1YV6yT84qP3T+rBW1L08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SueyYcLeB1v6xlG1U9xTZ9GZ0GCXyNF2Z9hOOK/AVZRWB0ErB8ek+0FTOazfL7228t98sIrwCyZYIFPIH0RDHqoyItubEN0Pd+ayRhrE9Eay68CXnYk7rl1bSgcJNAathXvJzvlXe4t795EHJx+UGQb6uYxj7Gn8RQK5L6HUdL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uapfokV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uapfokV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F16C4CECE;
	Thu, 12 Dec 2024 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023668;
	bh=2ZA4HxqYfmH0GetntLTnsvl1YV6yT84qP3T+rBW1L08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uapfokVsOPG03AnnQQA0zEpt9OptQtQ5C9i3o7UnZq4CrYf9e0M7whWM3YvA8qTh
	 pHQwQL/75NqCvZe2Y6V3ph3kMFN+jkWCRq5nznaHrV2JFIV4zwOICrq2SDEcQWMic9
	 2reXfuLrZ8IvxFfXMVwlmZODFki44n+Zegka9uvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/459] soc: qcom: Add check devm_kasprintf() returned value
Date: Thu, 12 Dec 2024 15:56:20 +0100
Message-ID: <20241212144255.190110083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit e694d2b5c58ba2d1e995d068707c8d966e7f5f2a ]

devm_kasprintf() can return a NULL pointer on failure but this
returned value in qcom_socinfo_probe() is not checked.

Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20240929072349.202520-1-hanchunchao@inspur.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 60c82dcaa8d1d..7bb3543e42e59 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -507,10 +507,16 @@ static int qcom_socinfo_probe(struct platform_device *pdev)
 	qs->attr.revision = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%u.%u",
 					   SOCINFO_MAJOR(le32_to_cpu(info->ver)),
 					   SOCINFO_MINOR(le32_to_cpu(info->ver)));
-	if (offsetof(struct socinfo, serial_num) <= item_size)
+	if (!qs->attr.soc_id || qs->attr.revision)
+		return -ENOMEM;
+
+	if (offsetof(struct socinfo, serial_num) <= item_size) {
 		qs->attr.serial_number = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"%u",
 							le32_to_cpu(info->serial_num));
+		if (!qs->attr.serial_number)
+			return -ENOMEM;
+	}
 
 	qs->soc_dev = soc_device_register(&qs->attr);
 	if (IS_ERR(qs->soc_dev))
-- 
2.43.0



