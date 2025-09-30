Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E7D27056D;
	Tue, 30 Sep 2025 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245800; cv=none; b=do6f0E7EkqTeZ/vIR5/qFPiAu3ffrjt9JZS3SDuh/Ir3YP3Bo6L6teIFP1lWGidYCmcJasYWwB1kFy9w4+iE78cW0pVdNv0i8tVo9OiCF2iqtdu80KMZOujdD7TN3BDsLki8IJmmMQ4i6tUnexqqd5uOcupk43xbiKkrBnOeF5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245800; c=relaxed/simple;
	bh=7//x2NvAvgbljN05Ks6r4it1DpagUQppYEhj8ydA+9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8A+VPvga0vR1YdWA25q6p0PcBwIyUPoCkmWsIMA7Xhe1eVsADOawSKt7CwbO53qX9VnwsQiXrvmvFVIITlgzRj04tXnesVSqPfqu2L6IC4m9/4oktp7RJ85flrnMzpW6zeK6SsPB0QRvitCACyb8tk97yVGijwRebL86ZQhwAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCzAy8E4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCzAy8E4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA92C4CEF0;
	Tue, 30 Sep 2025 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245799;
	bh=7//x2NvAvgbljN05Ks6r4it1DpagUQppYEhj8ydA+9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCzAy8E4cUL9k+Qnxzc1qJlpsVApUZApabExgS314lSwe1qrdgiwy1ZQDt1apWmRZ
	 vor6yx134Mxos4sUdZs++gmslqScCAR8bISw86J19NzPbO4av/TxnPNCVYYJsKvMfV
	 eVK0S7Vx512HiJxXAP1VQKr+djkebWIIfitOgSfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zabelin Nikita <n.zabelin@mt-integration.ru>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/91] drm/gma500: Fix null dereference in hdmi teardown
Date: Tue, 30 Sep 2025 16:47:51 +0200
Message-ID: <20250930143823.350408140@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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
index ed8626c73541c..f0ae675581d9a 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -726,8 +726,8 @@ void oaktrail_hdmi_teardown(struct drm_device *dev)
 
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



