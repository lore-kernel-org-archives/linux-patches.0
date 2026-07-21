Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848133B2FC0;
	Tue, 21 Jul 2026 20:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666378; cv=none; b=j2eyY/8OJsr/tXYvWKayO30VieWCe7LzADnU/849w4IQJgT5bAmNajumMbWugaeQ9lu4H3PhL1S0DdQymWehPHW2ntGJOqNpp5nRfg7i7J+PHKs8e2vAA3QN0yE0WZdZF41ATHWQRJJzTQXJjUCHN2UgITdRaUQ2B6Dsj+MvlYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666378; c=relaxed/simple;
	bh=Z9L8uKDy/Kj4MTnNVeaFShoY0iWbQtXG6hAm6U/lYyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4oTPQHtpcALCOoFbTPXn0e5seGTJXDaxTiWrUTyM+/PzEz+Ez7/dMo6dgAMKGpJWQzWvJ2pskAK9TN796yvrJZ5CRyOJos3oVlqx3ygJvBm+Yt0PrupKyZCdNIMy+lNt/TTcCpW067Xu0F5DxYrE+PWi7dM/HZmeN7yq9v8+ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDhQkgzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDhQkgzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2BD1F00A3A;
	Tue, 21 Jul 2026 20:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666377;
	bh=VyUiZqmJMScykLaOKbRYbZQmMbEavI0Y/7I6q4pmNuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDhQkgzlAV+ccl2Aj/+n95G154E8lMmq14mCZkwWJqZbdf3wRsjhsntPLmNok1xRU
	 WQIXwRk7n6t0R/V7AFMWkJ9Mf+OVWe7112NCMOGRAbbDuL9DlFrPApCg2wB5+0nWY5
	 rGCCuvnzt+gs8/+j4QbmIbm4JfP8NskdVkRXzj4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0661/1266] PCI: meson: Propagate devm_add_action_or_reset() failure
Date: Tue, 21 Jul 2026 17:18:18 +0200
Message-ID: <20260721152456.650927036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit b12341b98d5ac52f48ca1390e1e371aed81346c8 ]

meson_pcie_probe_clock() enables a clock and then registers a devres
action to disable it during teardown. If devm_add_action_or_reset()
fails, it runs the action immediately, disabling the clock.

The return value is currently ignored, so on that failure path,
meson_pcie_probe_clock() returns the disabled clock and probe continues.
Return the error so the existing probe error path unwinds normally.

Fixes: 9c0ef6d34fdbf ("PCI: amlogic: Add the Amlogic Meson PCIe controller driver")
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/177909148011.9588.6639767953842842291@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-meson.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-meson.c b/drivers/pci/controller/dwc/pci-meson.c
index 407558f5d74acd..282f218e8b68e2 100644
--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -194,7 +194,9 @@ static inline struct clk *meson_pcie_probe_clock(struct device *dev,
 		return ERR_PTR(ret);
 	}
 
-	devm_add_action_or_reset(dev, meson_pcie_disable_clock, clk);
+	ret = devm_add_action_or_reset(dev, meson_pcie_disable_clock, clk);
+	if (ret)
+		return ERR_PTR(ret);
 
 	return clk;
 }
-- 
2.53.0



