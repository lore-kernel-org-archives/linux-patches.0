Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E790D4E4C5E;
	Thu, 17 Sep 2026 15:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659867; cv=none; b=JKYeleyPQX5S9CUXJzR+8azsz2WQXJHi5FVFzVOyl4amYZehxSmvVggXXS7gxOxFo85HiwHIMjbK93m4aONvMVBbPXLBYt4PAFLc7WzHaoe/035K1J4Zjv61LrqYLtvLw84pKrQ+XWk+nDjIEMstTqOnHarte/vD/nLLX0XD0LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659867; c=relaxed/simple;
	bh=9hwD+G4h/j0Pq5mWphOH+By/IPd0KLDfR/1/9vWHuFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wb+drilrvqVt1G0HcGLWSGMVOmDzCAH/smj2Wtoxbd+AcSfTcSZzENYOKIMeWOVDuyID1knEC+p07NMOJG8qm46vCXMJ0cUdhIXDmwjsuJwdGsso3qdRvbJvAnD41K/lOVJM1ivIkFnufael3zzLkc2dfe0eDm2uwMAPJLv0OWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN+mXZ1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN+mXZ1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0011F00893;
	Thu, 17 Sep 2026 15:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659859;
	bh=D2CN+uDlu764HfO2WafQnfHXk/LOCzdgxumoPAfXhtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EN+mXZ1aCqcjOJ93fKL15uTvmKmZv8oW2cugFwMCgz18Z13u/laR36l9PeiDdZ12+
	 CvvqrtG/cZfBW/4y6iCA1lat6K5Krk6KKU9XS96fI/NOOvu9Hyt345YHgf7LGCCa5y
	 Aoy0eF6pFqDk+wtPiYJyaa7jQZJp57efsTgpLfbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 371/733] platform/x86: x86-android-tablets: fix gpio_secondary_fwnode_init() not working
Date: Thu, 17 Sep 2026 16:11:19 +0100
Message-ID: <20260917151400.885146751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit dd519eb8f66eaa205bbbdcb753588138a1d18414 ]

acpi_bus_find_device_by_name() call returns a pointer to the device object
on the ACPI bus, aka the ACPI companion device.

gpio_secondary_fwnode_init() then continues with setting the secondary
fwnode on this device. But this is not the actual physical device for
the GPIO controller (e.g. the GPIO controller platform bus device).

This mismatch is causing GPIO lookups by secondary fwnode to not work.

Modify gpio_secondary_fwnode_init() to instead set the secondary fwnode
of the first physical device associated with the ACPI companion device.

This fixes the GPIO lookups not working.

Fixes: 1448c2d2ca5c ("platform/x86: x86-android-tablets: enable fwnode matching of GPIO chips")
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260908185517.49047-1-johannes.goede@oss.qualcomm.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index 722c0ae4ecd12..7751261f4b7cf 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -381,6 +381,7 @@ static int gpio_secondary_fwnode_init(struct device *parent)
 {
 	const struct software_node *const *swnode;
 	struct fwnode_handle *fwnode;
+	struct device *phys_dev;
 	int ret;
 
 	if (!gpiochip_node_group)
@@ -408,9 +409,15 @@ static int gpio_secondary_fwnode_init(struct device *parent)
 		if (WARN_ON(!fwnode))
 			return -ENOENT;
 
-		set_secondary_fwnode(dev, fwnode);
+		phys_dev = acpi_get_first_physical_node(to_acpi_device(dev));
+		if (!phys_dev)
+			return dev_err_probe(parent, -ENODEV,
+					     "No physical device for ACPI GPIO dev: %pfwP\n",
+					     fwnode);
 
-		ret = devm_add_action_or_reset(parent, gpio_secondary_unset, get_device(dev));
+		set_secondary_fwnode(phys_dev, fwnode);
+
+		ret = devm_add_action_or_reset(parent, gpio_secondary_unset, get_device(phys_dev));
 		if (ret)
 			return ret;
 	}
-- 
2.53.0



