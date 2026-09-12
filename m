Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C83C1D67;
	Sat, 12 Sep 2026 11:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211202; cv=none; b=Gtl7s4ewUWTUNH/hxuCM45iMc6XJ7M2kuIaEWC2GPE7mQodpDhRbv7u25Unii6c8cI1KdH3haCsa55Ih4Ve348fvQkMIX3yRuTJAOFjbNk7tULn/C09jlXxRvGR8cmipjne8BPkiemarLP4xl0iBbO0izN0f7fiqxKPyKMetyGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211202; c=relaxed/simple;
	bh=H9PtmHKCSd13QoBbIKoB/CLsXEW64nmQMQWpR1ftJpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THdVmNoVvJjK+DTnWvzWgPmrGJcZ9QA+oT2gQgYXu+mrfmDvDx9RjL+r2IAy8ua2661su7uRvcMu0h4yy9GNqECuKY4Rmfjz056lLe1CR7o8cx2RhB0H+qLOBLddMnhnk/DPDFjrSHr3AV/8UJrBSsEhqb4tbl/w5/vsGm1mmME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A57oebAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A57oebAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF45A1F000FF;
	Sat, 12 Sep 2026 11:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211200;
	bh=n4kDw0br0T+5irAjqC/mY0nFbADLZMWpC02KirhJ4E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A57oebASHvv8ey69cRCGCZm3EziU+33dSMznx/wwEAdNDSVkwMrfB5ziW6ZGNEJor
	 XrzLQXN8M7zeSU2/9GnZkzt89V5WWycU2SnrZi5nMlbx3jBdfsCTp5hNfFkIPM7qRz
	 9kXUITMccGn4wfIUKdCOjM3fR5zLz4nWmM7zZOhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1181/1518] selftests/bpf: Fix for veristat file/prog filters processing
Date: Sat, 12 Sep 2026 08:55:50 +0200
Message-ID: <20260912065650.194062045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 98d309ec8189fd91698d1a72946c3d888270c57e ]

At the moment veristat filtering behaves unexpectedly for the
following filter expression:

  -f !file/prog

The expression rejects all programs with name 'prog', and all programs
in a file with name 'file'. This commit fixes the expression to
exclude only a program 'prog' from a file 'file'. Additionally,
the commit makes empty filters like '-f ""' or '-f "/"' and error.
Here is the filtering behaviour compared old versus new:

| filter   | file | prog | old verdict | new verdict |
|----------+------+------+-------------+-------------|
| !foo     | foo  | bar  | skipped     | skipped     |
| !foo     | bar  | foo  | skipped     | skipped     |
| !foo     | bar  | bar  | processed   | processed   |
| !foo/bar | foo  | bar  | skipped     | skipped     |
| !foo/bar | foo  | buz  | skipped     | processed   | (!)
| !foo/bar | bar  | bar  | skipped     | processed   | (!)
| !foo/    | foo  | bar  | skipped     | skipped     |
| !foo/    | bar  | bar  | processed   | processed   |
| !/bar    | foo  | bar  | skipped     | skipped     |
| !/bar    | foo  | foo  | processed   | processed   |
| !/       | foo  | bar  | processed   | error       | (!)
| !        | foo  | bar  | processed   | error       | (!)
|----------+------+------+-------------+-------------|
| foo      | foo  | bar  | processed   | processed   |
| foo      | bar  | foo  | processed   | processed   |
| foo      | bar  | bar  | skipped     | skipped     |
| foo/bar  | foo  | bar  | processed   | processed   |
| foo/bar  | foo  | buz  | skipped     | skipped     |
| foo/bar  | bar  | bar  | skipped     | skipped     |
| foo/     | foo  | bar  | processed   | processed   |
| foo/     | bar  | bar  | skipped     | skipped     |
| /bar     | foo  | bar  | processed   | processed   |
| /bar     | foo  | foo  | skipped     | skipped     |
| /        | foo  | bar  | processed   | error       | (!)
|          | foo  | bar  | skipped     | error       | (!)

Fixes: 10b1b3f3e56a ("selftests/bpf: consolidate and improve file/prog filtering in veristat")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260811-veristat-filter-fix-v2-1-6c234c4cd6ef@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 76 +++++++++++++++++---------
 1 file changed, 49 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 1be1e353d40a7..df4aea8bbe82c 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -513,6 +513,40 @@ static bool is_bpf_obj_file(const char *path) {
 	return err == 0;
 }
 
+/* Exact filter match */
+static bool name_filter_matches(struct filter *f, const char *filename, const char *prog_name)
+{
+	if (f->any_glob)
+		return glob_matches(filename, f->any_glob) ||
+		       (prog_name && glob_matches(prog_name, f->any_glob));
+	if (f->file_glob && f->prog_glob)
+		return prog_name &&
+		       glob_matches(filename, f->file_glob) &&
+		       glob_matches(prog_name, f->prog_glob);
+	if (f->file_glob)
+		return glob_matches(filename, f->file_glob);
+	if (f->prog_glob)
+		return prog_name && glob_matches(prog_name, f->prog_glob);
+	return false;
+}
+
+/* Check if the filter does not outright reject the file name */
+static bool name_filter_may_match(struct filter *f, const char *filename)
+{
+	if (f->file_glob)
+		return glob_matches(filename, f->file_glob);
+	/*
+	 * If we don't know program name yet, any_glob filter
+	 * has to assume that current BPF object file might be
+	 * relevant; we'll check again later on after opening
+	 * BPF object file, at which point program name will
+	 * be known finally.
+	 */
+	if (f->any_glob || f->prog_glob)
+		return true;
+	return false;
+}
+
 static bool should_process_file_prog(const char *filename, const char *prog_name)
 {
 	struct filter *f;
@@ -520,16 +554,7 @@ static bool should_process_file_prog(const char *filename, const char *prog_name
 
 	for (i = 0; i < env.deny_filter_cnt; i++) {
 		f = &env.deny_filters[i];
-		if (f->kind != FILTER_NAME)
-			continue;
-
-		if (f->any_glob && glob_matches(filename, f->any_glob))
-			return false;
-		if (f->any_glob && prog_name && glob_matches(prog_name, f->any_glob))
-			return false;
-		if (f->file_glob && glob_matches(filename, f->file_glob))
-			return false;
-		if (f->prog_glob && prog_name && glob_matches(prog_name, f->prog_glob))
+		if (f->kind == FILTER_NAME && name_filter_matches(f, filename, prog_name))
 			return false;
 	}
 
@@ -539,24 +564,15 @@ static bool should_process_file_prog(const char *filename, const char *prog_name
 			continue;
 
 		allow_cnt++;
-		if (f->any_glob) {
-			if (glob_matches(filename, f->any_glob))
-				return true;
-			/* If we don't know program name yet, any_glob filter
-			 * has to assume that current BPF object file might be
-			 * relevant; we'll check again later on after opening
-			 * BPF object file, at which point program name will
-			 * be known finally.
-			 */
-			if (!prog_name || glob_matches(prog_name, f->any_glob))
-				return true;
-		} else {
-			if (f->file_glob && !glob_matches(filename, f->file_glob))
-				continue;
-			if (f->prog_glob && prog_name && !glob_matches(prog_name, f->prog_glob))
-				continue;
+		if (prog_name && name_filter_matches(f, filename, prog_name))
+			return true;
+		/*
+		 * If there is no prog_name and the file name is not blocked by
+		 * the filter, allow to open the file. Afterwards there would be
+		 * a second refining query with prog_name set.
+		 */
+		if (!prog_name && name_filter_may_match(f, filename))
 			return true;
-		}
 	}
 
 	/* if there are no file/prog name allow filters, allow all progs,
@@ -702,6 +718,12 @@ static int append_filter(struct filter **filters, int *cnt, const char *str)
 		}
 	}
 
+	if ((!f->any_glob && !f->file_glob && !f->prog_glob) ||
+	    (f->any_glob && strcmp(f->any_glob, "") == 0)) {
+		fprintf(stderr, "Invalid filter: '%s'\n", str);
+		return -EINVAL;
+	}
+
 	*cnt += 1;
 	return 0;
 }
-- 
2.53.0



