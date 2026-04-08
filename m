Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFF8282F1E;
	Wed,  8 Apr 2026 19:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674989; cv=none; b=r8dLPOLu/DczLOZ1jnOcGvieqQpKlXq3fbJwdv/ZsosPK4cF5f6aVeSEZNfCvBQi4mLtFUaBEsMzJUlOx6QTIJ0XtVbqQku/NM88bjDoyDvMpKcY5+TV83V3tHWo9OKIG3GHeWd4RMOdy8VWyFaBKbkd43efCA3p62ch9jaTpZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674989; c=relaxed/simple;
	bh=NwFoP+NbDNebgb++oJ8CuHIU+2IIIAXEicoiaoELccw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3/tnh0K0L8gZ+GH6LA6iyTddwc6n4N3xZoob7os1XTg3HGPUs6YcLJulnPhUqx8hfeQSoLVBakspNgn8FHvIOPplihQeD0V6mW6kTlyYxSnXvdSWYPI2mCdRFBZ57GQ+iBoZ70epKA3xTGZDjsWVHD7D/PxfgpEZqZ9rcV+9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcflYcJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcflYcJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1B9C19421;
	Wed,  8 Apr 2026 19:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674989;
	bh=NwFoP+NbDNebgb++oJ8CuHIU+2IIIAXEicoiaoELccw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcflYcJxkUmPf7PsKovOPEcHrxloskxiWJUGFdXemI6gKr4vfmWYseJXQWLN+85Rz
	 ocJB2kOL8GQ829PrAW+2AooSwOFCg6hpm/1/Us74wtvUlC3U+FuF0aSukoBPr/OhAP
	 MfAZ6pdy/A3BvzlbS1YdgRG0S3l9bKhgauI/2ODk=
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
Subject: [PATCH 6.19 310/311] kallsyms: prevent module removal when printing module name and buildid
Date: Wed,  8 Apr 2026 20:05:10 +0200
Message-ID: <20260408175950.940999538@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Petr Mladek <pmladek@suse.com>

commit 3b07086444f80c844351255fd94c2cb0a7224df2 upstream.

kallsyms_lookup_buildid() copies the symbol name into the given buffer so
that it can be safely read anytime later.  But it just copies pointers to
mod->name and mod->build_id which might get reused after the related
struct module gets removed.

The lifetime of struct module is synchronized using RCU.  Take the rcu
read lock for the entire __sprint_symbol().

Link: https://lkml.kernel.org/r/20251128135920.217303-8-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
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
 kernel/kallsyms.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -474,6 +474,9 @@ static int __sprint_symbol(char *buffer,
 	unsigned long offset, size;
 	int len;
 
+	/* Prevent module removal until modname and modbuildid are printed */
+	guard(rcu)();
+
 	address += symbol_offset;
 	len = kallsyms_lookup_buildid(address, &size, &offset, &modname, &buildid,
 				       buffer);


