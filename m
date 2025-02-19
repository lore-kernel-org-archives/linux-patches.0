Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EAD1F463F;
	Wed, 19 Feb 2025 08:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954767; cv=none; b=k4FClxfY8utN7d0aHqo2VgZYL2VXhLpqTTVCJkiU0DwqvnfqpjNtP9Y2mzahGVLQYfGQwKKkSSz7tW8ClcRcLAWNEOrJ1SzDDGP8ALt91N5Rr65djqEKSi0D0Sedk5AGroXTZyS7cYgyZz0nLGkQndChZpJ+6rgdcxG6GFCNlc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954767; c=relaxed/simple;
	bh=gWPW2VREhfzBowktHqngccayz79ofHB3BMWeniHNW5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8gAjwgQd77ZKzjVSj4vM31KvJWz2WRlHDszqV/bXdxJzJg0BipAmBy8wr/C2yUe++C/bPOLFMDTFKH7K2u6XAMXtwhf7wQyeKyzOyDAEHCsj3j3mYB50SNbC+nP0UBRvIYMO/w79zTc7fVE94BWoosNtH5wwNaOP787zay/muQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=annMANdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="annMANdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDA9C4CED1;
	Wed, 19 Feb 2025 08:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954767;
	bh=gWPW2VREhfzBowktHqngccayz79ofHB3BMWeniHNW5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=annMANdKNfNkO9H+vrPwPW1HYR2DA1SOUBXWhS82mrYxFrXjQRTX/Np0TI0N7CMvI
	 nNGBD8wEAbUXJEHZ6K0CtG0d64h5zufBjB40HheLMbOAHeQYH1iWUzktE3WqNQXBct
	 MD/lQz5QuqoT9P0G2rwlAVIKtqudcM6dIM7GOGz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/230] HID: winwing: Add NULL check in winwing_init_led()
Date: Wed, 19 Feb 2025 09:25:26 +0100
Message-ID: <20250219082602.061723488@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

[ Upstream commit 45ab5166a82d038c898985b0ad43ead69c1f9573 ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in winwing_init_led() is not checked.
Add NULL check in winwing_init_led(), to handle kernel NULL
pointer dereference error.

Fixes: 266c990debad ("HID: Add WinWing Orion2 throttle support")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-winwing.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-winwing.c b/drivers/hid/hid-winwing.c
index 831b760c66ea7..d4afbbd278079 100644
--- a/drivers/hid/hid-winwing.c
+++ b/drivers/hid/hid-winwing.c
@@ -106,6 +106,8 @@ static int winwing_init_led(struct hid_device *hdev,
 						"%s::%s",
 						dev_name(&input->dev),
 						info->led_name);
+		if (!led->cdev.name)
+			return -ENOMEM;
 
 		ret = devm_led_classdev_register(&hdev->dev, &led->cdev);
 		if (ret)
-- 
2.39.5



