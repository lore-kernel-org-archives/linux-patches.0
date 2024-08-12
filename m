Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4764134AC;
	Mon, 12 Aug 2024 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479969; cv=none; b=qRqxVjeB8LdG0L1kci1JD2/9Yf9UHj33bSlJg9U21NKVljVF0qa2QHOSD56k7nJ1o2+RLZ27ZjTwzmHMqTwa+5XgSfByUsdq+ZN/TRoynPi6N9cwVgDnD0HbJQGR/AyHSXU6kNFkfv8dlddcdor0bpCFQIJr46MxxasD/0nireU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479969; c=relaxed/simple;
	bh=8n8a/rqK6aMAbpRRnvpuqfhQUvmKHHsyj2tPmhgwEP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIpMbce6lyvtOHVIqu7Bum2CxKDdEc9fGNl+aLu2LvOdBOVTVCSepjP/xEClpX+SpLloGV020aqtJSKAE927QlA2zFdZFOPTjV0o2dsjzgPGeX0XOAqMRUaw9bEszW5ZW53mzC14THcIGe9OEb5XlUbCGoezclSng36zXu0q+Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3/+k8dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3/+k8dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF1C32782;
	Mon, 12 Aug 2024 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479969;
	bh=8n8a/rqK6aMAbpRRnvpuqfhQUvmKHHsyj2tPmhgwEP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3/+k8dcC5THhLaNx3WU49SKN3cHRNLXHURU8xEzXR9gHXij23LuE3WMfnTyNdxrt
	 HZWX6ejEnYK0jaxQTK+gqxwqhbzW+zAAzeNbtGPKEedBsw7+a7Yzbd3yGTZyiLth3a
	 cjgw5dsERy01dWAA6C8wDOO2nBvoSLT1hMSSHp+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Amuraritei <andamu@posteo.net>,
	Perry Yuan <perry.yuan@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 057/263] cpufreq: amd-pstate: auto-load pstate driver by default
Date: Mon, 12 Aug 2024 18:00:58 +0200
Message-ID: <20240812160148.726020594@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit 4e4f600ee750facedf6a5dc97e8ae0b627ab4573 ]

If the `amd-pstate` driver is not loaded automatically by default,
it is because the kernel command line parameter has not been added.
To resolve this issue, it is necessary to call the `amd_pstate_set_driver()`
function to enable the desired mode (passive/active/guided) before registering
the driver instance.

This ensures that the driver is loaded correctly without relying on the kernel
command line parameter.

When there is no parameter added to command line, Kernel config will
provide the default mode to load.

Meanwhile, user can add driver mode in command line which will override
the kernel config default option.

Reported-by: Andrei Amuraritei <andamu@posteo.net>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218705
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/83301c4cea4f92fb19e14b23f2bac7facfd8bdbb.1718811234.git.perry.yuan@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 874ee90b1cf10..67c4a6a0ef124 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1764,8 +1764,13 @@ static int __init amd_pstate_init(void)
 	/* check if this machine need CPPC quirks */
 	dmi_check_system(amd_pstate_quirks_table);
 
-	switch (cppc_state) {
-	case AMD_PSTATE_UNDEFINED:
+	/*
+	* determine the driver mode from the command line or kernel config.
+	* If no command line input is provided, cppc_state will be AMD_PSTATE_UNDEFINED.
+	* command line options will override the kernel config settings.
+	*/
+
+	if (cppc_state == AMD_PSTATE_UNDEFINED) {
 		/* Disable on the following configs by default:
 		 * 1. Undefined platforms
 		 * 2. Server platforms
@@ -1777,15 +1782,20 @@ static int __init amd_pstate_init(void)
 			pr_info("driver load is disabled, boot with specific mode to enable this\n");
 			return -ENODEV;
 		}
-		ret = amd_pstate_set_driver(CONFIG_X86_AMD_PSTATE_DEFAULT_MODE);
-		if (ret)
-			return ret;
-		break;
+		/* get driver mode from kernel config option [1:4] */
+		cppc_state = CONFIG_X86_AMD_PSTATE_DEFAULT_MODE;
+	}
+
+	switch (cppc_state) {
 	case AMD_PSTATE_DISABLE:
+		pr_info("driver load is disabled, boot with specific mode to enable this\n");
 		return -ENODEV;
 	case AMD_PSTATE_PASSIVE:
 	case AMD_PSTATE_ACTIVE:
 	case AMD_PSTATE_GUIDED:
+		ret = amd_pstate_set_driver(cppc_state);
+		if (ret)
+			return ret;
 		break;
 	default:
 		return -EINVAL;
@@ -1806,7 +1816,7 @@ static int __init amd_pstate_init(void)
 	/* enable amd pstate feature */
 	ret = amd_pstate_enable(true);
 	if (ret) {
-		pr_err("failed to enable with return %d\n", ret);
+		pr_err("failed to enable driver mode(%d)\n", cppc_state);
 		return ret;
 	}
 
-- 
2.43.0



