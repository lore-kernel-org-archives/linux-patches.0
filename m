Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABAA46A61C;
	Tue, 21 Jul 2026 17:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655077; cv=none; b=DhUgcbKUHKZ7QoVVUDmjx3VE/1QiqBmD5Gq+uTWRKUq4fJSiQOkT530r9nOH6gS4DrewTlEPItEJ8vZeLC4k91wOXOM4g+mVsLxrkY+OC1u8eDxhZJaYerl9kfl/cvCL1tEYWNQIX158GXMZQHaR0OfZq++JE5Ub8GPfLHQ/0ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655077; c=relaxed/simple;
	bh=EC7Nm+GTAn0oBxn4i0vys3UTXZ31yZE4ZA6RhD+OWZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/eHOl1BcoWNPYbEKggs2OgCWXlc7mQXjaZqBhj2P+oS9Iz4MoaxptO2bPCktjpCYdESYJMnCfcAbqi31TxtSa0hTHNk+AxN6hgmp8V8uK0pIVj8tk0PXKJG1NzkrjVbCSmw4CwuHXWHixR83ho+cYG6yC/BxcGvpIDVcWYZ+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieI0xoZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieI0xoZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323C91F000E9;
	Tue, 21 Jul 2026 17:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655076;
	bh=kq6Yv6rGEKL/CKzf1SGzwuomRY7P0BLsGsa5z+kJiRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieI0xoZp6G+sPF6Tmvjir1ycOmlk7A++jHMc/WGdDp+4aHrS1otfQkkdp0/lQi8l8
	 zRZlYvsTig/8x/1I41D4FR2oxyaf9bwID3H/DRp/4wPdaVnuCHELIY+BjpDgaCE9eu
	 i2I3fOZFUrYRx0RvMOBse3FCr/EUfHyFqGCcd058=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.1 1948/2077] hwmon: (w83793) remove vrm sysfs file on probe failure
Date: Tue, 21 Jul 2026 17:27:01 +0200
Message-ID: <20260721152638.658077428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


