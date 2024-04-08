Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D003B7BAF4;
	Mon,  8 Apr 2024 13:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582678; cv=none; b=L6y3hZk/5w3LfJAJ7/uzvt7VS+AwfJ5+xqAv3dQgSQEqARkrcgwnj2N+8JDiFmGxQdl6UhuTHFLtsEP2FoGhRRCtbtrCCrXUmVPdsF/2MJ+tjME3ozoTbJ73egfjyAFtw6jiSJdWgLZr56cE4UmlCLGMdSRDMGQC1tByffGCr5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582678; c=relaxed/simple;
	bh=ddrxBgtjb2ub+SZuiQPZcvRSfEvXdKBYcRQtUZtByFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDE6eDEnsndpSkp7UXpZEgjeqCaB4u4Ck2+vG14BTsb2/wF4Ku52KgWUKfv94B7hHwxVOkkWv2KfWhgGz71qwdRpquok+HzwbGlkC6q1qpPd5nyGfGR9vXwejGYn5ajY1SFRZe7b9zH+kXWPfO+ZvVKTmEeNauQqMPgL8e4E9go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Dd4OpUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Dd4OpUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F59DC433C7;
	Mon,  8 Apr 2024 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582678;
	bh=ddrxBgtjb2ub+SZuiQPZcvRSfEvXdKBYcRQtUZtByFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Dd4OpUXsLDGW1ZpCWaSK+0p2CzpwpVDM8TYmojW+sOcKvByb8NIc6uCz0u/jXjOp
	 hKrozBK6LBtIxUdXa6tprBLZVK18i6wgJ2PpFZgR8a8MezS4U1EmrJGEQS26iosZkc
	 Ru7xy3ZXCcHs7Y3Tq6ybGxyV9S+DGZpYVGAYUugE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.8 095/273] x86/retpoline: Do the necessary fixup to the Zen3/4 srso return thunk for !SRSO
Date: Mon,  8 Apr 2024 14:56:10 +0200
Message-ID: <20240408125312.249831350@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 0e110732473e14d6520e49d75d2c88ef7d46fe67 upstream.

The srso_alias_untrain_ret() dummy thunk in the !CONFIG_MITIGATION_SRSO
case is there only for the altenative in CALL_UNTRAIN_RET to have
a symbol to resolve.

However, testing with kernels which don't have CONFIG_MITIGATION_SRSO
enabled, leads to the warning in patch_return() to fire:

  missing return thunk: srso_alias_untrain_ret+0x0/0x10-0x0: eb 0e 66 66 2e
  WARNING: CPU: 0 PID: 0 at arch/x86/kernel/alternative.c:826 apply_returns (arch/x86/kernel/alternative.c:826

Put in a plain "ret" there so that gcc doesn't put a return thunk in
in its place which special and gets checked.

In addition:

  ERROR: modpost: "srso_alias_untrain_ret" [arch/x86/kvm/kvm-amd.ko] undefined!
  make[2]: *** [scripts/Makefile.modpost:145: Module.symvers] Chyba 1
  make[1]: *** [/usr/src/linux-6.8.3/Makefile:1873: modpost] Chyba 2
  make: *** [Makefile:240: __sub-make] Chyba 2

since !SRSO builds would use the dummy return thunk as reported by
petr.pisar@atlas.cz, https://bugzilla.kernel.org/show_bug.cgi?id=218679.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202404020901.da75a60f-oliver.sang@intel.com
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/all/202404020901.da75a60f-oliver.sang@intel.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -229,8 +229,11 @@ SYM_CODE_END(srso_return_thunk)
 #define JMP_SRSO_UNTRAIN_RET "ud2"
 /* Dummy for the alternative in CALL_UNTRAIN_RET. */
 SYM_CODE_START(srso_alias_untrain_ret)
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_FUNC_END(srso_alias_untrain_ret)
+__EXPORT_THUNK(srso_alias_untrain_ret)
 #endif /* CONFIG_CPU_SRSO */
 
 #ifdef CONFIG_CPU_UNRET_ENTRY


