Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E47B155A4E;
	Tue, 29 Apr 2025 18:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950581; cv=none; b=AF0cwct0HRSKW41KPI0Q5cUa/CKf5WSRlOugvcBW4PsHOrR6+odJ1SxIi68E3ULoNAGqcfB4IsSV58rNClNP7sH2hpn/VRNBUEVm9RLmpJx52OOshBwwrMrKwd0uCIYgOAoR1N5j9Ltx7NifZRdi6k4hyvvxT98DjThfLR/VviQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950581; c=relaxed/simple;
	bh=RLqe2bTd0e+RNFBAQpWv4ldZOdJ3N+cDIeBJPAOyKv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iepQSynfE89FX3Gi+W6LhVPM4NfogUzxlsoKR8MpXLdT4gH/233CEVGOeiBR56qPD06CauCX/T0P8nPY3Wa2aDk82RY9CBlK594t0Z9A3zedjeWeUsqDPPoRIP9g6dmtE240tycslHjkCWr1g8wohWZHUI4rw/l507BJRNNjfSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tveZTdbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tveZTdbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F57AC4CEE3;
	Tue, 29 Apr 2025 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950581;
	bh=RLqe2bTd0e+RNFBAQpWv4ldZOdJ3N+cDIeBJPAOyKv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tveZTdbk+b4E9Hhol+MKJcoJNE/qVubn/iQJiiBTGcWvavhTOd7LfoLYVZF66lqfd
	 QkzqBYjyd7xvP5UQW+NO+VH7rJxq5PT7rwLpbX4pRPdeX+Ir2aSnI316SSP4TXsVxX
	 02eoOjR65eMVpilOO4TMmBo5le7Gu55xIzUywsL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/204] objtool: Silence more KCOV warnings
Date: Tue, 29 Apr 2025 18:43:49 +0200
Message-ID: <20250429161105.196866116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8ba5bcfd5cd57..ddf3da6eccd0d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3569,6 +3569,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			    !strncmp(func->name, "__pfx_", 6))
 				return 0;
 
+			if (file->ignore_unreachables)
+				return 0;
+
 			WARN("%s() falls through to next function %s()",
 			     func->name, insn_func(insn)->name);
 			return 1;
@@ -3788,6 +3791,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
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



