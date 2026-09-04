Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678E3414A2A;
	Fri,  4 Sep 2026 05:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499883; cv=none; b=A1t6ZhcWnp3EnnJ7Sqvlx84KtVN7PRnpVsK5Voj6G9uh8xCfnr/EiGWaPkdWVVZQVYdmCLHJwri/bqaw349e0NNwRbaNJER+3WhFczP8Lfqt+uVJyYLRr0XXrx6qq6l+pYuhMgYdapOYn8O9pOIXjpWUP6mi/iX0E9+V/pujIUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499883; c=relaxed/simple;
	bh=xBOkwTh24uR756hqlpgbE4cLAVNCHn1fDX6ph//FDeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvrPnqkh7oU6g0AedTGkZRDiJO5YmI3sf6BbdEc5sVIkUbCDQqwmdxhJKMi5l+vJsu+XP3SIFqwyocJKDGo1xf14OEYzpBwM0pQ5TGMVhSvIbmc3djerE5SiZOGwaQJon4jhB9nUGYRo5oj52L2viCSZMXx7/dQfmQgNvRP2Zhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ummqb/kX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ummqb/kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C371F00A3D;
	Fri,  4 Sep 2026 05:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499882;
	bh=DsNx+xPDaUm8padLvwngRGLHqHZ1B1AqfBjab4S34oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ummqb/kXH2i5tDFYt1s869o4aKm6lrwiJ0cFIeVPqo3vluF12/SzYcHsXcsjdAqUF
	 2tzY0GBY7xwXli5gWp9i75X8ZUZX+vu7rU4HSqBmT17x5F+yY6mpy6KaDC9Qyup5Q7
	 9VTUHw0Iw7NQsAoaaVFYHV0r7ihHSXnJnUlYZrXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis De Brabandere <francisdb@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 573/713] platform/x86/amd/pmc: Propagate SMU errors and validate S2D address
Date: Fri,  4 Sep 2026 06:59:01 +0200
Message-ID: <20260904045816.664862227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 0225c1d637687b03726f00ac65b6def843d2c464 upstream.

amd_stb_s2d_init() discards the return value of several S2D SMU commands.
When the SMU refuses a command (e.g. "SMU cmd failed. err: 0xff") the
failure is only noticed indirectly - if at all - and reported as -EIO,
masking the real error.

More seriously, the S2D_PHYS_ADDR_LOW/HIGH return values are ignored, so
on failure phys_addr_low/hi are left uninitialised and the assembled
address is passed straight to devm_ioremap().  When the SMU leaves them at
zero this maps physical address 0 and trips the ioremap-on-RAM warning:

  amd_pmc AMDI000B:00: SMU cmd failed. err: 0xff
  ioremap on RAM at 0x0000000000000000 - 0x0000000000ffffff
  WARNING: CPU: 13 PID: 4592 at arch/x86/mm/ioremap.c:...

Check the return value of each SMU command and propagate it, and reject a
zero physical address before calling devm_ioremap().

Reported-by: Francis De Brabandere <francisdb@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221759
Tested-by: Francis De Brabandere <francisdb@gmail.com>
Fixes: 3d7d407dfb05 ("platform/x86: amd-pmc: Add support for AMD Spill to DRAM STB feature")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260721181756.143084-4-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/mp1_stb.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/platform/x86/amd/pmc/mp1_stb.c
+++ b/drivers/platform/x86/amd/pmc/mp1_stb.c
@@ -306,30 +306,39 @@ int amd_stb_s2d_init(struct amd_pmc_dev
 	/* Spill to DRAM feature uses separate SMU message port */
 	dev->msg_port = MSG_PORT_S2D;
 
-	amd_pmc_send_cmd(dev, S2D_TELEMETRY_SIZE, &size, dev->stb_arg.s2d_msg_id, true);
+	ret = amd_pmc_send_cmd(dev, S2D_TELEMETRY_SIZE, &size, dev->stb_arg.s2d_msg_id, true);
+	if (ret)
+		goto out;
 	if (size != S2D_TELEMETRY_BYTES_MAX) {
 		ret = -EIO;
 		goto out;
 	}
 
-	/* Get DRAM size */
-	ret = amd_pmc_send_cmd(dev, S2D_DRAM_SIZE, &dev->dram_size, dev->stb_arg.s2d_msg_id, true);
-	if (ret || !dev->dram_size)
+	/* Get DRAM size; fall back to the default if the query fails */
+	if (amd_pmc_send_cmd(dev, S2D_DRAM_SIZE, &dev->dram_size, dev->stb_arg.s2d_msg_id, true) ||
+	    !dev->dram_size)
 		dev->dram_size = S2D_TELEMETRY_DRAMBYTES_MAX;
 
 	/* Get STB DRAM address */
-	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_LOW, &phys_addr_low, dev->stb_arg.s2d_msg_id, true);
-	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_HIGH, &phys_addr_hi, dev->stb_arg.s2d_msg_id, true);
+	ret = amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_LOW, &phys_addr_low,
+			       dev->stb_arg.s2d_msg_id, true);
+	if (ret)
+		goto out;
+	ret = amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_HIGH, &phys_addr_hi,
+			       dev->stb_arg.s2d_msg_id, true);
+	if (ret)
+		goto out;
 
 	stb_phys_addr = ((u64)phys_addr_hi << 32 | phys_addr_low);
-
-	dev->stb_virt_addr = devm_ioremap(dev->dev, stb_phys_addr, dev->dram_size);
-	if (!dev->stb_virt_addr) {
-		ret = -ENOMEM;
+	if (!stb_phys_addr) {
+		dev_err(dev->dev, "S2D phys addr query returned invalid address\n");
+		ret = -ENXIO;
 		goto out;
 	}
 
-	ret = 0;
+	dev->stb_virt_addr = devm_ioremap(dev->dev, stb_phys_addr, dev->dram_size);
+	if (!dev->stb_virt_addr)
+		ret = -ENOMEM;
 
 out:
 	/* Restore the default message port for subsequent SMU operations */


