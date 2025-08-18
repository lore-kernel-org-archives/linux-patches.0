Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58193335BAF;
	Mon, 18 Aug 2025 13:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525032; cv=none; b=T9MEl4UOrDwvRt5Znzry07agXdXHk19SYEGi7zBWkMFSfc2B0t8ojr7Rcqf85fohIsJsOPkT1074P4vwpjPGFMmZGbrO46rrsqCCg6MgkUJIOD5g9lGhiFMxSuEifPEQfZDDFdCp798UL8H5wWr+7VixHjNMJzHAkRTpZR99v/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525032; c=relaxed/simple;
	bh=GTdgYIoO1kEFQh3leuF4xCjg9rLJS9lqCXRmTkIVtZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IHfE0YcBNX/zT+Y9I3ya+ROpiyXAobR1XYv6aNRCwXyincYAuhKAP4ndA5LQRHSvBeNw4ujZxbx3bKMrLyledcYCXaloh3Bji2BdoIJO8yp12a1mCIvuvuVPqUHsqh7J594g+n7/ZYtHxPXubX+8D84jrmDQQshw4My1EQWQDyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCkgrw60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCkgrw60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB643C4CEEB;
	Mon, 18 Aug 2025 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525032;
	bh=GTdgYIoO1kEFQh3leuF4xCjg9rLJS9lqCXRmTkIVtZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCkgrw60dSfFIJuu31aHVIyIs0M4eiS9r3e3AAGMxuJly/DqLMxd9baaGPgDJr20c
	 CzvWUezn+kMsmS/LJPh2u8eEu5O44bXf2ubV3HHjsMYc0Kpo+OkBPfd7zBR68knPox
	 Y2rXUKFPie8eZE4euUda4tEyAG/SdHRkwqoFaN9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 096/570] tpm: tpm_crb_ffa: try to probe tpm_crb_ffa when its built-in
Date: Mon, 18 Aug 2025 14:41:23 +0200
Message-ID: <20250818124509.512264456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 746d9e9f62a6e8ba0eba2b83fc61cfe7fa8797ce ]

To generate the boot_aggregate log in the IMA subsystem using TPM PCR
values, the TPM driver must be built as built-in and must be probed
before the IMA subsystem is initialized.

However, when the TPM device operates over the FF-A protocol using the
CRB interface, probing fails and returns -EPROBE_DEFER if the
tpm_crb_ffa device — an FF-A device that provides the communication
interface to the tpm_crb driver — has not yet been probed.

This issue occurs because both crb_acpi_driver_init() and
tpm_crb_ffa_driver_init() are registered with device_initcall.  As a
result, crb_acpi_driver_init() may be invoked before
tpm_crb_ffa_driver_init(), which is responsible for probing the
tpm_crb_ffa device.

When this happens, IMA fails to detect the TPM device and logs the
following message:

  | ima: No TPM chip found, activating TPM-bypass!

Consequently, it cannot generate the boot_aggregate log with the PCR
values provided by the TPM.

To resolve this issue, the tpm_crb_ffa_init() function explicitly
attempts to probe the tpm_crb_ffa by register tpm_crb_ffa driver so that
when tpm_crb_ffa device is created before tpm_crb_ffa_init(), probe the
tpm_crb_ffa device in tpm_crb_ffa_init() to finish probe the TPM device
completely.

This ensures that the TPM device using CRB over FF-A can be successfully
probed, even if crb_acpi_driver_init() is called first.

[ jarkko: reformatted some of the paragraphs because they were going past
  the 75 character boundary. ]

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_crb_ffa.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb_ffa.c b/drivers/char/tpm/tpm_crb_ffa.c
index 4ead61f01299..462fcf610020 100644
--- a/drivers/char/tpm/tpm_crb_ffa.c
+++ b/drivers/char/tpm/tpm_crb_ffa.c
@@ -115,6 +115,7 @@ struct tpm_crb_ffa {
 };
 
 static struct tpm_crb_ffa *tpm_crb_ffa;
+static struct ffa_driver tpm_crb_ffa_driver;
 
 static int tpm_crb_ffa_to_linux_errno(int errno)
 {
@@ -168,13 +169,23 @@ static int tpm_crb_ffa_to_linux_errno(int errno)
  */
 int tpm_crb_ffa_init(void)
 {
+	int ret = 0;
+
+	if (!IS_MODULE(CONFIG_TCG_ARM_CRB_FFA)) {
+		ret = ffa_register(&tpm_crb_ffa_driver);
+		if (ret) {
+			tpm_crb_ffa = ERR_PTR(-ENODEV);
+			return ret;
+		}
+	}
+
 	if (!tpm_crb_ffa)
-		return -ENOENT;
+		ret = -ENOENT;
 
 	if (IS_ERR_VALUE(tpm_crb_ffa))
-		return -ENODEV;
+		ret = -ENODEV;
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tpm_crb_ffa_init);
 
@@ -369,7 +380,9 @@ static struct ffa_driver tpm_crb_ffa_driver = {
 	.id_table = tpm_crb_ffa_device_id,
 };
 
+#ifdef MODULE
 module_ffa_driver(tpm_crb_ffa_driver);
+#endif
 
 MODULE_AUTHOR("Arm");
 MODULE_DESCRIPTION("TPM CRB FFA driver");
-- 
2.39.5



