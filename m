Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00B92EE262;
	Tue, 31 Mar 2026 16:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974971; cv=none; b=QpCsFEcOxwg+XaZH9A7ZzJef0AuR5Y04TFM2GeROxrpI3PO34HV+gK1yBfXeYooqDzlNALw1bG8I3L0Fe51Jf7V92WiZmdG5xhM3q4Cdrx/vJBiK1e690Ro7rG6zzHmc1MI/uPRpGm0wFfCXBfyVL/SHtSYDWkcS4Gdpz24cczM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974971; c=relaxed/simple;
	bh=DsjPwArU9Uf2hkDzyCZAU0Ssjs0sioo4semtGJM3fzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PYS4foVPnCz3RKytU/f6w1WuyB7+jcjUtsVlsD0LDIiLvYLbqNlcrZDHugxzG5QZAxYtTvTdbV55VZ3ObweM7b6oy42oE7Vw3QYlT6p4UaTB0bfqPXasol8cRMHx3SZMVcFUQcTaIld3CmQB60E1LQMKPnQQeVizrC2CgGPDaG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ffd5iA8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ffd5iA8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5731EC19423;
	Tue, 31 Mar 2026 16:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974971;
	bh=DsjPwArU9Uf2hkDzyCZAU0Ssjs0sioo4semtGJM3fzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ffd5iA8k4bBjrrToV0bQ1Bq+NA1qqRSPxWXUYBsD/4X9RNmazHs2WIsxfrPKrs16b
	 8k8HdVzvPzxK2coDlevyAclDDuYdc0QOHV3UC/OWXjQWfrTn0BXuQLOYgIdl0m5cmD
	 02YW09Fbsv39eB4n0u2WkMIqPRiWn0mkfRS2ct3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David McFarland <corngood@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 114/342] platform/x86: intel-hid: disable wakeup_mode during hibernation
Date: Tue, 31 Mar 2026 18:19:07 +0200
Message-ID: <20260331161803.205603057@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David McFarland <corngood@gmail.com>

[ Upstream commit e02ea3ae8ee40d5835a845884c7b161a27c10bcb ]

Add a freeze handler which clears wakeup_mode. This fixes aborted hibernation on
Dell Precision 3880.

  Wakeup event detected during hibernation, rolling back

This system sends power button events during hibernation, even when triggered by
software.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218634
Fixes: 0c4cae1bc00d ("PM: hibernate: Avoid missing wakeup events during hibernation")
Signed-off-by: David McFarland <corngood@gmail.com>
Link: https://patch.msgid.link/20260205231629.1336348-1-corngood@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index f2b309f6e458a..c5e80887d0cb0 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -432,6 +432,14 @@ static int intel_hid_pl_suspend_handler(struct device *device)
 	return 0;
 }
 
+static int intel_hid_pl_freeze_handler(struct device *device)
+{
+	struct intel_hid_priv *priv = dev_get_drvdata(device);
+
+	priv->wakeup_mode = false;
+	return intel_hid_pl_suspend_handler(device);
+}
+
 static int intel_hid_pl_resume_handler(struct device *device)
 {
 	intel_hid_pm_complete(device);
@@ -446,7 +454,7 @@ static int intel_hid_pl_resume_handler(struct device *device)
 static const struct dev_pm_ops intel_hid_pl_pm_ops = {
 	.prepare = intel_hid_pm_prepare,
 	.complete = intel_hid_pm_complete,
-	.freeze  = intel_hid_pl_suspend_handler,
+	.freeze  = intel_hid_pl_freeze_handler,
 	.thaw  = intel_hid_pl_resume_handler,
 	.restore  = intel_hid_pl_resume_handler,
 	.suspend  = intel_hid_pl_suspend_handler,
-- 
2.51.0



