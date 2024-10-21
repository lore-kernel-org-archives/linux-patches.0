Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0324A1E7C09;
	Mon, 21 Oct 2024 10:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507148; cv=none; b=iBQutdYsKstLNZoiE5lwxUfLTqsHMobwNhBKQu0IMvRoG2OtJbdlNomTDazDZy8QE8radX5Bnts0rv6S3hUXJLxhhe53uHTaoFx6Cij6Kq0jrpX3xidwMfabRlgE6XOOole8VhPRVW/814SOAYH6jxZWF9gREZ8ofQGiVDDG6yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507148; c=relaxed/simple;
	bh=0bxSPgdA6D32nK0+OlE37U0qVUDnLiR7OOreCcRNKeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5WlTFe3gNDTfLfx6DgZ8aZLhnFD5lJQn2hWjgQa6pyt6Oe/tUiDM97A+wPDsVjbVey6aZFilEB8e3TM/iBPfL/LOHmo7Djtng7rcaNSD6rN6KhbfjUnBxlV22lCOLcccHNqIPe3O+PnNWphBFd1ojD7bgTEqEEMB2U7bo/617c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piC/j7NK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piC/j7NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743A8C4CEC3;
	Mon, 21 Oct 2024 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507147;
	bh=0bxSPgdA6D32nK0+OlE37U0qVUDnLiR7OOreCcRNKeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piC/j7NK+jG6cxq0l6PJaYI0i2Ib46SXzdyVT68BwKEGB/pkeaqf7wIrp7TChczsb
	 caMWhW5fqbdeozQI+dN864yFOP7QGPd5AqZ/KuuFn9LdDJjPAvf8UPKh37YpiX7VAa
	 z3nMh8K+8afVCFX2JyfpCDw0TvkGCOvljdKMinyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jari Ruusu <jariruusu@protonmail.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.6 106/124] x86/entry_32: Do not clobber user EFLAGS.ZF
Date: Mon, 21 Oct 2024 12:25:10 +0200
Message-ID: <20241021102300.818134439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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
@@ -875,6 +875,8 @@ SYM_FUNC_START(entry_SYSENTER_32)
 
 	/* Now ready to switch the cr3 */
 	SWITCH_TO_USER_CR3 scratch_reg=%eax
+	/* Clobbers ZF */
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Restore all flags except IF. (We restore IF separately because
@@ -885,7 +887,6 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
-	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.


