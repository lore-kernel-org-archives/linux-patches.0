Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82659443AA7;
	Thu, 30 Jul 2026 15:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425787; cv=none; b=M4v6sbfUnohNIHSNGBsW7ZY0xEzOaXaoTxx2fJx7g/U2CMRPNwKgNvN27hp2hA2SvQxV3dXXixVpJtdDOQC5JmzSfL5nzI+wX6gJfCjO/S8zCIrnFR0zQmkIzCTPvO9IJ/+4mX177YpuF6ZkhCk8rE5CIBVJ0Z7PtBMcBMxCO10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425787; c=relaxed/simple;
	bh=CdRDSuVHFmTKP5lqd7WZNvUxHudyY3YhDIBTx8Pyil8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5wOGG//LM2764gow9X7Thrp4OLY3u9pkqO2SqRmV8xGtiLXtX6nqA9B+LookOuavJ/r/4zK8Caf2oR1LS02cB1yTi0IkL4fKiEBAzkzInItsTTnx5nj7Ft/l+sKgIcaJTFt5UHgVjBbYnReuKsW5fXTPN+d/0lJEIqf3jp+4DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuUgttKr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuUgttKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3621F000E9;
	Thu, 30 Jul 2026 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425786;
	bh=RHVkz0mNvcUvw+dQEkVmZ9r7jv+eNRzHOjP7fEb6wvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuUgttKrQGvlbr+ICxTF0jS5pQVKf157udr0diAtxBbF6krZ24EV1PAsHj8rs2nIX
	 p/2pPdCXAs+J59jUKJXD24X2gSQrFm1mfDwuaYhr6pggdQc0JaSPP1lBdmBAak3PFX
	 aKUbPg3zG5rxs5Pvd0rOEqhlG7Oz426L/w2QELj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/602] hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:08:49 +0200
Message-ID: <20260730141438.859941589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 94c87871b051d7ad758828a805215a2ec194512a ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 40c3a44542257 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index b7b911f8359c7f..71e48b3bba60f0 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -645,6 +645,7 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 out_hw_close:
 	hid_hw_close(hdev);
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



