Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4AF37BE64;
	Sat, 17 Oct 2026 16:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254716; cv=none; b=tsfrZyaaOy9kv+Iws7DQnO1dqWOGka8X6nadNPHeWK95NRqcYwYcl2/fUtqf1OTNQfybryBXEnCJbclRlQKBlmgR3QKlEIQaZpBjwrZhTX1qfRafPZChe8P94gb0CiQoKqUeYESmIktaJLYj9LOxuO5o4f+OVipO/E3JX9P0FJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254716; c=relaxed/simple;
	bh=iCb28sk+0+XpAd46rt/vHUTHldNz1AnPZV22SLnS6DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1iYxAAlVUAEyRzSMFDrX04tvgUXx+G5Rx1R/mSlYuu72988/p9QqPzPgRL08P18hRqn2l1kEjGg5TDhSx7rnInBydBrT63haOMFf62ArISZsIve59LBt28231VsAUfS/PduAJ37PsJ56Mb66CWPcHnWQJbSGF4yFl/uzmm8Fsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7gO/C0Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7gO/C0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37201F000C4;
	Sat, 17 Oct 2026 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254715;
	bh=qkzmZyOQDQDYFygS+rJzjyZIXusXS0bXcgL5aWObEME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7gO/C0ZJPiH4ZzSFT5+Ywb3un4ZiApnnClzYCtM3+FGzhbEs67UFjH6mUneEhO88
	 qdq8tU5IJkvXJYb0OXGZXJXUcqLwY6UDsVgChk4oF/ywFIxujoIP56pmNZWGtJv78Q
	 wjtoBzRxgCQGiNqqn0/VkeB/ClklWnHX+EW4gy6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 538/869] EDAC/igen6: Fix call trace due to missing release()
Date: Sat, 17 Oct 2026 17:56:19 +0200
Message-ID: <20261017160050.893818350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit ab1f9d466c7d83ab0d2a529e07984e53b5960dcd ]

When unloading the igen6_edac driver, there is a call trace:

  Device '(null)' does not have a release() function, it is broken and must be fixed.
  See Documentation/core-api/kobject.rst.
  WARNING: drivers/base/core.c:2567 at device_release+0x84/0x90, CPU#5: rmmod/127209
  ...
  RIP: 0010:device_release+0x84/0x90
  Call Trace:
   <TASK>
   kobject_put+0x8c/0x220
   put_device+0x17/0x30
   igen6_unregister_mcis+0xa2/0xe0 [igen6_edac]
   igen6_remove+0x82/0xb0 [igen6_edac]
   ...

Fix the call trace by providing empty release() functions for the
memory controller devices.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260403054029.3950383-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index d4b034737e31f..3a28b3d6242da 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1198,6 +1198,11 @@ static bool igen6_imc_absent(void __iomem *window)
 	return readl(window + MAD_INTER_CHANNEL_OFFSET) == ~0;
 }
 
+static void imc_release(struct device *dev)
+{
+	/* Nothing to do, the 'imc' owns the 'dev' and will also release it. */
+}
+
 static int igen6_register_mci(int mc, void __iomem *window, struct pci_dev *pdev)
 {
 	struct edac_mc_layer layers[2];
@@ -1236,6 +1241,7 @@ static int igen6_register_mci(int mc, void __iomem *window, struct pci_dev *pdev
 	mci->pvt_info = &igen6_pvt->imc[mc];
 
 	imc = mci->pvt_info;
+	imc->dev.release = imc_release;
 	device_initialize(&imc->dev);
 	/*
 	 * EDAC core uses mci->pdev(pointer of structure device) as
-- 
2.53.0



