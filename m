Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC08D8063B;
	Mon,  8 Apr 2024 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585197; cv=none; b=J3KyA+o5CGWc1sR9cD9/3JbvhcH5+cM3BT4pBAUxFhD1b5PWo1EZ5VHNCLOmOIM1EMF9CYKbafQy9ygrLVuF07m3yw+RDcdCWq9gtOw5eRCAEq0CU1c2daQEutkZlFomOC0PlaVqv4mVwxbfhtb/jWOZxcE6u5AWWuSthzoQBDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585197; c=relaxed/simple;
	bh=ehOo5fyseOkjfBrngTTAHZyPAb2YHtYVhoPgMrpPL3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TY7g+qX9cN1w4JiLFjb9iqr9Bcp99ry5HuiVsrbEbjTuydmGfaigA+pmZKhQuo10w+XHoyqxPBO62+ZQtBS+XnwheAhsmPzCoqLMNlEMLMwJJny4u5FG9VyYbptlHc7cE4AiH7KyKG68ecDokUT7nl61HD9Qogl3dRTbXvLm0j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEoQirCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEoQirCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33171C433C7;
	Mon,  8 Apr 2024 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585197;
	bh=ehOo5fyseOkjfBrngTTAHZyPAb2YHtYVhoPgMrpPL3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEoQirCViY5kpvWIG4BqKNCItBAycMX7YbuVJ5koemrfdgn9HBeEn9jUQtsZ4kK41
	 fTOZiXD2w0toIuo6L1K41etKT+9rUtYncn1pfdAEtk30jUUFzRzJO+wJ6HXTRnWR9l
	 g0RM0c4R2lEOvAXDvzz7jJaw2L2h+rMdc9JQwR2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 686/690] x86/retpoline: Do the necessary fixup to the Zen3/4 srso return thunk for !SRSO
Date: Mon,  8 Apr 2024 14:59:12 +0200
Message-ID: <20240408125424.583300187@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit 0e110732473e14d6520e49d75d2c88ef7d46fe67 upstream.

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
 arch/x86/lib/retpoline.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -108,6 +108,7 @@ SYM_START(srso_alias_untrain_ret, SYM_L_
 	ret
 	int3
 SYM_FUNC_END(srso_alias_untrain_ret)
+__EXPORT_THUNK(srso_alias_untrain_ret)
 #endif
 
 SYM_START(srso_alias_safe_ret, SYM_L_GLOBAL, SYM_A_NONE)


