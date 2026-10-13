Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46B94FC320;
	Tue, 13 Oct 2026 12:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894208; cv=none; b=dODRq5g42CBS5Cfo7nie/rjI2OrX8gXsXeip9eL6oL3ukgPycZ658t+uHddO6q6kCy271AfS4Y+KOjEE0GG2GbbIycn/vw2NZE55mwhuGapfw3FXXcB8KCJTuIPbfZCsmIEhzA60GQ7IOE8/K2CzkMiCcv2QsPOob9z3uzI9wPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894208; c=relaxed/simple;
	bh=o8a9mWXV48/jTZqQ2oN34tlqmHWRN2Sa4v7aVmdk4rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j49XESPTUPf/V3XPfRodYp7+lg8l/vklBnpUeLOczakiARdgQLYfkFgbTqxMXoq10ZNf+8sLw2uoBMPe9jGISqJeF9MsAwfDkvlaiRnVPBmLjYX+kXrsPye587k4oyy9vV51fCpKNWZImzdQtDnGGDj696SD46OURe2/Pp9Y8Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2Eg4vPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2Eg4vPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290101F000FF;
	Tue, 13 Oct 2026 12:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894207;
	bh=my9N5sIWFISQNfzJD5ys2may3iexEtr1/cjPOOMmvyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2Eg4vPQLE79n30AZsY0qJJzJRcMyIy0hukjaNnMRn6uInkYZHa2qZouba16U+BrU
	 f5g12Pu7y4tDfdxmrdMpWLmbDoOVzCOjZAHAQAWBVb/Mw8t9yStjZWl0QWMxmpJLr7
	 V19TXJ8K9TCywsPNsBAtqruaYus/beRhZlth83tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 481/621] platform/x86: asus-wmi: fix resource leaks on probe failure
Date: Tue, 13 Oct 2026 13:37:56 +0200
Message-ID: <20261013112932.247770628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit ef3daa2b84a2b8499ce9e2ce1c865dca36d39f95 ]

During driver initialization in asus_wmi_add(), various subsystems are
registered sequentially. However, the error path labels are out of order
relative to the registration sequence.

Specifically:
1. If asus_wmi_custom_fan_curve_init() fails, the driver jumps to
   fail_custom_fan_curve. Because this label is placed below fail_sysfs,
   it bypasses the cleanup calls for the input device and sysfs groups,
   which were successfully registered before, leaking those resources.
2. If asus_screenpad_init() fails, the driver jumps to fail_screenpad.
   Because fail_screenpad is placed below fail_backlight, it bypasses the
   cleanup calls for backlight and rfkill, leaking those resources.

Fix these resource leaks by reordering the error path labels in
asus_wmi_add() to match the exact reverse order of the resource
allocations.

Fixes: 0f0ac158d28f ("platform/x86: asus-wmi: Add support for custom fan curves")
Fixes: 2c97d3e55b70 ("platform/x86: asus-wmi: add support for ASUS screenpad")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260617155104.10111-1-scardracs@disroot.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 9026744d72267..9f0f79030b5b8 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4877,20 +4877,20 @@ static int asus_wmi_add(struct platform_device *pdev)
 	return 0;
 
 fail_wmi_handler:
+	asus_screenpad_exit(asus);
+fail_screenpad:
 	asus_wmi_backlight_exit(asus);
 fail_backlight:
 	asus_wmi_rfkill_exit(asus);
-fail_screenpad:
-	asus_screenpad_exit(asus);
 fail_rfkill:
 	asus_wmi_led_exit(asus);
 fail_leds:
+fail_custom_fan_curve:
 fail_hwmon:
 	asus_wmi_input_exit(asus);
 fail_input:
 	asus_wmi_sysfs_exit(asus->platform_device);
 fail_sysfs:
-fail_custom_fan_curve:
 fail_platform_profile_setup:
 fail_fan_boost_mode:
 fail_platform:
-- 
2.53.0



