Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477301F473E;
	Mon, 21 Oct 2024 10:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507694; cv=none; b=hjzYVQXM61JlUHXCw1HW6H6m18oSXjPQihTFXzthrF8krlKkE8UQG2H82XdYIfMvue8oD4rJTVBCUCZzbX6ZZE4j8gD1b/m6GTNKnZcoTj4KmHNVhwwEcztjy8xAwZ+ZpR0brM76HOngA3XI2r2oamTeON6M79nsWurhSEIvGqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507694; c=relaxed/simple;
	bh=gnIfJUHfMLS9B2vvQlTW+AD92K9dSAShb0VWq1brCzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6y0BrBWHTWqFCybP5BU2ygpD3FUC/bw9/mwyVKKStkSSFLUkoCfiv6i9g7NC7hph0JXPlDykNCwQ7DX9f/7gHFFGmfEpGo1ltVpoIuqn1fL2S7ZvOcBrz7dWdebcor1XHTSjhSxqI+EucHJDywj1iC7o5Lk62AO7AoSWlMYzNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLirw+Tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLirw+Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E657C4CEC3;
	Mon, 21 Oct 2024 10:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507693;
	bh=gnIfJUHfMLS9B2vvQlTW+AD92K9dSAShb0VWq1brCzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLirw+Tlw1SifpsQC89YEg4h6lwJYiURs/KspykGAkiKmjqmjjzffx7SRct1MfKx2
	 3NXo9vLbsqFo+bBNqrWDGY96276zxwyLhLhO1/dxiMjMWAKbAOPhjjey8f7ExaZDzy
	 WvOZ57PturDcu89b5hZIhYuZ0zfdvq52Qxjz5auU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jari Ruusu <jariruusu@protonmail.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 70/82] x86/entry_32: Do not clobber user EFLAGS.ZF
Date: Mon, 21 Oct 2024 12:25:51 +0200
Message-ID: <20241021102249.986312819@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 2e2e5143d4868163d6756c8c6a4d28cbfa5245e5 upstream.

Opportunistic SYSEXIT executes VERW to clear CPU buffers after user EFLAGS
are restored. This can clobber user EFLAGS.ZF.

Move CLEAR_CPU_BUFFERS before the user EFLAGS are restored. This ensures
that the user EFLAGS.ZF is not clobbered.

Closes: https://lore.kernel.org/lkml/yVXwe8gvgmPADpRB6lXlicS2fcHoV5OHHxyuFbB_MEleRPD7-KhGe5VtORejtPe-KCkT8Uhcg5d7-IBw4Ojb4H7z5LQxoZylSmJ8KNL3A8o=@protonmail.com/
Fixes: a0e2dab44d22 ("x86/entry_32: Add VERW just before userspace transition")
Reported-by: Jari Ruusu <jariruusu@protonmail.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240925-fix-dosemu-vm86-v7-1-1de0daca2d42%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -902,6 +902,8 @@ SYM_FUNC_START(entry_SYSENTER_32)
 
 	/* Now ready to switch the cr3 */
 	SWITCH_TO_USER_CR3 scratch_reg=%eax
+	/* Clobbers ZF */
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Restore all flags except IF. (We restore IF separately because
@@ -912,7 +914,6 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
-	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.


