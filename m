Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339E73090D5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300886; cv=none; b=W7n1jcLLI7r2t5Y6TggNmKVUiD6iOeDY4Vx5mJpVUw4/oFyxT8cK0rr1UvBgsVrzGpWOWG9XvaPRbeiKXRQAa52Pr9oFDSq2ppRHje1IWmzrjOZcDTpxT1AkoDQBb1rmKpn4skA1MxdcM9zwo4hZnVvCCBWwJQl9S0t29sobHro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300886; c=relaxed/simple;
	bh=YguACwKeqrdXixPWz4QFCRIZisZJoePDLuE9Nvn+DJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idzwrGjnMvqzvKwARGr+lgKK87yTsIGuNmrh27Kh/7L9VaSEqFQEoaFTLmr0q0k/pqGzsRGwgYOyZV1lmS5H2Z4TezQRJhjY+jY+jwjdoITsKpAaAH3Wx7Xdgwri4f8tZOqvllals9OeuIhvtgAp4DxcXolOVzoCV23DpMTRiHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWS2YMUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWS2YMUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B0EC19423;
	Sat, 28 Feb 2026 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300886;
	bh=YguACwKeqrdXixPWz4QFCRIZisZJoePDLuE9Nvn+DJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWS2YMUEfIwYYerEI8IZA7AafwAzuM8kSwZCrwBv+kZhG3NCH+I7LG8ifyTpOWEvc
	 dlal9xxOLmohCOqpEyngn/egreLaoKHpX0F7ZEGPIt2i53AoPo1+0PAQNBRMwWdwP4
	 up1/nOd9BVb+E9R9iaSPEBvyRaTCWune1ZWmMT1PY3b3eXMUkk+HFgPgAh373E2blo
	 ZRWn0ID2Ui3Lh3A0/c2zYcv1KDnXdKBRh4yKRYq0sX6PReWjp12KEony1C6i+W5EWy
	 ySZp9dhS0lm0sDj6xVvW92nJenOCMa3c8KSiasDaRxfFdjjAVi/QTGbVM8Y1KOwEqJ
	 zh+4tqpYeDFLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/752] perf tools: Get debug info of DSO properly
Date: Sat, 28 Feb 2026 12:35:20 -0500
Message-ID: <20260228174750.1542406-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 069e603d8248dac98b1ef2909e2f1c4169b9da11 ]

The dso__debuginfo() just used the path name to open the file but it may
be outdated.  It should check build-ID and use the file in the build-ID
cache if available rather than just using the path name.

Let's factor out dso__get_filename() to avoid code duplicate.

Fixes: 53a61a6ca279165d ("perf annotate: Add dso__debuginfo() helper")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 63 ++++++++++++++++++++++++++++++++-----------
 tools/perf/util/dso.h | 11 ++------
 2 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 344e689567ee1..dc202d4943721 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -111,7 +111,7 @@ bool dso__is_object_file(const struct dso *dso)
 
 int dso__read_binary_type_filename(const struct dso *dso,
 				   enum dso_binary_type type,
-				   char *root_dir, char *filename, size_t size)
+				   const char *root_dir, char *filename, size_t size)
 {
 	char build_id_hex[SBUILD_ID_SIZE];
 	int ret = 0;
@@ -563,20 +563,15 @@ char *dso__filename_with_chroot(const struct dso *dso, const char *filename)
 	return filename_with_chroot(nsinfo__pid(dso__nsinfo_const(dso)), filename);
 }
 
-static int __open_dso(struct dso *dso, struct machine *machine)
-	EXCLUSIVE_LOCKS_REQUIRED(_dso__data_open_lock)
+static char *dso__get_filename(struct dso *dso, const char *root_dir,
+			       bool *decomp)
 {
-	int fd = -EINVAL;
-	char *root_dir = (char *)"";
 	char *name = malloc(PATH_MAX);
-	bool decomp = false;
 
-	if (!name)
-		return -ENOMEM;
+	*decomp = false;
 
-	mutex_lock(dso__lock(dso));
-	if (machine)
-		root_dir = machine->root_dir;
+	if (name == NULL)
+		return NULL;
 
 	if (dso__read_binary_type_filename(dso, dso__binary_type(dso),
 					    root_dir, name, PATH_MAX))
@@ -601,20 +596,38 @@ static int __open_dso(struct dso *dso, struct machine *machine)
 		size_t len = sizeof(newpath);
 
 		if (dso__decompress_kmodule_path(dso, name, newpath, len) < 0) {
-			fd = -(*dso__load_errno(dso));
+			errno = *dso__load_errno(dso);
 			goto out;
 		}
 
-		decomp = true;
+		*decomp = true;
 		strcpy(name, newpath);
 	}
+	return name;
+
+out:
+	free(name);
+	return NULL;
+}
 
-	fd = do_open(name);
+static int __open_dso(struct dso *dso, struct machine *machine)
+	EXCLUSIVE_LOCKS_REQUIRED(_dso__data_open_lock)
+{
+	int fd = -EINVAL;
+	char *name;
+	bool decomp = false;
+
+	mutex_lock(dso__lock(dso));
+
+	name = dso__get_filename(dso, machine ? machine->root_dir : "", &decomp);
+	if (name)
+		fd = do_open(name);
+	else
+		fd = -errno;
 
 	if (decomp)
 		unlink(name);
 
-out:
 	mutex_unlock(dso__lock(dso));
 	free(name);
 	return fd;
@@ -1910,3 +1923,23 @@ const u8 *dso__read_symbol(struct dso *dso, const char *symfs_filename,
 	return __dso__read_symbol(dso, symfs_filename, start, len,
 				  out_buf, out_buf_len, is_64bit);
 }
+
+struct debuginfo *dso__debuginfo(struct dso *dso)
+{
+	char *name;
+	bool decomp = false;
+	struct debuginfo *dinfo = NULL;
+
+	mutex_lock(dso__lock(dso));
+
+	name = dso__get_filename(dso, "", &decomp);
+	if (name)
+		dinfo = debuginfo__new(name);
+
+	if (decomp)
+		unlink(name);
+
+	mutex_unlock(dso__lock(dso));
+	free(name);
+	return dinfo;
+}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index f8ccb9816b89c..54e470dd07305 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -766,7 +766,7 @@ int dso__kernel_module_get_build_id(struct dso *dso, const char *root_dir);
 
 char dso__symtab_origin(const struct dso *dso);
 int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type type,
-				   char *root_dir, char *filename, size_t size);
+				   const char *root_dir, char *filename, size_t size);
 bool is_kernel_module(const char *pathname, int cpumode);
 bool dso__needs_decompress(struct dso *dso);
 int dso__decompress_kmodule_fd(struct dso *dso, const char *name);
@@ -915,14 +915,7 @@ u64 dso__findnew_global_type(struct dso *dso, u64 addr, u64 offset);
 bool perf_pid_map_tid(const char *dso_name, int *tid);
 bool is_perf_pid_map_name(const char *dso_name);
 
-/*
- * In the future, we may get debuginfo using build-ID (w/o path).
- * Add this helper is for the smooth conversion.
- */
-static inline struct debuginfo *dso__debuginfo(struct dso *dso)
-{
-	return debuginfo__new(dso__long_name(dso));
-}
+struct debuginfo *dso__debuginfo(struct dso *dso);
 
 const u8 *dso__read_symbol(struct dso *dso, const char *symfs_filename,
 			   const struct map *map, const struct symbol *sym,
-- 
2.51.0

