Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD18264614;
	Tue,  8 Apr 2025 11:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111160; cv=none; b=VLKk8Gb8BqjU5oXKP3SUM3fBLqymUKFE3hb60wSyXzbSoR6tG5fnOc5PDEAN2jYldU+stFI+HmMeE3byDhsYEN1ilEsg81tZOIq08o4m0yeQJOfSyrT1YvhHb0kG4/zuipccEpm01TQoYhTCq1+HUYBnqtD+ceVL97hfoCZ4XL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111160; c=relaxed/simple;
	bh=sF8PeD0wI6XNDsDUaehPuW+q3lX3PB5GR7QKVMeGOwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQOQ9DHwFoAlUUTzwUJ3NJD6EqTIqPlJSepbrIfzuczZeBHQhO5RXxgaeE6h9bpA5ijBeeDcKJ97ZUT2aP+K4LvoXQDwjXQQpqo6rszogi8Rf3tlPFyI5eh8Ji0TLDRw0ce6+IPUyXHKDbVjxqLSVVjG0SejAZRspJSGwJJNESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWAn0AyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWAn0AyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464BFC4CEE7;
	Tue,  8 Apr 2025 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111159;
	bh=sF8PeD0wI6XNDsDUaehPuW+q3lX3PB5GR7QKVMeGOwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWAn0AyT0Y8O3WDFOSc5Vhmpk66aVn8U0No4bE9/VOy3GZBs1Hn0qjA7boENtxwa1
	 9jLMwOMbkX7Zv731nIxnTdKuqAGzGOzSPlr1bLfDn7C+32ozHUVNjBqWT+yfepogvt
	 /1WkncR27IPzejXI8zkMCUkWsbVze3NFj3pooiV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 329/731] powerpc/kexec: fix physical address calculation in clear_utlb_entry()
Date: Tue,  8 Apr 2025 12:43:46 +0200
Message-ID: <20250408104921.929183414@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



