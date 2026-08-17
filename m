Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F024B3F8EDE;
	Mon, 17 Aug 2026 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974975; cv=none; b=i3XEGfKDC8vzOVvL0MesRH+LFOusiFT45mgWmYkTeL+DUcsj5Gu/yuzTAiq6i8uCh/241OCZahXgyBIWWrNuFkbHT8HNnb4asiCOE7DRl4+6y/Not+IyHSmyuOVPEfJgPYgWfdV5b6Xmna2QCUtVGLDIZPFAdW40d8tPsMjxvs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974975; c=relaxed/simple;
	bh=ZanUWJ2NiP+jp12iE/huPArTMTpX0IYCeogRWg7Hnek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBW6fhrqG7wMSUh06fpSIGJdQUIiXwigC0KAgGA2KApmxCeR7eA8ZVoMIiwiPg6quBtoQDVO7YLiSxCjcmJ96E7HT3xP3G79RskfXe3nZe+o0vICc2d/dSkT2SZ1SQcvMFZTiw6k2bOskv+80oRAF0l7fc8HEabxoblTB3nhUc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sd0eRAgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sd0eRAgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC791F00A3A;
	Mon, 17 Aug 2026 13:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974969;
	bh=PJIZtFFd0pjALlWLQ6CoR6OR8BeWiKfse/uHHVP51d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sd0eRAgO4zOIqIVpKJfp8C76UpZKcO9bq47nSknUn8L4ctZvXZRvQeC4IAcnZF3iW
	 im5LVU5tOCrHJMaoTH+J5SFdXmIhg6D9Bb1vU3F2bqtkcFGuJjRHVuiT9kelHHclYm
	 eIl7JH9wFE/NZhEgRdYWzQ0CI1lw911JghD6uZAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/250] hwmon: (nzxt-smart2) Check return value of init_device() in probe
Date: Mon, 17 Aug 2026 15:30:39 +0200
Message-ID: <20260817132539.630079044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



