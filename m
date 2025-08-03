Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9C61F91D6;
	Sun,  3 Aug 2025 21:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255995; cv=none; b=LAbBJvu86SGcNv5b0mBB4kes6j1HoY5EfvtWYrwtKnoeCE43TbFId55GraGdYWC8B+ZWAhuqcPx71tYP+MhyLncFto9A9lqkcIZE7Dm6c8sxNWN8x5+pbo/+0aC2XebXhqxVmQoSZl1CvvZMuoog2OO9LZjvmlDKfHj8U0QjLIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255995; c=relaxed/simple;
	bh=dsFFt10BbQJYnX+TuufFrES91w5IxxNZcwePwelbtvs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hxCECaPOMtdHuGWxQrvy2mjNazsMlg9nXMO9ipTnPT5aMUU6QPqwo1UGXXZqrVqntRrxvW1e4GKrQLSqi25+5CH/f+22y4k2fTQ3vYSJnA3M4q/vptYtECfY/QMxlBrOqJxProoluCvceMoIstQbLjqIM0Ic44W73tJ3GE7mUbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKoH8ioN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKoH8ioN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC06C4CEEB;
	Sun,  3 Aug 2025 21:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255995;
	bh=dsFFt10BbQJYnX+TuufFrES91w5IxxNZcwePwelbtvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKoH8ioNQN5RGN4n3YcYzEEdLR4sU6D8Rb0vgFtBoiJZUtBqGGR7Flj9ieQpQvdYi
	 Ovdn7tPNs1xRLtkbjCWphjQE7d423pGj34AX3mLyM9qAXxY1w9C0/9EqSuimRjNXsR
	 +sTDP9AbRHGTbT+IxQGlbSVJPdTdiRnLO0OPsFD5nHPhvoRBTXCxRzMn3Tw0d5mZ4R
	 Z8Php+kmjDA9hnBshg9wIxK5C3qRMDDpiS1MHjjZU+0LQxUaouoLkrsV+W7zIDMRhg
	 I2pVFOImkkN29SDvAkLcOZ0odMOcD7Qqg/hsNKGKK9EandJ7jrhOxInhTz+WWPmC5/
	 V62w4jz0e8ncw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.12 07/31] firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall
Date: Sun,  3 Aug 2025 17:19:10 -0400
Message-Id: <20250803211935.3547048-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211935.3547048-1-sashal@kernel.org>
References: <20250803211935.3547048-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real bug affecting users**: The commit fixes a boot
   initialization order issue where IMA (Integrity Measurement
   Architecture) fails to find the TPM device when using TPM over FF-A
   (Firmware Framework for Arm Architecture). Without this fix, systems
   with TPM accessed via FF-A get the error "ima: No TPM chip found,
   activating TPM-bypass!" and fail to generate boot_aggregate with PCR
   values, breaking secure boot attestation.

2. **Small and contained change**: The code change is minimal - just
   changing `module_init(ffa_init)` to `rootfs_initcall(ffa_init)`. This
   is a one-line change that only affects initialization timing.

3. **No architectural changes**: This is purely an initialization order
   fix that doesn't introduce new features or change the architecture of
   the FF-A driver.

4. **Security-critical fix**: IMA is a security subsystem used for
   secure boot, file integrity, and remote attestation. The bug prevents
   proper boot measurements from being recorded in the TPM, which is a
   critical security failure for systems relying on measured boot.

5. **Clear problem and solution**: The commit message clearly explains
   the initialization order dependency between FF-A, TPM drivers
   (tpm_crb_ffa), and IMA. The fix ensures FF-A initializes earlier (at
   rootfs_initcall level) so the TPM is available when IMA initializes
   (at late_initcall level).


7. **Multiple reviewers**: The patch has been reviewed by relevant
   maintainers including Mimi Zohar (IMA maintainer), Sudeep Holla (FF-A
   maintainer), and Jarkko Sakkinen (TPM maintainer).

The change meets all stable kernel criteria: it fixes an important bug,
has minimal risk of regression, and is confined to fixing the specific
initialization order issue without side effects.

 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 83dad9c2da06..9fdfccbc6479 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1815,7 +1815,7 @@ static int __init ffa_init(void)
 	kfree(drv_info);
 	return ret;
 }
-module_init(ffa_init);
+rootfs_initcall(ffa_init);
 
 static void __exit ffa_exit(void)
 {
-- 
2.39.5

