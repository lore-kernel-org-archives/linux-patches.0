Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4261C2522A8;
	Tue, 20 May 2025 14:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750297; cv=none; b=YpbiTyTQQaER9gI7ncU5xw2bKAgbsmAW+82DbE+CIOS8Tt5w2LKs0Esrzw/BAewLEjdrFCre+uLs/XjXKPek4gpc215xv6UFYdTuKt7LMOv3xCwng8cti0PJmXlcW+abbez5/KjOStWKUUgY0UvBpjA7ci2a0b2C7uv9sDimYSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750297; c=relaxed/simple;
	bh=yh/KUYDh3msUwcpD4zSzQahU4FCJtnWG8QYcg/Qfssw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9YU2jms12pVa4MZnrsTgkBdShiP91CtBNV+r391BssZEKYcSoAy7mT8d34+DlFqXLfyZFDoBVWuaC2jTGwW8sKEq81NYedIiP7jMbNRQX4M3MxjjRSX51P1ZH40mZVEYK+pC3KosyLKe/LUpaUu2hU4gyQS5eBuBfVIKmktaiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vanFL54A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vanFL54A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF746C4CEE9;
	Tue, 20 May 2025 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750297;
	bh=yh/KUYDh3msUwcpD4zSzQahU4FCJtnWG8QYcg/Qfssw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vanFL54AsjgpagemeAFubmBBnghRxMd9WBLeRAM7cJj1C+PAHws3wm7c5BipUw3K0
	 z/X2gto4eQ8hePZO6p1inGnzsQGKHCxbKS66AwOlgIPB4rTPtCTXk6+DBGGuT6O6XP
	 984J9Z0LJ9wotEPlWERvmIWW7CbWIBN5W3EWvYbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 076/143] LoongArch: Fix MAX_REG_OFFSET calculation
Date: Tue, 20 May 2025 15:50:31 +0200
Message-ID: <20250520125813.056337045@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 90436d234230e9a950ccd87831108b688b27a234 upstream.

Fix MAX_REG_OFFSET calculation, make it point to the last register
in 'struct pt_regs' and not to the marker itself, which could allow
regs_get_register() to return an invalid offset.

Cc: stable@vger.kernel.org
Fixes: 803b0fc5c3f2baa6e5 ("LoongArch: Add process management")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/ptrace.h
+++ b/arch/loongarch/include/asm/ptrace.h
@@ -55,7 +55,7 @@ static inline void instruction_pointer_s
 
 /* Query offset/name of register from its name/offset */
 extern int regs_query_register_offset(const char *name);
-#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last))
+#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last) - sizeof(unsigned long))
 
 /**
  * regs_get_register() - get register value from its offset


