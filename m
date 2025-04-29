Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091B8211A0B;
	Tue, 29 Apr 2025 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946391; cv=none; b=CCQ8oPr4yMDklgBmX8jlYGOnBkNsxmLLG8UixaQcf1St+xtbc07nxEwPG8QJl8+yyLinsfbEVljsL5kPD9Ork8h6FQOo/jufeIhQjduhG5XHkNaxMRsoEQcmsrLoW+Sl20grm8TF76dDZQw9dniEZoN1rX4+p/TE8l9GAfMV3FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946391; c=relaxed/simple;
	bh=9vD1Tshq2693gFqSUektjmnjqg8/4y6QZkWWp6u9r+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEOTCtDbm0zINyUTK85glxLKrlVgMG7+j9CU7m4tdwrDBAngvxt+20d/Bt/P65vuoWhd0M1M4wt9sjGqrHjx/mXIXl4mMkRk7sF2EVn7oyA/+QUoNIFyqSK3yrm6GyaG6XW48bbAiIZsVtooz3n15hYYodSD4BlDvgh3xmU6OTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWc/Q8lD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWc/Q8lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5AFC4CEE3;
	Tue, 29 Apr 2025 17:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946390;
	bh=9vD1Tshq2693gFqSUektjmnjqg8/4y6QZkWWp6u9r+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWc/Q8lDYD1VnZvcb0RUHPldP/Gcwog0qyfEWQi5+XXez2XDY75Q9UGkZL/0MKXAZ
	 uZfzcFQkQVYYegIazlJzQkDBoqo5N5zA8b+L62JamZTcsj5S5btVMJxdTQntWZJfbX
	 gTJwub5hcNm1TanCk8RxDgZjBOlFvVaQRva5wZb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 221/311] objtool: Silence more KCOV warnings
Date: Tue, 29 Apr 2025 18:40:58 +0200
Message-ID: <20250429161130.072034407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 6b023c7842048c4bbeede802f3cf36b96c7a8b25 ]

In the past there were issues with KCOV triggering unreachable
instruction warnings, which is why unreachable warnings are now disabled
with CONFIG_KCOV.

Now some new KCOV warnings are showing up with GCC 14:

  vmlinux.o: warning: objtool: cpuset_write_resmask() falls through to next function cpuset_update_active_cpus.cold()
  drivers/usb/core/driver.o: error: objtool: usb_deregister() falls through to next function usb_match_device()
  sound/soc/codecs/snd-soc-wcd934x.o: warning: objtool: .text.wcd934x_slim_irq_handler: unexpected end of section

All are caused by GCC KCOV not finishing an optimization, leaving behind
a never-taken conditional branch to a basic block which falls through to
the next function (or end of section).

At a high level this is similar to the unreachable warnings mentioned
above, in that KCOV isn't fully removing dead code.  Treat it the same
way by adding these to the list of warnings to ignore with CONFIG_KCOV.

Reported-by: Ingo Molnar <mingo@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/66a61a0b65d74e072d3dc02384e395edb2adc3c5.1742852846.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/Z9iTsI09AEBlxlHC@gmail.com
Closes: https://lore.kernel.org/oe-kbuild-all/202503180044.oH9gyPeg-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 7b535e119cafa..0ca83c74c1f38 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3490,6 +3490,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			    !strncmp(func->name, "__pfx_", 6))
 				return 0;
 
+			if (file->ignore_unreachables)
+				return 0;
+
 			WARN("%s() falls through to next function %s()",
 			     func->name, insn_func(insn)->name);
 			return 1;
@@ -3709,6 +3712,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 		if (!next_insn) {
 			if (state.cfi.cfa.base == CFI_UNDEFINED)
 				return 0;
+			if (file->ignore_unreachables)
+				return 0;
+
 			WARN("%s: unexpected end of section", sec->name);
 			return 1;
 		}
-- 
2.39.5



