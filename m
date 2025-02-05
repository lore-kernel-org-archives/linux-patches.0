Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA79913C9C4;
	Wed,  5 Feb 2025 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763497; cv=none; b=HI1jKpEEXLf35+xImgRYyd/VvT7z/9oRLEnsZNdPY/Oz75omIRyKByBOG0G2F2e3htQoi1fx+dDE8kv06A2yhdAWMRlyii5FYQa0FV8go0WjZZJfToOWZ/3Lclw503uBbaGR/qfqlRGHqbV2M2QVetU1F3QysSitoTLrKded/wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763497; c=relaxed/simple;
	bh=/xGqoXQIAy1EJrWuiV6D8PCq1xuBZj3x+hOdo1vs1RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miukcsYOSRpjG7orM4E+rM1kGTcwFoFx9IHfdOgs2JfBzs01H8clA68/ouxGCpS1zSYZH4I9vC2E1RMsEW28wZZcjOA7yxVXj/l/toaPPObV1oq3vmPf1tL9twf+jjSCpq+6YEkWJUKDjqwMdVWqKm5/11LCpjQysk5q4zCzpXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vni25rmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vni25rmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5040DC4CED1;
	Wed,  5 Feb 2025 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763496;
	bh=/xGqoXQIAy1EJrWuiV6D8PCq1xuBZj3x+hOdo1vs1RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vni25rmS7jt0JGeD9lNDbWWRqBk+qCc3Z4wJyGzhlhWy2Pg4C8GFEs09pm7oiD4hf
	 BIBw1dIJL9BYuL9flww9Q7N2mjvbwd6/GU6pi6YvJqPPoFy017VvTtwy3Tev4WX8xU
	 FTghP7AShh7zQZR9mu188BAg7ZSNm+ppwgIMNY7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/393] ACPI: fan: cleanup resources in the error path of .probe()
Date: Wed,  5 Feb 2025 14:39:52 +0100
Message-ID: <20250205134423.085473358@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9dccbae9e8ea7..e416897e3931c 100644
--- a/drivers/acpi/fan_core.c
+++ b/drivers/acpi/fan_core.c
@@ -367,19 +367,25 @@ static int acpi_fan_probe(struct platform_device *pdev)
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



