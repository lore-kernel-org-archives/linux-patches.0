Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DCE4C9559;
	Fri, 15 May 2026 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861177; cv=none; b=Bcrv2P+Nd6/CUVYofQn1Oy6E2ROMJSn8FOrxiL8Lb6dpSG2U2vR1ZWktsyLEfLaMS4ZwO3JoWkCcrF6ZpNEvZnCg0rVKUnTJ4uavMxR10WuzTsUbCEA/GAIZEDhJ0rOkr4YBQmJ3WciOM7/h8JAiXnorWOENTxKS+0iub411X6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861177; c=relaxed/simple;
	bh=T+9aUbEhXFvgIGV7EAYkDDht/GsQkWoqDTWoizWjRcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3Kq0KUggijzhgqKCcY9vd09o4DvBkwJzATDa8nnn5CPzm7BAWyoNAdE1y8ftSFKrQn8Lyu1/JfsUJpA/xS/EGMpY0Bo+s7pplGYEAB8UrbPrdsiQNeFb186s6mfnGuwVNPVLOGtE5vogvUt1F59BCniUHDxXXaV5b1kB/Mkkx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bq/Ojp2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bq/Ojp2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089DCC2BCB0;
	Fri, 15 May 2026 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861177;
	bh=T+9aUbEhXFvgIGV7EAYkDDht/GsQkWoqDTWoizWjRcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bq/Ojp2a3qbG1Cmyw/O7anqtY3E1tRE7Ofn8wwQvA9b+entuxMw+/mBs8wPDY1KQ+
	 iJnK2CyTQzGadExuHeoyHHG0VWtxBE03qcasJU5+PEEDZGAoLNfxq2fhK9Fp99Xmxs
	 8x2EiOsl0v8wu1VC+y5ZiD0BPh1BHA+40W4PjUIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 228/474] hwmon: (corsair-psu) Close HID device on probe errors
Date: Fri, 15 May 2026 17:45:37 +0200
Message-ID: <20260515154719.939382123@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 174606451fbb17db506ebaacdd5e203e57773d5f upstream.

corsairpsu_probe() opens the HID device before sending the device init
and firmware-info commands. If either command fails, the error path jumps
directly to fail_and_stop and skips hid_hw_close().

Use the existing fail_and_close label for those post-open failures so the
open count and low-level close callback are balanced before hid_hw_stop().

Fixes: d115b51e0e56 ("hwmon: add Corsair PSU HID controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/20260424135107.13720-1-mhun512@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/corsair-psu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -805,13 +805,13 @@ static int corsairpsu_probe(struct hid_d
 	ret = corsairpsu_init(priv);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to initialize device (%d)\n", ret);
-		goto fail_and_stop;
+		goto fail_and_close;
 	}
 
 	ret = corsairpsu_fwinfo(priv);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to query firmware (%d)\n", ret);
-		goto fail_and_stop;
+		goto fail_and_close;
 	}
 
 	corsairpsu_get_criticals(priv);


