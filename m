Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2793D2FE3;
	Thu, 15 Jan 2026 17:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499391; cv=none; b=G+Xa82zFzcgzcA6nTeNpz3yN38dMJOzHt2e+y3tgW/l7PHTm3i9/sETsjnDo3bwdSwiXzZ7dqumMdiB+H5yvbzTvEwp3Hiq+2AgyDvbkx+13Smdkgn4n2we8R9I0f0toJFvDgx1xT2JwC9WytUernLOGAKP0qSuAFgUlORLw7jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499391; c=relaxed/simple;
	bh=NeK6aB+ntuhWbppWJ68SvEiHcLev3QKMEdk6hHXnJ9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D21lBmdgUKJs8zOFPK3Cu8j0/QFdv9lVZibhSsI0cCPAk/hDK5t1qipFMzugnsp46cwVyJL1TGAo7U7ugiRs8zL9bT7WotvvzVMmFAaRBRpJJjSFvP/awcrilSqjhb/qcGg7OditfpbMvINELNPvp67wbydyTYWuQRi87IaYa8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pkxa0fWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pkxa0fWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F911C116D0;
	Thu, 15 Jan 2026 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499391;
	bh=NeK6aB+ntuhWbppWJ68SvEiHcLev3QKMEdk6hHXnJ9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pkxa0fWmbXSiia6eCkWY5M90k+jEohb3NK7ZsTqXPi9nn5mBMbzC/PxU4bk9D4/jU
	 3jWpYnHj1dZ0Qg2K1Q7Rj/scuUZLhaP+MF3DKu2gp9EGrtEV/WLQtKofiXG8lcRObR
	 vVmainnQCNuSQsXtEX+TMA44Xlf2s5kq0leYTgBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/451] via_wdt: fix critical boot hang due to unnamed resource allocation
Date: Thu, 15 Jan 2026 17:46:52 +0100
Message-ID: <20260115164238.533725674@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



