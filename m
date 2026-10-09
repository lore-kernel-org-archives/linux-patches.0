Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214874E36C4;
	Fri,  9 Oct 2026 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556125; cv=none; b=N5vhHIGfOhCJYIRntBEZ1jf6jQWrDXA/vUpCn9+3VpZkrVbiRN2r1oXxfEByEXaiH9v7X1mtn2A9qZ6IbJkNZho7T+VWXNMjr1am63RYfJrew1+vD1aa+hVEDBgkJaX5EvDm/MxvFVQ8qxXAPiWh0n79ncVSKWTi3WCrsRySG8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556125; c=relaxed/simple;
	bh=K1DKfQ6ScnbvouKQ8nwoOskEGsiHFw4E8drBcYGki94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDmE1PlbfXwmrLP5MWqVLrtCREXLepDK8d1PZ+Bqtwvnznh9JeM0ACb6hIo1W3YcL2L+8N2eDHDi2qqXand0bD1ZUacElAJMNrRrhIMQoNV6bjlBm4ezS+w8TWWCrhmvYI5PxXbwH02ebXxhuKu2UzZh4BjM/pEDMgy8suRHsiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVKKRuRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVKKRuRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8039F1F000FF;
	Fri,  9 Oct 2026 14:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556124;
	bh=5ak9vePrz1EF3Mcb25QFl5lJ+j3dl/EiP3ItuUsvtC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVKKRuRzFxNSpiL/rta/58J1dVlnl/9IsePhcq7p2VA5yvvwn5Amg9diEodoxf3zf
	 4fFNZpAbsQpuHpAVcjJB5s9Jx0wRSRh261RAUhGtVvaRsbBrV+jx24k9/led76xg4p
	 PkhvwNJ4MZLX/XZxkWekuaYW4HoAvOzceLPxOvVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.18 178/403] usb: chipidea: tegra: disable runtime PM on resume failure
Date: Fri,  9 Oct 2026 16:08:59 +0200
Message-ID: <20261009140956.279131289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit f1d6f7d25fe88ee49aaad96c8649e090fc3a4b68 upstream.

tegra_usb_probe() enables runtime PM before resuming the device. If
pm_runtime_resume_and_get() fails, probe returns without disabling runtime
PM. The later error paths reach pm_runtime_force_suspend(), but this early
return bypasses that cleanup.

Disable runtime PM before returning the resume error. Do not use the
fail_power_off path: the failed resume did not retain a usage reference,
so its pm_runtime_put_sync_suspend() would be unbalanced.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 8b85e11c1a7a ("usb: chipidea: tegra: Add runtime PM and OPP support")
Cc: stable <stable@kernel.org>
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260913041033.25144-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_tegra.c
+++ b/drivers/usb/chipidea/ci_hdrc_tegra.c
@@ -306,8 +306,10 @@ static int tegra_usb_probe(struct platfo
 
 	pm_runtime_enable(&pdev->dev);
 	err = pm_runtime_resume_and_get(&pdev->dev);
-	if (err)
+	if (err) {
+		pm_runtime_disable(&pdev->dev);
 		return err;
+	}
 
 	if (device_property_present(&pdev->dev, "nvidia,needs-double-reset"))
 		usb->needs_double_reset = true;


