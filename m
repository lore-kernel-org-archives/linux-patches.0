Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF1A49D584;
	Thu, 17 Sep 2026 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664326; cv=none; b=PXWf0VU4dT2h8Px62ZwfINzFwuv7syBRcSh4BUieonxSjlnbGjTCBfOYbeQRDg1Q+g6e+17izYkQzRuLTsEkK+HZZHTNf2e7HM2CC+54posZSv/X/ec0vKKPVYiKV2GLOW5j+QwxkvL2SuUQ7mqUrM7Xx/RVR25MltA239bVXgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664326; c=relaxed/simple;
	bh=2bQJ36E1YUxnJSZSzMbeuVtKwQq5ZveAiX8HVHnSUOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZZ89LLWxXuw1mZOB5fzqb1vD5FSGctxO0S88rs1uAlyIMcIyyIKEqfl9d2hLnvc7lgQhtAqr01bYWwDKlSTWz6MyZAqY39c1o4PJHYHFx7EcUKMIAcVE+Jw/tamQvsbouAmtYRpNyMuB22nFoZH2l9GaXbZq35y9khbAmEBG1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHmBdWC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHmBdWC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A491F000FF;
	Thu, 17 Sep 2026 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664324;
	bh=7ZUZXC13lrG/GuKN48x1X35LFVlSZUzYWE9oYBaXoAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHmBdWC3/t+NanmX3zKs8u38PfFkHvySMxUNd/JH0Iku2bqNVReK//C/R93rQmVv3
	 /+dXfD8+H2slusqTj6H9irQ4sp1qu/j/jZ52Af7GrF7GtXcdIm6zpEtesnsrhWUHHr
	 1jWXxvhhjsne5sjcSezyWHkCeV+L+CGGcH1bwq60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0332/1250] x86/microcode/AMD: Move the no-revision fixup to get_patch_level()
Date: Thu, 17 Sep 2026 16:02:07 +0100
Message-ID: <20260917151601.088598301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 098bcea71b8d257d80b0037b97b66070806600a5 ]

On machines which don't have microcode applied yet, the revision is 0.
However, this doesn't work with the Zen family/model/stepping patch
arithmetic. So move the fixup to the patch level getter function and
this way make sure the patch level is always proper and thus the
arithmetic always works.

And now that it can be called on any family, make this Zen-only.

Assisted-by: claude/claude-opus-4-6
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20260530024213.86137-1-bp@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/amd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 46673530bc6f0..4a33d10685587 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -233,11 +233,6 @@ static bool need_sha_check(u32 cur_rev)
 {
 	u32 cutoff;
 
-	if (!cur_rev) {
-		cur_rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
-		pr_info_once("No current revision, generating the lowest one: 0x%x\n", cur_rev);
-	}
-
 	cutoff = get_cutoff_revision(cur_rev);
 	if (cutoff)
 		return cur_rev <= cutoff;
@@ -338,6 +333,13 @@ static u32 get_patch_level(void)
 	}
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	if (!rev) {
+		if (x86_family(bsp_cpuid_1_eax) < 0x17)
+			return rev;
+
+		rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
+		pr_info_once("No current revision, generating the lowest one: 0x%x\n", rev);
+	}
 
 	return rev;
 }
-- 
2.53.0



