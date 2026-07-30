Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12C9442139;
	Thu, 30 Jul 2026 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423954; cv=none; b=InOpbo8Asxq+W/k9EeHMI66tkpIOmWKCzTLzsXJMhDRMhigyNqIBeumYs8SaQCSsCpZblfMyJuMSkRh5ZgcjBtbtDFH0hsd77fRVsY51t+HKH0y3mXDElY0qRQX0FmwRMIybFU/d0NYbqb2jYRowGPXCK1Skz7bDulfZxcv3LNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423954; c=relaxed/simple;
	bh=vQFJ19TWavVINO+q9Lbq9SdeEx9e+kK9QAn8qxg7HJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D34P82qUFN+BRQkSxTP8e+AvOqVtiyssF8D6PkSxfmL6CmZ+/v1nCK0psDS7/d8BlNzL/naDekGeo9sKAd55Y9dkAn3HTZ8wJFeuQoB903H/DBFdMZhH7kFZsj4tXvVFiQWCOSdYxfKG1BMdt0DZ7n1lfuhG4+HYQqOecPo+yhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsDjCcrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsDjCcrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5FD1F000E9;
	Thu, 30 Jul 2026 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423953;
	bh=LScDMGvQCbkn/k2iCzCIjLbLr9oHoVCsmVRn6V5QMgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsDjCcrKXlcgsqhHSixRe8kkuHfY0D3YEo08UBjRKfEqsfLxnijd5rDoXuF4fnKD1
	 xdYmnncSbNz+WbHLJ4PMskD8EIyqIxkxFFHVWdiZ7a3QK9Q9up2zTXfaoi4rsy6Q48
	 k7kFLsoTtBdzJyQ2o4TYSWTkvCZq2EPIxQfqnRqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/675] hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:08:19 +0200
Message-ID: <20260730141448.727858553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



