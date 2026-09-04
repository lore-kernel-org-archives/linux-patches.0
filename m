Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933042DCF57;
	Fri,  4 Sep 2026 05:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499718; cv=none; b=TkVmFjtpcZ/8auPI2aXyrmGJiB89rzqy4cF23GvGsgqcH5+Zu6EaTVw8fGPi6ml/nX6xqUQPd7VwJQlB1Vv+N7plZBwYQy9UKeUBD9FV+MOvrXMjqDi/t/9QEJ1YH8GWOaD0JM5X8qrFGXRTRg+yg5iY6ogKdOpSlgUIv8EmsxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499718; c=relaxed/simple;
	bh=dzSPVB3/XPBRAyxrer7gg8qFsJD5ty3e0LYav3EfA68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPo2XMVkj9EBY7eEcqFVMBB91PzfL2D4eXtSzRkzaCuA+yFyypLAX60TRA8k99iHPEIwgsbZ04e5RU5OZ+wJAbPSgaPlw+VkcY0Pb5UNnG/qw50hvMR7zZIPiR8sMYJZ4/KxqO9ciL7umQn6UlnQuvJMDelBf6ch2WHk9lk6d1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUTif07Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUTif07Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF21F1F00A3D;
	Fri,  4 Sep 2026 05:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499717;
	bh=VwmSCeb7Hhui39gquYAgnijXJqDVSlDojfSvVQ9PNJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUTif07QZB9rUKTkEGsYb3Zo5dJabXK+cBlnJZZbzuEyWqCGSkblUOM2QpssLM1jO
	 rbwpcKQHFqu/9Z3ZpAR0dSeD2/sgZ4L1M4YdowW3e70KxvJ6vK48/zPPJwdPHCfRbs
	 9mgwZPb4xbjZEkozkoeXT3tupe8k0no3zaKJyyCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.2 516/713] s390/percpu: Fix MVIY_PERCPU() with older binutils
Date: Fri,  4 Sep 2026 06:58:04 +0200
Message-ID: <20260904045815.385842791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 101782f8945a125044347312d74d488c05741c4a upstream.

Commit a737737cdb9c ("s390/percpu: Infrastructure for more efficient
this_cpu operations") introduced MVIY_PERCPU(), which stringifies
arguments that are already C string literals. This generates an
assembler macro invocation with whitespace-separated quoted arguments:

  GEN_MVIY "459712" "%r3"

GNU as versions prior to binutils 2.39 drop the separating whitespace
between quoted macro arguments during input scrubbing. They
consequently parse the invocation as a single argument and emit
repeated warnings:

  Warning: missing closing `"'

The .ifc in GEN_MVIY never matches and GNU as exits successfully
without emitting the mviy instruction. As a result, the interrupted
per-CPU sequence is not marked in lowcore and the exception return
path cannot repair the per-CPU address register after migration.

All MVIY_PERCPU() callers pass C string literals. Use them directly
and separate the assembler macro arguments with an explicit comma. The
resulting invocation is:

  GEN_MVIY 459712, %r3

This form is unambiguous for GNU as and LLVM's integrated assembler.
This behavior was fixed in GNU as from binutils 2.39, but Linux
supports binutils 2.30.

Fixes: a737737cdb9c ("s390/percpu: Infrastructure for more efficient this_cpu operations")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/percpu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 1d955dd0defa..feb58acf87d6 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -107,8 +107,8 @@
 	"	.endif\n"							\
 	".endr\n"								\
 	".endm\n"								\
-	ALTERNATIVE("GEN_MVIY " __stringify(disp)    " " __stringify(reg) "\n",	\
-		    "GEN_MVIY " __stringify(dispalt) " " __stringify(reg) "\n",	\
+	ALTERNATIVE("GEN_MVIY " disp    ", " reg "\n",				\
+		    "GEN_MVIY " dispalt ", " reg "\n",				\
 		    ALT_FEATURE(MFEATURE_LOWCORE))				\
 	".purgem GEN_MVIY\n"
 
-- 
2.55.0



