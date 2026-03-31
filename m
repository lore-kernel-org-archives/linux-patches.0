Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDD62D77F5;
	Tue, 31 Mar 2026 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976456; cv=none; b=KmgCrwUd9tqepC6wg1nNw+yoMdXHZJKOkBw7uEzUUpePU3HrCuygZlszj4vP9k0fzuzJ5Af+IqOnS8H6ONCXwczZN8So1S61cBzqdpVmaQLznAIbrLzQCNUZGKoQDfctqDEFNfoawd6jxpeG2ndyxiTbdU6phlW/7hJyqSgiPSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976456; c=relaxed/simple;
	bh=fBVCxeuY4TF3ISvtkVsEOBc1pouyzjHiuNOMDQ5LEXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEYzMZ2l6gLupw0tF7uft38Xgwo4SeAUNzPtoThgaE9UnwAd6sfbanFhBYNu+zveVIIcLpOExX0j/8cCq7uJXx+3KBKSDXoriW8kAlQ3gQB8kSI0/gy5Z8MBhWQXXsnqd8K2yhdAeaKdq2Q/dkvF55jjYvJnKf0Sjh0cW/Ff4a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfAN3FGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfAN3FGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BF5C19423;
	Tue, 31 Mar 2026 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976456;
	bh=fBVCxeuY4TF3ISvtkVsEOBc1pouyzjHiuNOMDQ5LEXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfAN3FGBgyYZQzsaozncJoWwFDPna84VJi9meDHG73sCeh5fCjcf707epKiNEL3aR
	 4/X5X01Os6B0pnTX09VjQQCeSem5SBCBowI4U9jGgO2TxJayaRHZk3HWTUI9T9IVgB
	 7mNckaWRnDJ5KVjPh+H7mxs5JgNY+hMKT3ilEo2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/309] powerpc64/ftrace: fix OOL stub count with clang
Date: Tue, 31 Mar 2026 18:19:20 +0200
Message-ID: <20260331161755.586101823@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit 875612a7745013a43c67493cb0583ee3f7476344 ]

The total number of out-of-line (OOL) stubs required for function
tracing is determined using the following command:

    $(OBJDUMP) -r -j __patchable_function_entries vmlinux.o

While this works correctly with GNU objdump, llvm-objdump does not
list the expected relocation records for this section. Fix this by
using the -d option and counting R_PPC64_ADDR64 relocation entries.
This works as desired with both objdump and llvm-objdump.

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260127084926.34497-3-hbathini@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/tools/ftrace-gen-ool-stubs.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/tools/ftrace-gen-ool-stubs.sh b/arch/powerpc/tools/ftrace-gen-ool-stubs.sh
index bac186bdf64a7..9218d43aeb548 100755
--- a/arch/powerpc/tools/ftrace-gen-ool-stubs.sh
+++ b/arch/powerpc/tools/ftrace-gen-ool-stubs.sh
@@ -15,9 +15,9 @@ if [ -z "$is_64bit" ]; then
 	RELOCATION=R_PPC_ADDR32
 fi
 
-num_ool_stubs_total=$($objdump -r -j __patchable_function_entries "$vmlinux_o" |
+num_ool_stubs_total=$($objdump -r -j __patchable_function_entries -d "$vmlinux_o" |
 		      grep -c "$RELOCATION")
-num_ool_stubs_inittext=$($objdump -r -j __patchable_function_entries "$vmlinux_o" |
+num_ool_stubs_inittext=$($objdump -r -j __patchable_function_entries -d "$vmlinux_o" |
 			 grep -e ".init.text" -e ".text.startup" | grep -c "$RELOCATION")
 num_ool_stubs_text=$((num_ool_stubs_total - num_ool_stubs_inittext))
 
-- 
2.51.0



