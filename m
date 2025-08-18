Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E513632142A;
	Mon, 18 Aug 2025 13:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523258; cv=none; b=GC49OZO5rLJ1OBcUGnFfhasBwkZDRFp87GtKXm1xtCE6ffG33Ovsld/UvE8aOu6pRWgFp58czFd3ohhpJkHV/8Yagk/wAkxXtYAbrVYiCa5Vym+LST2aXyZqYamzi8Fdp206xe9l6Y1Md3F+Nea4PzARzh4Sx6MPi3J7mIcGYZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523258; c=relaxed/simple;
	bh=TBTtTnTd2KQzmAshqP25JRuaJGpx3TPNa+IufaLLRLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kj2bdO+14UPw28DYPJKcEj74VQO8iFapKIV49G49SS+MeuM8h3VoVRmMQAU82MaMTyyjcnIXF6kwDUqty6CT09c4iuv/WxWvFZQxoEXyDHA+igina9HrRUYNP0NRXBpHB7pIwNmwgtCmo+SLFpkFgtdH8irCSUTpdv5R98/etFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uY9YXi90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uY9YXi90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6394FC4CEF1;
	Mon, 18 Aug 2025 13:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523257;
	bh=TBTtTnTd2KQzmAshqP25JRuaJGpx3TPNa+IufaLLRLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uY9YXi90l2JB7fQehnTsK53Nj++bvoCRl6CooE7AbWfsW2xi9a8B/ZZpG8gF5Yc/i
	 EFIRiZ2Q3PcFcqR3BUNSQcUelMnYMiOf9RG7tLR+4jEdTiDSN24jNXaaefoHezyDGo
	 NJ6Ot4Z85F0dRaHM/hGOaU2nB6Po+eyJNhMkMx70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 085/515] tpm: tpm_crb_ffa: try to probe tpm_crb_ffa when its built-in
Date: Mon, 18 Aug 2025 14:41:11 +0200
Message-ID: <20250818124501.646601752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3169a87a56b6..430b99c04124 100644
--- a/drivers/char/tpm/tpm_crb_ffa.c
+++ b/drivers/char/tpm/tpm_crb_ffa.c
@@ -109,6 +109,7 @@ struct tpm_crb_ffa {
 };
 
 static struct tpm_crb_ffa *tpm_crb_ffa;
+static struct ffa_driver tpm_crb_ffa_driver;
 
 static int tpm_crb_ffa_to_linux_errno(int errno)
 {
@@ -162,13 +163,23 @@ static int tpm_crb_ffa_to_linux_errno(int errno)
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
 
@@ -341,7 +352,9 @@ static struct ffa_driver tpm_crb_ffa_driver = {
 	.id_table = tpm_crb_ffa_device_id,
 };
 
+#ifdef MODULE
 module_ffa_driver(tpm_crb_ffa_driver);
+#endif
 
 MODULE_AUTHOR("Arm");
 MODULE_DESCRIPTION("TPM CRB FFA driver");
-- 
2.39.5



