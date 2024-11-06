Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90351FBF65;
	Wed,  6 Nov 2024 12:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896736; cv=none; b=PMEundaS1YCoVmB/8/vu1BuDfHiPzIISyB0yq0jh8A4WUYMjemTT0gIWIImKdh8LsGW/c87xB9HbTu+YKydKWQ4M8M2I1hUA20TXJHRCPIYu7TnxHRwykN+W8ljnVgmcZt82erBfXDXy+J1GfSaaAUHK7BxkRmnLWVQqVI7F594=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896736; c=relaxed/simple;
	bh=VR59fxSQRyeuAahpLsHaBV+yYCiQCvaTT3+4/4ldOwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKJVusjiDJjcYveBWfj49IXci5GSKc2df4+6UAxAcoXDC2/Eje5SmD4LGS9ip1tk0fsDaIdtlYjzrKUpV0PQc/pFzfX+9EVXYId/pZqWYdku7EwbaiTTJQkQLfwJ3rUjo0/GbyG0MYaVSUsHHF4pj+Nsf3SlOSLGeysuz4vQDUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=paWlm81f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="paWlm81f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DF4C4CED4;
	Wed,  6 Nov 2024 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896736;
	bh=VR59fxSQRyeuAahpLsHaBV+yYCiQCvaTT3+4/4ldOwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paWlm81fFCpxJ13QH/bqaIMgL113W7PkaNwx+hIJyGves+Zqcq0CrxH7w/LQua3zF
	 11Qqhw9X/C81uQsTDGM7Ot8gER0aXZxCmdbx7DjP7tcxegaup4z59H8ig7iF3StqTd
	 pJyJoY8TmU7V039e+VY7XlV5gFgl0quVR/4aJmDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	junhua huang <huang.junhua@zte.com.cn>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 055/110] arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning
Date: Wed,  6 Nov 2024 13:04:21 +0100
Message-ID: <20241106120304.721158082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

From: junhua huang <huang.junhua@zte.com.cn>

commit ef08c0fadd8a17ebe429b85e23952dac3263ad34 upstream.

After we fixed the uprobe inst endian in aarch_be, the sparse check report
the following warning info:

sparse warnings: (new ones prefixed by >>)
>> kernel/events/uprobes.c:223:25: sparse: sparse: restricted __le32 degrades to integer
>> kernel/events/uprobes.c:574:56: sparse: sparse: incorrect type in argument 4 (different base types)
@@     expected unsigned int [addressable] [usertype] opcode @@     got restricted __le32 [usertype] @@
   kernel/events/uprobes.c:574:56: sparse:     expected unsigned int [addressable] [usertype] opcode
   kernel/events/uprobes.c:574:56: sparse:     got restricted __le32 [usertype]
>> kernel/events/uprobes.c:1483:32: sparse: sparse: incorrect type in initializer (different base types)
@@     expected unsigned int [usertype] insn @@     got restricted __le32 [usertype] @@
   kernel/events/uprobes.c:1483:32: sparse:     expected unsigned int [usertype] insn
   kernel/events/uprobes.c:1483:32: sparse:     got restricted __le32 [usertype]

use the __le32 to u32 for uprobe_opcode_t, to keep the same.

Fixes: 60f07e22a73d ("arm64:uprobe fix the uprobe SWBP_INSN in big-endian")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: junhua huang <huang.junhua@zte.com.cn>
Link: https://lore.kernel.org/r/202212280954121197626@zte.com.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/uprobes.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/uprobes.h
+++ b/arch/arm64/include/asm/uprobes.h
@@ -14,7 +14,7 @@
 #define UPROBE_SWBP_INSN_SIZE	AARCH64_INSN_SIZE
 #define UPROBE_XOL_SLOT_BYTES	AARCH64_INSN_SIZE
 
-typedef u32 uprobe_opcode_t;
+typedef __le32 uprobe_opcode_t;
 
 struct arch_uprobe_task {
 };


