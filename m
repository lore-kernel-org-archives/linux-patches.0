Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5944399D6;
	Mon, 17 Aug 2026 13:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974208; cv=none; b=fc1XDjwNjNDFj4IXO6qjRlaDxeiKr60td/LBbxLSkQqmlz7C00Zzb5g3drNIu2c4uVU/XCZKiDE8EW5LgevCvCJmoPhJHOepenvv+pCB73HIqSHMVOL9SDGZ0Vij42prWkcuj0zNOrKqO+qSNx92rTVC+ZL7Yreduj9KaSsUEoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974208; c=relaxed/simple;
	bh=O4/9dtZ82R87kiV0JYC/ejm0skT8suIRXHlfjTZaV84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVvOCftdh481Ybxw1IYrzquj1pi3Z9Ss/9n/RDyTKgmSI+6Hx1Cks0umBidjsv8D0XlzB7+cMJPcVHX/pR0klqujcM9GaZLLQpptx20iU9GPb8cVsgAkKUQOQraiV2akjq1vn/szm0xyakCQiKY3A0xqb/v2ydmWW0ZOY/PInp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nussIDN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nussIDN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1D41F000E9;
	Mon, 17 Aug 2026 13:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974207;
	bh=sHicGSYARo1Efi181+MNAFTCPBXZE6xdA7c0f9Ac/NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nussIDN8Twb+3oG1jwT9g8Ob+x0g/7w139VznwK0+P9cKw6bTnWeQ1vsWpv7KHVXU
	 5Ri1AMk5CGk8UzxCMqTvwEf+AfZZSQezsbfxkvmEk4OM5lpBuLuCudcxYA39ifQjJ5
	 hsHvkf9NrrCclBzPIMtTRloBUxybjUzlIHn9pbRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 087/271] hwmon: (nzxt-smart2) Check return value of init_device() in probe
Date: Mon, 17 Aug 2026 15:30:12 +0200
Message-ID: <20260817132540.326912326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

[ Upstream commit d533882ce1060866a590257f2c77ee23eabef5b8 ]

The init_device() call in nzxt_smart2_hid_probe() can fail because it
sends HID output reports to the hardware to detect fans and set the
update interval.  If the hardware is not responding or the HID reports
fail, init_device() returns a negative error code.

However, the return value was ignored, causing the probe to continue
and register an hwmon device even though the device was never properly
initialized.  This leads to an inconsistent state where the driver
reports stale data or blocks on wait queues that will never be woken.

The same function's return value is already checked in the
reset_resume() handler, confirming the author's intent that errors
should be propagated.

Note that this fix was not possible before commit 59d104b54b0b
("hwmon: (nzxt-smart2) Stop device IO before calling hid_hw_stop")
because the out_hw_close error path was missing hid_device_io_stop(),
which would have opened a use-after-free risk window.

Fixes: 53e68c20aeb1 ("hwmon: add driver for NZXT RGB&Fan Controller/Smart Device v2.")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Link: https://lore.kernel.org/r/20260804074842.505923-1-fffsqian@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nzxt-smart2.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/nzxt-smart2.c b/drivers/hwmon/nzxt-smart2.c
index ff0c0bee0e839..efc78a8f58c88 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -754,7 +754,11 @@ static int nzxt_smart2_hid_probe(struct hid_device *hdev,
 
 	hid_device_io_start(hdev);
 
-	init_device(drvdata, UPDATE_INTERVAL_DEFAULT_MS);
+	ret = init_device(drvdata, UPDATE_INTERVAL_DEFAULT_MS);
+	if (ret) {
+		dev_err(&hdev->dev, "init_device failed: %d\n", ret);
+		goto out_hw_close;
+	}
 
 	drvdata->hwmon =
 		hwmon_device_register_with_info(&hdev->dev, "nzxtsmart2", drvdata,
-- 
2.53.0



