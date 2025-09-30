Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1A61B4156;
	Tue, 30 Sep 2025 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243961; cv=none; b=XerEQLtQ0xrX98b2w1Slsy1+Z+FV4Udg9nQrfRfaJuib1YGBttjrZE5Ulx9B0dy6Vd/Yf9/Emel9afznFccbv7YShcMTUzunjKIBYPHhTJtKFzOyldIy4+XBBnakb7mwp3MHNZ7UoKm0FngTjVvNDyNryDOTlYRbqMZxJAZ8sfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243961; c=relaxed/simple;
	bh=6lk2+qi1SxMk0xyDU19CoIwKhswamFgBfVnxzG6TDzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb/ARaHHx2oe/l6eqfD2vafX4UMy0w6T7DpWLCemIDccqfWiMw9a05XTG/Ewmykua3zmF4zmM1KlK/YmBuNnm8Cz2mnIqcMPibEsXs0BzCwoPRBJlLT0esdLaZu91ctFaCv90SMC3WR2iP+aijzFUjVdMfBh6DOjiLq8bMAKjKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X26SRy6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X26SRy6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E803C4CEF0;
	Tue, 30 Sep 2025 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243961;
	bh=6lk2+qi1SxMk0xyDU19CoIwKhswamFgBfVnxzG6TDzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X26SRy6myqgDr0uYbuNl3GShWJmqxf5o/P6rZD1AnWSQAs0uw8qLmbcjdYnf2z3Og
	 stUKs6FY/oDrJxxilb+3/DF7+e40XLo1Brb7MJTQUNiU4E2CEkyGFS5j16FQpOHeJo
	 CGuXF/vIswmWhegG84D0r0ZkxI31xTiBfqWq1q9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zabelin Nikita <n.zabelin@mt-integration.ru>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 69/81] drm/gma500: Fix null dereference in hdmi teardown
Date: Tue, 30 Sep 2025 16:47:11 +0200
Message-ID: <20250930143822.578974675@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zabelin Nikita <n.zabelin@mt-integration.ru>

[ Upstream commit 352e66900cde63f3dadb142364d3c35170bbaaff ]

pci_set_drvdata sets the value of pdev->driver_data to NULL,
after which the driver_data obtained from the same dev is
dereferenced in oaktrail_hdmi_i2c_exit, and the i2c_dev is
extracted from it. To prevent this, swap these calls.

Found by Linux Verification Center (linuxtesting.org) with Svacer.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Signed-off-by: Zabelin Nikita <n.zabelin@mt-integration.ru>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://lore.kernel.org/r/20250918150703.2562604-1-n.zabelin@mt-integration.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi.c b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
index f4c520893ceb6..93a0a791b8c38 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -741,8 +741,8 @@ void oaktrail_hdmi_teardown(struct drm_device *dev)
 
 	if (hdmi_dev) {
 		pdev = hdmi_dev->dev;
-		pci_set_drvdata(pdev, NULL);
 		oaktrail_hdmi_i2c_exit(pdev);
+		pci_set_drvdata(pdev, NULL);
 		iounmap(hdmi_dev->regs);
 		kfree(hdmi_dev);
 		pci_dev_put(pdev);
-- 
2.51.0



