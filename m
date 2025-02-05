Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C4A126C18;
	Wed,  5 Feb 2025 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763347; cv=none; b=piG9o+f/R206v5GO9IBfJUUIZlJitbpo7Yt9tM5hmcVo7TpDR82Pfq4jvEX3Q+okRrfV3HLSYp5eRWmgBZxTx82Q0za/ucczdux6ZLkA6u6kFlnG5Hft5hv3SxzQ/e0U0IgLK0+oqfZLImZhlsXnECxNmb9dv7+HhAkaQH4N4v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763347; c=relaxed/simple;
	bh=zW8XnsT5Vi/Gh0XuOg+tsObEXDN+kRhidrXpR4OwSO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WD0TVw4zZMWb+p1i4JtaUEUNhld+wRWbSNo6jflw/lEi4DwX4y7XSRVEf2EVLZWH/m6kktjLgT/O7l1UskyQtY5tHO1PjGtea5MxH9kb7oV9uFYZIXfv1sQZ/dGkFwCCrYm+agRo3D9kREr0df+RM0gORaY1xjlvl3CzI/bDgaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yD7tezPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yD7tezPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A05C4CED1;
	Wed,  5 Feb 2025 13:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763347;
	bh=zW8XnsT5Vi/Gh0XuOg+tsObEXDN+kRhidrXpR4OwSO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yD7tezPqOs4LqpnTedIaxMnB+v6T69EnC5sT0rHAkEp92uxwohkpCZdi7ICVHCMdJ
	 A+0emn1RWM9nyWpD0wS9IIgMZauQh/ZMmTR9kjP2OyNuVolxPiZb+62lrU5T1/MT+s
	 u9VHeMQT9BVemo5P0b5L4leIn861FGdeW3Ku9TaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/393] ipmi: ipmb: Add check devm_kasprintf() returned value
Date: Wed,  5 Feb 2025 14:39:26 +0100
Message-ID: <20250205134422.101592486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 49100845fcb7b..9371891915129 100644
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



