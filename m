Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EED33803CF;
	Sat, 12 Sep 2026 07:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198127; cv=none; b=Td1ItLP96EOb72htIVtsKkqiRqjXIY9h/11qbq6HDScJ992Ir9SGqwHMRGkMYvEAYYtvwQph9K/JK1GUp0zvZ/u1H6Lv6qRHb5M2p8Obl0fab34VEGGRYsbN/hVMJyit4GwnwvmuV7hNz/dof2kB0AubqmAyoTMP5Rpgv652bZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198127; c=relaxed/simple;
	bh=Wd1G0QHPStJSygmAENFbb+2n+DRYZyuPOYAlRBbYC8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cG/e5FC0kuSOMVUTiEvLaUa28Um8HPLCZRjTwRI2R0bp7qn9VNA3fIwPTT5oNk52akZhhzijjh9k0GAnZWxHiY3DOlJO9SR9Xkf3OdMYfNLzzOAm8RWxurCpnsUNEdwI9vPSMSFrr+PVmulUR9XwnwBq2JJ/p9SpVVAXmmXnV+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTiPWUH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTiPWUH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E213A1F000FF;
	Sat, 12 Sep 2026 07:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198126;
	bh=TqJUsckfnoR244uMSVn8g2Yccba9gWVuTVmJVSv7WbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rTiPWUH0zXA6oO+ocHkfNHDdNbUVGx1cPKhDnVPp7ulxQxBd7K0FEH7fwe1yp2x7S
	 7dn9q3ySQKSOAlOk02Trpyvwa7z2XaQCikEHe8k6XQ8CVHXjpz4Ff/ljP3Aui+ehtX
	 EqkZcTgZDII6Kntx6k2inkP7tOw73rhWCqRhQ2cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0314/1815] platform/x86: asus-wireless: Fail probe when there is no ACPI match
Date: Sat, 12 Sep 2026 08:34:24 +0200
Message-ID: <20260912065656.313279246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 4aefd66ef7822cf7d3f53146dcee0b71021ed2b7 ]

Every platform driver can be forced to match a device that does not match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device ACPI companion
object need to verify its presence.

asus_wireless_probe() returns success when acpi_match_acpi_device()
finds no match, leaving behind an input device that never reports
anything because the notify handler is not installed.  Worse, when the
driver is force-bound to a device without an ACPI companion, probe
still succeeds and stores a NULL companion pointer, which
asus_wireless_remove() later passes to acpi_dev_remove_notify_handler(),
leading to a NULL pointer dereference on unbind.

Return -ENODEV when the device does not match the ID table.  This also
covers the missing-companion case, because acpi_match_acpi_device()
rejects a NULL device.  Perform the check before allocating any driver
state, instead of after the input device has already been registered.

Fixes: f7e648027d7e ("platform/x86: asus-wireless: Convert ACPI driver to a platform one")
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260710094355.186143-1-lilinmao@kylinos.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wireless.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/asus-wireless.c b/drivers/platform/x86/asus-wireless.c
index 2b494bf3cba8c..aab45f0442c5b 100644
--- a/drivers/platform/x86/asus-wireless.c
+++ b/drivers/platform/x86/asus-wireless.c
@@ -132,6 +132,10 @@ static int asus_wireless_probe(struct platform_device *pdev)
 	const struct acpi_device_id *id;
 	int err;
 
+	id = acpi_match_acpi_device(device_ids, adev);
+	if (!id)
+		return -ENODEV;
+
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -139,6 +143,7 @@ static int asus_wireless_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, data);
 
 	data->adev = adev;
+	data->hswc_params = (const struct hswc_params *)id->driver_data;
 
 	data->idev = devm_input_allocate_device(&pdev->dev);
 	if (!data->idev)
@@ -153,12 +158,6 @@ static int asus_wireless_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	id = acpi_match_acpi_device(device_ids, adev);
-	if (!id)
-		return 0;
-
-	data->hswc_params = (const struct hswc_params *)id->driver_data;
-
 	data->wq = create_singlethread_workqueue("asus_wireless_workqueue");
 	if (!data->wq)
 		return -ENOMEM;
-- 
2.53.0



