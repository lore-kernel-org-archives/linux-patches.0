Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC851A315E;
	Wed, 19 Feb 2025 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956009; cv=none; b=CM1l6rz902Jcdd5yRiVAFun3KqmWthnyd4oqf9Af5FVm4j1cdjb11RvEl63EgN9M/3d8+6dB1s6V7a7BhDjHBXWBP88BDljoYdFIldPEENJ6fpPbNmkJ/64EnjJ2XGikHuJhHCBYZedR8fnCMoJ/EfjsQY0JUO8Z7nVNwjdTkNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956009; c=relaxed/simple;
	bh=xnAtYpGUFNTxnMehkmE8jKw8+JJIoITHlruHPh2nDbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4tftjE4XPrCI8xcA1Hsukk3uAvRfDT3o46e3AYL8t9xd/dfhAPpJRkpo6ID3T3I3R1PAIe0cmU3UJtRpoP3NvxO3HeEPB0s/UMlTf9aHn801uEuQbXOS4TeOtq73c7mcGOOUAIibbXf4O4+C87mrkzA2pSxI+dyfVCcQ5nC6XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeHOVMTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeHOVMTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F03C4CED1;
	Wed, 19 Feb 2025 09:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956009;
	bh=xnAtYpGUFNTxnMehkmE8jKw8+JJIoITHlruHPh2nDbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeHOVMTowZhTtb3f4NB7WNsaJ6qgoHom5gl5TYH/LiavM6qbUgcVZjTMK/V3W6vPR
	 we2rWUBQGabZgmmzMtf1FgvGiMUyQaAxIF7+sIpkl4MAz47GtcyZSvDkbrl4R/veau
	 wCZUO7yGQu6kuwH2Dnwg4UEi6U9Sj7rtOHPUo9cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/578] ipmi: ipmb: Add check devm_kasprintf() returned value
Date: Wed, 19 Feb 2025 09:20:38 +0100
Message-ID: <20250219082654.239099880@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 2378bd0b264ad3a1f76bd957caf33ee0c7945351 ]

devm_kasprintf() can return a NULL pointer on failure but this
returned value is not checked.

Fixes: 51bd6f291583 ("Add support for IPMB driver")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Message-ID: <20240926094419.25900-1-hanchunchao@inspur.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmb_dev_int.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/ipmi/ipmb_dev_int.c b/drivers/char/ipmi/ipmb_dev_int.c
index a0e9e80d92eeb..d6a4b1671d5bc 100644
--- a/drivers/char/ipmi/ipmb_dev_int.c
+++ b/drivers/char/ipmi/ipmb_dev_int.c
@@ -321,6 +321,9 @@ static int ipmb_probe(struct i2c_client *client)
 	ipmb_dev->miscdev.name = devm_kasprintf(&client->dev, GFP_KERNEL,
 						"%s%d", "ipmb-",
 						client->adapter->nr);
+	if (!ipmb_dev->miscdev.name)
+		return -ENOMEM;
+
 	ipmb_dev->miscdev.fops = &ipmb_fops;
 	ipmb_dev->miscdev.parent = &client->dev;
 	ret = misc_register(&ipmb_dev->miscdev);
-- 
2.39.5



