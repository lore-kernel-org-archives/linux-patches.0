Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ACD347FCD;
	Thu,  2 Jul 2026 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010352; cv=none; b=UTES2N4mm6HI0IWQcduUP1hYDPnW1+4dRj9ZPHR/cdVmHrUJ52t8uvY7i3+JHkvmVrQf62WMeakTOIoFldRM5DXH8VMi64tvvDc4rbjhNWY/AfgW2xP+k+abWWFdUmkbSVRYb1oGR+tXX7Mx+Mz5JM8zwrhb5qtEh38y8V5zoS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010352; c=relaxed/simple;
	bh=bARL1UfQ2+/TVIKdaHQ6opMS9ybB3oAQx961l0o5yN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1k+ylpb19ECdCHB2dDjItlPsOm06SpzzruMKGAaaqeR1nI5DY9ZpOVgrJtGRoDi3YUD0x9FO+mxMJz52YOcUtqVD09m0clgywRL9Gn51aAF7ZSxSkmPAWomaGFqDwiwCSBfmObv7O7p0yQMv9mpW1rv43N4XpLvvMlrTLiluAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tImRB9f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tImRB9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948361F000E9;
	Thu,  2 Jul 2026 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010351;
	bh=hTkMjPba82vZaMvl5WNIP5krQISY8NwgVjgfri0lkOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tImRB9fJrbyIme1z1SFh0lyjxyAOX0FcZ+3zi/8bL7d4bx4pa4TUCNOhOurvGdEW
	 UkB/ijisQRUPEutFfOJB4Fuo8g9b9ZEFW65XE8z38ZbG/FdP1o8PPbloO+LM1kO9ex
	 WQy4iE3KghP7nLU8KzDBmyr2o3TQDovTgiqEGMWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bpf <bpf@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Martin Kelly <martin.kelly@crowdstrike.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.12 077/204] ftrace: Have ftrace pages output reflect freed pages
Date: Thu,  2 Jul 2026 18:18:54 +0200
Message-ID: <20260702155120.282872367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 264143c4e54412095f4b615e65bf736fc3c60af0 ]

The amount of memory that ftrace uses to save the descriptors to manage
the functions it can trace is shown at output. But if there are a lot of
functions that are skipped because they were weak or the architecture
added holes into the tables, then the extra pages that were allocated are
freed. But these freed pages are not reflected in the numbers shown, and
they can even be inconsistent with what is reported:

 ftrace: allocating 57482 entries in 225 pages
 ftrace: allocated 224 pages with 3 groups

The above shows the number of original entries that are in the mcount_loc
section and the pages needed to save them (225), but the second output
reflects the number of pages that were actually used. The two should be
consistent as:

 ftrace: allocating 56739 entries in 224 pages
 ftrace: allocated 224 pages with 3 groups

The above also shows the accurate number of entires that were actually
stored and does not include the entries that were removed.

Cc: bpf <bpf@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Martin  Kelly <martin.kelly@crowdstrike.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/20250218200023.221100846@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7050,6 +7050,7 @@ static int ftrace_process_locs(struct mo
 	unsigned long addr;
 	unsigned long kaslr;
 	unsigned long flags = 0; /* Shut up gcc */
+	unsigned long pages;
 	int ret = -ENOMEM;
 
 	count = end - start;
@@ -7057,6 +7058,8 @@ static int ftrace_process_locs(struct mo
 	if (!count)
 		return 0;
 
+	pages = DIV_ROUND_UP(count, ENTRIES_PER_PAGE);
+
 	/*
 	 * Sorting mcount in vmlinux at build time depend on
 	 * CONFIG_BUILDTIME_MCOUNT_SORT, while mcount loc in
@@ -7168,6 +7171,8 @@ static int ftrace_process_locs(struct mo
 			for (pg = pg_unuse; pg; pg = pg->next)
 				remaining += 1 << pg->order;
 
+			pages -= remaining;
+
 			skip = DIV_ROUND_UP(skip, ENTRIES_PER_PAGE);
 
 			/*
@@ -7181,6 +7186,13 @@ static int ftrace_process_locs(struct mo
 		synchronize_rcu();
 		ftrace_free_pages(pg_unuse);
 	}
+
+	if (!mod) {
+		count -= skipped;
+		pr_info("ftrace: allocating %ld entries in %ld pages\n",
+			count, pages);
+	}
+
 	return ret;
 }
 
@@ -7835,9 +7847,6 @@ void __init ftrace_init(void)
 		goto failed;
 	}
 
-	pr_info("ftrace: allocating %ld entries in %ld pages\n",
-		count, DIV_ROUND_UP(count, ENTRIES_PER_PAGE));
-
 	ret = ftrace_process_locs(NULL,
 				  __start_mcount_loc,
 				  __stop_mcount_loc);


