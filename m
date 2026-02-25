Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB29E4369A;
	Wed, 25 Feb 2026 01:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982925; cv=none; b=RoOiEMkDaDdrJN6AF3+tvcmlcSoz+TeFDLTVWCLxvCkwnFJ0v/w6dYwQtayfyGBnbweTiGf3QCAmLb78NKl2Wdjyw1FMmebiK0cwQmeJhLgjrfkRGlOIzfrGGHlJZ17TF93nLEx2kG5FvByc6MgBZHJ+29XPvGVOk7a/fxLoYv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982925; c=relaxed/simple;
	bh=lmQ29mhPmcdOK8NXe6f/1ylnZ4GUGV249DqwbcMHa9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwIwl1ZqwuCm0tidZXET6Y8onAgCrHvvHaD67QGS3MV/u8erEuEOSiHktzPympXnQlrPF+WC7yvdRBMaE6eJ4du+DiKhJDnCv47J44Ta2iztCb3KuPKxcT+r4A/5kRbwYqemqOVEwpwg1McwX5h9eqE8JLczysweUx+bElBtIq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IK2WFCjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IK2WFCjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D60BC116D0;
	Wed, 25 Feb 2026 01:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982925;
	bh=lmQ29mhPmcdOK8NXe6f/1ylnZ4GUGV249DqwbcMHa9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IK2WFCjk4pMAdL2iOr83OL/H4dq0nQIOFkhnmkG2gWaBTxtKJYJtTQj2qmU6St3lI
	 TKtAwxzQ4LV7nlQopoV7WQC2VkDlbAGK5CkSgJnEA4Y/9/xlcUHLHJcDDomIJ9rtIB
	 WxEg83hAhu9p703foKuW9k+D5nZ6aVGUvOeWhsDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	x86@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 068/781] x86/cpu/amd: Correct the microcode table for Zenbleed
Date: Tue, 24 Feb 2026 17:12:57 -0800
Message-ID: <20260225012401.372170432@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Cooper <andrew.cooper3@citrix.com>

[ Upstream commit fb7bfa31b8e8569f154f2fe0ea6c2f03c0f087aa ]

The good revisions are tied to exact steppings, meaning it's not valid to
match on model number alone, let alone a range.

This is probably only a latent issue.  From public microcode archives, the
following CPUs exist 17-30-00, 17-60-00, 17-70-00 and would be captured by the
model ranges.  They're likely pre-production steppings, and likely didn't get
Zenbleed microcode, but it's still incorrect to compare them to a different
steppings revision.

Either way, convert the logic to use x86_match_min_microcode_rev(), which is
the preferred mechanism.

Fixes: 522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: x86@kernel.org
Link: https://patch.msgid.link/20251126130352.880424-1-andrew.cooper3@citrix.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bc94ff1e250ad..86059f2c0fcd4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -951,26 +951,14 @@ static void init_amd_zen1(struct cpuinfo_x86 *c)
 	}
 }
 
-static bool cpu_has_zenbleed_microcode(void)
-{
-	u32 good_rev = 0;
-
-	switch (boot_cpu_data.x86_model) {
-	case 0x30 ... 0x3f: good_rev = 0x0830107b; break;
-	case 0x60 ... 0x67: good_rev = 0x0860010c; break;
-	case 0x68 ... 0x6f: good_rev = 0x08608107; break;
-	case 0x70 ... 0x7f: good_rev = 0x08701033; break;
-	case 0xa0 ... 0xaf: good_rev = 0x08a00009; break;
-
-	default:
-		return false;
-	}
-
-	if (boot_cpu_data.microcode < good_rev)
-		return false;
-
-	return true;
-}
+static const struct x86_cpu_id amd_zenbleed_microcode[] = {
+	ZEN_MODEL_STEP_UCODE(0x17, 0x31, 0x0, 0x0830107b),
+	ZEN_MODEL_STEP_UCODE(0x17, 0x60, 0x1, 0x0860010c),
+	ZEN_MODEL_STEP_UCODE(0x17, 0x68, 0x1, 0x08608107),
+	ZEN_MODEL_STEP_UCODE(0x17, 0x71, 0x0, 0x08701033),
+	ZEN_MODEL_STEP_UCODE(0x17, 0xa0, 0x0, 0x08a00009),
+	{}
+};
 
 static void zen2_zenbleed_check(struct cpuinfo_x86 *c)
 {
@@ -980,7 +968,7 @@ static void zen2_zenbleed_check(struct cpuinfo_x86 *c)
 	if (!cpu_has(c, X86_FEATURE_AVX))
 		return;
 
-	if (!cpu_has_zenbleed_microcode()) {
+	if (!x86_match_min_microcode_rev(amd_zenbleed_microcode)) {
 		pr_notice_once("Zenbleed: please update your microcode for the most optimal fix\n");
 		msr_set_bit(MSR_AMD64_DE_CFG, MSR_AMD64_DE_CFG_ZEN2_FP_BACKUP_FIX_BIT);
 	} else {
-- 
2.51.0



