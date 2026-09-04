Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73AE3E7631;
	Fri,  4 Sep 2026 05:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501511; cv=none; b=SlYYStSpKq7tgfZstQ0GhcyAHDhntFvODWhkst4rr67mObMO91SCZOj0IiY5DKiYxl8ecT8gArfVMV+b+hjXlARSU3z7TJtCDchTnGkBzuxcnquSod/aUi4k9lO3pn850+ohEA3vT9UYl81Br2hGshLs8M0BXoQPMu5lhOMVNgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501511; c=relaxed/simple;
	bh=W9bQ/gbb+4CyBrxjVwfp4hvBb+ersORLHTsGEw87UeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MX8+PbCYWk/rSj+O/iPN8olbiLCm9cDoElnVHTQd/jBEF0oynqNUbMgaFSODseVp6vB9+JnWsbJKSSqdzd6xXYUlGa13FBkXsPD6qjn2uqbjZ/H3oCm+et5ek8xRZlhy2NWQBiyRWjDJgjpvfruKhmMHsHZy2FEcJxto15jhlaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1hEo0I0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1hEo0I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1DC1F00A3D;
	Fri,  4 Sep 2026 05:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501509;
	bh=X1aaj7ZMv8xqVk9eSh+eeJJapziCpdHMvPf8VTDSQGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1hEo0I0aJA6v4JMAvp03Ulv1Y+0PF4WJQHT8m1DkqqzU91FBuFjD8CEjfMYgoQUd
	 0BzSlDAfUleeTHoCiS/XKw3JoxGjUEFvlHXfQeypCC4WVlynKswtkghO2eP13shXHF
	 5p9kZUFNaAo2EqZ7YoSf1S0QrFOiPcfj/NU8Juic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis De Brabandere <francisdb@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 433/552] platform/x86/amd/pmc: Fix LPS0 and debugfs leaks when STB init fails
Date: Fri,  4 Sep 2026 06:59:50 +0200
Message-ID: <20260904045800.410902329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 76f650a76d6a36a4bee79d94db90a0e935a95477 upstream.

amd_pmc_probe() registers the LPS0 s2idle handler with
acpi_register_lps0_dev() and creates the driver's debugfs directory before
calling amd_stb_s2d_init(), which is the last step in probe that can fail.

When amd_stb_s2d_init() fails (for example the S2D telemetry region cannot
be ioremapped on a long-running system, or the SMU rejects the S2D setup)
the error path only calls pci_dev_put() and returns.  This leaves
amd_pmc_s2idle_dev_ops on the global lps0_s2idle_devops_head list and leaks
the debugfs directory, while the devm-managed resources backing the handler
are torn down.

Reloading the module then walks the corrupted list in
acpi_register_lps0_dev() and hits:

  list_add corruption. next->prev should be prev, but was NULL.
  kernel BUG at lib/list_debug.c:29!
   acpi_register_lps0_dev+0x44/0x80
   amd_pmc_probe+0x224/0x380 [amd_pmc]
   platform_probe+0x67/0x90

Even without a reload, the stale registration means the next s2idle
transition calls into torn-down driver state.

Unwind the debugfs directory and the LPS0 registration on the
amd_stb_s2d_init() error path.  acpi_unregister_lps0_dev() is safe to call
unconditionally here: it is guarded on the same conditions as
acpi_register_lps0_dev(), which is exactly what amd_pmc_remove() already
relies on.

Reported-by: Francis De Brabandere <francisdb@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221759
Tested-by: Francis De Brabandere <francisdb@gmail.com>
Fixes: 83ad6974dd3b ("platform/x86/amd/pmc: Move STB block into amd_pmc_s2d_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260721181756.143084-6-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -870,13 +870,17 @@ static int amd_pmc_probe(struct platform
 	amd_pmc_dbgfs_register(dev);
 	err = amd_stb_s2d_init(dev);
 	if (err)
-		goto err_pci_dev_put;
+		goto err_dbgfs_unregister;
 
 	if (IS_ENABLED(CONFIG_AMD_MP2_STB))
 		amd_mp2_stb_init(dev);
 	pm_report_max_hw_sleep(U64_MAX);
 	return 0;
 
+err_dbgfs_unregister:
+	amd_pmc_dbgfs_unregister(dev);
+	if (IS_ENABLED(CONFIG_SUSPEND))
+		acpi_unregister_lps0_dev(&amd_pmc_s2idle_dev_ops);
 err_pci_dev_put:
 	pci_dev_put(rdev);
 	return err;


