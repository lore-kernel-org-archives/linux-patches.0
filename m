Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B46143C65;
	Wed, 19 Jun 2024 13:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803504; cv=none; b=A+QLULnUDdj4Ktqc6FDQ/qa9k3u3SswoEJ4V5WlChfyqvyPYfagj/lCMZUaFu/f4UpJK9AllAh3nz0FdHzY736EAnHLjcZk8Lvmw9/cx3xDYepr1ju2Su0GaSgmU1tWbJmE+kbZSN7aAc76P3n9bO8iDuT/EEPgclxQJRU1/mk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803504; c=relaxed/simple;
	bh=8i+i2vKCjTkhNTUksVBg3iNO2aZT5aYXIhpek2X8A3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc3GebBF83M6qT0KQDzMV+RgmJKPO1p/kwrwavvt6kyMck228dzr7k0BQH21w3x+E75NjeGoaUr8iS+RKksV7mtjhxHiBeNkTnJ/aGn2UapwBOdZ3HItgx3wzD8u4+PJo4jGguCF/N0c/CZ8siRPg9IHLpeYfUOOBM9l3GaHCRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU+0AOKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU+0AOKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FC0C32786;
	Wed, 19 Jun 2024 13:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803504;
	bh=8i+i2vKCjTkhNTUksVBg3iNO2aZT5aYXIhpek2X8A3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vU+0AOKSHY5+xcT6Jn5zyQk0oFY8DhfaanuIk3DmZwG2bB8bejoPZOhLQTXjsk+xW
	 zjnSpt8glzJ5kOlqyIoFsbRgn4qO+04JeNX1H6qChSuwCf6/Z4FRGr3Mhmd5k0nrsK
	 otdSb0CKGk2lYU2ecSGNrFenqdNjVabqEDtdrV8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Wentong Wu <wentong.wu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 277/281] mei: vsc: Fix wrong invocation of ACPI SID method
Date: Wed, 19 Jun 2024 14:57:16 +0200
Message-ID: <20240619125620.638690490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit af076156ec6d70332f1555754e99d4a3771ec297 ]

When using an initializer for a union only one of the union members
must be initialized. The initializer for the acpi_object union variable
passed as argument to the SID ACPI method was initializing both
the type and the integer members of the union.

Unfortunately rather then complaining about this gcc simply ignores
the first initializer and only used the second integer.value = 1
initializer. Leaving type set to 0 which leads to the argument being
skipped by acpi acpi_ns_evaluate() resulting in:

ACPI Warning: \_SB.PC00.SPI1.SPFD.CVFD.SID: Insufficient arguments -
Caller passed 0, method requires 1 (20240322/nsarguments-232)

Fix this by initializing only the integer struct part of the union
and initializing both members of the integer struct.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Reviewed-by: Wentong Wu <wentong.wu@intel.com>
Link: https://lore.kernel.org/r/20240603205050.505389-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-fw-loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/vsc-fw-loader.c b/drivers/misc/mei/vsc-fw-loader.c
index ffa4ccd96a104..596a9d695dfc1 100644
--- a/drivers/misc/mei/vsc-fw-loader.c
+++ b/drivers/misc/mei/vsc-fw-loader.c
@@ -252,7 +252,7 @@ static int vsc_get_sensor_name(struct vsc_fw_loader *fw_loader,
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER };
 	union acpi_object obj = {
-		.type = ACPI_TYPE_INTEGER,
+		.integer.type = ACPI_TYPE_INTEGER,
 		.integer.value = 1,
 	};
 	struct acpi_object_list arg_list = {
-- 
2.43.0



