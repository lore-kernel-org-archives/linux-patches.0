Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0C61A682A;
	Thu,  2 Jul 2026 16:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010315; cv=none; b=IJAnJrjjnrmG+bHGCNm/KmjAYr0ih+iIHjvpx7/DoDMYOiu6hB8pNo3cgZkw7UheNkmxcXHsRalSoN7l4MzeCPl3YQkYQ9L6mdKGk/bJHiVAWYvUgcQf5UQayxyLVJubKKMPTCHe36X0CxE/ALhSs4dINU6bsY3jL2yAqxDRorY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010315; c=relaxed/simple;
	bh=fxpxGda1BT9kGUlDqeYqv3kwoRJAPRhyW0oyMSepis0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCP3CGKsWY0zUItv3jXlLshGMWwwiX8GMjloxyY4ZUBAXshlZRXIHGF9i6GZQzmzzM7Q+YbcF5me9vMHl+x5/4oW9gHCOgGKr7L9nT6bLYKlDIUbuNkIUxbgivNrW37lQ0/M2+1ciPWcJKzFHEkyXkVVRVNi9h3jqb4NBb4mC/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUUB/VZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUUB/VZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCEB1F000E9;
	Thu,  2 Jul 2026 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010314;
	bh=RRmTDIlxSxYk9jhs2BsgSGsT0BsQe2ufO3+9IYUun70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUUB/VZc5jOa4DFsdNP/G6iTYwlYfLScGK0bQmZQxNtCLut+NUTFvbufwUxFur5an
	 ocXAp8fg9JMJ0L+YklFugK2ExxrEzRC3HtyfW1DvhmMAth0FUEAIkSdfvOs7Xhkt/T
	 8vo1X4WRJsAEF0vbNSSvsF51z2t6xYb2onpHVWNQ=
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
Subject: [PATCH 6.12 060/204] scripts/sorttable: Have the ORC code use the _r() functions to read
Date: Thu,  2 Jul 2026 18:18:37 +0200
Message-ID: <20260702155119.920632860@linuxfoundation.org>
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

[ Upstream commit 66990c003306c240d570b3ba274ec4f68cf18c91 ]

The ORC code reads the section information directly from the file. This
currently works because the default read function is for 64bit little
endian machines. But if for some reason that ever changes, this will
break. Instead of having a surprise breakage, use the _r() functions that
will read the values from the file properly.

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
Link: https://lore.kernel.org/20250105162344.721480386@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -299,14 +299,14 @@ static int do_sort(Elf_Ehdr *ehdr,
 #if defined(SORTTABLE_64) && defined(UNWINDER_ORC_ENABLED)
 		/* locate the ORC unwind tables */
 		if (!strcmp(secstrings + idx, ".orc_unwind_ip")) {
-			orc_ip_size = s->sh_size;
+			orc_ip_size = _r(&s->sh_size);
 			g_orc_ip_table = (int *)((void *)ehdr +
-						   s->sh_offset);
+						   _r(&s->sh_offset));
 		}
 		if (!strcmp(secstrings + idx, ".orc_unwind")) {
-			orc_size = s->sh_size;
+			orc_size = _r(&s->sh_size);
 			g_orc_table = (struct orc_entry *)((void *)ehdr +
-							     s->sh_offset);
+							     _r(&s->sh_offset));
 		}
 #endif
 	} /* for loop */


