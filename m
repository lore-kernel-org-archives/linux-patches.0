Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA676140E3C;
	Thu, 11 Apr 2024 10:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832127; cv=none; b=jcHxODtTIWMfPAOIZ9zaSgdKm4HTJPcZvTS9dcZrM3P094tR23ALpG6bDc63MovwuVOyEKmTst58eewjEMul4FNRiHQJUbakVAEB6Ojh0krtzwmlcLQvyFOoXeWbW3V8sUms+DRV5vMLs6z99sg0kvFE7F9qcoJ1fHHHWQ9Ndj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832127; c=relaxed/simple;
	bh=bpAzt+3Z1Wbz7ND/OlGZnHtpd46B3VX7hgi8auhzVQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZgTiO/+Vjy568pP09FzZa3NyXQsmBotsJpj/xQfl0ZqVMGzhA9wt9em2tZetiBL2uAFZ+M48VIOGHUij/kqBjZBELgkec3lZSeMQDmuFfGo812lSI7XSgVhph7c7vgmKiLG7LSCDi1tRV3QVGz3l93W8eIQ55oErVHpPLOeCtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sk8GIxzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sk8GIxzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3428EC433C7;
	Thu, 11 Apr 2024 10:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832127;
	bh=bpAzt+3Z1Wbz7ND/OlGZnHtpd46B3VX7hgi8auhzVQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sk8GIxzlGn6zTyk+uyRQ3NP2a7LdbxbA0SJv92RXYd88FiXdwb2XMyu5vyoj248H7
	 WxZHyIPAdFCqb3dbeJN1Z5vP1e2f7aGOEOToUYIcSlG8gFjhzJDTGh0HgymhLoDLhc
	 YwY/HXfKhU4jsvzQaXp85uhYsnpdGpptOo9WDwmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 239/294] x86/retpoline: Do the necessary fixup to the Zen3/4 srso return thunk for !SRSO
Date: Thu, 11 Apr 2024 11:56:42 +0200
Message-ID: <20240411095442.770858885@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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


