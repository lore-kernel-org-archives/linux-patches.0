Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E27FBEF;
	Tue, 25 Jun 2024 09:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308121; cv=none; b=IPzUYOQw8uNmtRUvqcgRtV8qOMNLp94W45uOaQ5vKESL5PckrtRwNUFutG9Ac7bDEkV4w9FmbDU/ZF07GvYQBj8/TsqmmCmGJq//ewcEJKBdyresrnwVmiA4xg+owx7oVmU3ewBke5Jf05IqJmPXlSjKQckDQYUUMMnoq8sicoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308121; c=relaxed/simple;
	bh=m/LuzSUL94rlEyXRLoYm90sxJb0DcROZBy3ToFw4YRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezrQhv/N2jWm3l4Lsc7vxp8/8mnSm3KHtkcsrqpOdGOWymvD/IQOUfJLWdf3iBK2GXKAdYz2Ydf3tZ01WZYXDFXxKWqKbRD4AvGpnR4U46B5v7VPeEh36yvQqONNQi9K+rptmJofs6MPSq1XVlTHCyiRGZKYKV2yMSsuXV5mTkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQYlg5nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQYlg5nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46477C32781;
	Tue, 25 Jun 2024 09:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308120;
	bh=m/LuzSUL94rlEyXRLoYm90sxJb0DcROZBy3ToFw4YRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQYlg5nBM+eKUEai6QDt2MQM714I4GrU/GoYq1r02D/QZor486lbLsvaXxMrGwrEY
	 6HV4TkFNgfbmzCMFd293B7j2BCEfQj2V+wV/fj7UcicQR1xh5xGcaVPMTUHT+W0JC7
	 vdz/N4ycfjxeA82xFm2P5PhPx4b0dai0omEZoB8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 014/250] ssb: Fix potential NULL pointer dereference in ssb_device_uevent()
Date: Tue, 25 Jun 2024 11:29:32 +0200
Message-ID: <20240625085548.593979713@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit 789c17185fb0f39560496c2beab9b57ce1d0cbe7 ]

The ssb_device_uevent() function first attempts to convert the 'dev' pointer
to 'struct ssb_device *'. However, it mistakenly dereferences 'dev' before
performing the NULL check, potentially leading to a NULL pointer
dereference if 'dev' is NULL.

To fix this issue, move the NULL check before dereferencing the 'dev' pointer,
ensuring that the pointer is valid before attempting to use it.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240306123028.164155-1-rand.sec96@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ssb/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 9f30e0edadfe2..bdb6595ffd2d5 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -341,11 +341,13 @@ static int ssb_bus_match(struct device *dev, struct device_driver *drv)
 
 static int ssb_device_uevent(const struct device *dev, struct kobj_uevent_env *env)
 {
-	const struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
+	const struct ssb_device *ssb_dev;
 
 	if (!dev)
 		return -ENODEV;
 
+	ssb_dev = dev_to_ssb_dev(dev);
+
 	return add_uevent_var(env,
 			     "MODALIAS=ssb:v%04Xid%04Xrev%02X",
 			     ssb_dev->id.vendor, ssb_dev->id.coreid,
-- 
2.43.0



