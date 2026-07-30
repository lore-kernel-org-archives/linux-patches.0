Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AFA399003;
	Thu, 30 Jul 2026 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427293; cv=none; b=Z5NvZA/nIPPcR8Ld1HI/5ZC9QHz7nBc7Vnbe79FNPuz9Sl57zzAwJxNJKi5bYuh6k4FO0/ftOF5Re2obRIZJvheuYtl9RcD8dI3HJ7DjKhjDWsNwN8Ss8vDhluNGpv27y+RoOyYc2lv8CKf/a+2fy5xE6RqzodByEvY9YKhYqD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427293; c=relaxed/simple;
	bh=TBp8ztSxrBStFA2C4BYpihrVYDUY69VSonn7jMXM00A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7wvIjfEZTxqUPWUd/ml0G5HbwbzcZ2obF72I74HVgumiUvw7j9TaixpPpRCZ6zZaoGbHCexmGSgXLp1l2WdkefXvo0toXxx2+leoz/a85maeg6zN4g8eyBefOF7OLAXdjT83X6EwueMMqJKZqGtj8H86H9yLNRY4q7+gy0cdeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfzcrITN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfzcrITN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89071F000E9;
	Thu, 30 Jul 2026 16:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427292;
	bh=hMsU0Qf+Rvic70cln/xoePCcgAGyzMzi+4iZIrgQ4CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfzcrITNozcXmzDTa6gELtVPDEZbEjr+cPnV/KgZ+y8vcByeV/mxTxLoxmjCfTk2d
	 FoQpjZYlDl69Fe6biTOkRP5qpGvWfBfHo5NssOIRrU2qZteIFFDhIswQgOjYJVMep+
	 O2Xsew+DA23Sbrlz0VEqlPaPJu04CQk7b/Ymef14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/484] hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:10:15 +0200
Message-ID: <20260730141426.024189699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index b37f36f55f88a5..096e187082b80a 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -558,6 +558,7 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 out_hw_close:
 	hid_hw_close(hdev);
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



