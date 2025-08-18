Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275AB1E48A;
	Mon, 18 Aug 2025 13:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524922; cv=none; b=Zl6n1+ccU326tmWgaE3LnN40KTvuwOew14FdLNCXw88DKhbkG1K99PzQMlesJfPt7GOatnJc2XewvtnFgUtxfBmGPNzeL+ktTj14v62fAA0z59YfjboWn1/ILXqFAkTKy9ZWs/lOEfKgUvmSLGD4Zp20h0UM+318z6f4nN6IfSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524922; c=relaxed/simple;
	bh=3B6x166sKIbyy311ID1Pr0C1qh23liM8l/mfD/OXhb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hqhoZnDZN8xtDyWUdwCwP7+PIBqxkcTnzfrjeuVoZvh25EBPUJElWPtJ57hG+L5Hkh6kGAYbfaEzSoiSTPLdSuhrVUllqeRExK+4fagTnNllQ3jahgYGfaMZP7YAzh16RXY1+G3HssPkmlYZoeoUrDNvZ1xpW4tQ7fo3nBj99so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oviv6fso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oviv6fso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89812C4CEEB;
	Mon, 18 Aug 2025 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524922;
	bh=3B6x166sKIbyy311ID1Pr0C1qh23liM8l/mfD/OXhb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oviv6fso6uRJqsK4IhhHtjqsbxshNp1JIDEYtF9myT/7+OB63890SYxNPnr66zZsA
	 y9tE+fHfhF0unwEE+tWBNRxpNyruiMA5grk+aJYvodRlDfWtRaqDhb7I8snHPpbkCY
	 ZYP0NsoNm7U14Jp651Pz1Xi3g7ypgf5n1v6ZNZnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 097/570] firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall
Date: Mon, 18 Aug 2025 14:41:24 +0200
Message-ID: <20250818124509.551870471@linuxfoundation.org>
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

[ Upstream commit 0e0546eabcd6c19765a8dbf5b5db3723e7b0ea75 ]

The Linux IMA (Integrity Measurement Architecture) subsystem used for
secure boot, file integrity, or remote attestation cannot be a loadable
module for few reasons listed below:

 o Boot-Time Integrity: IMA’s main role is to measure and appraise files
 before they are used. This includes measuring critical system files during
 early boot (e.g., init, init scripts, login binaries). If IMA were a
 module, it would be loaded too late to cover those.

 o TPM Dependency: IMA integrates tightly with the TPM to record
 measurements into PCRs. The TPM must be initialized early (ideally before
 init_ima()), which aligns with IMA being built-in.

 o Security Model: IMA is part of a Trusted Computing Base (TCB). Making it
 a module would weaken the security model, as a potentially compromised
 system could delay or tamper with its initialization.

IMA must be built-in to ensure it starts measuring from the earliest
possible point in boot which inturn implies TPM must be initialised and
ready to use before IMA.

To enable integration of tpm_event_log with the IMA subsystem, the TPM
drivers (tpm_crb and tpm_crb_ffa) also needs to be built-in. However with
FF-A driver also being initialised at device initcall level, it can lead to
an initialization order issue where:
 - crb_acpi_driver_init() may run before tpm_crb_ffa_driver()_init and
   ffa_init()
 - As a result, probing the TPM device via CRB over FFA is deferred
 - ima_init() (called as a late initcall) runs before deferred probe
   completes, IMA fails to find the TPM and logs the below error:

   |  ima: No TPM chip found, activating TPM-bypass!

Eventually it fails to generate boot_aggregate with PCR values.

Because of the above stated dependency, the ffa driver needs to initialised
before tpm_crb_ffa module to ensure IMA finds the TPM successfully when
present.

[ jarkko: reformatted some of the paragraphs because they were going past
  the 75 character boundary. ]

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 37eb2e6c2f9f..65bf1685350a 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2059,7 +2059,7 @@ static int __init ffa_init(void)
 	kfree(drv_info);
 	return ret;
 }
-module_init(ffa_init);
+rootfs_initcall(ffa_init);
 
 static void __exit ffa_exit(void)
 {
-- 
2.39.5



