Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D89349CF0;
	Tue, 16 Jun 2026 19:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636751; cv=none; b=GH7RVj8d4VRbKbmUUvcoZ4KVVg+YMe9dhDiedVbCTyBpfCyWfZtMyY+ANq2wtrDzHGrxT2jPkl8XZLOvBjDXzBOO6JrXVSTRhsZhM355u/HoLo+iCl3SIMGjfbVtrHZ/rtFKeNvGu0oMY/WwRdhMgKaHgr7dY0y9JgGuzInB5Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636751; c=relaxed/simple;
	bh=QlJtSaMSTjKIxWiO/I6VReSj+WWZrY9vUXDeq7xTHjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvOcsYcMvDIq8ntUJfVmMNmnzFAuRoEDULdqplgmmG+u72dQWE1M3mCS11Ml4zouAtW0WrQ0XbpMQ3oWAE5cIxqYX3QjDwLFNMaT50RJ32GLquOdGis9ztjOBGkSihZ8plHDcamZr2tejAab5lGspxyL121IgHqDAMLYG7sKYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4vqJZAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4vqJZAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D861F000E9;
	Tue, 16 Jun 2026 19:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636750;
	bh=KVqU5r2iIU3JtaM/QRIvO9MnvOmM1KbDXHmbeY5oo+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4vqJZACANnqQFQL8wUe+JPPt0YjjrEyiC/zu6+gOHYVFl11x5YZ3cfnotDQlGaKB
	 pKpV8N4SLWDPf9FvSqGQu8soDGFML3VbX1ZXuZqdJ23/GaYcnRf9LJkZAyEIUM09H4
	 ocIsPQuhzD8PwMA+1Q+Uf3VNP+XMQjHkcVUwGhWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 299/342] phy: tegra: xusb: Disable trk clk when not in use
Date: Tue, 16 Jun 2026 20:29:55 +0530
Message-ID: <20260616145102.362344852@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit 71d9e899584e11bbd7eaf9934a619c69a15060d8 ]

Pad tracking is a one-time calibration for Tegra186 and Tegra194.
Clk should be disabled after calibration.

Disable clk after calibration.
While at it add 100us delay for HW recording the calibration value.

Signed-off-by: Wayne Chang <waynec@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20230111110450.24617-5-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: da110228b54f ("phy: tegra: xusb: Fix per-pad high-speed termination calibration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -225,6 +225,10 @@ static void tegra186_utmi_bias_pad_power
 	value &= ~USB2_PD_TRK;
 	padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL1);
 
+	udelay(100);
+
+	clk_disable_unprepare(priv->usb2_trk_clk);
+
 	mutex_unlock(&padctl->lock);
 }
 
@@ -249,8 +253,6 @@ static void tegra186_utmi_bias_pad_power
 	value |= USB2_PD_TRK;
 	padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL1);
 
-	clk_disable_unprepare(priv->usb2_trk_clk);
-
 	mutex_unlock(&padctl->lock);
 }
 


