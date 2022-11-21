Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36473D74
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 12:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5845FC433C1;
	Mon, 21 Nov 2022 12:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669034761;
	bh=IRnb6U/Hv7emtNJQDqeo2ttwK4Yc0J7lHL8BnUjNKyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUyoouNdLi1fMizEq+OcWypLjGUB8OVc6hKQF+wqP1TLu6wQOMRCPWyi1HiVcwVtT
	 j5b4cDQPz0IdvTJHg0Qru8dJO8iPdqceOxg6UDL+FvMZiKPUdRcfhna6Eq/RWaJKi0
	 7HooDG+vlep5IPzV7m9acXwb1NBZMIwiumfNSekg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@suse.de>,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
	Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 23/34] x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
Date: Mon, 21 Nov 2022 13:43:45 +0100
Message-Id: <20221121124151.735011961@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
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
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
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
@@ -1274,7 +1265,6 @@ static void __init spectre_v2_select_mit
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
-		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
 		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 	}


