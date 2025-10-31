Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D809C22A4D6;
	Fri, 31 Oct 2025 14:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919525; cv=none; b=QlIt/K457piDdhGomcrnHWJstmb1N4QdTqDqzjTi4QMNg8rsRCdUgmFwuRQ71XGy0iy3Nkt9e7T8ZsIGuR/nfPau8kBg5tEydMaAKwScxAdKgtIpmNY76iYI+/xFzEU7NRBq7XWJ8zADHvUiMTQ58DapEXcmWuhY8R8Pnf/VFeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919525; c=relaxed/simple;
	bh=ww2wUT+U5QC1f8i3e3c2G8JPHbIYc8kkseA4OXP2Vmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3kvv/IR9uGXuU7ESPwwfoRuMc3/VjbFcMhZZaDwgvTN7E9vaAPPZf+HPQcM4WnzPhaTCE0PZhfZHxSQxSOXYoPH6oaZ5BvobjHfZJiH0HBIU4uFLCUIMElK9rthkcSsY90pleRoLh5fwdGTFjPO2ojd1VDpjouhaUKRx9xPPiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxoUlVQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxoUlVQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66052C4CEE7;
	Fri, 31 Oct 2025 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919525;
	bh=ww2wUT+U5QC1f8i3e3c2G8JPHbIYc8kkseA4OXP2Vmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxoUlVQHDUXnZZa9djVA439+lXXAu37cMm0IYqyERCRJgLzLTmDYhrP/idIkgd+Nq
	 S9k6m8rv0B1kCB9/FfuPy15k4S/SwvgVeepYB30KSf5ISPlVLg8mGxW5r8L+klndn8
	 RjBfgLCAnRQ/eRN5lKY7N+vs/MMPNsfpL6kQETkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 09/40] x86/bugs: Fix reporting of LFENCE retpoline
Date: Fri, 31 Oct 2025 15:01:02 +0100
Message-ID: <20251031140044.169929185@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Kaplan <david.kaplan@amd.com>

[ Upstream commit d1cc1baef67ac6c09b74629ca053bf3fb812f7dc ]

The LFENCE retpoline mitigation is not secure but the kernel prints
inconsistent messages about this fact.  The dmesg log says 'Mitigation:
LFENCE', implying the system is mitigated.  But sysfs reports 'Vulnerable:
LFENCE' implying the system (correctly) is not mitigated.

Fix this by printing a consistent 'Vulnerable: LFENCE' string everywhere
when this mitigation is selected.

Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250915134706.3201818-1-david.kaplan@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0c16457e06543..939401b5d2ef0 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1598,7 +1598,7 @@ spectre_v2_user_select_mitigation(void)
 static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
 	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
-	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
+	[SPECTRE_V2_LFENCE]			= "Vulnerable: LFENCE",
 	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced / Automatic IBRS",
 	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced / Automatic IBRS + LFENCE",
 	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced / Automatic IBRS + Retpolines",
@@ -3251,9 +3251,6 @@ static const char *spectre_bhi_state(void)
 
 static ssize_t spectre_v2_show_state(char *buf)
 {
-	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
-		return sysfs_emit(buf, "Vulnerable: LFENCE\n");
-
 	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
 		return sysfs_emit(buf, "Vulnerable: eIBRS with unprivileged eBPF\n");
 
-- 
2.51.0



