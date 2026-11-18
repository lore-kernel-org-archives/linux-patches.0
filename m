Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016073;
	b=3ZhQhq4WtnhwyMYX2mJukjjygIXJBmQBIztUdjkN2mQCuOi99pv+rtqtgmRstpmprAk8
	 Ck10HWwKkta5WdkmSj50FcJEDfSqqxKyp1BnL9u1+hSQ4gQLmkQieaH+UyMphootLFmUo
	 kuBBHaugFUmV5WhlMYG86If/UxyAeXp/8eEFUCEDHocDGmpiKmJ66VOezyqM42sK5zs9A
	 zRRxuUrk0JtVsDHQbT2KNbSikWGO9UAOVdvvEkg+J1I854FLCLyI9COv08SRqyPJkd09w
	 EPMTnvzJXuhN9828q5G5p9NDBrp2ErIvT6B/Ns+ckjtLvLaPxWbI3DlsOB/TD+N7x6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B6Mfg5b55Aziz9iRcy4z4S2D5fiPjd47v2PC7ZENVKI=;
	b=nRHu4AML+RIn+qc4rHMFw2e9f6HUSQpv8e/fvCXewoBcpADxOikJhhbvQbBI2w5up8oP
	 58jTInNKDCOFsNNirEKy17sVw+M6q0zUo3byh4YpsKhKrS+i606EmV0eqa2PXrY6eRDRH
	 2ExoDC9f/yX4acyTPlhZZcmeTwO9e2cAJ/+SYVd4510ryw7YQ8wlXev8/xsT3TWADtpAw
	 Yhylq5QARORQUXuDKc+4Kr7GT23iAR/4NrCBRb7y46mibRvKxvtrfNZutEoCyR6c1S8Od
	 hWPhwwUPETkoEWposJ1ouV1IiT167HnmJtPQtk1CY83iSd5BSOnjHqws9I2FSKdFWqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5rpw4Nd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B83606A32F;
	Wed, 18 Nov 2026 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5rpw4Nd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BFC1F000C4;
	Wed, 18 Nov 2026 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016073;
	bh=B6Mfg5b55Aziz9iRcy4z4S2D5fiPjd47v2PC7ZENVKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5rpw4NdPCTPz6zQI/yvtpxiCzIYVbmuD79huTSoBCTo8VaHYCBKrgVMjzekJRUWG
	 +Tb1NhZSRFcViu8m2DEL1K/1u+c9U9UTOZ4xKCwto40oVPRrNEqdNMp79f30XnG4mz
	 rIdBFDffATMg57zomox393+GPhVMCyc83baqeP3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0382/2651] regulator: ab8500: Propagate mode enable read errors
Date: Wed, 18 Nov 2026 15:27:02 +0100
Message-ID: <20261118150301.586453533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 71ac8878573058e2b85210760ccaeaac90796c35 ]

For regulators whose enable and mode share a state field, set_mode()
first reads that field so changing the requested mode does not enable a
disabled rail. A register read error is currently treated as true and
the driver proceeds to write the new mode, potentially enabling a rail
whose state is unknown.

Return the read error without changing the register or cached mode.

References: AB8500 User Manual, UM0836 Rev 3, p. 227;
AB8505 User Manual, DM00046744 Rev 3, p. 237

Fixes: 438e695b87e0 ("regulator: ab8500: Get rid of is_enabled from struct ab8500_regulator_info")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-6-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 05c6b9c7af0c7..e4c3502c8dbcc 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -433,7 +433,7 @@ static unsigned int ab8500_regulator_get_optimum_mode(
 static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
-	int ret = 0;
+	int enabled, ret = 0;
 	u8 bank, reg, mask, val;
 	bool lp_mode_req = false;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -490,7 +490,17 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		goto out_unlock;
 	}
 
-	if (info->mode_mask || ab8500_regulator_is_enabled(rdev)) {
+	if (info->mode_mask) {
+		enabled = 1;
+	} else {
+		enabled = ab8500_regulator_is_enabled(rdev);
+		if (enabled < 0) {
+			ret = enabled;
+			goto out_unlock;
+		}
+	}
+
+	if (enabled) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 			bank, reg, mask, val);
 		if (ret < 0) {
-- 
2.53.0



