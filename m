Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1AA335BD8;
	Mon, 18 Aug 2025 13:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523261; cv=none; b=UgLm7zVJWH5As/RR0x78tKiqhdKmcaHSjEKDK2mDMGs6GAlbdQdIJkG8qAXIPe6eXdkTrQhrgDU2Hh1s7tgtc2MP5RSBLnSNIv5DBnBQ9LArQI+V8fYXVetCi6QiN0NJ8bYa0QPj9PXuqOR5VQyi2uFzxreNfESNterKil7+HGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523261; c=relaxed/simple;
	bh=L/YdTlTrngD96KqCmNGXSlO3ZsWr+8Rsx2sXRws2kDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PBbx5MBijqspibMr/0Vr991uhPkGUVnhsY7LY+0n5ugbQ+gFrwCESD1Sek5RG9h/TO+oVjP9IAGGatTh405icNFo1GMurivBb07S28dMinhp4AAPWpb6X50pwFoawd9h+BwHc+zf7rzB85ur+px+FOVQgBPCbMZIVVn0ip43IIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNC+1Y/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNC+1Y/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C699BC4CEEB;
	Mon, 18 Aug 2025 13:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523261;
	bh=L/YdTlTrngD96KqCmNGXSlO3ZsWr+8Rsx2sXRws2kDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNC+1Y/gUSJ0V6H8G8d4Dbps3pyqJinw8s/ZyDuvu39JV3mBQSt/9gYSaYFYW9q1/
	 jTAV5F9PQk0lxye2/LuL4OXj4pblkbSwn68J2297GetT7oRhaDYWh9kM3zg7cu/QCb
	 +YURmyxe+1bO0YhghLF8eK0miD9cKHW688pTJG7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 086/515] firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall
Date: Mon, 18 Aug 2025 14:41:12 +0200
Message-ID: <20250818124501.682474377@linuxfoundation.org>
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



