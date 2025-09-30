Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906662D24AD;
	Tue, 30 Sep 2025 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243870; cv=none; b=neRaN1U2n1PrLZkrtf9CmOAWF3l734GnI2131MtdxZlpmzhsKhxmyCQPxuKQBYRFUYBZ+BtroK/PV2EleqgBJ3eWePRY48h/VeaGGqnE7jZoB3QvYqrDJyBVJPAhkFrDEBd3a+l0/myMEK+vn9LFMBVMVFcYVr8q+YSmNxZnyP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243870; c=relaxed/simple;
	bh=eHfCZmZp0JV7yUCHwr+oSdkNoTZrwPpl15MX5PYzYFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3aLA+iu0zORr1RHkN0/5zMFKmSuif0/FyKa/o6Kvo4bp7+sKLEePYgdUMOfvTlmFIfqv11XaDsv+8+tY4oHbeSgCg5rwpkM1Brty+Nfl8887dIfrbfW7ChquhbInj5BYLfLaTS9Yxb1rclXYQFUkUsnjEr5nlFTKKN6bkUUILE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7oFdBSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7oFdBSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E50C4CEF0;
	Tue, 30 Sep 2025 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243870;
	bh=eHfCZmZp0JV7yUCHwr+oSdkNoTZrwPpl15MX5PYzYFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7oFdBSJ0AcmSZTFzNyhGPOc5XZ9+qAuOdqszoBaDsTYRmJqeRtHiur5D7hyV4ddT
	 osx4RnAZ3XBJpemuPMc82TOi6i51TmradXIeX0rzI6R6cDmIZSI0Rp9Th2FMI8fuXs
	 B65SAm1m8pOprcj8G41K8gfh9+ofCQz0PaX5q35E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Lv <Jerry.Lv@axis.com>,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 42/81] power: supply: bq27xxx: fix error return in case of no bq27000 hdq battery
Date: Tue, 30 Sep 2025 16:46:44 +0200
Message-ID: <20250930143821.431580504@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 2c334d038466ac509468fbe06905a32d202117db upstream.

Since commit

	commit f16d9fb6cf03 ("power: supply: bq27xxx: Retrieve again when busy")

the console log of some devices with hdq enabled but no bq27000 battery
(like e.g. the Pandaboard) is flooded with messages like:

[   34.247833] power_supply bq27000-battery: driver failed to report 'status' property: -1

as soon as user-space is finding a /sys entry and trying to read the
"status" property.

It turns out that the offending commit changes the logic to now return the
value of cache.flags if it is <0. This is likely under the assumption that
it is an error number. In normal errors from bq27xxx_read() this is indeed
the case.

But there is special code to detect if no bq27000 is installed or accessible
through hdq/1wire and wants to report this. In that case, the cache.flags
are set historically by

	commit 3dd843e1c26a ("bq27000: report missing device better.")

to constant -1 which did make reading properties return -ENODEV. So everything
appeared to be fine before the return value was passed upwards.

Now the -1 is returned as -EPERM instead of -ENODEV, triggering the error
condition in power_supply_format_property() which then floods the console log.

So we change the detection of missing bq27000 battery to simply set

	cache.flags = -ENODEV

instead of -1.

Fixes: f16d9fb6cf03 ("power: supply: bq27xxx: Retrieve again when busy")
Cc: Jerry Lv <Jerry.Lv@axis.com>
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/692f79eb6fd541adb397038ea6e750d4de2deddf.1755945297.git.hns@goldelico.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1553,7 +1553,7 @@ static void bq27xxx_battery_update_unloc
 
 	cache.flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, has_singe_flag);
 	if ((cache.flags & 0xff) == 0xff)
-		cache.flags = -1; /* read error */
+		cache.flags = -ENODEV; /* read error */
 	if (cache.flags >= 0) {
 		cache.temperature = bq27xxx_battery_read_temperature(di);
 		if (has_ci_flag && (cache.flags & BQ27000_FLAG_CI)) {


