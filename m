Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B98C7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59791C433D7;
	Wed,  2 Nov 2022 02:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356718;
	bh=9YCzPQ68Rjp+v6jOl/svErKvtcNSF0Dw7Bxo8sJfbtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuPi/sFa/trQ0zGejTcmC5cDPD1wJ7No2ypi0/aSFlrjlWxbpPwN0b07kswfc5lXL
	 rq3BZ0AtXTRh6kbLJ76ylKfd5naP7EGaMjPJtnvpsjJlLIrY8r4R35NvSJpYrsv6yO
	 edTOh11Osn/XWWRnKBjPl644fw43Y+xdzwhIuFM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.0 030/240] usb: typec: ucsi: acpi: Implement resume callback
Date: Wed,  2 Nov 2022 03:30:05 +0100
Message-Id: <20221102022112.084152682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 4e3a50293c2b21961f02e1afa2f17d3a1a90c7c8 upstream.

The ACPI driver needs to resume the interface by calling
ucsi_resume(). Otherwise we may fail to detect connections
and disconnections that happen while the system is
suspended.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210425
Fixes: a94ecde41f7e ("usb: typec: ucsi: ccg: enable runtime pm support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221007100951.43798-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -185,6 +185,15 @@ static int ucsi_acpi_remove(struct platf
 	return 0;
 }
 
+static int ucsi_acpi_resume(struct device *dev)
+{
+	struct ucsi_acpi *ua = dev_get_drvdata(dev);
+
+	return ucsi_resume(ua->ucsi);
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(ucsi_acpi_pm_ops, NULL, ucsi_acpi_resume);
+
 static const struct acpi_device_id ucsi_acpi_match[] = {
 	{ "PNP0CA0", 0 },
 	{ },
@@ -194,6 +203,7 @@ MODULE_DEVICE_TABLE(acpi, ucsi_acpi_matc
 static struct platform_driver ucsi_acpi_platform_driver = {
 	.driver = {
 		.name = "ucsi_acpi",
+		.pm = pm_ptr(&ucsi_acpi_pm_ops),
 		.acpi_match_table = ACPI_PTR(ucsi_acpi_match),
 	},
 	.probe = ucsi_acpi_probe,


