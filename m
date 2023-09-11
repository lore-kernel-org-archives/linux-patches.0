Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7140411715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9586C433C8;
	Mon, 11 Sep 2023 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444822;
	bh=dpfVlXJKU7P4kTV5umabutpazSfnvJLO7+WbpsIGtUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hq6OjxaR9gR9Je4sXqQtT35WPA+r/vrk7ZZBsihV3Cth2Ao6jJONpe0YlVHcW4lMJ
	 GK5MH87BuMzLUANDmRXRDpRmW32fKT+Yzf2429NGiTMaPO0jDzwjDowwVAGcyglAXs
	 jBLCnaqSjdnEiv3y47rvvKUc8NPTS0Y/fD02Sn6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@intel.com>,
	Patrick Steinhardt <ps@pks.im>,
	Raymond Jay Golo <rjgolo@gmail.com>,
	Ronan Pigott <ronan@rjp.ie>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>
Subject: [PATCH 6.1 081/600] tpm: Enable hwrng only for Pluton on AMD CPUs
Date: Mon, 11 Sep 2023 15:41:54 +0200
Message-ID: <20230911134636.007048439@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 8f7f35e5aa6f2182eabcfa3abef4d898a48e9aa8 upstream.

The vendor check introduced by commit 554b841d4703 ("tpm: Disable RNG for
all AMD fTPMs") doesn't work properly on a number of Intel fTPMs.  On the
reported systems the TPM doesn't reply at bootup and returns back the
command code. This makes the TPM fail probe on Lenovo Legion Y540 laptop.

Since only Microsoft Pluton is the only known combination of AMD CPU and
fTPM from other vendor, disable hwrng otherwise. In order to make sysadmin
aware of this, print also info message to the klog.

Cc: stable@vger.kernel.org
Fixes: 554b841d4703 ("tpm: Disable RNG for all AMD fTPMs")
Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217804
Reported-by: Patrick Steinhardt <ps@pks.im>
Reported-by: Raymond Jay Golo <rjgolo@gmail.com>
Reported-by: Ronan Pigott <ronan@rjp.ie>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_crb.c |   33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -463,28 +463,6 @@ static bool crb_req_canceled(struct tpm_
 	return (cancel & CRB_CANCEL_INVOKE) == CRB_CANCEL_INVOKE;
 }
 
-static int crb_check_flags(struct tpm_chip *chip)
-{
-	u32 val;
-	int ret;
-
-	ret = crb_request_locality(chip, 0);
-	if (ret)
-		return ret;
-
-	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val, NULL);
-	if (ret)
-		goto release;
-
-	if (val == 0x414D4400U /* AMD */)
-		chip->flags |= TPM_CHIP_FLAG_HWRNG_DISABLED;
-
-release:
-	crb_relinquish_locality(chip, 0);
-
-	return ret;
-}
-
 static const struct tpm_class_ops tpm_crb = {
 	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = crb_status,
@@ -826,9 +804,14 @@ static int crb_acpi_add(struct acpi_devi
 	if (rc)
 		goto out;
 
-	rc = crb_check_flags(chip);
-	if (rc)
-		goto out;
+#ifdef CONFIG_X86
+	/* A quirk for https://www.amd.com/en/support/kb/faq/pa-410 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	    priv->sm != ACPI_TPM2_COMMAND_BUFFER_WITH_PLUTON) {
+		dev_info(dev, "Disabling hwrng\n");
+		chip->flags |= TPM_CHIP_FLAG_HWRNG_DISABLED;
+	}
+#endif /* CONFIG_X86 */
 
 	rc = tpm_chip_register(chip);
 


