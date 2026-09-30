Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1BD5304AB;
	Wed, 30 Sep 2026 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790572; cv=none; b=UbWUZcBx+6We6DF/6QMNXFgzjrv/QQfydtj4nQotiG6g6E5kyCTUfpYdYU+4XsGIKCUEWfGU3+Wi4VRZzN06Tfn0SYFSL/bAMmzgWCxExvijHKGy85WnS+rwAJeU1dgZDk5J51Dk3qBmZxkKlIQUhNHZrBrYHWlFJytQMWfYACs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790572; c=relaxed/simple;
	bh=Jz/lkfY9LBJQr+7XDSVf5ki8h2UcmTLlcrOkwYTEBbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SsZ4CLpib2/Qm0XD2KNgTca7eqwI+DR6TPao13FvcU4sIQz7FISoygW8IdxmFzgbOEOkkDKrE5ySpGxs4u/djZHJKSGoJuYouKwo+82woG+3QoehgaZ5/Xq+VtCI/GXzjJZ6fi/3juz8kYO4uMnOGQAGMM/lpzXtZWHK672JJgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JM5L76c9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JM5L76c9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14A41F000FF;
	Wed, 30 Sep 2026 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790571;
	bh=3lKVApqOBotDwuMUXLIQNRvwBpv+9Wlh8Ls8/ZD+i+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JM5L76c9SDXPTg6E0vwmvbRaCe9GJNk5xe3cbbbTghJAokD1+vJNAqAHqIxKgO/UU
	 PLbgV91FHkzq/oDaz+NlfzzChjdbazKsXLuU4oE9hQkfsvMmJoPic2OarpU4mUYSB6
	 RCwKqyB3sMQSGr7VKLXcdn3Kp1Q0epxsn27aHTuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis De Brabandere <francisdb@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 874/877] platform/x86/amd/pmc: Fix LPS0 and debugfs leaks when STB init fails
Date: Wed, 30 Sep 2026 17:29:45 +0200
Message-ID: <20260930152433.594000799@linuxfoundation.org>
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
@@ -933,13 +933,17 @@ static int amd_pmc_probe(struct platform
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


