Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3636FE35;
	Mon,  8 Apr 2024 13:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582054; cv=none; b=OHXQxeE073hljaX5B6RGW7I/xQ/RrU0UB6cVdLIQvZwjp6ja0Giz5R2TIXDazAtE24qtEs+5J5LDGmaxhhvoOk+XdOGsjPitPOxWm3Fwb24JqUitPCW3AF/ohh1Z8pMYV77af3IcMNrBImTMwVRoOf6smFzw+E80+InObbKccXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582054; c=relaxed/simple;
	bh=UtAsA4TKW+/icmU659cg0QFdcy3hdYhcZ07NY/k0f1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrVFI+aHVn6uws4izOpIa3CIlqFyFp4PCeEhU9TrBi67yKE8051c6P+DW2eSLIXyABkBc3fCHOuy/RUvSCx89sc4be0PVTPsNwQNfHzr9Jg0Wh/kWIIMMUd3+UXxB/VFn+xyWHIkZp2u6NiDd970kIrEJautUb//eQIA/VKugTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7426h8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7426h8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23955C43390;
	Mon,  8 Apr 2024 13:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582054;
	bh=UtAsA4TKW+/icmU659cg0QFdcy3hdYhcZ07NY/k0f1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7426h8QJMhFDJwHf4luiCQL1FwEvmZ0kw6PBWkBTGrc67tM8Lgu1BK1kKE0/dfsk
	 cty2TZcW2+1B+GLZ22y9VQIRjq60Ft0DPC3akPHJgPJ/A+rtGa04ayUt6Cntd6GIjC
	 PaJIgcOng9LhldM07qZNCvKZFmhY6R0ai9FsVoN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/252] x86/CPU/AMD: Move the DIV0 bug detection to the Zen1 init function
Date: Mon,  8 Apr 2024 14:55:59 +0200
Message-ID: <20240408125308.501026151@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit bfff3c6692ce64fa9d86eb829d18229c307a0855 ]

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: http://lore.kernel.org/r/20231120104152.13740-9-bp@alien8.de
Stable-dep-of: c7b2edd8377b ("perf/x86/amd/core: Update and fix stalled-cycles-* events for Zen 2 and later")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index d8a0dc01a7db2..f4373530c7de0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -70,10 +70,6 @@ static const int amd_erratum_383[] =
 static const int amd_erratum_1054[] =
 	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0, 0, 0x2f, 0xf));
 
-static const int amd_div0[] =
-	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0x00, 0x0, 0x2f, 0xf),
-			   AMD_MODEL_RANGE(0x17, 0x50, 0x0, 0x5f, 0xf));
-
 static const int amd_erratum_1485[] =
 	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x19, 0x10, 0x0, 0x1f, 0xf),
 			   AMD_MODEL_RANGE(0x19, 0x60, 0x0, 0xaf, 0xf));
@@ -1043,6 +1039,9 @@ static void init_amd_zen(struct cpuinfo_x86 *c)
 		if (c->x86 == 0x19 && !cpu_has(c, X86_FEATURE_BTC_NO))
 			set_cpu_cap(c, X86_FEATURE_BTC_NO);
 	}
+
+	pr_notice_once("AMD Zen1 DIV0 bug detected. Disable SMT for full protection.\n");
+	setup_force_cpu_bug(X86_BUG_DIV0);
 }
 
 static bool cpu_has_zenbleed_microcode(void)
@@ -1211,11 +1210,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 	    cpu_has(c, X86_FEATURE_AUTOIBRS))
 		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS));
 
-	if (cpu_has_amd_erratum(c, amd_div0)) {
-		pr_notice_once("AMD Zen1 DIV0 bug detected. Disable SMT for full protection.\n");
-		setup_force_cpu_bug(X86_BUG_DIV0);
-	}
-
 	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&
 	     cpu_has_amd_erratum(c, amd_erratum_1485))
 		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
-- 
2.43.0



