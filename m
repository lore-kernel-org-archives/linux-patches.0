Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F80F36F431;
	Tue, 17 Feb 2026 20:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361006; cv=none; b=LcEpKpB3S+uwiyVSO5xX2sT4NCuWirAmRbPthp54Akzmgm8bpSpiUdBRlSQiZEqiENz56xdRvLIcqOcfz+N8MpMB68Cch8p5GSocdZn0yxCvI1dF/9mor/gDctZVC2Dra9aIor2cWso09hmSQBMfOAC2rPI0LtHK7NIs0vpD1V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361006; c=relaxed/simple;
	bh=4pV1/wpJqEsTyEvl/8pXFk9k6C8BRWSsH5HIhSdhMxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yag0fMYZ+G9smQwf+PY8gVpfQdT1NPMhJ/q+hvh8L3OEnHFuUU5JeNWrdG1pEoq6BvwhWaICU1WYTtokNKfa7YebQiJcXm7FtLpvMmixikoExI3oHhxD8JWJzDTQ+Yb/vxPFo8mrMUzAHZ0OrMvmAU0XC2jYgpLDqVbCSMSPaIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBRUDeQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBRUDeQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB67C4CEF7;
	Tue, 17 Feb 2026 20:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361006;
	bh=4pV1/wpJqEsTyEvl/8pXFk9k6C8BRWSsH5HIhSdhMxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBRUDeQuctnOljL2EFVoimG6GhWsEDnkFi1X+yTylHJFh2AnO37WpdTgx+0fED75H
	 p2zijzGjl6IivbC43oXmYqq68NMiXzzZIwoRhGZTBTtfNUdekeYj9VyIfeop7SiMXz
	 ig41W+xoQPVBWXhDwfF4w+CCtvcx2WPwS4d2WMjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/39] platform/x86: panasonic-laptop: Fix sysfs group leak in error path
Date: Tue, 17 Feb 2026 21:31:23 +0100
Message-ID: <20260217200003.478966544@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 43b0b7eff4b3fb684f257d5a24376782e9663465 ]

The acpi_pcc_hotkey_add() error path leaks sysfs group pcc_attr_group
if platform_device_register_simple() fails for the "panasonic" platform
device.

Address this by making it call sysfs_remove_group() in that case for
the group in question.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3398370.44csPzL39Z@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index e412a550f0983..418cd4d781261 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -1073,7 +1073,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 			-1, NULL, 0);
 		if (IS_ERR(pcc->platform)) {
 			result = PTR_ERR(pcc->platform);
-			goto out_backlight;
+			goto out_sysfs;
 		}
 		result = device_create_file(&pcc->platform->dev,
 			&dev_attr_cdpower);
@@ -1089,6 +1089,8 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 
 out_platform:
 	platform_device_unregister(pcc->platform);
+out_sysfs:
+	sysfs_remove_group(&device->dev.kobj, &pcc_attr_group);
 out_backlight:
 	backlight_device_unregister(pcc->backlight);
 out_input:
-- 
2.51.0



