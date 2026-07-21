Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB4244AB9F;
	Tue, 21 Jul 2026 22:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674517; cv=none; b=c3pmXqV4nmSGsIEGZUugKN6Aj6Uu252GXT77OtIkvBbXXRp8F2hS6iKA9Pv+EMBQutsxhtfxEi1oVjaY7Dlg/I+sdS6rvXa4DublSlXI+IKAiZcP5qZ/7OgQLRR/YKSDFO9SWGQG/rJRDr+9em5Khhtk6XVr8rp2GAEWvJL5gcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674517; c=relaxed/simple;
	bh=1xsIbNv0VMeziPVQfvc5xxsTLOqDhRRnUgPc1ZTKBPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8KZW6HTbIu2dOgG1bpv+bBT8HUQEmLNhF85SNgms/QPCv66ljv1GuCseOl/NU0W0TTK0m6cp9XEorNPW85y54R13k1o9xW3M6v/3TljIjlyL4UiEbpB3QReydEwdvR1zmq8NZb5Ay4PEEv9axNEnLscbi6ezdRSVxVgButAzGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8lKpWZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8lKpWZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FE31F000E9;
	Tue, 21 Jul 2026 22:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674516;
	bh=jxb6z7JthywEvGfvMs/vbz2yhs+8r3q79r0fbN4sSCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8lKpWZSAahqGV8QhmnR5wt7wvG9cYwJVjmqpQW54PemHiHxYjiYepeejFi2sRnmt
	 8gcdte+Aqh+6xE0NCjsBqPci77ufm2zFVfjvT8P4AAnsEffHziaQvhw6aPuhw321Dn
	 mxvlI6ca2RksfQYc/INeKtWC4JzzJIw3BSVEUZm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 544/699] hwmon: (w83793) remove vrm sysfs file on probe failure
Date: Tue, 21 Jul 2026 17:25:03 +0200
Message-ID: <20260721152407.975251685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


