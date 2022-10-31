Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC4917F3
	for <patches@lists.linux.dev>; Mon, 31 Oct 2022 07:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29898C433D6;
	Mon, 31 Oct 2022 07:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667199799;
	bh=HiPxRbtBhb0NaQRf0hI4JtS7NlW2Jh6WQPEHKo5B2JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUIjLj9tpn8oMGW2ktf6TrP1Hz06qGvOvAKhKY+VQDM+yau3X7HHQvRkVLhRgN4rZ
	 Zi7vUc3y2/AeX33xvSD1KnT/XG/j3jU9l20wLk92HAjZPm6EVFN0CwQJJflWmpjBqd
	 PDTTROUdmgNR10x2Fx5sO1tSuhdCIzZwPhzUomuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@suse.de>,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 23/34] x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
Date: Mon, 31 Oct 2022 08:02:56 +0100
Message-Id: <20221031070140.657904873@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit bbb69e8bee1bd882784947095ffb2bfe0f7c9470 upstream.

There's no need to recalculate the host value for every entry/exit.
Just use the cached value in spec_ctrl_current().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -198,7 +198,7 @@ void __init check_bugs(void)
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
-	u64 msrval, guestval, hostval = x86_spec_ctrl_base;
+	u64 msrval, guestval, hostval = spec_ctrl_current();
 	struct thread_info *ti = current_thread_info();
 
 	/* Is MSR_SPEC_CTRL implemented ? */
@@ -211,15 +211,6 @@ x86_virt_spec_ctrl(u64 guest_spec_ctrl,
 		guestval = hostval & ~x86_spec_ctrl_mask;
 		guestval |= guest_spec_ctrl & x86_spec_ctrl_mask;
 
-		/* SSBD controlled in MSR_SPEC_CTRL */
-		if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-		    static_cpu_has(X86_FEATURE_AMD_SSBD))
-			hostval |= ssbd_tif_to_spec_ctrl(ti->flags);
-
-		/* Conditional STIBP enabled? */
-		if (static_branch_unlikely(&switch_to_cond_stibp))
-			hostval |= stibp_tif_to_spec_ctrl(ti->flags);
-
 		if (hostval != guestval) {
 			msrval = setguest ? guestval : hostval;
 			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
@@ -1272,7 +1263,6 @@ static void __init spectre_v2_select_mit
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
-		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
 		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 	}


