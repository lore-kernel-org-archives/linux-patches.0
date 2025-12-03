Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2013030DEA9;
	Wed,  3 Dec 2025 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775896; cv=none; b=sj54nMLE4j5WCuaU2KitRjzMDQ0JdPcpog89N/BiXc/J6W7eDCV4hnaeKYz2bDqqZA/IFVIWCoL/wNxIKnmif/8Ra/6XwPsZSObWW6KQBuviK44aun4mmAO90FwBdmA1Njkk8GvObb+Fwaa9UWqQXsNd4mYfa7m/cpwxPv5ZdYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775896; c=relaxed/simple;
	bh=4E5QnOOtwJLYn+0riezjBQgvtHRauGGVc+Pu8MP9wsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjiDKEDxSMIunfb6UNVPMdKb9HezdFUyY8vyILu0llZ/2TuIo7Kt+Y1eSVVIjhFz8r6ZtZUJR2709UklAs17wHuRovYp1yQZcI2nheR+Rsw5yg3SXNMdS1yTOosqIQAZ0xJgxi+27gV+ZkFFDnSyKRZ7wOLxrMBB5Za5l2tuTjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7Q1ZI2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7Q1ZI2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187CDC4CEF5;
	Wed,  3 Dec 2025 15:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775895;
	bh=4E5QnOOtwJLYn+0riezjBQgvtHRauGGVc+Pu8MP9wsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7Q1ZI2FImtaqowhgT/Z3RY7VhMLonvXMs2v3GzxViszI9RuVBHJUJmtMpy2mf+KZ
	 anEcwREtoJcYdatwz+n3J+Zdrf2edpVb9HCn+ZnaYQARBhHUwy2gj5E/jbvc+xOb+B
	 /Pmnaz0FemeaclbvnqOpbV/wT+VfiuqRrmGHL5RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/300] x86/bugs: Fix reporting of LFENCE retpoline
Date: Wed,  3 Dec 2025 16:23:26 +0100
Message-ID: <20251203152400.546012062@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8794e3f4974b3..57ba697e29180 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1508,7 +1508,7 @@ spectre_v2_user_select_mitigation(void)
 static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
 	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
-	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
+	[SPECTRE_V2_LFENCE]			= "Vulnerable: LFENCE",
 	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced / Automatic IBRS",
 	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced / Automatic IBRS + LFENCE",
 	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced / Automatic IBRS + Retpolines",
@@ -3011,9 +3011,6 @@ static char *pbrsb_eibrs_state(void)
 
 static ssize_t spectre_v2_show_state(char *buf)
 {
-	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
-		return sysfs_emit(buf, "Vulnerable: LFENCE\n");
-
 	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
 		return sysfs_emit(buf, "Vulnerable: eIBRS with unprivileged eBPF\n");
 
-- 
2.51.0



