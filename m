Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F726335BCD;
	Fri,  9 Jan 2026 12:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962270; cv=none; b=tdUGzbTTm6MSpoFx/tjbCP6W8kQ8bLriWxZlfikmztLDRcjQngTqeVcXQyOY62lmD3d4iPpYiY9UoCr1hGXcn9juEJBdjQDJvHmpUgFkwLOUs7iX5YtPAtBfJtjnY5inQEzNwKItKocJBE0gBa888DPRKYmeeKTjzm+AMLCeFHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962270; c=relaxed/simple;
	bh=cImV3KpHFohL2ihHr1x7KZZfm6QuqsxMFMzJ0RMPeZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgHkmSSoDaLFr7xJrCmjq5fiE8tDFmvIjqdBoGh1i5iTCT+7ksWDPTdjaodtSCGd3t6o+YJ463VRtMgfpty6EchGMBK9C0MSjrtnKItnxnP98YsLBTvoxKM1m2OC02/nxWlDldweeJh8WdIVb7ApkkZ6LTeLonzMOm862rtF/Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvpKliGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvpKliGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8D5C4CEF1;
	Fri,  9 Jan 2026 12:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962270;
	bh=cImV3KpHFohL2ihHr1x7KZZfm6QuqsxMFMzJ0RMPeZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvpKliGceqMcpaF78WKWCQcW8oNEwA4ikzCYMSJuVjoBNrbyImmildu+ilk/r0T0c
	 Qc1UMmJS+DN+aDh0rlH11iBRbu/g88nlAT53bZBb4Y32MXqOPfoWcihGHTlgsvRmet
	 tA1gkfzHBpqaQTvE2UlF09tgvBDUtJrF8lMz17LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 305/634] via_wdt: fix critical boot hang due to unnamed resource allocation
Date: Fri,  9 Jan 2026 12:39:43 +0100
Message-ID: <20260109112129.011136625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



