Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA8D3C17;
	Fri, 31 Oct 2025 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919558; cv=none; b=I9g7Srgr6/svYFKI+ktX4U9kEjbI/uZsb7/j9Nm1sexUrTkdjKmlGvmEtudfnyqRW4ZWBg/lQcFw/M0I5a7ZxjhP3p9Ep6dGx8sARKKLo5EP+pHcGd6NSR3usWnYwZB4dGqyQfqcIIeGUcevqqBMBIl4K8W2j2+cr6sMQthbufA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919558; c=relaxed/simple;
	bh=I0Bt8/hOyrKTatjUlV+jQVod56rUEr/f5fwWxgV0InQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sj8GCr1NhMG4aR4wa4vfjjoM/7YpyGMC2a9TXeQJ0sGDQ1Viy9/8Q44v6z3bHEUikOkiF1pi3L5IlH606dic0Q7XrIUES781lHcc0UBlzHC+ucLMuwQ9JgmkwleQYzVsOfMc5JGQEnvGDOlgb/dxsX+J/cXAgrJ4YCSSBUbYhew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQgYJ03r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQgYJ03r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371B1C4CEE7;
	Fri, 31 Oct 2025 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919558;
	bh=I0Bt8/hOyrKTatjUlV+jQVod56rUEr/f5fwWxgV0InQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQgYJ03r+wIK1aBjw4fOnVc6U8KoAN7dUT1ajYn5a49TNG0Sy85FsIhkxiXjd/g+T
	 eiljYttH2HTC9BQ4nj0w3L+GNiN26N2+gPFjOSD/t35YfofgA/+YWktmcmBTwIRPsN
	 DF41a62kiw6UyQPfPm3VAraYW8ZUeBlJLzVliTzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 19/35] x86/bugs: Add attack vector controls for VMSCAPE
Date: Fri, 31 Oct 2025 15:01:27 +0100
Message-ID: <20251031140044.023887631@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Kaplan <david.kaplan@amd.com>

[ Upstream commit 5799d5d8a6c877f03ad5b5a640977053be45059a ]

Use attack vector controls to select whether VMSCAPE requires mitigation,
similar to other bugs.

Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/hw-vuln/attack_vector_controls.rst |  1 +
 arch/x86/kernel/cpu/bugs.c                         | 14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/attack_vector_controls.rst b/Documentation/admin-guide/hw-vuln/attack_vector_controls.rst
index 5964901d66e31..d0bdbd81dcf9f 100644
--- a/Documentation/admin-guide/hw-vuln/attack_vector_controls.rst
+++ b/Documentation/admin-guide/hw-vuln/attack_vector_controls.rst
@@ -218,6 +218,7 @@ SRSO                  X              X            X              X
 SSB                                  X
 TAA                   X              X            X              X            *       (Note 2)
 TSA                   X              X            X              X
+VMSCAPE                                           X
 =============== ============== ============ ============= ============== ============ ========
 
 Notes:
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 9750ce448e626..c6bb8e76eb984 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -434,6 +434,9 @@ static bool __init should_mitigate_vuln(unsigned int bug)
 	case X86_BUG_SPEC_STORE_BYPASS:
 		return cpu_attack_vector_mitigated(CPU_MITIGATE_USER_USER);
 
+	case X86_BUG_VMSCAPE:
+		return cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST);
+
 	default:
 		WARN(1, "Unknown bug %x\n", bug);
 		return false;
@@ -3308,15 +3311,18 @@ early_param("vmscape", vmscape_parse_cmdline);
 
 static void __init vmscape_select_mitigation(void)
 {
-	if (cpu_mitigations_off() ||
-	    !boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
+	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
 	    !boot_cpu_has(X86_FEATURE_IBPB)) {
 		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 		return;
 	}
 
-	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO)
-		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
+	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
+		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
+			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
+		else
+			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
+	}
 }
 
 static void __init vmscape_update_mitigation(void)
-- 
2.51.0



