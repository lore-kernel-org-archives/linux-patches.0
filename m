Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C1C21CC5C;
	Mon, 17 Aug 2026 14:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978552; cv=none; b=mbXAiAKn+7Uyg6XwRog0IGBbn4jEWyczyO1oEtFh03HQG4NLEZ9S20mpTpGtR3QSzevpTRAJBD4lH3/0YcSBuxZIHnRVpUxkD9r2bsiSOzv+628pho1K/PvCPUWcK7qRJYtU7rVBxTGbjP8x1Hwtu3yInSpX6pBgxF5aTSEYuCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978552; c=relaxed/simple;
	bh=sy+I6Xvl9iiQKOeIK7bHmzkFwipOUwQQ29suf5ZdiFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hrt13uns7WdoZ/eJLi430ERM3IFxig9MaYmNVHZjwT28ClewtW8wKQcemUj6dK8p/OD7d0b5I7bcvcoCCmHk0s2gJ5rXS5tKikcvwJdHz4skqLzjCN5urAJpcxt49mnEUAmo2IyhWQH0UOf+Q2D5MVyYcEM8dVV6yPgaI5qSLq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7OIIsXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7OIIsXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1731F000E9;
	Mon, 17 Aug 2026 14:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978551;
	bh=8MOy/1FI/SYYByjJ3uGNKf9UEGqlyH9GLLFnDwN5UvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7OIIsXD8SUq7CSfchFq+yK3JrTL/1sM0bCb8EIqRZKRqtLrQBxsC3gNeYklnickV
	 HNk3cU7hEHNUh5b2A3F2okZG7DGgoQC6eUxyJfDAEptS1/Jv/Llb474WGzvBMy/Tem
	 aW0pbhRkqHeO8Z+arYxv5J+2wcC0i6UxlDkFtbEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/156] hwmon: (nzxt-smart2) Check return value of init_device() in probe
Date: Mon, 17 Aug 2026 15:32:53 +0200
Message-ID: <20260817132536.144056472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
index 5bbe6f3f8af48..00c8d3bc3e344 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -760,7 +760,11 @@ static int nzxt_smart2_hid_probe(struct hid_device *hdev,
 
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



