Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC8B25EFAE;
	Tue, 11 Mar 2025 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706410; cv=none; b=AMzmxqg0KUWI2T27FijjLGCY6ziSrSOraYx4uIGULISpFWOgIns7SczcS/xWYPyS9UxblQpPbXfnXHFZe/Pq5nWesgQBrTmHoSHrWjAKnfCei5kVxXzW47qGS1+ljt7yqPOAr1/DDNq6WegvWn6SP8bGS4eiKZqqSJLHYNutGmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706410; c=relaxed/simple;
	bh=Qws+FS2KYbwMTQP3wzBEeSv1Bg0DJSRIkYhpXdcNDuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJms3nFIks9ZR2DkrSJDBNWadeNUlttuSCUh2uhQkbhmoyxcPDiNezsdM02HC4qiCGzLokR3jSRi1oQpYhUZTIctUbuMwyZ40UK+5UTKENkpkynKOvbN/pa8Jt5AN7RoS2/m2P5gQgXJF6SliCT0C++m4kna0p7o77FWTP0KOjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+MlS7/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+MlS7/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D18C4CEEA;
	Tue, 11 Mar 2025 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706409;
	bh=Qws+FS2KYbwMTQP3wzBEeSv1Bg0DJSRIkYhpXdcNDuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+MlS7/NG0E+X6dtFdPfMzITCZY0+zjA4aJV4yN9bOLbLhgVkP6psF7TGI2S03czg
	 EzoIWAuiDvvT2RIuI/qNf+podkxNd034Oaa0XFeAF+rvBw3UhDWfHJWblUviRIx1aV
	 A1pXcI7OLvSaG1umM5hP6IXSy9LMxED4pQSJHh64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/462] ipmi: ipmb: Add check devm_kasprintf() returned value
Date: Tue, 11 Mar 2025 15:54:37 +0100
Message-ID: <20250311145758.797114363@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 382b28f1cf2f6..8800f2998d590 100644
--- a/drivers/char/ipmi/ipmb_dev_int.c
+++ b/drivers/char/ipmi/ipmb_dev_int.c
@@ -322,6 +322,9 @@ static int ipmb_probe(struct i2c_client *client,
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



