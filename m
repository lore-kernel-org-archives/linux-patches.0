Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1609D176FCE;
	Tue,  8 Oct 2024 12:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391576; cv=none; b=cAPYUaUkKVBEIvVUyjGWZ6zlggNdtNtp6c8LkdZw48Hy5CWSvPxz1Dcorn3o19jpfZmDwL/PochFrT1ahgMC1c+bXKHLAH3qdcWEUh+ImaLXROQQ6ArKtFLAV4/v+lYwrBzFWXhSG5ddE7Mh0KehmfZtCQEkYyJjKFVdQBnNeow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391576; c=relaxed/simple;
	bh=pRk94JIcSn5g1656qmuqk9i6NNQiaTG1Oqe2iIFHchU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnvUy8zwxlmnnDLK5sU+fh02d80eV3eNCcKL/2OTX5yKF079Si+gaHTm2d9Jz/t313xNsvrjEn7Sjsx4pJjdxnYlUNPyF66i0ua8AUIl3lySrkIIUyJUhMRDgiQFZlur2UduVKZxK4YwdW8KS15NJYQ54s3nTZrAIfi5CP0GYSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4c3+Y4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4c3+Y4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C444C4CEC7;
	Tue,  8 Oct 2024 12:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391576;
	bh=pRk94JIcSn5g1656qmuqk9i6NNQiaTG1Oqe2iIFHchU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4c3+Y4IcHPx57H4VO4VWPIuMwlhjIgvnK+vwPyktwDYRldLUuV+orQ2JH3RwRepA
	 c4AQFpoxcZFcQ5ZVl+c6ObeJKo0HFumurgIhQtTVq896arXP4USvzrCz2cukJbhJd2
	 pz2ABcxoNKPKS+XS80uTHsxnvF1tbwa3yflId7lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 157/558] x86/bugs: Fix handling when SRSO mitigation is disabled
Date: Tue,  8 Oct 2024 14:03:07 +0200
Message-ID: <20241008115708.539756155@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Kaplan <david.kaplan@amd.com>

[ Upstream commit 1dbb6b1495d472806fef1f4c94f5b3e4c89a3c1d ]

When the SRSO mitigation is disabled, either via mitigations=off or
spec_rstack_overflow=off, the warning about the lack of IBPB-enhancing
microcode is printed anyway.

This is unnecessary since the user has turned off the mitigation.

  [ bp: Massage, drop SBPB rationale as it doesn't matter because when
    mitigations are disabled x86_pred_cmd is not being used anyway. ]

Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20240904150711.193022-1-david.kaplan@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 45675da354f33..468449f73a957 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2551,10 +2551,9 @@ static void __init srso_select_mitigation(void)
 {
 	bool has_microcode = boot_cpu_has(X86_FEATURE_IBPB_BRTYPE);
 
-	if (cpu_mitigations_off())
-		return;
-
-	if (!boot_cpu_has_bug(X86_BUG_SRSO)) {
+	if (!boot_cpu_has_bug(X86_BUG_SRSO) ||
+	    cpu_mitigations_off() ||
+	    srso_cmd == SRSO_CMD_OFF) {
 		if (boot_cpu_has(X86_FEATURE_SBPB))
 			x86_pred_cmd = PRED_CMD_SBPB;
 		return;
@@ -2585,11 +2584,6 @@ static void __init srso_select_mitigation(void)
 	}
 
 	switch (srso_cmd) {
-	case SRSO_CMD_OFF:
-		if (boot_cpu_has(X86_FEATURE_SBPB))
-			x86_pred_cmd = PRED_CMD_SBPB;
-		return;
-
 	case SRSO_CMD_MICROCODE:
 		if (has_microcode) {
 			srso_mitigation = SRSO_MITIGATION_MICROCODE;
@@ -2643,6 +2637,8 @@ static void __init srso_select_mitigation(void)
 			pr_err("WARNING: kernel not compiled with MITIGATION_SRSO.\n");
                 }
 		break;
+	default:
+		break;
 	}
 
 out:
-- 
2.43.0



