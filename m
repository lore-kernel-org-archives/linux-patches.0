Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A29944AB68;
	Tue, 21 Jul 2026 21:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669236; cv=none; b=jtIa7If/OL+dFwD5yOpeGhx9cE3v/X3AWwjqTTtnh2jzSl0Lhz/ZGiPKphUb6W/T1lCwol1XRHvdzEr41WJXKwbqctqa45QVDrD2OO2E1swIp6IbtUy6YwEpBYHROc9KPN030mHhqb02YTgKfWAJSnDbqVrgwd+PfkvsXnYYlus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669236; c=relaxed/simple;
	bh=jV9Nr9+jv08ygaKyQ6z/dbKCp9kmwnkpdssIoWApAf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dAPFAWTthjPmcX9SRpcFlzvDEIIq6Q4lcjkuxiNbM2jWlciJEYle3l5Hr4BLUwIoRYGZ8nj5Dr1BzJHOK644WQW7MKhYoPGL+1n7CvTuIYpCVD54vGpMCnyERe9S5LYM8cBKJsXGwfNOyHILHOA+Ai03O3vNJsrKqI7MBViHzxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOsYM/Fj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOsYM/Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812771F000E9;
	Tue, 21 Jul 2026 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669235;
	bh=Wi3yLqj8wNjnzUnLbhXMDkpjDHn4exNxqDnD9Sn/QSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOsYM/FjzP37kgl3jqX4lR7B7jzFh0RYGlGJWwr06Gfwp2x7QFjbgO+x6mhliiW+K
	 3fgYRjRuDX+/wnKygKzhSYht6JswD3qOQ58cMsQVHX0r9ureiupbrxdKutGpit4c1f
	 /kKy+eAgpTfubbmxG+YCSTfl6jFu2i3YRnr8Vx58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0479/1067] platform/x86: xo15-ebook: Fix wakeup source and GPE handling
Date: Tue, 21 Jul 2026 17:18:00 +0200
Message-ID: <20260721152435.328955492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit b2fc2c6ebbd2d49935c8960755d8170faead2159 ]

The device_set_wakeup_enable() call in ebook_switch_add() doesn't
actually do anything because power.can_wakeup is not set for ACPI
device objects.  Moreover, had it done anything, it would have
registered a wakeup source object that wouldn't have been used
going forward and that wakeup source would have been leaked after
driver removal because ebook_switch_remove() doesn't clean it up.
Accordingly, remove that call from ebook_switch_add().

Also prevent leaking an enabled ACPI GPE after removing the driver by
adding appropriate cleanup code to ebook_switch_remove().

Fixes: 89ca11771a4b ("OLPC XO-1.5 ebook switch driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1966125.tdWV9SEqCh@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/xo15-ebook.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index 97440462aa258a..6413bb8fe26df9 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -38,6 +38,7 @@ MODULE_DEVICE_TABLE(acpi, ebook_device_ids);
 struct ebook_switch {
 	struct input_dev *input;
 	char phys[32];			/* for input device */
+	bool gpe_enabled;
 };
 
 static int ebook_send_state(struct acpi_device *device)
@@ -131,7 +132,7 @@ static int ebook_switch_add(struct acpi_device *device)
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device_set_wakeup_enable(&device->dev, true);
+		button->gpe_enabled = true;
 	}
 
 	return 0;
@@ -147,6 +148,10 @@ static int ebook_switch_remove(struct acpi_device *device)
 {
 	struct ebook_switch *button = acpi_driver_data(device);
 
+	if (button->gpe_enabled)
+		acpi_disable_gpe(device->wakeup.gpe_device,
+				 device->wakeup.gpe_number);
+
 	input_unregister_device(button->input);
 	kfree(button);
 	return 0;
-- 
2.53.0



