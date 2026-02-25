Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439F427603A;
	Wed, 25 Feb 2026 01:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983773; cv=none; b=C83z09lbaFOJEiUaBDnkZuX9uCwfiSDkTVX6bo66FatSyqXDbFLzAhhoqvtnPIo/TuXTOCr+ulSxUVffS73DsMaTvH61XC98Dx8VTQDYQ7sANzgjnK2hZuaU+QMG8HFBNMIuwExCVRRUhHwfuW9hiYFN71nkZEAHKNvf67Xq8R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983773; c=relaxed/simple;
	bh=hHljI9zu/7ApduK2xY6MufKtUKdP3+zty8iKq+2ViFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WylV9RZaDX0jJ1cGVKPGQTDJdmzi2qzDjO4J/DUUKMYdaryJiqMUluaoD4opRtCBEat/g2XICdlGlwegbNWxxYk6c7P579DDmaTIOrgSFR5cPipSzsy10PElhUGJ9+dKFaVuukmiHmXUrx/7RYUWsOIx3MHHnWyIKdmkbbblY18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg05cXiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg05cXiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4365C19424;
	Wed, 25 Feb 2026 01:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983772;
	bh=hHljI9zu/7ApduK2xY6MufKtUKdP3+zty8iKq+2ViFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg05cXivkYp5KEhiaUxYQNmqyeHZKPj3pyw+6uTBElh7rezpNLS/NL+mTGyCOrTZQ
	 s9Pl7tLCfIf+MIGRzvCFX0JwaJIUkFh2nDC6HWS09znR5h9Hq0P78UtHCRn/18Z/B+
	 jnBtrWoxYhpRgBiwtZqkAzNR+vorm6tqi14tdofQ=
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
Subject: [PATCH 6.18 063/641] x86/cpu/amd: Correct the microcode table for Zenbleed
Date: Tue, 24 Feb 2026 17:16:29 -0800
Message-ID: <20260225012350.579345028@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5d46709c58d0b..a92750f3079af 100644
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



