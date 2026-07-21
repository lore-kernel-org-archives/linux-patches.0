Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEBD407CCF;
	Tue, 21 Jul 2026 18:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659210; cv=none; b=b01yPN3ZhtQf6GPlfbgVNMSWBEF9NnE/jukzF/xANXVQrNDAnCk0XdEw69vLH/xwcFTNjzNMK9AsEDBaeNxhkQLzWEGfOTBgBdP/ajvJ0cz3hPz20jtIjvoLD04bdU3JVZwAmbwtYb/gCMljCkragvxKNpCcpCKddnQLILHtzH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659210; c=relaxed/simple;
	bh=rVjI01By4jhXPFXiVRVv3JDG9cbu9nIPavAwMzZWhPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qK9JCFXcLgSTj8LzQJ0pEVpJ1uVG6PkMBG1QUnFpWhscJ7npVeCiZ9xI9PdM6zrT67uSydO80pzlwHYczjhdKFMD8VidykhnXDVvt7uUOt4I6IOTRRZ9vsTksPwmW0mxG+WkNyY79RChszdq9uj1SV/wRGNEtA5AhbWIpw/23Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XahzOgvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XahzOgvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A8D1F000E9;
	Tue, 21 Jul 2026 18:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659207;
	bh=evQQ3g1cMu+Y1kVkVWgvO4/OpImEw7yb7xf+1RBWG6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XahzOgvEURasPNuyIhZO3RI9Gjpzhk7VWjNIP9i1NiD8hkA//ra5J8YzohyOtvJ3x
	 h2ghWkvSUr9axSgT0e6P6cEDSQ4SfaGNR34dDrpSLY1/NeyY1CzSTuriaFB3no8Mkp
	 E35SMCX727PCriVUFmeXQaS8321F2f+r96FJPJHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1432/1611] hwmon: (w83793) remove vrm sysfs file on probe failure
Date: Tue, 21 Jul 2026 17:25:48 +0200
Message-ID: <20260721152547.651976258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1917,6 +1917,7 @@ exit_remove:
 
 	for (i = 0; i < ARRAY_SIZE(w83793_vid); i++)
 		device_remove_file(dev, &w83793_vid[i].dev_attr);
+	device_remove_file(dev, &dev_attr_vrm);
 
 	for (i = 0; i < ARRAY_SIZE(w83793_left_fan); i++)
 		device_remove_file(dev, &w83793_left_fan[i].dev_attr);


