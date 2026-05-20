Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B07E36E48D;
	Wed, 20 May 2026 16:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295128; cv=none; b=frqHFnOQlD3+VRd7DPxOhGMVcVpIquuDFpqHFq5BVXUqUeMmZBkFpL/ytxqv4Xb9siN7SN+B+Zh7x0AqO6WHz8Jt3drJNicIGsZJkd5kY7VWBGOORDUPsqcuUGJVt9VdJOPS8U7uHDYxfPFGR4yK67z/pCjJQvhNftFk4Pjn4yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295128; c=relaxed/simple;
	bh=RVNwAg5svHhlNc53ywFOl4K2DxBvjpvADNlasGr4e2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evUT4ZZszyZik1FqG6MfQO880nRdCdnyN4iDi97meqWBUf9mQ0oWeVT9Sk/HZ80H57uGnd3pmkiEgWE/ICeAsyvvQzhWw3XJ/Hh6+GuxdUepum6Lfj4SddJBNlLOTZILJOHgIbzN2SsFVFZDXGyjwnNijTXjum2RNw7SlpP1trQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnyMtpAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnyMtpAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F721F00893;
	Wed, 20 May 2026 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295127;
	bh=TepA8PRwyu5azYtlDZG/oppM4Dg15dmbs1i15MPWTxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnyMtpAevpViUFl6Gb2bvn3eOi93vpugusIYT7sWD2HB5laqvw73diLC37x+lecuC
	 6mZp+0LCymo9g8LkrqoQOdbpMEAeVlu6rAi1jKnUF40JcfL7N0rxfWgmnRYpar7d9c
	 7ucmKZ+5cErcWHdmLuaO8w9fB9ZjxCKez65AXnWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0260/1146] platform/chrome: chromeos_tbmc: Drop wakeup source on remove
Date: Wed, 20 May 2026 18:08:30 +0200
Message-ID: <20260520162154.114823337@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5d441a4bc93642ed6f41da87327a39946b4e1455 ]

The wakeup source added by device_init_wakeup() in chromeos_tbmc_add()
needs to be dropped during driver removal, so add a .remove() callback
to the driver for this purpose.

Fixes: 0144c00ed86b ("platform/chrome: chromeos_tbmc: Report wake events")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/6151957.MhkbZ0Pkbq@rafael.j.wysocki
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/chromeos_tbmc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_tbmc.c b/drivers/platform/chrome/chromeos_tbmc.c
index d1cf8f3463ce3..e248567c0a182 100644
--- a/drivers/platform/chrome/chromeos_tbmc.c
+++ b/drivers/platform/chrome/chromeos_tbmc.c
@@ -95,6 +95,11 @@ static int chromeos_tbmc_add(struct acpi_device *adev)
 	return 0;
 }
 
+static void chromeos_tbmc_remove(struct acpi_device *adev)
+{
+	device_init_wakeup(&adev->dev, false);
+}
+
 static const struct acpi_device_id chromeos_tbmc_acpi_device_ids[] = {
 	{ ACPI_DRV_NAME, 0 },
 	{ }
@@ -110,6 +115,7 @@ static struct acpi_driver chromeos_tbmc_driver = {
 	.ids = chromeos_tbmc_acpi_device_ids,
 	.ops = {
 		.add = chromeos_tbmc_add,
+		.remove = chromeos_tbmc_remove,
 		.notify = chromeos_tbmc_notify,
 	},
 	.drv.pm = &chromeos_tbmc_pm_ops,
-- 
2.53.0



