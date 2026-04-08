Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6B1B67E;
	Wed,  8 Apr 2026 18:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673518; cv=none; b=O2xDjDm81I9DrTGZPwBuIHnqrTGoFMaZJHYdpTfoK6cxxcKQtU6XII98ABUIT/yZDQH3fIPvY9/++ELcruA/ceATO3PI2I3qAEhjZFEei5YSBZYO1vLP4ni8dEksF/L8KRSN2hpURoaZFhOzoK17SS9lQaNJyB43i50S0dr+R9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673518; c=relaxed/simple;
	bh=2vmZi6jwP1+7bmG58mpa192Na3SAB8Q4lI4SIky4qPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHPwbJ6SzibpwUzAjan4SfhKqv7WwqcBf5rghQv7sl/WVj5vc6zADEacjtpetUbBXMHmrD6RFQPeAlzvBVcZu6sK+zmLdzNeF/IshOYRdRcDKfPkcS+0L3NcUaZn7bouHZhICvbHF2VHs1ryTSbBGtWEy9KlJKXufPQfNqbNKcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7VjgiJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7VjgiJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49791C19421;
	Wed,  8 Apr 2026 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673518;
	bh=2vmZi6jwP1+7bmG58mpa192Na3SAB8Q4lI4SIky4qPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7VjgiJKk5KE5Nf2xL1l67pEogTQz3CF5si78zWC/JaMsAzDm8nWflTW6/f8O5nYt
	 GUKqJ6YLhUSrc9zz/+qB3qtRRMw5Zn4s6FzGE6jIuyS5PLy2/YxWqNxxBYwtoGGXho
	 JwJf6xwXSawzfK+BnMRgH6XO84rtvvqconI3rJTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkman <daniel@iogearbox.net>,
	Daniel Gomez <da.gomez@samsung.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Marc Rutland <mark.rutland@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 264/277] kallsyms: clean up modname and modbuildid initialization in kallsyms_lookup_buildid()
Date: Wed,  8 Apr 2026 20:04:09 +0200
Message-ID: <20260408175943.716012815@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Petr Mladek <pmladek@suse.com>

commit fda024fb64769e9d6b3916d013c78d6b189129f8 upstream.

The @modname and @modbuildid optional return parameters are set only when
the symbol is in a module.

Always initialize them so that they do not need to be cleared when the
module is not in a module.  It simplifies the logic and makes the code
even slightly more safe.

Note that bpf_address_lookup() function will get updated in a separate
patch.

Link: https://lkml.kernel.org/r/20251128135920.217303-3-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kallsyms.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -362,6 +362,14 @@ static int kallsyms_lookup_buildid(unsig
 	 * or empty string.
 	 */
 	namebuf[0] = 0;
+	/*
+	 * Initialize the module-related return values. They are not set
+	 * when the symbol is in vmlinux or it is a bpf address.
+	 */
+	if (modname)
+		*modname = NULL;
+	if (modbuildid)
+		*modbuildid = NULL;
 
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
@@ -370,10 +378,6 @@ static int kallsyms_lookup_buildid(unsig
 		/* Grab name */
 		kallsyms_expand_symbol(get_symbol_offset(pos),
 				       namebuf, KSYM_NAME_LEN);
-		if (modname)
-			*modname = NULL;
-		if (modbuildid)
-			*modbuildid = NULL;
 
 		return strlen(namebuf);
 	}


