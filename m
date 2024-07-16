Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C474219DFB3;
	Tue, 16 Jul 2024 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145129; cv=none; b=s+u370TWJHF0OG2HJG0hVMoBG2miBm1XQxFAdEVDUMbEDAA+qk3/PgDrse8ApK+r/1bgrdjlPdQXq00hF2NfTIvxZ44JWX68VLFhQBgH7cPyYhsWqDA1rDOL9bVheXakbhbtSeRc5kYznGRVrn2QxXmfsJOv7CEX4kLBcRJazlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145129; c=relaxed/simple;
	bh=Vtv4IHljGmjVtlqyIfJaXsR55DQnr2fokV5UC0jJpoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oz3rJ8/rDy9FG++7z5QwsYYVey5SGhfullg3coMgJf9ArSgbmn/CEeqZ1aRGOJp2Y+5YvexgyDWhgwFgAJO2K6QrpMCJQSa6g658cFeUOqlnPfKM6FbHjb4E/yNe6CmmYGhWdlDwbEocvv4NK/SCGrSeUuq4JcUWDIv6fkKC8YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMuDgd85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMuDgd85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49120C116B1;
	Tue, 16 Jul 2024 15:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145129;
	bh=Vtv4IHljGmjVtlqyIfJaXsR55DQnr2fokV5UC0jJpoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMuDgd85qaC9XjYVd9wfJaxQruflQhmijBuzEo30j0Jp6yoF1LyEMS/74GwmdmZjz
	 91xBN17rSG/FpTLydMOXTgAZ0pG2eJYoB3Zhuylm4qK88YqCx4qAED17CH1uC+4k9J
	 AKsiwlI0D00UOUJlXwiMewgnXRXDsCcC+whcF34Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentong Wu <wentong.wu@intel.com>,
	Jason Chen <jason.z.chen@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.9 109/143] mei: vsc: Enhance IVSC chipset stability during warm reboot
Date: Tue, 16 Jul 2024 17:31:45 +0200
Message-ID: <20240716152800.169491115@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

From: Wentong Wu <wentong.wu@intel.com>

commit 07de60a46ae9c0583df1c644bae6d3b22d1d903d upstream.

During system shutdown, incorporate reset logic to ensure the IVSC
chipset remains in a valid state. This adjustment guarantees that
the IVSC chipset operates in a known state following a warm reboot.

Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Cc: stable@vger.kernel.org # for 6.8+
Signed-off-by: Wentong Wu <wentong.wu@intel.com>
Tested-by: Jason Chen <jason.z.chen@intel.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20240625081047.4178494-2-wentong.wu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/vsc-tp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index e6a98dba8a73..5f3195636e53 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -568,6 +568,19 @@ static void vsc_tp_remove(struct spi_device *spi)
 	free_irq(spi->irq, tp);
 }
 
+static void vsc_tp_shutdown(struct spi_device *spi)
+{
+	struct vsc_tp *tp = spi_get_drvdata(spi);
+
+	platform_device_unregister(tp->pdev);
+
+	mutex_destroy(&tp->mutex);
+
+	vsc_tp_reset(tp);
+
+	free_irq(spi->irq, tp);
+}
+
 static const struct acpi_device_id vsc_tp_acpi_ids[] = {
 	{ "INTC1009" }, /* Raptor Lake */
 	{ "INTC1058" }, /* Tiger Lake */
@@ -580,6 +593,7 @@ MODULE_DEVICE_TABLE(acpi, vsc_tp_acpi_ids);
 static struct spi_driver vsc_tp_driver = {
 	.probe = vsc_tp_probe,
 	.remove = vsc_tp_remove,
+	.shutdown = vsc_tp_shutdown,
 	.driver = {
 		.name = "vsc-tp",
 		.acpi_match_table = vsc_tp_acpi_ids,
-- 
2.45.2



