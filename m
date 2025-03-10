Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2104322D4C3;
	Mon, 10 Mar 2025 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628821; cv=none; b=SHptLK2z+whOQQAfvcwAZW7LraG0Tl9wasd7KY5+6tNbFP8ya4kmWFLvjv633tFFjLfqK7c6kV7bH0TGYzdyxRt6D3UuKSDnVVE6mNcB0hkjB4aCO/tzL8eFHZ426zLYeMZ+/PdiyeKYqFLomdQC4cM+9Uzgrrs9NWvRdrgGMlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628821; c=relaxed/simple;
	bh=UYzXmDqp2yAwkgttTx81ISyFXo/Z2zk12GsU7TRTrTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2FOI7CUfJN6EOD/93c8ASaJRbhLGRQsgq9rUtBGnUxuZoMz2pBlW+1zSDo94DkDjWRrDJfiKawMUSEH0DDFznecEFfFa1MNasOCXk6y5dxsfYqwy8tJAcylZ5EW92XFB1ZZ2fGGwrHuwpoh8EoXlo0NUmK5wo04xygHaolSgrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lD2rgUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lD2rgUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A192AC4CEE5;
	Mon, 10 Mar 2025 17:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628821;
	bh=UYzXmDqp2yAwkgttTx81ISyFXo/Z2zk12GsU7TRTrTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lD2rgUS729W73AwXnGlbOepg/fu4EtlSWHhKtoSqJYZqnSh6dpL92WJOxfz0Mpe8
	 +GRPu7OU+hk82bOiAt9qvvFRQQXmPjeHHKmvzh3hyZcTPwmD3OoyVwgzLfdC5XLLFi
	 JjB6YuU6grPVqQlbqG7WEsbmusLOqk5GckHJwt9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/620] ACPI: fan: cleanup resources in the error path of .probe()
Date: Mon, 10 Mar 2025 17:58:15 +0100
Message-ID: <20250310170547.514798964@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/acpi/fan.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 5cd0ceb50bc8a..936429e81d8c8 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -423,19 +423,25 @@ static int acpi_fan_probe(struct platform_device *pdev)
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
 	if (fan->acpi4) {
 		int i;
-- 
2.39.5



