Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231D96FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ADCC433A1;
	Mon,  3 Apr 2023 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532184;
	bh=jHpfYkZgMnZVmtjaR/s+2UKOeQyOCn+wvBCBrkBHDm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moriHL5xHqQPiezNMYKuIOLgaw7pf90b2NRjUq3kSmptFoXBhVQ5LcYcTjkvajH1o
	 NKUyCR4+IFcGB5fPO1MWPf7ADqZDvNdQHKXbsl4ZEoXCySlbw9l1TzR7sySH5WmGVp
	 HnnnIKC7zahykkemkIFLeJ1Eo0vlr5r+Zl+pDoko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.10 160/173] xtensa: fix KASAN report for show_stack
Date: Mon,  3 Apr 2023 16:09:35 +0200
Message-Id: <20230403140419.619285765@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Max Filippov <jcmvbkbc@gmail.com>

commit 1d3b7a788ca7435156809a6bd5b20c95b2370d45 upstream.

show_stack dumps raw stack contents which may trigger an unnecessary
KASAN report. Fix it by copying stack contents to a temporary buffer
with __memcpy and then printing that buffer instead of passing stack
pointer directly to the print_hex_dump.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/traps.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -503,7 +503,7 @@ static size_t kstack_depth_to_print = CO
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
-	size_t len;
+	size_t len, off = 0;
 
 	if (!sp)
 		sp = stack_pointer(task);
@@ -512,9 +512,17 @@ void show_stack(struct task_struct *task
 		  kstack_depth_to_print * STACK_DUMP_ENTRY_SIZE);
 
 	printk("%sStack:\n", loglvl);
-	print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
-		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
-		       sp, len, false);
+	while (off < len) {
+		u8 line[STACK_DUMP_LINE_SIZE];
+		size_t line_len = len - off > STACK_DUMP_LINE_SIZE ?
+			STACK_DUMP_LINE_SIZE : len - off;
+
+		__memcpy(line, (u8 *)sp + off, line_len);
+		print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
+			       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
+			       line, line_len, false);
+		off += STACK_DUMP_LINE_SIZE;
+	}
 	show_trace(task, sp, loglvl);
 }
 


