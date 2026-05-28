Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE42F340293;
	Thu, 28 May 2026 20:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000455; cv=none; b=EqNKuXGZ5chRHPNKLMMpPJnAjna+qRIZdOEDmTA/lmJYSeiEhxBd5byIltYqbrCAJoBFJzlgE6lgJSlB05cH8yWsqL8unPEMHOSDGXmEfznlPX+GyN/d3XZQPPJSgoC07vlHl3lVpFt8Ke2R+k/0CI5IImPecsXLKHVdSz4P+y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000455; c=relaxed/simple;
	bh=Rip0i5o9z88mbvKyIn8eva2ayE3EMj7f3naJ04WTm20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zku1UddBwGN4fTzjW5tUBKEOZcjSS89qJae0ofZ1JeJK2USceaOVOc3GjIBLJfYMDyXm/9Jqd7Ti321idQzJrc9988KGcs0CV4x69jlwp9VdZrmlxJrafOSH3fIuJfDK/ZjRGiSx3rt8arYf7nED2VLOCSTjr0knQsPxPCy5WsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dzosm+Ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dzosm+Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23E31F000E9;
	Thu, 28 May 2026 20:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000454;
	bh=Cc7eBaJU18Bzk3/EmhlbwXs1vGZQDxnhid/9nuqJls4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dzosm+Ffpl4UbBfRy8TZ6AMaDZ3dGBPNME/eXMb/fisgqEv6cjQiTHkMdQrvsouwe
	 SEF6FsYFmwpGGr/hh9+DQfkJAYFaVBqVoEiE2GDpoHqFZaiGhZ3dea2wqqds9RaMSy
	 qAyPZNoGYZ86CgsdiOcxVtq2aI/ATPB5VYPYDGG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/272] Revert "x86/vdso: Fix output operand size of RDPID"
Date: Thu, 28 May 2026 21:46:28 +0200
Message-ID: <20260528194629.782808232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit d607e6b349b014df1d2d0399f6667322626450e0.

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



