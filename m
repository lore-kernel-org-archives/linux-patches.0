Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25D7196DBC;
	Thu,  6 Jun 2024 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682904; cv=none; b=EepS36KIo/UYTcbB1sKxafSQcEWD+1AoxCkuahNR6goabeOYrI76TpCl8B1YWFGiirS+ragK43qoolr8qI9ydkIj6Br+ZACz8oK7t8KLw+vv9p7KiYg6OY0m81fl6X/eHFY12BrQMQ9th+TcisFoW3pMcRfk0gagNvEse/VmbCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682904; c=relaxed/simple;
	bh=WB4bRg37FrUGFRmjG4Tlo08I+uf8u78PCKJLyAAkVS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da/GkkDIDIEubqzTDyUZb6as5W6KKXLRpQ41d3sFJlHgha4cFThP6T/8sEp7UUq1/pHp6CHfZ7iepS1BhYM9+IQixZZKSwi7PqciBac7QEN1wsKKwFGUQeWKIiLmCKtAt9cB56+wdA8OpBNKYksK3cxhR+ZJ51YaJTtRqMl+wDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdLOtYiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdLOtYiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7658C2BD10;
	Thu,  6 Jun 2024 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682904;
	bh=WB4bRg37FrUGFRmjG4Tlo08I+uf8u78PCKJLyAAkVS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdLOtYiW3QljHJCisjPsX5Rax1yLVLO4Ks5LSF81wFXWafnwrJwZhTyRbXowMUNY8
	 1P4xodY49245fu9OKd0Mr/ZpefrhVOdpdFsc+jiCTXypQ2DyIMxFu/K5cAmqNA1O5C
	 +dUlW8xQu1W4Y/JgpfBwZbkuAhAiDTe5jN6C+8TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 027/374] greybus: arche-ctrl: move device table to its right location
Date: Thu,  6 Jun 2024 16:00:06 +0200
Message-ID: <20240606131652.733796660@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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
index 8541995008da8..aa6f266b62a14 100644
--- a/drivers/staging/greybus/arche-apb-ctrl.c
+++ b/drivers/staging/greybus/arche-apb-ctrl.c
@@ -466,6 +466,7 @@ static const struct of_device_id arche_apb_ctrl_of_match[] = {
 	{ .compatible = "usbffff,2", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, arche_apb_ctrl_of_match);
 
 static struct platform_driver arche_apb_ctrl_device_driver = {
 	.probe		= arche_apb_ctrl_probe,
diff --git a/drivers/staging/greybus/arche-platform.c b/drivers/staging/greybus/arche-platform.c
index 891b75327d7f7..b33977ccd5271 100644
--- a/drivers/staging/greybus/arche-platform.c
+++ b/drivers/staging/greybus/arche-platform.c
@@ -619,14 +619,7 @@ static const struct of_device_id arche_platform_of_match[] = {
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



