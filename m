Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7F2423A61;
	Tue, 31 Mar 2026 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974599; cv=none; b=e9aypG+S8v3+fw0ufkaSFqX+TqUzb8tqkuUqyo9McaUFttYlTBnOUJNClHy4iyoapWOC/UqACX4RnENZ6Cgo2Q2QYd52Ikeust+PCQcp85dwsZMtBtyWi1tGU9wTEqlmAbK2QhTjsUSAJoDx3l1l+uVNmV6Hzg20P3ek2xCrDXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974599; c=relaxed/simple;
	bh=QBc+Ye484imVi7a0vX9K7pcAOGxRYqS+dlW9ym24mGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNApWWCtMq1Y7AumEJMzK9n07AXVSwqD5WxG539CgprHboFtANiDjhrz7yxkjP8Jy5jJ07F2etE/qdmQWyghJlAbqTvj0AcI7GMjWg32Kwk4m6xIjlRhlSyXXyvvQNz3iI9CvAE7nsAfRjV+VUEuXCJ6Iv8G6CbfxJgm9ySJm/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvjVItF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvjVItF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A17C19423;
	Tue, 31 Mar 2026 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974599;
	bh=QBc+Ye484imVi7a0vX9K7pcAOGxRYqS+dlW9ym24mGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvjVItF4O5zLJg7SvueEsH1wCsTZX+f6zHCs2grMqg1jk5+IL975cB95nTyMTICV3
	 3J10ACGVIhvOvB7IU1jGTQH2EDmmU9prQJwta/ZzjX8n7K8XxxX2P0TiEaa0fIkKzQ
	 j+NoX1qmpuz7LAtdi9z21+4s42x0orlKGh4OeCpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 115/175] s390/entry: Scrub r12 register on kernel entry
Date: Tue, 31 Mar 2026 18:21:39 +0200
Message-ID: <20260331161734.006218967@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

commit 0738d395aab8fae3b5a3ad3fc640630c91693c27 upstream.

Before commit f33f2d4c7c80 ("s390/bp: remove TIF_ISOLATE_BP"),
all entry handlers loaded r12 with the current task pointer
(lg %r12,__LC_CURRENT) for use by the BPENTER/BPEXIT macros. That
commit removed TIF_ISOLATE_BP, dropping both the branch prediction
macros and the r12 load, but did not add r12 to the register clearing
sequence.

Add the missing xgr %r12,%r12 to make the register scrub consistent
across all entry points.

Fixes: f33f2d4c7c80 ("s390/bp: remove TIF_ISOLATE_BP")
Cc: stable@kernel.org
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/entry.S |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -300,6 +300,7 @@ SYM_CODE_START(system_call)
 	xgr	%r9,%r9
 	xgr	%r10,%r10
 	xgr	%r11,%r11
+	xgr	%r12,%r12
 	la	%r2,STACK_FRAME_OVERHEAD(%r15)	# pointer to pt_regs
 	mvc	__PT_R8(64,%r2),__LC_SAVE_AREA_SYNC
 	MBEAR	%r2
@@ -378,6 +379,7 @@ SYM_CODE_START(pgm_check_handler)
 	xgr	%r5,%r5
 	xgr	%r6,%r6
 	xgr	%r7,%r7
+	xgr	%r12,%r12
 	lgr	%r2,%r11
 	brasl	%r14,__do_pgm_check
 	tmhh	%r8,0x0001		# returning to user space?
@@ -439,6 +441,7 @@ SYM_CODE_START(\name)
 	xgr	%r6,%r6
 	xgr	%r7,%r7
 	xgr	%r10,%r10
+	xgr	%r12,%r12
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
 	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA_ASYNC
 	MBEAR	%r11
@@ -547,6 +550,7 @@ SYM_CODE_START(mcck_int_handler)
 	xgr	%r6,%r6
 	xgr	%r7,%r7
 	xgr	%r10,%r10
+	xgr	%r12,%r12
 	mvc	__PT_R8(64,%r11),0(%r14)
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)


