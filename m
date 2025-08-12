Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3AF2F5E;
	Tue, 12 Aug 2025 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022422; cv=none; b=PpRBeHMyjxL84T5PTvMcA4O7cjMfDKovgyJ9QPtWrtfoCtGADndNr8F0iuk4UbtznIr9H7CLsalR/boS+FE3sQbvhuR8UIjZ3136sEBtecNja4zhW1V38vPuDVRSTte91QdJA2G1AEGeYpCM1K6x3uRAskR1gCekKVAujl5QqDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022422; c=relaxed/simple;
	bh=7SarkvDLs6Rntmzu4VAxXxwYn3SrmydggRi398D6dJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjbx5XjKE2WQEB0Bbh/32a/9AOA+C53jOpecoWxrx71AxSTP/4abEXUHB4IPOey0jEcMutbqEiWn+akXDodbE/tL1bYYZYGzkcNRG4JsFivN4V33Dt1P14TW0+cNv66d/6rZsPnNBOp+1LECfm4eTIEtc0y9/hxaIPvyRkwa3xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzsTSVPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzsTSVPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBCCC4CEF1;
	Tue, 12 Aug 2025 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022421;
	bh=7SarkvDLs6Rntmzu4VAxXxwYn3SrmydggRi398D6dJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzsTSVPSkdNVJtVDwHt/LDoG+RNpgM2prwFdM7kJHAvNU2N1qHXigHgH7phbcdM+I
	 qYSd1C4fwhz2Yz+ZXZV/QTWSYEtA4Vs7v9nJHQilKSH8XLyL5mPCszyqbnbzcnUXhN
	 4h4/3T8Ntv21oLNGHbgJ08s0HUMBJnTW28cjmuOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zepta <z3ptaa@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/369] staging: media: atomisp: Fix stack buffer overflow in gmin_get_var_int()
Date: Tue, 12 Aug 2025 19:27:28 +0200
Message-ID: <20250812173020.462254426@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit ee4cf798202d285dcbe85e4467a094c44f5ed8e6 ]

When gmin_get_config_var() calls efi.get_variable() and the EFI variable
is larger than the expected buffer size, two behaviors combine to create
a stack buffer overflow:

1. gmin_get_config_var() does not return the proper error code when
   efi.get_variable() fails. It returns the stale 'ret' value from
   earlier operations instead of indicating the EFI failure.

2. When efi.get_variable() returns EFI_BUFFER_TOO_SMALL, it updates
   *out_len to the required buffer size but writes no data to the output
   buffer. However, due to bug #1, gmin_get_var_int() believes the call
   succeeded.

The caller gmin_get_var_int() then performs:
- Allocates val[CFG_VAR_NAME_MAX + 1] (65 bytes) on stack
- Calls gmin_get_config_var(dev, is_gmin, var, val, &len) with len=64
- If EFI variable is >64 bytes, efi.get_variable() sets len=required_size
- Due to bug #1, thinks call succeeded with len=required_size
- Executes val[len] = 0, writing past end of 65-byte stack buffer

This creates a stack buffer overflow when EFI variables are larger than
64 bytes. Since EFI variables can be controlled by firmware or system
configuration, this could potentially be exploited for code execution.

Fix the bug by returning proper error codes from gmin_get_config_var()
based on EFI status instead of stale 'ret' value.

The gmin_get_var_int() function is called during device initialization
for camera sensor configuration on Intel Bay Trail and Cherry Trail
platforms using the atomisp camera stack.

Reported-by: zepta <z3ptaa@gmail.com>
Closes: https://lore.kernel.org/all/CAPBS6KoQyM7FMdPwOuXteXsOe44X4H3F8Fw+y_qWq6E+OdmxQA@mail.gmail.com
Fixes: 38d4f74bc148 ("media: atomisp_gmin_platform: stop abusing efivar API")
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250724080756.work.741-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/atomisp_gmin_platform.c    | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
index e176483df301..b86494faa63a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
@@ -1358,14 +1358,15 @@ static int gmin_get_config_var(struct device *maindev,
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		status = efi.get_variable(var16, &GMIN_CFG_VAR_EFI_GUID, NULL,
 					  (unsigned long *)out_len, out);
-	if (status == EFI_SUCCESS)
+	if (status == EFI_SUCCESS) {
 		dev_info(maindev, "found EFI entry for '%s'\n", var8);
-	else if (is_gmin)
+		return 0;
+	}
+	if (is_gmin)
 		dev_info(maindev, "Failed to find EFI gmin variable %s\n", var8);
 	else
 		dev_info(maindev, "Failed to find EFI variable %s\n", var8);
-
-	return ret;
+	return -ENOENT;
 }
 
 int gmin_get_var_int(struct device *dev, bool is_gmin, const char *var, int def)
-- 
2.39.5



