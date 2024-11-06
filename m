Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56FB1CC14B;
	Wed,  6 Nov 2024 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899012; cv=none; b=CYoVJXT5x9mZsrDPBkb6s8RXGJHmCocZWVe1hXlLpOQhnc+edAiPNmEHvVb9y7dbI+6KDTLKyXH7ps3etUZkGZcVRbweTOgqTZj7QFfc0nr0x7Dx5PgDBsctTW5+PoETOYWy65RARUM2/mtOJipbwmT8tpRG4T8O7WWmpeJ2A/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899012; c=relaxed/simple;
	bh=BzflyP79Tc/YLtHYwKh+G8aqTZrf+TVMn5zNtksPnu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt4zFwLVaknP/JwYtHHuONCGk7ETMkPAx3pLwiHzFCetnFrcMOTBNvL44d7myVdmmZ6qPHHG8DjAcd9q9drXME1dJ0hqqwj1BK7QkfHCMMWd1YHuCNe2+gxXUGc/V5iRclqwiUc2ydLohoskIP7DS7YfAuXby0UHdrtuUGrEYR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFSYV7wZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFSYV7wZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71900C4CECD;
	Wed,  6 Nov 2024 13:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899011;
	bh=BzflyP79Tc/YLtHYwKh+G8aqTZrf+TVMn5zNtksPnu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFSYV7wZx6+G54QMX6RHR/4T8EtHreEpoeDABH08wStHa0jFBX28uV4btOyKSCpva
	 dClnszdpPRA3oVjFFYEgShry9KrNd8cHNdF5Ai4JBvGoGWYdZ+aducPCtve0zBXgdC
	 A8sW3RWy5IDP0oh7Tlip7P5JqXV5BQ+KyjOIWSQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	junhua huang <huang.junhua@zte.com.cn>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 424/462] arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning
Date: Wed,  6 Nov 2024 13:05:17 +0100
Message-ID: <20241106120341.986101483@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


