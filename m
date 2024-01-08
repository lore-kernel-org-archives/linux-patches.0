Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A4F4BAB1;
	Mon,  8 Jan 2024 15:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeLT9n4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29FAC433CD;
	Mon,  8 Jan 2024 15:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726785;
	bh=dmWIid33lCMvDo5AYrDV9L9DeipAeUs7KgT3jMZBASU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeLT9n4sUf+qxveaVKX/wuzJXUgH9kFU9kmZxeOPjZGeIYlBYdJNLgMrOIuv7NBNb
	 VkHBwp1npUbfFVT8hfhGFGSHzNhFcMiMdsmo2aeCJOZo93jV9w4jBpH3cXVJ1b1Z2i
	 7Fdkri2+T1LxV3LaxW+7Y6J0Ep6N6urudL9lDUJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/124] ACPI: thermal: Fix acpi_thermal_unregister_thermal_zone() cleanup
Date: Mon,  8 Jan 2024 16:08:23 +0100
Message-ID: <20240108150606.514127592@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4b27d5c420335dad7aea1aa6e799fe1d05c63b7e ]

The acpi_thermal_unregister_thermal_zone() is paired with
acpi_thermal_register_thermal_zone() so it should mirror it.  It should
clean up all the resources that the register function allocated and
leave the stuff that was allocated elsewhere.

Unfortunately, it doesn't call thermal_zone_device_disable().  Also it
calls kfree(tz->trip_table) when it shouldn't.  That was allocated in
acpi_thermal_add().  Putting the kfree() here leads to a double free
in the acpi_thermal_add() clean up function.

Likewise, the acpi_thermal_remove() should mirror acpi_thermal_add() so
it should have an explicit kfree(tz->trip_table) as well.

Fixes: ec23c1c462de ("ACPI: thermal: Use trip point table to register thermal zones")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 312730f8272ee..8263508415a8d 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -778,9 +778,9 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 
 static void acpi_thermal_unregister_thermal_zone(struct acpi_thermal *tz)
 {
+	thermal_zone_device_disable(tz->thermal_zone);
 	acpi_thermal_zone_sysfs_remove(tz);
 	thermal_zone_device_unregister(tz->thermal_zone);
-	kfree(tz->trip_table);
 	tz->thermal_zone = NULL;
 }
 
@@ -985,7 +985,7 @@ static void acpi_thermal_remove(struct acpi_device *device)
 
 	flush_workqueue(acpi_thermal_pm_queue);
 	acpi_thermal_unregister_thermal_zone(tz);
-
+	kfree(tz->trip_table);
 	kfree(tz);
 }
 
-- 
2.43.0



