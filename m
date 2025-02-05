Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7961514EE;
	Wed,  5 Feb 2025 13:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763935; cv=none; b=d7LRUcviXcoOYvvPG7ZFBG24aGYdgfCBvxMBT8Qp7jdBSWq0Wcxk0hcGLyXOfTclSrlDF9bojOXnePBE20WG/lbqK+uLZRx5xPSu7hTrdDhaddFpQg/5crjN+qrNTfuyAIA3vkQQ4LnudX94PZnTmLuzEaF43qdgICWgVOJYtZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763935; c=relaxed/simple;
	bh=tzpoYOTcdnyrHcrB7id0cGTh4SZUk1FCS8DfqDFVJ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6tRtegUVXlq2EJWZgIu4n27dNKKAYxZWSG4APga0fifm3ibglNSU72NvAnSP5prlrK1ydnQ4g4HCdN15J+GbB9kfuJgCCb8lgxY0oBO8islAM2Yjh6Zz4NjjqSuFS7C8Vr74NTTgjCGHQNyzZB9XjlecOHwMlGVxzFst/a8I5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQQrqbi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQQrqbi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4B3C4CED6;
	Wed,  5 Feb 2025 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763935;
	bh=tzpoYOTcdnyrHcrB7id0cGTh4SZUk1FCS8DfqDFVJ7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQQrqbi5knJAvcFHuBjajvoiBZWmCYcTZ/F6RCh8DKM8RaJBqAgOO/iJAoLabN1pE
	 GzB93K1WoxS3FEHp3ZeNObzrOTOPv9hPfBf0FgAM+1aPjZLqSDdTEEs7JGMm7ELl1k
	 vUOwXjW5kVKSM+5CDD65fwzDaYzgyANyUifuf3zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/590] ipmi: ipmb: Add check devm_kasprintf() returned value
Date: Wed,  5 Feb 2025 14:37:09 +0100
Message-ID: <20250205134458.086718694@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7296127181eca..8a14fd0291d89 100644
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



