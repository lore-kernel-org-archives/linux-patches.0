Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D828E15198D;
	Wed,  5 Feb 2025 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764781; cv=none; b=nwcQnvfp1d+MB8Xu2+yFabZGPSdI3KInbNVJxStaV0+qYFLxCRuyUiXSzu9WchN8nDRnoyT1ucPFbnliq6xtD5FUY8En2r0+Yo1RfySMJRD6tMHFlXWmT0YCvX0dW3N3onAiEc2dU1WsKhMNM3he59TmiccwNmkiEFLeeeV4k+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764781; c=relaxed/simple;
	bh=NFYOXbcZLTQBVEu7fe2cDB/hKkd7YAwL9G+mr7zfgjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUjRtKybaGfrUROosK2Mo25S9S9oJLVG7Pq+hU2OVpJ2VDPU8DvlgHqesnkwWT5BqkLTgic5el2uRt/FZaHC6x4WZabZIuXkKT5sHkXmAyLTwBbu0/xV4oV5zNY7Qi5Yt6DrOCwaDe/eiqtjeRiGHQe6NUCNKeENzLbBTuvgakA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbA1JmMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbA1JmMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7D2C4CED1;
	Wed,  5 Feb 2025 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764781;
	bh=NFYOXbcZLTQBVEu7fe2cDB/hKkd7YAwL9G+mr7zfgjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbA1JmMGS4HpfOSghCduJqVqiqmYx6SIPpaSisz2P14voBY/oiQz+Z58PgvBe+nO/
	 b/O9Vg4a5Pnlaabm9Dh7oNfp+KvoqUV9p0AI5H6/hA3eTWaTJCITf8ajXsLtLEubGs
	 FgNJzn+0Si2yj1USVH8aYhzy5Z2yhTW23bWC3AJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 113/623] ACPI: fan: cleanup resources in the error path of .probe()
Date: Wed,  5 Feb 2025 14:37:35 +0100
Message-ID: <20250205134500.539425802@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit c759bc8e9046f9812238f506d70f07d3ea4206d4 ]

Call thermal_cooling_device_unregister() and sysfs_remove_link() in the
error path of acpi_fan_probe() to fix possible memory leak.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 05a83d972293 ("ACPI: register ACPI Fan as generic thermal cooling device")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241211032812.210164-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/fan_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/fan_core.c b/drivers/acpi/fan_core.c
index 3ea9cfcff46e7..10016f52f4f40 100644
--- a/drivers/acpi/fan_core.c
+++ b/drivers/acpi/fan_core.c
@@ -371,19 +371,25 @@ static int acpi_fan_probe(struct platform_device *pdev)
 	result = sysfs_create_link(&pdev->dev.kobj,
 				   &cdev->device.kobj,
 				   "thermal_cooling");
-	if (result)
+	if (result) {
 		dev_err(&pdev->dev, "Failed to create sysfs link 'thermal_cooling'\n");
+		goto err_unregister;
+	}
 
 	result = sysfs_create_link(&cdev->device.kobj,
 				   &pdev->dev.kobj,
 				   "device");
 	if (result) {
 		dev_err(&pdev->dev, "Failed to create sysfs link 'device'\n");
-		goto err_end;
+		goto err_remove_link;
 	}
 
 	return 0;
 
+err_remove_link:
+	sysfs_remove_link(&pdev->dev.kobj, "thermal_cooling");
+err_unregister:
+	thermal_cooling_device_unregister(cdev);
 err_end:
 	if (fan->acpi4)
 		acpi_fan_delete_attributes(device);
-- 
2.39.5



