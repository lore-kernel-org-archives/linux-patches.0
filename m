Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7D64ABBB4;
	Thu, 17 Sep 2026 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659460; cv=none; b=AyYVxFF2uSFgAbcoFqcYjW2sHqd4qFEhrPcW5NJmqDdXq28CJ2fCJnIE1lHV8MnCADvxHuEFPhFS4viI5UnHD+s944/1ukp/jguLRq/YQ4ItAFSIAUyciqAfjdlxuQUZSjgr+C5iI7pbPWKvvpTYhPtWSy9B4061z7HSTwJZ7kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659460; c=relaxed/simple;
	bh=rkgD3Fi/72chE2SS3zPiRFDvwwrnRZIJNqvAgWTAN4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL1x7FHZS9/bw8q7ISPNJ7RlT8ndnVL3P/J9lPkyHoqA7BepF8/AfjLfKCmtZs5PXkYj0PhQSwFdFCdeHn6w4uJ5hS7whuad8Ys/1VGlKsiy3plr99miVflc6G4nt1iRB0/Tfuqm2eJ4sBKZ1aBCRfjdvO3jiDPNlSxNlWSoUvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJGUw2zC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJGUw2zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBFA1F00898;
	Thu, 17 Sep 2026 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659451;
	bh=pNSIGy3k5SshpIcyt7hXgwbVo2S6z1ro1AxDeV0emVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJGUw2zCQZX4H4w+5vLgi2fPpbkS1ijeLt1+n1nFHjPfseZZVClmadxsK12lGVLCn
	 A7PgqWDBfj3riPlNlKIt6Z/BJukjk9SvXD3o1ob6CbIrBiQwrmWL3/FUgJvGMHqWkn
	 W2btGDF8HOr29kDkWo0L6eUammIdZZtNK39u4dwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 262/733] tracing: Fix to avoid creating trace instances with duplicate names
Date: Thu, 17 Sep 2026 16:09:30 +0100
Message-ID: <20260917151357.852174660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit d7dbdd2ee01e12211046d4a535623ac732b749fb ]

Since commit e645535a954a ("tracing: Add option to use memmapped
memory for trace boot instance") changed trace_array_get_by_name() to
trace_array_create_systems(), enable_instances() does not reuse the
same name instance. Therefore, if an administrator mistakenly specifies
multiple `trace_instance=` options with duplicate names, all are
created but only the first is accessible via tracefs.

Check whether an instance with the same name already exists before
creating a new one, and reject duplicates with a warning.

Link: https://patch.msgid.link/178847790399.283263.5313150997200138426.stgit@devnote2
Fixes: e645535a954a ("tracing: Add option to use memmapped memory for trace boot instance")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fc964001783f3..e6915fc7de832 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9708,6 +9708,11 @@ __init static void enable_instances(void)
 		if (flag_delim)
 			*flag_delim++ = '\0';
 
+		if (trace_array_find(name)) {
+			pr_warn("Tracing: Instance %s already exists\n", name);
+			continue;
+		}
+
 		if (backup) {
 			if (backup_instance_area(backup, &addr, &size) < 0)
 				continue;
-- 
2.53.0



