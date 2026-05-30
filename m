Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80B6137750;
	Sat, 30 May 2026 18:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166959; cv=none; b=i1Wp3cgzLIKD5YJdKH0NTiApx3cQrjXFepBF/4/VRFr7/7jZwFvHu78OdYv5GtiDYenPKlQgLJW4k4FwDvW+PXJyMXe2QR0PHG8wXYbZd732vSeqMlLfxEGAfEd9LTeKmjOuLcEVlTOYtIB46d30ZT0cjDpRiWzcSVh2kSf6zVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166959; c=relaxed/simple;
	bh=4ue3Ps0yYZyU54Yo+DWnK8dtl9KX6ek8zNJ6zarx91o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnlp8cECirkaCtQM9o/k37k1oGcQE/qps/Rz1f5AvX4Qp7t83anWp8zwIJqkibTArKyTNlUqGJ4+uu/mSo8oHRPw3BfRPoVD4CunKdxLsjLTG5M7mp7+2Fh+gwf7TMIh9kAm3hfpMKW+QxYQoUv7bJoIJIC5XdcB9esuHpYjUbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uExjAF7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uExjAF7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5EE1F00893;
	Sat, 30 May 2026 18:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166958;
	bh=6Bkj2uxZcalIMTn3uK40v8JGCpbm3fHiQdoZSjmsgKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uExjAF7GKYkdHsDo92NoXzRWqwP4t1x22FimH4W73WNgOuqiHjVKOug1YeJSZsOkp
	 djteYwOoHuQXi1StSX6QrID6t/A/cCehgfhW/nbQf0tN+V+86k4R8GCiN1TmpZ4JXr
	 rdMLzKF3as22sVMcmh5LAP+jkF/Z15zQmQXXPYOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 523/589] Revert "x86/vdso: Fix output operand size of RDPID"
Date: Sat, 30 May 2026 18:06:44 +0200
Message-ID: <20260530160238.358917120@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit f097ba74116fce394160c919bb2039b60fc64159.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/segment.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 8686f5cfbc6b7..72044026eb3c2 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -242,7 +242,7 @@ static inline unsigned long vdso_encode_cpunode(int cpu, unsigned long node)
 
 static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 {
-	unsigned long p;
+	unsigned int p;
 
 	/*
 	 * Load CPU and node number from the GDT.  LSL is faster than RDTSCP
@@ -252,10 +252,10 @@ static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
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



