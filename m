Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5B733C193;
	Tue,  6 Jan 2026 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720098; cv=none; b=UDpJqgk85AE5pavYlBvV4OlpIjhcy7FjUQmfhlsH0xOgri+A/agYjXmpCn9f5Y+uJ5RwFwZucT1JlbSO7NLK0yOoQ4Huhfwp0TB/kO03GshWs022HJ8hOB4pnaTWQ2HW14nhU1wQr8Q170XLS82n8UMkuAO0bOMcNyzZqd7ZdD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720098; c=relaxed/simple;
	bh=Dqn6cVranBeyCUanrckiY+0fkVRX4xZSf4FEecT16vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfUcqqirEo+8JGmhBszar8dPUOmPH1RbWxuxVOUsQ5QZiZXMYhedm+vzyisNfzn6jQs9HskCBoJrKA7NP7UBF5MdflWPu5G/cDPVjzC/PGSOStBLg8Jq8airNkxQjSlk8eHYJ1TDYQYT+ImerK0vH+Y7qGBoV7BYRDFyUoMsVvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U10gc3cT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U10gc3cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D0DC4AF0D;
	Tue,  6 Jan 2026 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720098;
	bh=Dqn6cVranBeyCUanrckiY+0fkVRX4xZSf4FEecT16vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U10gc3cT7/fTN0zI5gxBpmkvbGpVKAap9SV6WIlJUKOiBSQHa9AnuYa3XCTV2h7fV
	 wAH7Nw5fYqWNkVWt1NhpnFrY6xUtT8K6i6TACXtqVE3ypWqOJNupLd1CDgMnvvJ/5o
	 hz2PVCGp85U84tG6bIFqEeHBoYkb8jz5YdqtVoLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/567] via_wdt: fix critical boot hang due to unnamed resource allocation
Date: Tue,  6 Jan 2026 17:58:34 +0100
Message-ID: <20260106170456.210673159@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 7aa31ee9ec92915926e74731378c009c9cc04928 ]

The VIA watchdog driver uses allocate_resource() to reserve a MMIO
region for the watchdog control register. However, the allocated
resource was not given a name, which causes the kernel resource tree
to contain an entry marked as "<BAD>" under /proc/iomem on x86
platforms.

During boot, this unnamed resource can lead to a critical hang because
subsequent resource lookups and conflict checks fail to handle the
invalid entry properly.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/via_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index eeb39f96e72e..c1ed3ce153cf 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -165,6 +165,7 @@ static int wdt_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "cannot enable PCI device\n");
 		return -ENODEV;
 	}
+	wdt_res.name = "via_wdt";
 
 	/*
 	 * Allocate a MMIO region which contains watchdog control register
-- 
2.51.0



