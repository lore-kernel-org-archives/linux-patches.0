Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D839D217679;
	Thu, 12 Dec 2024 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018713; cv=none; b=MebHDefle+C0ZzKSkJGoKJCPTytyR8xgmKhSTEedlbDBCZkZqArWT0Ov9VMgx3bJEHhOiMUdAp4x9TDiACR2i5Oq8CVWAjBmO2KF2oNFfuj8QTjOnhyc1v+A9mghbpf8UdyP4i8YBQlaa9aKQDDF0HykCfVLluWZfFz2vn0EM8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018713; c=relaxed/simple;
	bh=iGrdfZi8j/3TScNVy5cS74ik3HjJR4Osv6zZWzgWZ9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDHqaCzpBzQhuyMwMkVx7E2LJJv5Awt7j6XQfpia/nULmhAMpPbO4WaGfTYrGVLt+brQiHBITW2G67w5oIJe9XYQskPWEm7016BdWo7Z88k9/v2Fz7oE1HNg8MviGxtRmfobABmkQK5T00MK2HJVbHXu8FbHW644YhKNCZmRQ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7KwQNFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7KwQNFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BE1C4CECE;
	Thu, 12 Dec 2024 15:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018713;
	bh=iGrdfZi8j/3TScNVy5cS74ik3HjJR4Osv6zZWzgWZ9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7KwQNFAGYH5Kf0S8+E5s/uMbD5MqRkOtrRPboR3/g7MKRMR2NQ4AP65lHH6UZ7Ed
	 E6zz3ZEP/cXrjXtw8dA5OcaOMyTAxxsBPzWzCyi3+Iy8Sb+PCuHsxjtxjzm2pStV1l
	 1ZjD/2HsJyVjHXiysX+Wcct3wIiaW6AoZ2+CL+oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/772] soc: qcom: Add check devm_kasprintf() returned value
Date: Thu, 12 Dec 2024 15:49:17 +0100
Message-ID: <20241212144350.458741274@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index aa37e1bad095c..66219ccd8d47f 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -649,10 +649,16 @@ static int qcom_socinfo_probe(struct platform_device *pdev)
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



