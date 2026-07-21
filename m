Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD7F40587A;
	Tue, 21 Jul 2026 18:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657467; cv=none; b=tRCZFDBbeGdAtWp/RXb2B/XcUc4QSsFqF9oG9QjUAj5cxl9PnEAheTUCfu5FJCHEgrQ87KVsGjkVwd4J+jb1y8houTPXM87Gd6SnP3ZW1+AOwYLb+1oEjettX99zWPh2dStMR2og2PjJ0bmBZFpUTqvGRfVZt8qBWd+8zl4QNCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657467; c=relaxed/simple;
	bh=PoKEV8s38wM+PCWizvijWve3qy4jk0Vceew1AUNNzAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggAqEN+B5+6EJFKnPvVpoqp4CRXsA6nPvHHqsuVbH8vMeL//9WmEWq1ZZo7xG3dylZ9SsKHcbkGf3OSl67CyJZpA9UaalUNofUexsis8nQbYFvkFVRU21tLGnn2JXZ9fwHEwCNhApJpmySfMxBAdGI9B7MNrQSmpNoQPdLM8ej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbHswRuy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbHswRuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263A61F000E9;
	Tue, 21 Jul 2026 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657465;
	bh=K/peCKyUcUEyYV+v8BXoEFoYZ5Yb2NlR4avbHo1e9NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbHswRuyZ2kY+rd61yMq8OzWjtoCgCxNzaokhPVOO1S55aYySpqvIa7YQmfzHOM9L
	 zWzgs19lOn72jVrOBfUbih3SRgeZtLAP9UzBamQL2ky1+wDKLNZpmqM+tnM4qf6VyL
	 BFinBw3mx3tXH2vZrqDrj8vYosKCXyetSkMjg93w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0774/1611] perf tools: Fix uninitialized pathname on uncompressed fallback in filename__decompress()
Date: Tue, 21 Jul 2026 17:14:50 +0200
Message-ID: <20260721152532.796623277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
Stable-dep-of: f973e52a9977 ("perf dso: Fix heap overflow in dso__get_filename() on decompressed path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/code-reading.c |  7 +++++--
 tools/perf/util/disasm.c        |  7 +++++--
 tools/perf/util/dso.c           | 12 +++++++++---
 tools/perf/util/symbol-elf.c    |  6 ++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 4c9fbf6965c4ad..4e759b8989806a 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -465,8 +465,11 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
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
index c513db41137fa4..61a18639903542 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -1684,8 +1684,11 @@ int symbol__disassemble(struct symbol *sym, struct annotate_args *args)
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
index db0513936cea88..1205224e110375 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -342,8 +342,11 @@ int filename__decompress(const char *name, char *pathname,
 	 * To keep this transparent, we detect this and return the file
 	 * descriptor to the uncompressed file.
 	 */
-	if (!compressions[comp].is_compressed(name))
+	if (!compressions[comp].is_compressed(name)) {
+		if (pathname && len > 0)
+			pathname[0] = '\0';
 		return open(name, O_RDONLY | O_CLOEXEC);
+	}
 
 	fd = mkstemp(tmpbuf);
 	if (fd < 0) {
@@ -600,8 +603,11 @@ static char *dso__get_filename(struct dso *dso, const char *root_dir,
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
index 0dbc3d56a00a1f..491f43a68540dd 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -933,12 +933,14 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
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



