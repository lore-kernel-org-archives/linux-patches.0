Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287D3F510;
	Wed,  5 Feb 2025 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764249; cv=none; b=K8QswwxK1DPY1JrGSH7Ah6nju9DjZRwARqJC0ZWYm9QmSCgyQCtfrcIfJP5YpptHNECE0xVCH8Gei6HvLuAxO0hqZ4cxcS2fzSPNf2utSheSY3cRqMb2+G6mTNLKufeT8sST7PglisIFERaS9OhOIoVpEvhd3bFyFteYvnxZOkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764249; c=relaxed/simple;
	bh=Qy9eG2NEsdgOH86RxcAy7Je7gI+yPmvHXMA4wGzQaB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luQIiNHQXmgHJ9gNQNqdBSGPjGY0CSiaX/3lHIZTYgE/r7Bd5MQ74JOX2/tho2RuHCzd9ObzW8Z85H2RnhTk4sgrJEtpSGxdzf+FdVWJLT37Nr+m2+U3VMBiZ3zq0CEaCz4/JTlLysyn0hGE9TXpneDb01YdqIKnJOxHeq9GZHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAKhUKdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAKhUKdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D286AC4CED1;
	Wed,  5 Feb 2025 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764248;
	bh=Qy9eG2NEsdgOH86RxcAy7Je7gI+yPmvHXMA4wGzQaB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAKhUKdIMRaR9Oe031TX0xb15ycCcVWsw1N/8M8XY+ijMxvVjnH/XC7uy+lH3EKmU
	 Mo0fX+cM7eHulT5v+l7hbAPn7yJ5HrQI1uZdZVnbPgfmMEGPNID2CSOe38OvTKqEN/
	 5x6vCpo6x5owVy4kcr8fmI2rrFywURUKGtllGP8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/590] ACPI: fan: cleanup resources in the error path of .probe()
Date: Wed,  5 Feb 2025 14:37:37 +0100
Message-ID: <20250205134459.160684637@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7cea4495f19bb..300e5d9199864 100644
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



