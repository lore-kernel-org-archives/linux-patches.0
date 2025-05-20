Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E809E2472AB;
	Tue, 20 May 2025 14:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750102; cv=none; b=UmSiQ6f3+IlRh1pk0t6v2afqfVDqKF4eKn0OgqfS/zlKp9IrMhlErrxh/wg61GZuBHRL2XgrHYX9azMr4oyB4TkRbPU3DcsqJbCfyuWqGjcRKwMoHKnDw+Bgg7MO1S1fTqm3m3aAynOrrZJQthQQzsm7UMcD3tzOmJMfNH/fVeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750102; c=relaxed/simple;
	bh=ratLmIniXr/UflHQpp9bGI8nLisFiCArdSTrrKCS/30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWfg/3hdpWvK0l+opi1i8QLXsKb/moPVG0FEj0Zbs/4PXDN5Q8SSY/pVL5U1o37lc0CdULXNI7mcpSiwPim+qj5KnLDesUG3XQpD2ZIC47rpRGqOxa6g4/GWet1McIFI3LHTBtNymiklLn3la3H/fzzlYj8eyZSOlMvZMEcCsVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUceAEyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUceAEyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F173EC4CEE9;
	Tue, 20 May 2025 14:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750101;
	bh=ratLmIniXr/UflHQpp9bGI8nLisFiCArdSTrrKCS/30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUceAEyLY3tto16fss9/bc03MFoq9or3Fq2Ypp8GO4awWTAgt6htEEJ5wxiLbDNRw
	 kcTiCnb/vQm8lbuXEL+nY2OYqupfdgNMp0JaOHgHSFE1AXRut7+usLzuNl2cUx3Usx
	 cJ3DRaruGfMFy4Z2q0PFb1l/TRv1fApbphTlNLx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/143] tpm: tis: Double the timeout B to 4s
Date: Tue, 20 May 2025 15:49:27 +0200
Message-ID: <20250520125810.541827108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 2f661f71fda1fc0c42b7746ca5b7da529eb6b5be ]

With some Infineon chips the timeouts in tpm_tis_send_data (both B and
C) can reach up to about 2250 ms.

Timeout C is retried since
commit de9e33df7762 ("tpm, tpm_tis: Workaround failed command reception on Infineon devices")

Timeout B still needs to be extended.

The problem is most commonly encountered with context related operation
such as load context/save context. These are issued directly by the
kernel, and there is no retry logic for them.

When a filesystem is set up to use the TPM for unlocking the boot fails,
and restarting the userspace service is ineffective. This is likely
because ignoring a load context/save context result puts the real TPM
state and the TPM state expected by the kernel out of sync.

Chips known to be affected:
tpm_tis IFX1522:00: 2.0 TPM (device-id 0x1D, rev-id 54)
Description: SLB9672
Firmware Revision: 15.22

tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1B, rev-id 22)
Firmware Revision: 7.83

tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)
Firmware Revision: 5.63

Link: https://lore.kernel.org/linux-integrity/Z5pI07m0Muapyu9w@kitsune.suse.cz/
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.h | 2 +-
 include/linux/tpm.h             | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 970d02c337c7f..6c3aa480396b6 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -54,7 +54,7 @@ enum tis_int_flags {
 enum tis_defaults {
 	TIS_MEM_LEN = 0x5000,
 	TIS_SHORT_TIMEOUT = 750,	/* ms */
-	TIS_LONG_TIMEOUT = 2000,	/* 2 sec */
+	TIS_LONG_TIMEOUT = 4000,	/* 4 secs */
 	TIS_TIMEOUT_MIN_ATML = 14700,	/* usecs */
 	TIS_TIMEOUT_MAX_ATML = 15000,	/* usecs */
 };
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 6c3125300c009..3db0b6a87d454 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -224,7 +224,7 @@ enum tpm2_const {
 
 enum tpm2_timeouts {
 	TPM2_TIMEOUT_A          =    750,
-	TPM2_TIMEOUT_B          =   2000,
+	TPM2_TIMEOUT_B          =   4000,
 	TPM2_TIMEOUT_C          =    200,
 	TPM2_TIMEOUT_D          =     30,
 	TPM2_DURATION_SHORT     =     20,
-- 
2.39.5



