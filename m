Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808CF3D7D70;
	Mon, 17 Aug 2026 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980266; cv=none; b=G9BbVI/EXlsWihO06bnuLoIU8+Z6Zh69Szx5G0uMO3OOamwVLO8iA/WNNbiKcV1Dw9N0jT5c0Cjx5zTX4tFHLZSaUaGYsEVtDbXv4Ovd3qtrmAab/rwpcbkaGccWjpMzg8fa3uYGu0jCHdtzA+pCwHL8DFTJr1Bl3TZlkOE6WyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980266; c=relaxed/simple;
	bh=F435HJg1KUMQxaHxoV0v/da+id29L0rsAUGJVxZqohQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P60zUa6EcY/GhllKfXJKY/R9iIMXKu2fLTk9aF9bJScpjgEIc0TDgft+VxZLw0Mmhi6sArfsqrPBhplyKL2dj1FvftQANx1X7lbgafxFLumqGGm2ea2siBNVXhU+YUj/+6iRbq68x1MIbAysJrgrtXgNDBpcj9ffBTYVSStm+rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rvHP7nt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rvHP7nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E881F00A3A;
	Mon, 17 Aug 2026 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980265;
	bh=QdUWKh5wUJMpHrFgcc4gb+RSyMT80mKYrodnDN62jYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rvHP7ntBInvg6c1xfDj63ryyajSHd2ZgvC/12oEzc66SeApDFToQmtVWj6EdOTEC
	 IVWIxwQfcdW+L2LrBCkOneZlNHyBHGjfncyea+6Kht3Ezqf/9DUGJiOUkh9n5ng0Lt
	 S7HjrLx/Tf2Q3Pk5RH3Xa1eJR3IVFylU0mA4zYvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 513/609] hwmon: (nzxt-smart2) Check return value of init_device() in probe
Date: Mon, 17 Aug 2026 15:33:29 +0200
Message-ID: <20260817132601.015737903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 90df6a7fc88d7..9f30ec0883fbc 100644
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



