Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E9E439345;
	Tue, 21 Jul 2026 20:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667552; cv=none; b=N/xtPj3G8Uv56OgVPjIu1//ZXr+SCAEdycTUqO2+CBhnQ9gXDSg5ACQyNXrdZou0wQaQyFe9sp1lZO0y30KMY3R0/Qg2UD4EKFG1RCajBYBf07X6qE9guu0MwDq3Vc+sNPAfVkdRZ5qMPuLaxubLRFjdaUbom2+CPkddNZkbTaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667552; c=relaxed/simple;
	bh=EQBq9TTTI55w81xg5wXRNHBVQfQg2arepSKBRW66yUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZrMFlXmZL9j3NaR3jr59s7HXTTmANzHheQrBOCUY4dnKxvfNLOEnbj2in/DxiAPC/t2u8IgVg7CyYkZFALSIarzjfvdH7IwvVP1x4RW4xBGxV/VknOc0konrcQfy+ymFvnXduGejXDfuLCOBkeyUe8fzLyOf1wbt3tBM2BWCIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPAUSNjs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPAUSNjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFF51F000E9;
	Tue, 21 Jul 2026 20:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667551;
	bh=NHXMPDkML5XKaefC0yId1jOpyHyA2vdfDDsImkBw9Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPAUSNjs/oFtSbIxq1ddvzsp2ekhNGsL3FIIAUNW6yqPqVq0s6/kCdoOI2phN7ycY
	 kvMdEbV8N0AFmVSjJO4mLWsv37S7du/5fE+r+nAx/AscdSLlFraZK3JcHl19ukfhSo
	 6+yJ0X+8z8+hYzyPKJ1whXLqyLTyeaZrKLpkezJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 1102/1266] hwmon: (w83793) remove vrm sysfs file on probe failure
Date: Tue, 21 Jul 2026 17:25:39 +0200
Message-ID: <20260721152506.462440405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 77b983757280c69b0290811669ff1d31022e5f1d upstream.

w83793_probe() creates the vrm sysfs file after creating the VID files
when VID support is present.

The normal remove path deletes vrm, but the probe error path only
removes the sensor, SDA, VID, fan, PWM and temperature files.  A later
probe failure can therefore leave vrm behind after the driver data has
been freed.

Remove vrm in the probe error path next to the VID files, matching the
normal remove path.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260615064806.51139-1-pengpeng@iscas.ac.cn
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83793.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1918,6 +1918,7 @@ exit_remove:
 
 	for (i = 0; i < ARRAY_SIZE(w83793_vid); i++)
 		device_remove_file(dev, &w83793_vid[i].dev_attr);
+	device_remove_file(dev, &dev_attr_vrm);
 
 	for (i = 0; i < ARRAY_SIZE(w83793_left_fan); i++)
 		device_remove_file(dev, &w83793_left_fan[i].dev_attr);


