Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B751624D5;
	Tue, 31 Mar 2026 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974731; cv=none; b=gwLhmzXCffNW62gy3/bqVdzLqg6eZy2Ak+QrniHHVVGA4d5y6kvojtd1sIcVY+JaWeSK0w8Sg/tqYL0j+P4vtpLgps1AxtmDPgIWbdcG6s7FUrryI/Vz/Z0uM2gt45+XGFhOm4CHRK+hOqtq5DHYYMSwASQ1/pT4PJ5IsVjM5xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974731; c=relaxed/simple;
	bh=4vocyztRguFNS1tugmB7H6E49uTjNu/DR6tEKCna7PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmF7gWtQhm20kgbrR5b6+rL61hSO7VUUUgvAL1+9auTWdPy5ug+0nz9nsHMpHYrPzIeXS2QdsDs2ByUZ2RJM4D6YMnmTAgZeHwIrhNXr8l7gWespVHskJixPsp/ZqUuJcmvGHW/oh0lCPHq66JNgALvS8jq0ljct+ANpnH42QC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya1jkepq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya1jkepq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD53C19423;
	Tue, 31 Mar 2026 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974731;
	bh=4vocyztRguFNS1tugmB7H6E49uTjNu/DR6tEKCna7PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya1jkepqyRPQKKxHTh1ABqvdfq+3j3xveKLjiCOL1yUYt9LR7pOTtDzZ8GqVRrh84
	 7gT15gX0r/97PJ4QVWneoqbFpN3G7JuF9JmQIgMVKuty6VW3npO/5dt7d6M9O+Y9v2
	 /Ru2c7Dbsd9RE26CemxMW/hPqx61BrjgQQTfny7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 008/342] objtool/klp: fix data alignment in __clone_symbol()
Date: Tue, 31 Mar 2026 18:17:21 +0200
Message-ID: <20260331161759.219617896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit 2f2600decb3004938762a3f2d0eba3ea9e01045b ]

Commit 356e4b2f5b80 ("objtool: Fix data alignment in elf_add_data()")
corrected the alignment of data within a section (honoring the section's
sh_addralign).  Apply the same alignment when klp-diff mode clones a
symbol, adjusting the new symbol's offset for the output section's
sh_addralign.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://patch.msgid.link/20260310203751.1479229-2-joe.lawrence@redhat.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index d94632e809558..b1847828217ba 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -14,6 +14,7 @@
 #include <objtool/util.h>
 #include <arch/special.h>
 
+#include <linux/align.h>
 #include <linux/objtool_types.h>
 #include <linux/livepatch_external.h>
 #include <linux/stringify.h>
@@ -560,7 +561,7 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 		}
 
 		if (!is_sec_sym(patched_sym))
-			offset = sec_size(out_sec);
+			offset = ALIGN(sec_size(out_sec), out_sec->sh.sh_addralign);
 
 		if (patched_sym->len || is_sec_sym(patched_sym)) {
 			void *data = NULL;
-- 
2.51.0



