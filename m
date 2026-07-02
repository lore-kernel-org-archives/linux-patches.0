Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971CD39A045;
	Thu,  2 Jul 2026 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010357; cv=none; b=P/UuLAHBPCPWWB9+2FolxG/S/m73+r9k60+DefaxHTtfSq2qosyqoKDtqS9KQOQu0RaLfbcCgGU+f+Ncpiv3j6ThQGiNOXotX3hvpV3D9T8ZnxJ01DcljpeZcusFqfJleBlwwxHqSRP734jeNdZMAMC/MMvVMFNMIsJiD06MDjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010357; c=relaxed/simple;
	bh=cplsVb0/hynfNnYahJvw3YQn7lup+cQTYnSXE89zSWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiOhj8Uufu6eTfamjlIY9YlSUwuje36cd1VNPggZHpbxncTAoDe2OLUOsSpXSC4NTU0dDYLbYIMpWGy7BcmE7buea/fxfzNkPvS+liDPJdAnvM3phqRbQiytjwwOwckC/C9bqraDIK9mLBekHYVO/z/lFhblkcWZXpopJePMS2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDzyPZ9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDzyPZ9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39DE1F000E9;
	Thu,  2 Jul 2026 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010356;
	bh=BybCeYJU5Kb2wNNALgkVkZPwJT8XHNmAViv42NoQDgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDzyPZ9puayUyvj69PVUJhRJ/APTDERGgLjLykgySUMUA27zgLKjY/Hd2HZ7tPHXL
	 /9qw2byhvLa5LzVtIBoaPIN1pbbq2ZVLb2FzXHDVcK78rbBxVJW9YHXk9nyZRW+TYs
	 eyJzAit540LMhbfjg0M30izZ55BBiFdtICyaUxBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.12 079/204] ftrace: Test mcount_loc addr before calling ftrace_call_addr()
Date: Thu,  2 Jul 2026 18:18:56 +0200
Message-ID: <20260702155120.323387131@linuxfoundation.org>
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

[ Upstream commit 6eeca746fa5f1dd03c6ee05cb03f5eb1ddda1c81 ]

The addresses in the mcount_loc can be zeroed and then moved by KASLR
making them invalid addresses. ftrace_call_addr() for ARM 64 expects a
valid address to kernel text. If the addr read from the mcount_loc section
is invalid, it must not call ftrace_call_addr(). Move the addr check
before calling ftrace_call_addr() in ftrace_process_locs().

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/20250225182054.290128736@goodmis.org
Fixes: ef378c3b8233 ("scripts/sorttable: Zero out weak functions in mcount_loc table")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: "Arnd Bergmann" <arnd@arndb.de>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20250225025631.GA271248@ax162/
Closes: https://lore.kernel.org/all/91523154-072b-437b-bbdc-0b70e9783fd0@app.fastmail.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7108,7 +7108,9 @@ static int ftrace_process_locs(struct mo
 	pg = start_pg;
 	while (p < end) {
 		unsigned long end_offset;
-		addr = ftrace_call_adjust(*p++);
+
+		addr = *p++;
+
 		/*
 		 * Some architecture linkers will pad between
 		 * the different mcount_loc sections of different
@@ -7120,6 +7122,8 @@ static int ftrace_process_locs(struct mo
 			continue;
 		}
 
+		addr = ftrace_call_adjust(addr);
+
 		end_offset = (pg->index+1) * sizeof(pg->records[0]);
 		if (end_offset > PAGE_SIZE << pg->order) {
 			/* We should have allocated enough */


