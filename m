Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BC120C488;
	Tue, 29 Apr 2025 18:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950030; cv=none; b=oF+KWgkD/qwDHGfHNXLQ8pAq8tEppNI0x75V9bgvC3GXxVNtIaj4ys4c5sJE81dnriwGLWZPSD0/sW5ec/a4+2UWUsh01GGDq7LIp4TKoneS2pUeaButdaKNT241f5/nb5Kuws+yAmZJV0bNb8PCHFDNb5rQL8IvzotOhgLN7NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950030; c=relaxed/simple;
	bh=FqdlHLHghS/Kck5julK6hLvTtpWmBjW8ip4r2sfAdbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RG6+aeIlX3Wxsv8Fldi41TcqjHg0xWD2YcGPRHGecQsoi71KjPsEmjavLXAXfn9ChVMDPBAm8z35GLwbHuxskVVBgURnDsw1+ACnVyKnj7ui2tU4/2k9FoXCH1hqYAdQ9dWSXAnVjp6lLqxYwORZa9gjgwgyNrUiJ3Nkr/m9gx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XQjdH9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XQjdH9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F03C4CEE3;
	Tue, 29 Apr 2025 18:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950030;
	bh=FqdlHLHghS/Kck5julK6hLvTtpWmBjW8ip4r2sfAdbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XQjdH9WzRuz9jcMPBagJfxAgpW3bSLGR1A0GVspIFoMUWjy1HAM9de642o5BVVdI
	 UvI1P+ncjAcU1rslLJmjLs46+7Ho4b8A4P/EUF3VwaYR1afE/QV1M22VmFTPHpeuKs
	 C9RJW8L9TmGq1oiwDXAc+j4tQ2LRzf5NFIiaSJz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Amit Shah <amit.shah@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/167] x86/bugs: Dont fill RSB on VMEXIT with eIBRS+retpoline
Date: Tue, 29 Apr 2025 18:44:03 +0200
Message-ID: <20250429161057.193926030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 18bae0dfec15b24ec14ca17dc18603372f5f254f ]

eIBRS protects against guest->host RSB underflow/poisoning attacks.
Adding retpoline to the mix doesn't change that.  Retpoline has a
balanced CALL/RET anyway.

So the current full RSB filling on VMEXIT with eIBRS+retpoline is
overkill.  Disable it or do the VMEXIT_LITE mitigation if needed.

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Amit Shah <amit.shah@amd.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Link: https://lore.kernel.org/r/84a1226e5c9e2698eae1b5ade861f1b8bf3677dc.1744148254.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 7d73b53115514..f0f184afa44f3 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1579,20 +1579,20 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	case SPECTRE_V2_NONE:
 		return;
 
-	case SPECTRE_V2_EIBRS_LFENCE:
 	case SPECTRE_V2_EIBRS:
+	case SPECTRE_V2_EIBRS_LFENCE:
+	case SPECTRE_V2_EIBRS_RETPOLINE:
 		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 		}
 		return;
 
-	case SPECTRE_V2_EIBRS_RETPOLINE:
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
-		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 		return;
 	}
 
-- 
2.39.5



