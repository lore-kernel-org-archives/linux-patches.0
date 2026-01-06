Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F8035C1A6;
	Tue,  6 Jan 2026 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722081; cv=none; b=hnsFHqe+oHttMa8LtCpgr5TEb9KgIaTQ56om6d1bpAOLCCBM9ldIZlySdON4OFviyl/zvfttbWpKB7S5w470qNICJGj/Fm1BVM6rA4WB71CvjLybOUI7ZezIMofcP6a48d+IDioRRO+KBiSY0eAZyzlvdm9BMsQtyfhL5aFQ204=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722081; c=relaxed/simple;
	bh=g96/CUlQdz9kF3+61CPBwwvDg1YEAYntQ4oAjrrpfP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF57wgRwaqyIQ16oeNNtE1OdYLWMZGcOYXFIUbnK2hx21HvX1bGdUvTgA2M6pK481dk+3YnNsuEOfARZgZXhKBI+SRJzqu9WuJUIkwNgAG7h73GQeHZVbvSHVkla4pxX9eDs36H1172kr24BWJm/Shlgv200ELtdc5HJNftZj6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ui1wwAz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ui1wwAz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E105C116C6;
	Tue,  6 Jan 2026 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722080;
	bh=g96/CUlQdz9kF3+61CPBwwvDg1YEAYntQ4oAjrrpfP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ui1wwAz33EuF8ic4rzDHQ8uBh4OS5oASTc3i5OgKXvGQPyGU8ayzXw++ewG34ZP8q
	 XQ3mt2LkV2m6OXsd+yA6K/93aPMWs1bA/6FLObWuReYUvpQJrKAzB6qAfnz1BpbuQg
	 aIIx7NbP7uMAw2lKh6THxt8SEXdteqPX4rY6u0DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@stackframe.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 158/312] parisc: entry: set W bit for !compat tasks in syscall_restore_rfi()
Date: Tue,  6 Jan 2026 18:03:52 +0100
Message-ID: <20260106170553.553773627@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Sven Schnelle <svens@stackframe.org>

commit 5fb1d3ce3e74a4530042795e1e065422295f1371 upstream.

When the kernel leaves to userspace via syscall_restore_rfi(), the
W bit is not set in the new PSW. This doesn't cause any problems
because there's no 64 bit userspace for parisc. Simple static binaries
are usually loaded at addresses way below the 32 bit limit so the W bit
doesn't matter.

Fix this by setting the W bit when TIF_32BIT is not set.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/asm-offsets.c |    2 ++
 arch/parisc/kernel/entry.S       |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/asm-offsets.c
+++ b/arch/parisc/kernel/asm-offsets.c
@@ -258,6 +258,8 @@ int main(void)
 	BLANK();
 	DEFINE(TIF_BLOCKSTEP_PA_BIT, 31-TIF_BLOCKSTEP);
 	DEFINE(TIF_SINGLESTEP_PA_BIT, 31-TIF_SINGLESTEP);
+	DEFINE(TIF_32BIT_PA_BIT, 31-TIF_32BIT);
+
 	BLANK();
 	DEFINE(ASM_PMD_SHIFT, PMD_SHIFT);
 	DEFINE(ASM_PGDIR_SHIFT, PGDIR_SHIFT);
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1846,6 +1846,10 @@ syscall_restore_rfi:
 	extru,= %r19,TIF_BLOCKSTEP_PA_BIT,1,%r0
 	depi	-1,7,1,%r20			   /* T bit */
 
+#ifdef CONFIG_64BIT
+	extru,<> %r19,TIF_32BIT_PA_BIT,1,%r0
+	depi	-1,4,1,%r20			   /* W bit */
+#endif
 	STREG	%r20,TASK_PT_PSW(%r1)
 
 	/* Always store space registers, since sr3 can be changed (e.g. fork) */
@@ -1859,7 +1863,6 @@ syscall_restore_rfi:
 	STREG   %r25,TASK_PT_IASQ0(%r1)
 	STREG   %r25,TASK_PT_IASQ1(%r1)
 
-	/* XXX W bit??? */
 	/* Now if old D bit is clear, it means we didn't save all registers
 	 * on syscall entry, so do that now.  This only happens on TRACEME
 	 * calls, or if someone attached to us while we were on a syscall.


