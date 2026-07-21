Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204E4443AA0;
	Tue, 21 Jul 2026 22:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672620; cv=none; b=MRg7WgOJsZnYg/4SbbTOshJP/enRCkhIy+sT3JL3YF0pShWuP6/oELda5i1b5DsZiBdFDaRc0vJlE9RLI04R2qDYsUn9kGQXrxo7k2wivsaMjTsF5rgDibmgk31I1z0haxKbalVLtcyFx7WCneOPxpCGMuljW3UfgjAl9IvHCeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672620; c=relaxed/simple;
	bh=Awm5n/LRVydEPnCg5uTeDq6yFhpUx2z2GFxGsPczrq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abqdUSlT447EHGUB4aMB76amV4HBgxXuOQOct5aCN6aJpImwQ+7YHz7j/UfPx6cCx5KbAVADZaxdcFAKZHuXJ4YbGg03FNkbaEEOoXWwHw/fbmcGPBpJWRHnjGiO3B/BZFkogZbCOJkBOhgYpq2FFxYrcv5sgy8CLAPFOfJ0RAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QB+GJOXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QB+GJOXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD0C1F000E9;
	Tue, 21 Jul 2026 22:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672618;
	bh=1nKdrEvrUFeEN7XS/vKniDXgf6WpBrAeNfQ/Lt8C5ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QB+GJOXgWc0zJ51z/LeSqgQnTcCieVl7Sr9/OQUTUpjwYEqhCSmaFfV8Gn6JA9ViD
	 bou29uVzr19bePlxXerO2QIBPc8FEAliNwTY1etPujZyhFvqNJhQWAopuslTP5yxz9
	 S0so7Jft6OLN5XsL6e29jc+RUdzrCp0LtHm+fRQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 694/843] hwmon: (w83793) remove vrm sysfs file on probe failure
Date: Tue, 21 Jul 2026 17:25:29 +0200
Message-ID: <20260721152421.665143333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1920,6 +1920,7 @@ exit_remove:
 
 	for (i = 0; i < ARRAY_SIZE(w83793_vid); i++)
 		device_remove_file(dev, &w83793_vid[i].dev_attr);
+	device_remove_file(dev, &dev_attr_vrm);
 
 	for (i = 0; i < ARRAY_SIZE(w83793_left_fan); i++)
 		device_remove_file(dev, &w83793_left_fan[i].dev_attr);


