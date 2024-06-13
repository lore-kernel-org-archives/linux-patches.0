Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094DE81ABF;
	Thu, 13 Jun 2024 12:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281122; cv=none; b=lc2BuRrxCZ+t8swW9v46ONgLftFRmsLmCBWgV+EjBCS88MXeGL/v6GsrinjquuK6Cd6gKYBdUBvClFJUZw6gI9olo6GM9aJ/8LsnGhW1xBn8u9Rv4ZsTV64PHUk8T/YDos5cExGaE4042fiiIokm5L29L3yoGsQUvZlsUwsn/cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281122; c=relaxed/simple;
	bh=77Y3g/uyh8O0Ck3WmaIJ4UsrJdSG/74xMF4zxk2plG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqqatwdn1AtHjqq0mP+RWeoIS7KPxPUg1ATJRTkjO4SnpuN1gqjqtNYME9WsQQomy91CrdQAqcx2ot1YZlo0f0+U1UZ2D0QfYwmPtMpgj5x9bW+fuxEdzzsUx46/XKJE1oOWrgHQ9HkIGSkm2p06rS22eEviim/l9kObkBswges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xa7Udz7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xa7Udz7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F80C2BBFC;
	Thu, 13 Jun 2024 12:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281121;
	bh=77Y3g/uyh8O0Ck3WmaIJ4UsrJdSG/74xMF4zxk2plG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xa7Udz7sVHNSIAQb2XCGRm6Ah7I4av1geCsOgtKfUskYpdkQNg+q+Ga9iV9ht1hsy
	 uHMolowKEf9OXaPY9x5EomcBpqdk1lDA4ClpOLsekbdmsMtM+4rN6Jx8IoGTbXGQew
	 JuUM32lKuEszrc2vUhC52Ws8buJNf0FsOQDuIvc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/317] greybus: arche-ctrl: move device table to its right location
Date: Thu, 13 Jun 2024 13:32:46 +0200
Message-ID: <20240613113253.293353382@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6a0b8c0da8d8d418cde6894a104cf74e6098ddfa ]

The arche-ctrl has two platform drivers and three of_device_id tables,
but one table is only used for the the module loader, while the other
two seem to be associated with their drivers.

This leads to a W=1 warning when the driver is built-in:

drivers/staging/greybus/arche-platform.c:623:34: error: 'arche_combined_id' defined but not used [-Werror=unused-const-variable=]
  623 | static const struct of_device_id arche_combined_id[] = {

Drop the extra table and register both tables that are actually
used as the ones for the module loader instead.

Fixes: 7b62b61c752a ("greybus: arche-ctrl: Don't expose driver internals to arche-platform driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240403080702.3509288-18-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/arche-apb-ctrl.c | 1 +
 drivers/staging/greybus/arche-platform.c | 9 +--------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/greybus/arche-apb-ctrl.c b/drivers/staging/greybus/arche-apb-ctrl.c
index bbf3ba744fc44..c7383c6c6094d 100644
--- a/drivers/staging/greybus/arche-apb-ctrl.c
+++ b/drivers/staging/greybus/arche-apb-ctrl.c
@@ -468,6 +468,7 @@ static const struct of_device_id arche_apb_ctrl_of_match[] = {
 	{ .compatible = "usbffff,2", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, arche_apb_ctrl_of_match);
 
 static struct platform_driver arche_apb_ctrl_device_driver = {
 	.probe		= arche_apb_ctrl_probe,
diff --git a/drivers/staging/greybus/arche-platform.c b/drivers/staging/greybus/arche-platform.c
index eebf0deb39f50..02a700f720e6d 100644
--- a/drivers/staging/greybus/arche-platform.c
+++ b/drivers/staging/greybus/arche-platform.c
@@ -622,14 +622,7 @@ static const struct of_device_id arche_platform_of_match[] = {
 	{ .compatible = "google,arche-platform", },
 	{ },
 };
-
-static const struct of_device_id arche_combined_id[] = {
-	/* Use PID/VID of SVC device */
-	{ .compatible = "google,arche-platform", },
-	{ .compatible = "usbffff,2", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, arche_combined_id);
+MODULE_DEVICE_TABLE(of, arche_platform_of_match);
 
 static struct platform_driver arche_platform_device_driver = {
 	.probe		= arche_platform_probe,
-- 
2.43.0



