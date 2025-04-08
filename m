Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62667270EAB;
	Tue,  8 Apr 2025 12:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116284; cv=none; b=MzNsmofe4UUa3xlfj8d2Lc8rWeEpc7dyBcgGisnTIY7NP3GZHFBKm4rFSbgfAV6N/I1RdY7SjG9NtC/e6qEpI387hWiaYlbJzL6vhzT3Z2h8JL5NOauTuf4Wkwx8f1X+E/qUSDdXQul3GdLXrkqUEgGGALRkt6yuKHCAHGNMSCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116284; c=relaxed/simple;
	bh=yvsLctFlwDpo7BCZXxl5a4i13TLw2S/KWD3qGCFzomk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8nXsPh80kDHIzyM+y1lUCq0J5v+El8Y6Cc2QeQCAYUdpOL558SvvN0oUCR27nnaD3u1VMnwKo8iimJqaPbfJ6zr7LTS2lcsgR1Eb6N/ZRix/WcFzh7kPhX+AmQIFse4whFez3jv/F2JR3sp18NKzfjoAywNPdPqb7fYbIeJMV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eglZXuxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eglZXuxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8924AC4CEE5;
	Tue,  8 Apr 2025 12:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116283;
	bh=yvsLctFlwDpo7BCZXxl5a4i13TLw2S/KWD3qGCFzomk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eglZXuxN+HH8Z9tU/lISk5TmlVP+KoOwQcBIKHJ8gtPqNKq3vUbqCh2bPakSsVdyO
	 R96BqdtK6E2AzDDDWiNJL2HOlAuBURoMWH6gpBzllxcCc6PQiYiDJiP+hcCxWGLWyy
	 rlWKglgx8JAeZ3tHCj6VaZVnhqPE+PwRHjORmKnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/423] powerpc/kexec: fix physical address calculation in clear_utlb_entry()
Date: Tue,  8 Apr 2025 12:46:48 +0200
Message-ID: <20250408104847.653308238@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 861efb8a48ee8b73ae4e8817509cd4e82fd52bc4 ]

In relocate_32.S, function clear_utlb_entry() goes into real mode. To
do so, it has to calculate the physical address based on the virtual
address. To get the virtual address it uses 'bl' which is problematic
(see commit c974809a26a1 ("powerpc/vdso: Avoid link stack corruption
in __get_datapage()")). In addition, the calculation is done on a
wrong address because 'bl' loads LR with the address of the following
instruction, not the address of the target. So when the target is not
the instruction following the 'bl' instruction, it may lead to
unexpected behaviour.

Fix it by re-writing the code so that is goes via another path which
is based 'bcl 20,31,.+4' which is the right instruction to use for that.

Fixes: 683430200315 ("powerpc/47x: Kernel support for KEXEC")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/dc4f9616fba9c05c5dbf9b4b5480eb1c362adc17.1741256651.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/relocate_32.S | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kexec/relocate_32.S b/arch/powerpc/kexec/relocate_32.S
index 104c9911f4061..dd86e338307d3 100644
--- a/arch/powerpc/kexec/relocate_32.S
+++ b/arch/powerpc/kexec/relocate_32.S
@@ -348,16 +348,13 @@ write_utlb:
 	rlwinm	r10, r24, 0, 22, 27
 
 	cmpwi	r10, PPC47x_TLB0_4K
-	bne	0f
 	li	r10, 0x1000			/* r10 = 4k */
-	ANNOTATE_INTRA_FUNCTION_CALL
-	bl	1f
+	beq	0f
 
-0:
 	/* Defaults to 256M */
 	lis	r10, 0x1000
 
-	bcl	20,31,$+4
+0:	bcl	20,31,$+4
 1:	mflr	r4
 	addi	r4, r4, (2f-1b)			/* virtual address  of 2f */
 
-- 
2.39.5



