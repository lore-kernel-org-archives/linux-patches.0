Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A7D346A18;
	Thu,  2 Jul 2026 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010833; cv=none; b=uAI+gX/WUliDt7JexQ3lMTz5H7Wi6FPfojOBgvj64I2Ee/mGIUeajuUPQSr1m4Sen9rlBIzaEd4EadyzBbGR0ViiHbTI8X1CHu40th+jokIRMK1++VVf1ycNWmKvjkV7khfneP79kVEfx+w413YicAu9Ark4oHOqFu2Xli2kOZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010833; c=relaxed/simple;
	bh=Xkf6Hd+8/vjrBCt362ymLUa6m7d8Srl9zxE93HyLc5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az4hm6XYhfbvezv5K0J4xWY5sTw4dRxMbKJZdjzD8lS82sexDsNWb+uJjvlNzISsd3fEM+igi/g5Z+K5+K2DY8CkInACbDlfTXLUT5Zh/HXBBBASPDgqT7CxzIbnDnIWni2qPoRLWGA4d5q7sVgxOAXabXFC6ccW7OSunZ6Pjz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBCeGssE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBCeGssE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838451F00A3E;
	Thu,  2 Jul 2026 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010832;
	bh=CGvDThpXhSQn5z+GiSfX/scnUjOYAk8cJ/SrpnkAaeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBCeGssEcq4NaZxTWLWSBV4RZgTGBfrekgby7eGIXHaeKQhI4H/nZdlNmpr/0Xnin
	 7KvLvomfPf903nPeZ7UxhiQAERD+0N4vuxZTlEnyAOC84nLfO+ZSYLo+l5xlRXfPmU
	 SUtz082oQs1Z37R6D3TpthmrIBx5iep2LzPRd3DY=
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
Subject: [PATCH 6.6 047/175] scripts/sorttable: Have the ORC code use the _r() functions to read
Date: Thu,  2 Jul 2026 18:19:08 +0200
Message-ID: <20260702155116.789918873@linuxfoundation.org>
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


