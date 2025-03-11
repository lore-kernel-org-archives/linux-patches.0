Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8599825DCE5;
	Tue, 11 Mar 2025 15:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705367; cv=none; b=sal8yCqjZnE1qHLMxQ7ocfB++wZHay3+PSljYULnl4HMuSsIKxSvl2yLQ6SGdpD/8bSCklhJ6jJKc10bEC6ymouzN89ljCGnfqv8VgSATLbtECgcOfnkaIEKq1NaYx0AlH6mOYXdUG9s+W2XoNniSi1OlyVK/p1wHmy3IiPupX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705367; c=relaxed/simple;
	bh=04D3IOFch4lv+J145FZsC3twj0vn0K99bbGwP9007SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJYKYD9AT2WzqPbxoYqB1EqNLY55UE1c50aO1Z+HmPB+b0ADfPX5dbGwKAa8XBgHb5X6OhGfOQ4RyL38dDf04seoLrXmFUf/63XSvsah4/1MpAkD7riQfm082HfxbPbWTdymp5/oABW9Ih4xp+koW6szH9okLfSR6zbZKKQUzX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5uZJsb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5uZJsb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF27C4CEE9;
	Tue, 11 Mar 2025 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705367;
	bh=04D3IOFch4lv+J145FZsC3twj0vn0K99bbGwP9007SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5uZJsb7917LkKMlidNtYom9M1uaJJzwb8gvAFbEnLUbNgQjZk7mb4H7BenljYKl6
	 1L/fVMRC++dXwivcHv8MNdMniTq69XLZMPrvJjZBEScuk1en/cV7GRt9qMTxPk41Vr
	 Optcib7tUednJwFKTvy/ZXVz+Q1/y7pieHuA4Nzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/328] ipmi: ipmb: Add check devm_kasprintf() returned value
Date: Tue, 11 Mar 2025 15:56:21 +0100
Message-ID: <20250311145715.326481454@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 09e3e25562a89..f56b92880cdaf 100644
--- a/drivers/char/ipmi/ipmb_dev_int.c
+++ b/drivers/char/ipmi/ipmb_dev_int.c
@@ -309,6 +309,9 @@ static int ipmb_probe(struct i2c_client *client,
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



