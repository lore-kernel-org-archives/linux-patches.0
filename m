Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB348425CD9;
	Tue, 31 Mar 2026 16:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975231; cv=none; b=nShFuf7Kzn+FmWBAS3nm9ahqowDlEkiWoNGO5ogsbObHT/DbNaxtL0nzd8C9KxLD9zVcWCZQF5qPMTbACwO4zgR+igZaDkGKFap8M5eknADgrn5CDDcOVL9YKAFD4rUdTc/SPleaxaXCET+ePgNX2RVHoKzXUHY1ItsKdPt9nUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975231; c=relaxed/simple;
	bh=+qqJsbbI6d+gsxz4Gg/PkL1OCROqGkFurY6Zx0lxUio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q94G58TvMuoB/Kqq8NjXmwoRxVilsD7Yd2PBCbHHyPKcaB4WbJIZtrOz2mI8qE/PBUUaSUhROzAW0HlTu1jT6Tzo9sqDVdTHVkzJXYaM7K1A/X8GNqeBb+i3+5jQtX0J/pa88C6M5hv501TCNIKdx0SyEDxMPC3HbDdkC/VkrSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAZnrguU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAZnrguU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417ABC19423;
	Tue, 31 Mar 2026 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975231;
	bh=+qqJsbbI6d+gsxz4Gg/PkL1OCROqGkFurY6Zx0lxUio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAZnrguUXKdqq5TlM/1qdw8n3fgragHxHAnjBxbPdc0QRb44EhFtVwEyJX3qCcGYz
	 y1LORbhNvZODsxQ5GK2xtcMbIsV5hQMopf5uRzOUpM+z9WREOTFb1kf1X4VR3ejRKo
	 tsG7LJUHS60UjetQHYJhO8Ffbe5mya1miqRgWIys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.19 197/342] s390/entry: Scrub r12 register on kernel entry
Date: Tue, 31 Mar 2026 18:20:30 +0200
Message-ID: <20260331161806.239435416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 arch/s390/kernel/entry.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -260,6 +260,7 @@ SYM_CODE_START(system_call)
 	xgr	%r9,%r9
 	xgr	%r10,%r10
 	xgr	%r11,%r11
+	xgr	%r12,%r12
 	la	%r2,STACK_FRAME_OVERHEAD(%r15)	# pointer to pt_regs
 	mvc	__PT_R8(64,%r2),__LC_SAVE_AREA(%r13)
 	MBEAR	%r2,%r13
@@ -396,6 +397,7 @@ SYM_CODE_START(\name)
 	xgr	%r6,%r6
 	xgr	%r7,%r7
 	xgr	%r10,%r10
+	xgr	%r12,%r12
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
 	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA(%r13)
 	MBEAR	%r11,%r13
@@ -485,6 +487,7 @@ SYM_CODE_START(mcck_int_handler)
 	xgr	%r6,%r6
 	xgr	%r7,%r7
 	xgr	%r10,%r10
+	xgr	%r12,%r12
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)


