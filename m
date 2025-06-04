Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E30151C5A;
	Wed,  4 Jun 2025 11:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749037771; cv=none; b=W5C6hCwgyps8d4KNKmGq64neDdzTL5SLhT1XaY2JoY+IUGM2xZBCx3zpnAstFTHYi7Cbflm+PVnFS8BGAMOWyenM0MzTESnl4TAe4s5h8Fc9jfGpEAYltfmCP9fCcqrsXIeOcb23Oik0417chX8vE2+oMvLBd5TSzRXlI07Az4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749037771; c=relaxed/simple;
	bh=fb4lRrc5lL2UWvGPozqwLNQGjc6zQAOjqCRgSjVn+bE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bSGnwVirwya1zvFmrvjjh1c7QJcy3V4l20A4eJt1i6W+19813BfDZYqXOLfWhSjbpx29dOM37nBqfBSC884bW3piTvJgCtHAoltFJ/Y5p+lepXaa+/1rQwwDtqjkO//YA3qN8VWXDxi2duPJIuF6op26c7XTMBzV/gHnTEamDvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQXa/58F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQXa/58F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255D1C4CEE7;
	Wed,  4 Jun 2025 11:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749037771;
	bh=fb4lRrc5lL2UWvGPozqwLNQGjc6zQAOjqCRgSjVn+bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQXa/58FYN8DcRXvajo324X+NZV2qs+xb5qYBG4+LuM4KRMRQwv1mTYJfijnLFs3e
	 oOHq7qcbHxjLjGzwblY8TCZY0VDBRuKEf9a8vZBMIpMLkk5HFdGIRynJ1D5IZcSt28
	 Fd+Y3z+/fLOmy/yrpg27zd3zlDZ+SvytmdMAhlPmLpJxiOSduPvHeakzpG8TRPsFtY
	 iMmJmA8hWlYTKzRCrmIXFDdbsEHyVTYQorUYIVxxiXEFnMnNuWRCtLyM42g71FUqqU
	 JvE2PZN2wa4LWdbSSljNStt+rHakrPG1AEi8WrMboWxwMLKzpCGIu+2ryf42Z8n1sG
	 FAATnRFis3AdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	johannes.berg@intel.com,
	miriam.rachel.korenblit@intel.com,
	emmanuel.grumbach@intel.com,
	yedidya.ben.shimol@intel.com,
	shaul.triebitz@intel.com,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.15 2/9] wifi: iwlwifi: mld: Work around Clang loop unrolling bug
Date: Wed,  4 Jun 2025 07:49:15 -0400
Message-Id: <20250604114923.208380-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604114923.208380-1-sashal@kernel.org>
References: <20250604114923.208380-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit 368556dd234dc4a506a35a0c99c0eee2ab475c77 ]

The nested loop in iwl_mld_send_proto_offload() confuses Clang into
thinking there could be a final loop iteration past the end of the
"nsc" array (which is only 4 entries). The FORTIFY checking in memcmp()
(via ipv6_addr_cmp()) notices this (due to the available bytes in the
out-of-bounds position of &nsc[4] being 0), and errors out, failing
the build. For some reason (likely due to architectural loop unrolling
configurations), this is only exposed on ARM builds currently. Due to
Clang's lack of inline tracking[1], the warning is not very helpful:

include/linux/fortify-string.h:719:4: error: call to '__read_overflow' declared with 'error' attribute: detected read beyond size of object (1st parameter)
  719 |                         __read_overflow();
      |                         ^
1 error generated.

But this was tracked down to iwl_mld_send_proto_offload()'s
ipv6_addr_cmp() call.

An upstream Clang bug has been filed[2] to track this. For now fix the
build by explicitly bounding the inner loop by "n_nsc", which is what
"c" is already limited to.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2076
Link: https://github.com/llvm/llvm-project/pull/73552 [1]
Link: https://github.com/llvm/llvm-project/issues/136603 [2]
Link: https://lore.kernel.org/r/20250421204153.work.935-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now let me analyze the similar commits to understand the backporting
patterns: **YES** This commit should be backported to stable kernel
trees. ## Extensive Analysis ### Code Change Analysis The commit
modifies a single line in `drivers/net/wireless/intel/iwlwifi/mld/d3.c`,
changing: ```c for (j = 0; j < c; j++) ``` to: ```c for (j = 0; j <
n_nsc && j < c; j++) ``` This change adds an explicit upper bound
(`n_nsc`) to prevent the loop iterator `j` from exceeding the size of
the `nsc` array (which has 4 entries). ### Why This Should Be Backported
**1. Build Failure Fix**: This commit fixes a concrete build failure
when using Clang compiler with ARM architecture and
`CONFIG_FORTIFY_SOURCE=y`. Build failures are critical issues that
prevent kernel compilation entirely. **2. Compiler Support**: The fix
enables Clang compilation support for the iwlwifi driver, which is
important for kernel diversity and CI/build systems that use Clang. **3.
Minimal Risk**: The change is extremely small and contained: - Only adds
an additional bounds check (`j < n_nsc`) - No functional logic changes -
The added check is logically correct and safe - Cannot introduce
regressions as it only makes the loop more restrictive **4. Pattern
Matches "YES" Commits**: This fix aligns closely with similar commits
marked as "YES": - **Similar Commit #2** (wil6210 fortify warnings):
Fixed FORTIFY warnings with struct_group, minimal risk - **Similar
Commit #3** (mlxsw LLVM workaround): Explicitly worked around LLVM/Clang
compiler issues - **Similar Commit #4** (ath9k fortify warnings): Fixed
fortify warnings with struct_group - **Similar Commit #5** (plfxlc clang
fortify): Fixed clang-specific fortify warning **5. Architecture-
Specific but Affects Real Users**: While currently only exposed on ARM
builds with Clang, this affects legitimate build configurations used in
production environments. **6. No Side Effects**: The fix purely
constrains loop bounds without changing algorithmic behavior. The
original code was functionally correct but triggered false positive
compiler analysis. ### Technical Justification **Bug Analysis**: Clang's
loop unrolling optimization incorrectly analyzes that the variable `c`
could reach 4, making the inner loop potentially access `nsc[4]` (out of
bounds). The kernel's FORTIFY_SOURCE checking detects this theoretical
overflow and fails the build. **Fix Correctness**: The added bound `j <
n_nsc` is mathematically correct since: - `n_nsc` represents the actual
size of the `nsc` array (4 entries) - `c` is already bounded by `n_nsc`
in the outer loop condition - Adding `j < n_nsc` makes this constraint
explicit to the compiler **No Functional Impact**: Since `c` never
exceeds `n_nsc` in correct execution, the additional check `j < n_nsc`
never actually triggers - it exists purely to satisfy the compiler's
static analysis. ### Comparison to "NO" Reference Unlike **Similar
Commit #1** (iwlwifi fall-through warnings) which was marked "NO"
because it only addressed code style/warning improvements without fixing
actual bugs, this commit fixes a real build failure that prevents
compilation. ### Conclusion This is a textbook example of a good stable
backport candidate: it fixes a concrete build issue with minimal risk,
follows established patterns for compiler workarounds, and has zero
functional impact on runtime behavior. The fix enables continued Clang
compiler support for a critical wireless driver without introducing any
regression risk.

 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index ee99298eebf59..7ce01ad3608e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1757,7 +1757,7 @@ iwl_mld_send_proto_offload(struct iwl_mld *mld,
 
 		addrconf_addr_solict_mult(&wowlan_data->target_ipv6_addrs[i],
 					  &solicited_addr);
-		for (j = 0; j < c; j++)
+		for (j = 0; j < n_nsc && j < c; j++)
 			if (ipv6_addr_cmp(&nsc[j].dest_ipv6_addr,
 					  &solicited_addr) == 0)
 				break;
-- 
2.39.5

