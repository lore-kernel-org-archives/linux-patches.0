Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A09836CE19;
	Wed, 20 May 2026 18:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300323; cv=none; b=p/q7k55qS/1aJz1irkn6aCNUtrg+2h3Yorlc6I4ygpqbv9z634q+MQ5TSwj7GonI6hk24RWzTCLlIog/+FDv65VAkSklp/R1J7MYl+kE1Rvklyhf/TTM7mDT3UEgCawvScVar5nWHtzes7IwmFWcSrTpxxttflwDabOK86K4kGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300323; c=relaxed/simple;
	bh=i1QGFnKo3+b0ELCZEUDG0ckJwRFVsB4H1SK8tkZekgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpgtoQtrMoH1MZtvmQxSTMYiep+UrT/6YwZRiw5WhXaoWopWuJZ6qeX9K2lXsLPEiPHsasy5XwlyKmKA3A5DG0ezFj5ZrUdEem+c4eQU9Ao0tmVsKBIRmUAxYjIoKYL6FWW2LvLvhSvjVjx/3/Xq8A6KdTgwADvaEGBLbGUK7Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqYI8pl6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqYI8pl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12A71F000E9;
	Wed, 20 May 2026 18:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300322;
	bh=fJ36C18NinXox6c4hqQR/hV/HbOI/fBoKaNK2x6Aeng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqYI8pl6lHVnAh5l/VpQ5gi8cmlcZcQUVCQfKZHnXcFrIKuJzN9VT/kIXXVEShD/o
	 KFm4Cs/8BnGD+tyu3fWy3bCtxdRMfSxH0pFhYcUfYop8UH0fS2CKuRCz4ZJsrCz4gr
	 7JTwIbjr8ricbH1fI0uHCAMSaW/kgDWFWRjX6Ubc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/666] platform/chrome: chromeos_tbmc: Drop wakeup source on remove
Date: Wed, 20 May 2026 18:15:43 +0200
Message-ID: <20260520162114.073593025@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



