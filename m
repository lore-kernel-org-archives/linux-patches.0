Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F57394E93;
	Thu,  2 Jul 2026 16:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010839; cv=none; b=dN1qE82C8KBxEZMSc04wcM6ESqppXdRs/73ESPmFO0LO3FBMqPVbqo+TEZEeZ1eREFyaLTR8F2fDVMl1WsimeWK/X+dTcEfKk8E1+3RTXa4+tsEcDxuC2ByBFfmm1MBTvskiVRTj1vSGUQHEkPUATShkMQBcIFB0jR0vdm1Gomk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010839; c=relaxed/simple;
	bh=fVQ7DU5YhPckPuXu7ZmgFfqYdu5OoJGIiRPlMq/4DIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbvYaGTDiFGbs3GebqznmC17aNxncKyyoa1wpYOp+Om2bp/c+HYH58qd41i79W9nBIMdlsBnyopJ2IxMWc1GivzG6a1Jcouq/5jOS585F0NAqUQDgO1FrBE56pf3iymH1FFpoaLTTDjDSPuVyooatkRLtpeef3SMLSc596O7GoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ineIvtKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ineIvtKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10C91F00A3A;
	Thu,  2 Jul 2026 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010837;
	bh=YSn4oBl2Wd7tpIp6oFRTeKqBkzk9H27lFfT/rGWk6g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ineIvtKYJUyuFP3/CaSYgWNGENb7u9hB2jzWY3jXbzTy674Dd3vG0C9v3pmc+Euwh
	 yS8pb4HYPN2Iq85FbEEMz036GThU5YN3/T3QQk9orGErgUN+Ix6ji7wS2BuL0hFiOL
	 hjAjaIeDtTzW7EA9X8OD+meDiFcg9V9Wd2cTVbtw=
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
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.6 057/175] scripts/sorttable: Get start/stop_mcount_loc from ELF file directly
Date: Thu,  2 Jul 2026 18:19:18 +0200
Message-ID: <20260702155116.994945675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 4acda8edefa1ce66d3de845f1c12745721cd14c3 ]

The get_mcount_loc() does a cheesy trick to find the start_mcount_loc and
stop_mcount_loc values. That trick is:

 file_start = popen(" grep start_mcount System.map | awk '{print $1}' ", "r");

and

 file_stop = popen(" grep stop_mcount System.map | awk '{print $1}' ", "r");

Those values are stored in the Elf symbol table. Use that to capture those
values. Using the symbol table is more efficient and more robust. The
above could fail if another variable had "start_mcount" or "stop_mcount"
as part of its name.

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
Link: https://lore.kernel.org/20250105162346.817157047@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |   95 ++++++++++++++++++++++++----------------------------
 1 file changed, 45 insertions(+), 50 deletions(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -472,42 +472,41 @@ static void *sort_mcount_loc(void *arg)
 }
 
 /* Get the address of __start_mcount_loc and __stop_mcount_loc in System.map */
-static void get_mcount_loc(uint64_t *_start, uint64_t *_stop)
+static void get_mcount_loc(struct elf_mcount_loc *emloc, Elf_Shdr *symtab_sec,
+			   const char *strtab)
 {
-	FILE *file_start, *file_stop;
-	char start_buff[20];
-	char stop_buff[20];
-	int len = 0;
+	Elf_Sym *sym, *end_sym;
+	int symentsize = shdr_entsize(symtab_sec);
+	int found = 0;
+
+	sym = (void *)emloc->ehdr + shdr_offset(symtab_sec);
+	end_sym = (void *)sym + shdr_size(symtab_sec);
+
+	while (sym < end_sym) {
+		if (!strcmp(strtab + sym_name(sym), "__start_mcount_loc")) {
+			emloc->start_mcount_loc = sym_value(sym);
+			if (++found == 2)
+				break;
+		} else if (!strcmp(strtab + sym_name(sym), "__stop_mcount_loc")) {
+			emloc->stop_mcount_loc = sym_value(sym);
+			if (++found == 2)
+				break;
+		}
+		sym = (void *)sym + symentsize;
+	}
 
-	file_start = popen(" grep start_mcount System.map | awk '{print $1}' ", "r");
-	if (!file_start) {
+	if (!emloc->start_mcount_loc) {
 		fprintf(stderr, "get start_mcount_loc error!");
 		return;
 	}
 
-	file_stop = popen(" grep stop_mcount System.map | awk '{print $1}' ", "r");
-	if (!file_stop) {
+	if (!emloc->stop_mcount_loc) {
 		fprintf(stderr, "get stop_mcount_loc error!");
-		pclose(file_start);
 		return;
 	}
-
-	while (fgets(start_buff, sizeof(start_buff), file_start) != NULL) {
-		len = strlen(start_buff);
-		start_buff[len - 1] = '\0';
-	}
-	*_start = strtoul(start_buff, NULL, 16);
-
-	while (fgets(stop_buff, sizeof(stop_buff), file_stop) != NULL) {
-		len = strlen(stop_buff);
-		stop_buff[len - 1] = '\0';
-	}
-	*_stop = strtoul(stop_buff, NULL, 16);
-
-	pclose(file_start);
-	pclose(file_stop);
 }
 #endif
+
 static int do_sort(Elf_Ehdr *ehdr,
 		   char const *const fname,
 		   table_sort_t custom_sort)
@@ -538,8 +537,6 @@ static int do_sort(Elf_Ehdr *ehdr,
 	unsigned int shstrndx;
 #ifdef MCOUNT_SORT_ENABLED
 	struct elf_mcount_loc mstruct = {0};
-	uint64_t _start_mcount_loc = 0;
-	uint64_t _stop_mcount_loc = 0;
 #endif
 #ifdef UNWINDER_ORC_ENABLED
 	unsigned int orc_ip_size = 0;
@@ -577,13 +574,8 @@ static int do_sort(Elf_Ehdr *ehdr,
 
 #ifdef MCOUNT_SORT_ENABLED
 		/* locate the .init.data section in vmlinux */
-		if (!strcmp(secstrings + idx, ".init.data")) {
-			get_mcount_loc(&_start_mcount_loc, &_stop_mcount_loc);
-			mstruct.ehdr = ehdr;
+		if (!strcmp(secstrings + idx, ".init.data"))
 			mstruct.init_data_sec = shdr;
-			mstruct.start_mcount_loc = _start_mcount_loc;
-			mstruct.stop_mcount_loc = _stop_mcount_loc;
-		}
 #endif
 
 #ifdef UNWINDER_ORC_ENABLED
@@ -627,23 +619,6 @@ static int do_sort(Elf_Ehdr *ehdr,
 		goto out;
 	}
 #endif
-
-#ifdef MCOUNT_SORT_ENABLED
-	if (!mstruct.init_data_sec || !_start_mcount_loc || !_stop_mcount_loc) {
-		fprintf(stderr,
-			"incomplete mcount's sort in file: %s\n",
-			fname);
-		goto out;
-	}
-
-	/* create thread to sort mcount_loc concurrently */
-	if (pthread_create(&mcount_sort_thread, NULL, &sort_mcount_loc, &mstruct)) {
-		fprintf(stderr,
-			"pthread_create mcount_sort_thread failed '%s': %s\n",
-			strerror(errno), fname);
-		goto out;
-	}
-#endif
 	if (!extab_sec) {
 		fprintf(stderr,	"no __ex_table in file: %s\n", fname);
 		goto out;
@@ -663,6 +638,26 @@ static int do_sort(Elf_Ehdr *ehdr,
 	strtab = (const char *)ehdr + shdr_offset(strtab_sec);
 	symtab = (const Elf_Sym *)((const char *)ehdr + shdr_offset(symtab_sec));
 
+#ifdef MCOUNT_SORT_ENABLED
+	mstruct.ehdr = ehdr;
+	get_mcount_loc(&mstruct, symtab_sec, strtab);
+
+	if (!mstruct.init_data_sec || !mstruct.start_mcount_loc || !mstruct.stop_mcount_loc) {
+		fprintf(stderr,
+			"incomplete mcount's sort in file: %s\n",
+			fname);
+		goto out;
+	}
+
+	/* create thread to sort mcount_loc concurrently */
+	if (pthread_create(&mcount_sort_thread, NULL, &sort_mcount_loc, &mstruct)) {
+		fprintf(stderr,
+			"pthread_create mcount_sort_thread failed '%s': %s\n",
+			strerror(errno), fname);
+		goto out;
+	}
+#endif
+
 	if (custom_sort) {
 		custom_sort(extab_image, shdr_size(extab_sec));
 	} else {


