Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B63B13D516;
	Fri,  6 Dec 2024 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496468; cv=none; b=QkosvR7mxwcTFhh/0u0vPFwVenPml0lo9gC4HosF9v0J+p29os1nHKrB27ycBuiRRuTuHV+cbljo65f/NNuK32tVisd5uaFo94B050+7mze5Pr5MvipkP4atoGXUGV707xqkyab+t11IbGNydaMNs+IoOyNkAS/0j1rF+ZFvs6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496468; c=relaxed/simple;
	bh=HWFE/D1elPmXumwViKlt28qZbRCVbZQokoX8cCebv4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azfIMPoSUYr+etfJD7fPXSulSaSSPfMirCalV3rVJOTctOyerZNCp6uNduW6s5yO6JRwVGsMK6Wwb+sCBKBWCs07a+YMg0AB48ZPVCj1Cm4lW736f21Uy1Fs7FyIYD0+279/CeTwSxV+n/yRH3eD6zhXgJ7yWXZKMyFzOcfCt0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bXi6c8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bXi6c8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAB1C4CED1;
	Fri,  6 Dec 2024 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496468;
	bh=HWFE/D1elPmXumwViKlt28qZbRCVbZQokoX8cCebv4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bXi6c8ksAPorM/5/pusRfzq89v2qQG/qu+tSQgCPI+PwGAMbSiavNoDtL9DNEq0b
	 PWNi3rkvJ+PXoY1xrXmBzy4jH6fWuRo2mDpOFw006sZG+soqQriJRLeMSlhorQ20A5
	 NyPUsy54kzyz6ivGfGBmytBY7hzhZdQRS8F/o5Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/676] soc: qcom: Add check devm_kasprintf() returned value
Date: Fri,  6 Dec 2024 15:27:14 +0100
Message-ID: <20241206143653.953360599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 880b41a57da01..f979ef420354f 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -757,10 +757,16 @@ static int qcom_socinfo_probe(struct platform_device *pdev)
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



