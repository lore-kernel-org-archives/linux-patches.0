Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA71C29A1;
	Tue, 17 Feb 2026 20:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361598; cv=none; b=nJ/s9GBygFbi13PXlQymrQPUWtRlBUBYtE75+fDytRlUUTkxlCm1FhbuOY7tK6dC4CLW2PKlzp792rS0Y0kmqH49eRJvHFjJuuCPkYmLfoALGcWHb76ej94k6wUN4aYwyWh9kbCYvP0rtngPiX7a7kP5vPs0stPWPQTexpXxdJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361598; c=relaxed/simple;
	bh=85bKMC6MlLf9dixFHHkhMRiUUx68S2Rl4nZqY80ERCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LE5ygEa0X3fIqBx8puovAsp48jJ9sm2wU4z073eBsk2Ph8SZKs6JFSW7z8SJFClNNQqbdOjJ3jsRK8nXtvTyDJySO94QWLCXE+x2gBVC11fyXPFb8fB8NkjY9Qw8+XIR95sErTXJAC79Y0dImMqgG6XCvEtzXqIpYvVU+Nbl7P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFUqQc6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFUqQc6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D82C4CEF7;
	Tue, 17 Feb 2026 20:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361597;
	bh=85bKMC6MlLf9dixFHHkhMRiUUx68S2Rl4nZqY80ERCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFUqQc6i2t1RO1+KjexgHOM6olz9TGm/NNzorpErfQGQ0nOWsYUuot8Jpu1/XylLj
	 V/qgWYP/uzCIuIj/dD2z2T5GuN87xkN7qTwWsHFW+aw2IHh3B3zxJsOSPBG0vnXnyO
	 P1HKsOz1fc8RnAum3bAoAsFFkiIYCqhOz8BO/iSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 19/42] platform/x86: panasonic-laptop: Fix sysfs group leak in error path
Date: Tue, 17 Feb 2026 21:32:10 +0100
Message-ID: <20260217200006.737971447@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 22ca70eb82271..851f0f92219dd 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -1089,7 +1089,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 			PLATFORM_DEVID_NONE, NULL, 0);
 		if (IS_ERR(pcc->platform)) {
 			result = PTR_ERR(pcc->platform);
-			goto out_backlight;
+			goto out_sysfs;
 		}
 		result = device_create_file(&pcc->platform->dev,
 			&dev_attr_cdpower);
@@ -1105,6 +1105,8 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 
 out_platform:
 	platform_device_unregister(pcc->platform);
+out_sysfs:
+	sysfs_remove_group(&device->dev.kobj, &pcc_attr_group);
 out_backlight:
 	backlight_device_unregister(pcc->backlight);
 out_input:
-- 
2.51.0



