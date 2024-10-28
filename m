Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E2518DF8B;
	Mon, 28 Oct 2024 06:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096925; cv=none; b=Wwxo2ljyfDn7FH8kDEzfwXaMSYiDxPSYVGu6Z9jr1Towf65MfLcmrn4Qi2iaRcN/Mv+Ubas3noo+S8dt7pQvxcayyc9XuGDhPxH3kkBLTgGGwAYVXMwcMWeeSDBgCKvA5sLuE2F060JbekwFxzRSA1XCEpD452qv2ZrCRyD1GhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096925; c=relaxed/simple;
	bh=xPjvFj/iRByPz4WaHa/SEgZT8MYWiywK+F23bGjlG5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qk1l6U9o8rjnDxrKQ+19KxQ/Z4d092KPB//M+Fo67zFD+HY95ne/fJ8pXgHAe8zR6uw25SorrjHjkV3bgrvRUJGfQXdkhpHX0dQJOGew5YWxQWM28K6dIH6UoC5lEw+KuAJVhC/q9EiVdeIP9sM+37/TSqHZD3QGDuT1ftRevAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn/3HukP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn/3HukP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF16EC4CEC3;
	Mon, 28 Oct 2024 06:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096925;
	bh=xPjvFj/iRByPz4WaHa/SEgZT8MYWiywK+F23bGjlG5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn/3HukPE0sB6Bno8mGoVLq2f4lzZgp2cUO2nHbbAy2+WoxLmsGmRGr5uu8UPsOUU
	 mxmfAJ0/FsAwN9/vV8sUXmmMEpeE2u5CzWL/86hu/N8ScpIGCh0Z8GY5E6aonTR0go
	 XOedXB+kDfDkR36Vro6zfcZG3e1O6ap214f+iOkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	junhua huang <huang.junhua@zte.com.cn>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 47/80] arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning
Date: Mon, 28 Oct 2024 07:25:27 +0100
Message-ID: <20241028062253.926694718@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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


