Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2739751DB02;
	Wed, 30 Sep 2026 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789844; cv=none; b=hyqLIDDlqnBiXOW+RgCe/M+ZBdlQBqTLwJZL4EuGrTUFICx+UBXaWFgaMWIjfdv+6KZ9WPYmzTejP9JQ16NACijcKMMoJuqLx994sU+gJmGS2j+Txo/irf2c3Kwlq+wXISPFIQiT+aX9LpUI4Hwwcacy/40jB2iUzll9i1/uPHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789844; c=relaxed/simple;
	bh=AH/62inRieas6TsAyJwPiWSmgGcuyibGGEOTwxQJSUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aPGtPDEWLSD31sqQlC0szNirPbeDJCbCuXSC/OGqKHK/N8I8pcoq8H/agF0/8p/u9X37YImqQ9MHd+t7dG0oluOs7TWt4HQ1jz/fpwsz9kruA+/W7NEc0jlYyg1LOlqjIkKv0acNAWVaVXGrRKwvwQunslZjkrpM4eejw2D0IzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIgW1d+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIgW1d+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816D71F000FF;
	Wed, 30 Sep 2026 17:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789843;
	bh=9WiTHywOjJBUdRBdgdaTVlyWLC216IBqYP9rNEIiJow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIgW1d+rVeiTkNC57LnLn1FalUZaqRSEocgckP6cr3J+DKVpWmbB6Sfd3IlgPGP22
	 qx9ZmgyJ8siXU6HOk/jsSUPWd069CqM4WjNefKL1b4446UhF45cV5UhkGoYq+09QkP
	 RwXBzTqB2MGHIijH2y5uV8qwmT0tW2aU7uA+pyos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis De Brabandere <francisdb@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 593/877] platform/x86/amd/pmc: Propagate SMU errors and validate S2D address
Date: Wed, 30 Sep 2026 17:25:04 +0200
Message-ID: <20260930152427.447490033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 0225c1d637687b03726f00ac65b6def843d2c464 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/mp1_stb.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/amd/pmc/mp1_stb.c
+++ b/drivers/platform/x86/amd/pmc/mp1_stb.c
@@ -270,7 +270,9 @@ int amd_stb_s2d_init(struct amd_pmc_dev
 	/* Spill to DRAM feature uses separate SMU message port */
 	dev->msg_port = MSG_PORT_S2D;
 
-	amd_pmc_send_cmd(dev, S2D_TELEMETRY_SIZE, &size, dev->stb_arg.s2d_msg_id, true);
+	ret = amd_pmc_send_cmd(dev, S2D_TELEMETRY_SIZE, &size, dev->stb_arg.s2d_msg_id, true);
+	if (ret)
+		goto out;
 	if (size != S2D_TELEMETRY_BYTES_MAX) {
 		ret = -EIO;
 		goto out;
@@ -282,8 +284,14 @@ int amd_stb_s2d_init(struct amd_pmc_dev
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
 
 	if (!phys_addr_hi && !phys_addr_low) {
 		dev_err(dev->dev, "STB is not enabled on the system; disable enable_stb or contact system vendor\n");


