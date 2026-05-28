Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60947339866;
	Thu, 28 May 2026 20:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001107; cv=none; b=Df0p0vq5ojwNJeDkNeC1sCjT950esfvnJ07cKjshkWiq2QcRlXNYNdGhtNf3ibCV7xvlymxRQtrObD2kaOraUvzfUnjOwKRU321XOjHoKrqF8X5v1/0enlijtVVlLE2ZLN6I/jC5IzSxvJVVbabkRtZWn4KtWBRXkB1Nu05X1iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001107; c=relaxed/simple;
	bh=GzgNc3/5GjQieq6FvjyA2yp4SExwVl8wdeHxQYttQ44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFI36kxuM7O8FzthYh0WmYq71OOkwukPkPzuff0BXisWcsmBBwy4vdMdOGD0SvRA3d4COWGb9Hugqw7APsAA9QCTxDehx/9a/IUoUN29NwXaz+N9F2BwR7FnS2oZsRqvmTvYq/RAFQnPEz4QrHyGmVWfjP4l/KK6I2q7bjWExK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPTbE/ww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPTbE/ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5C31F000E9;
	Thu, 28 May 2026 20:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001106;
	bh=vqd+YmrQsVYdFvDuaQTvRQWK42jXukxkTHdLzHou9Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPTbE/wwcp2cloRc+uJGbQf3rlL3Sa/Aoeqmew4IxV5i/NEpOfrzneWF8pWO4kbIX
	 FGbEzSsS90zQ14miiedidIYSB1yEARlYsjKCGkjRZeGBFVhvNhVUqDqdIQIjVWp18E
	 GWKSYkO5KBUckBuYPP4gejmVcyZ8qx2m67U50qd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/186] Revert "x86/vdso: Fix output operand size of RDPID"
Date: Thu, 28 May 2026 21:48:10 +0200
Message-ID: <20260528194929.230321439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit db82a94b0c109e7697a593f36783e7ef36073983.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/segment.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 00cefbb59fa98..9d6411c659205 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -244,7 +244,7 @@ static inline unsigned long vdso_encode_cpunode(int cpu, unsigned long node)
 
 static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 {
-	unsigned long p;
+	unsigned int p;
 
 	/*
 	 * Load CPU and node number from the GDT.  LSL is faster than RDTSCP
@@ -254,10 +254,10 @@ static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 	 *
 	 * If RDPID is available, use it.
 	 */
-	alternative_io ("lsl %[seg],%k[p]",
-			"rdpid %[p]",
+	alternative_io ("lsl %[seg],%[p]",
+			".byte 0xf3,0x0f,0xc7,0xf8", /* RDPID %eax/rax */
 			X86_FEATURE_RDPID,
-			[p] "=r" (p), [seg] "r" (__CPUNODE_SEG));
+			[p] "=a" (p), [seg] "r" (__CPUNODE_SEG));
 
 	if (cpu)
 		*cpu = (p & VDSO_CPUNODE_MASK);
-- 
2.53.0



