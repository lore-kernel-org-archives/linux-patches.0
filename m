Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F49A33B6F1;
	Fri,  9 Jan 2026 12:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960508; cv=none; b=Lsqj3de3PcP0oKCxm6iTYeBCrnzHPbSLOFFJH04Ye4otaPEyPy77qbSWOo4nAjaK2GuJEVkgYaLoT7l6UoBTGOfWILzGo+1N9a6Hf2OCB4mNSYAJl/iNN1PMk4cPBDy9Y0R9QnbLwVBIOy7P8N+fk/JmnyS5qINSlLatuVh/zXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960508; c=relaxed/simple;
	bh=NUDpRAWUuzX9JqGOc+u0o3T9RcBt5fSvS9XNwS4G2d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS52ekeHxR+KfBTTgCYPfoW7FQfEjDH4Indxvtcr0zm+lzXaVyRx4RyM1QlELgshGzBP+xzX+2rf/wokRchQF3GT9cP5KQFBPyva34EwtKkYVInL/CflMWrgOaGeO0YcpuU9jWv4jxTz1SeZxZddEQ28K5QuWerA6vLXQEjnJFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDqpPony; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDqpPony"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1490C4CEF1;
	Fri,  9 Jan 2026 12:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960508;
	bh=NUDpRAWUuzX9JqGOc+u0o3T9RcBt5fSvS9XNwS4G2d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDqpPony0LImrG8ZO+m6aWzXA7iT2JptEy3V5oV/+fJ1aPVurdgnTlvK/JWHqZScw
	 rj74wF/9u9aqB7jQCl5N41aqX6kIYh3P1u3Vs30D91h3dLEkF2Z3sKNhzBa3cnB/Ay
	 3jS5tsbKZ8SHQSLxCa16l61hPXrzwprNzejjM354=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 396/737] via_wdt: fix critical boot hang due to unnamed resource allocation
Date: Fri,  9 Jan 2026 12:38:55 +0100
Message-ID: <20260109112148.896547323@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



