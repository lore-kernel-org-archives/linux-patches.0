Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4981F8F18;
	Mon, 21 Oct 2024 10:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507784; cv=none; b=bKl4OEsRF6yl4AJCqIv40nS90g3IEN/qB7q4Le9rpz8pIfoDwMS0JFY5d84ti9dzyU/fcr15/ezm09cSZtnEr2PmN6YSDa2RcuLvoD7amgKFSWunRQ2fRZKUDDpCqtzbrRaj3czQcyKcmUlMijWPGAp+GxUC1DTMHlrsUv6FPVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507784; c=relaxed/simple;
	bh=+3+uQAeBzMmpD5IY9BROyKXAF9c5oBIId5Yorfqjgfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFYwSjS9QRgIx9X/EykDzokdgUIDLICFGoUiFm1G7IvHCXSwJzfd3tOO3JGLaYsDeqPTfC+Frln8zW9WrCFkIU5gdNmjQN5OjYooYOPMurW9C3Ik+IhkI+TZtHDsdSXXRj9uIqevQ0QTO4sI6edP+0I0TdzvV9ZFrozbO6PW4n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OS2uTkh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OS2uTkh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67480C4CEE6;
	Mon, 21 Oct 2024 10:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507783;
	bh=+3+uQAeBzMmpD5IY9BROyKXAF9c5oBIId5Yorfqjgfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OS2uTkh+hJfoMsv7zLu+Hd0qHRRs64+a7C+t1SrrGRjijGjbPeaNbep4IUQsoc1NB
	 QDQ7v9GHGRPdzVuJXZx57zufuHAyeYZXLm7e0EswHb/W2veylkETxSTrcxISMMbEV+
	 G6qL1K7uBRlIiPqUN8qbZh9DGeO0wVcRwzB3BNgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Wikner <kwikner@ethz.ch>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.10 18/52] x86/cpufeatures: Add a IBPB_NO_RET BUG flag
Date: Mon, 21 Oct 2024 12:25:39 +0200
Message-ID: <20241021102242.339503398@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Wikner <kwikner@ethz.ch>

commit 3ea87dfa31a7b0bb0ff1675e67b9e54883013074 upstream.

Set this flag if the CPU has an IBPB implementation that does not
invalidate return target predictions. Zen generations < 4 do not flush
the RSB when executing an IBPB and this bug flag denotes that.

  [ bp: Massage. ]

Signed-off-by: Johannes Wikner <kwikner@ethz.ch>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    2 ++
 arch/x86/kernel/cpu/common.c       |    3 +++
 2 files changed, 5 insertions(+)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -456,4 +456,6 @@
 #define X86_BUG_SRSO			X86_BUG(1*32 + 0) /* AMD SRSO bug */
 #define X86_BUG_DIV0			X86_BUG(1*32 + 1) /* AMD DIV0 speculation bug */
 #define X86_BUG_RFDS			X86_BUG(1*32 + 2) /* CPU is vulnerable to Register File Data Sampling */
+#define X86_BUG_BHI			X86_BUG(1*32 + 3) /* CPU is affected by Branch History Injection */
+#define X86_BUG_IBPB_NO_RET		X86_BUG(1*32 + 4) /* "ibpb_no_ret" IBPB omits return target predictions */
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1335,6 +1335,9 @@ static void __init cpu_set_bug_bits(stru
 	if (vulnerable_to_rfds(ia32_cap))
 		setup_force_cpu_bug(X86_BUG_RFDS);
 
+	if (cpu_has(c, X86_FEATURE_AMD_IBPB) && !cpu_has(c, X86_FEATURE_AMD_IBPB_RET))
+		setup_force_cpu_bug(X86_BUG_IBPB_NO_RET);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 


