Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533713B8BB9;
	Tue, 21 Jul 2026 19:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660651; cv=none; b=cXPZGAdpwxpeu9rjj4CLTpZrH8QvsePc57z+JhtxOXjaL57vRjGfmHFR2pvLHOqyYmKRDE4iVOq0ebbLbJHtc0mIInVY4Pezt2BiumHAfxs/3UY7/DaCnf0vzndPY8YpXP7WNEbljp2ttSD6BbHD9V42aMbPg9wlcA8+nJ55Xhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660651; c=relaxed/simple;
	bh=D7kjvIsSTL7vpQRlLe7goPfGn/I4tVmYU4zcjOwNl58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9yN1AKxBCvIlXGpORd1F094+NqzpV9T1QcB8O+gNGTqoUuU4fqFu3rsQiSW6novOBu/5rN/QYNKbi2xb8L5i0+vTvxYWsBhVAr2X3udfOhh2oU8toPcpDa3c66E8UXLUn36fD4TpheeqKCZeiMMnxdWSw6tNWDgiYwTZzCGmv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lu2ikTq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lu2ikTq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B965D1F000E9;
	Tue, 21 Jul 2026 19:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660650;
	bh=EbM+YC8qO9AwlqUHnEH+tLIYlx5Wzji90gt+RsDE4k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lu2ikTq/2nH8ULQAUqES9ZxiNeEDuZe70MnSI5wKHkfSKXieHhWrDtT8lk2G+nQZE
	 PoqDXRFLg2ql84rij7FOAMOoSYJM0TuAZrlITWyMWppA4Y/m4mCvr9Z0Ywv06HiUYd
	 XMBcoaSjH9oLSHk5yXWK/Wyz66qm4mSj7lrot4D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1016/2077] perf tools: Fix uninitialized pathname on uncompressed fallback in filename__decompress()
Date: Tue, 21 Jul 2026 17:11:29 +0200
Message-ID: <20260721152616.783823595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 51cdb188edeaf389e4377859b9c483c19ce5a259 ]

filename__decompress() has an early return path for files that are not
actually compressed.  This path returns the fd from open() directly but
never writes to the pathname output parameter, leaving the caller with
an uninitialized buffer despite a successful return.

Callers like dso__decompress_kmodule_path() pass pathname to
decompress_kmodule() which uses it to set the decompressed file path.
If pathname is uninitialized, subsequent operations on the path produce
undefined behavior.

Fix by setting pathname to an empty string on the uncompressed path.
Callers already check for an empty pathname to distinguish temporary
decompressed files (which need unlink) from the original file.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 7ac22b088afe26a4 ("perf tools: Add filename__decompress function")
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/code-reading.c |  7 +++++--
 tools/perf/util/disasm.c        |  7 +++++--
 tools/perf/util/dso.c           | 12 +++++++++---
 tools/perf/util/symbol-elf.c    |  6 ++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 47043a3a2fb4f8..e82ecdc9577785 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -471,8 +471,11 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 			goto out;
 		}
 
-		decomp = true;
-		objdump_name = decomp_name;
+		/* empty pathname means file wasn't actually compressed */
+		if (decomp_name[0] != '\0') {
+			decomp = true;
+			objdump_name = decomp_name;
+		}
 	}
 
 	/* Read the object code using objdump */
diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index 59ba88e1f7443c..0a1a7e9cf3efee 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -1577,8 +1577,11 @@ int symbol__disassemble(struct symbol *sym, struct annotate_args *args)
 		if (dso__decompress_kmodule_path(dso, symfs_filename, tmp, sizeof(tmp)) < 0)
 			return -1;
 
-		decomp = true;
-		strcpy(symfs_filename, tmp);
+		/* empty pathname means file wasn't actually compressed */
+		if (tmp[0] != '\0') {
+			decomp = true;
+			strcpy(symfs_filename, tmp);
+		}
 	}
 
 	/*
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index d878c46de52a79..99199c68d9b5cb 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -343,8 +343,11 @@ int filename__decompress(const char *name, char *pathname,
 	 * To keep this transparent, we detect this and return the file
 	 * descriptor to the uncompressed file.
 	 */
-	if (!compressions[comp].is_compressed(name))
+	if (!compressions[comp].is_compressed(name)) {
+		if (pathname && len > 0)
+			pathname[0] = '\0';
 		return open(name, O_RDONLY | O_CLOEXEC);
+	}
 
 	fd = mkostemp(tmpbuf, O_CLOEXEC);
 	if (fd < 0) {
@@ -598,8 +601,11 @@ static char *dso__get_filename(struct dso *dso, const char *root_dir,
 			goto out;
 		}
 
-		*decomp = true;
-		strcpy(name, newpath);
+		/* empty pathname means file wasn't actually compressed */
+		if (newpath[0] != '\0') {
+			*decomp = true;
+			strcpy(name, newpath);
+		}
 	}
 	return name;
 
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 70f3b553baf082..161539b06727a3 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -919,12 +919,14 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			return -1;
 		}
 		close(fd);
-		filename = path;
+		/* non-empty path means a temp file was created */
+		if (path[0] != '\0')
+			filename = path;
 	}
 
 	err = read_build_id(filename, bid);
 
-	if (m.comp)
+	if (m.comp && filename == path)
 		unlink(filename);
 	return err;
 }
-- 
2.53.0



