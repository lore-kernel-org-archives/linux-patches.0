Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A9E1F7557;
	Tue,  3 Dec 2024 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237620; cv=none; b=TSL5amp4Ke+8TKVCpRq/Ku9ozM/CxNj82y8Zu+DCJC85RM0eZPkI2Koehiy4mvw5sDsmTEu/uu9R2sZCFDZ36GdSQvuBmKYwDfYQQlCbGd7NVf0CoV3wJFs4LKwVVPlZaoW0MD1CKYR6fcA65EN/IOSdlBTgCRCjJiZKXvhlSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237620; c=relaxed/simple;
	bh=+0YWJ1m2gBkoO9uIqG/PnTYE0WtaTOuVVzsdtAcLaBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjL87l4zVHY8hJmmc7i5xfR65fwTUc9aC9+lkjH/V3N4LmepGKkgTHW7KykjqDYFwj65cLj4SgaJ7X+hnFFdiHgmpe/h+WPegUmk9fyRvQH4HWTYzIlPX7MCPKjdPeoFzsrWO0UwJyxMkEJkWYq5ipsoUF1PBE3ahhrMhwpCFjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of2S3fl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of2S3fl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9BFC4CECF;
	Tue,  3 Dec 2024 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237620;
	bh=+0YWJ1m2gBkoO9uIqG/PnTYE0WtaTOuVVzsdtAcLaBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of2S3fl9Nwu449ELDxPKXuQ9L84GAKShxLLpUUMf5AsPMw7pmD8QEy6jE4VhIHOj0
	 6zO5Dn/cfi+vj0TGS+anc8kFoM2QGNHtTZLSOHMhjzzlF9gbsPrik5GiIYoOrjzpbO
	 scOMRxvIAHL1ZEQfnUmpkUWJGzp87qqkximPrJVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 022/817] soc: qcom: Add check devm_kasprintf() returned value
Date: Tue,  3 Dec 2024 15:33:14 +0100
Message-ID: <20241203143956.509980158@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d7359a235e3cf..1d5a69eda26e5 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -782,10 +782,16 @@ static int qcom_socinfo_probe(struct platform_device *pdev)
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



