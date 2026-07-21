Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE1346D2CC;
	Tue, 21 Jul 2026 18:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659657; cv=none; b=qc/9yLHeMc60fS8a5GvPLD5NxtW8H1V36SCCPkY82NL0FDyMJuS0CW0R5hrWwSJwe07QbjR2CTGkr2rDtjv7RgPmp4oFmKroJFVRSO58quzxhEm9oHJsb//rUR5whapdfXlJN96vOgTggjo+YMq18QNAXtkDks4ipOCjPz1jMNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659657; c=relaxed/simple;
	bh=85+jwEy1TkN7LIsy61C3Ly2QEIRgb0jC0eHt+U6wxxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1CFOitL4ehdPxYPuQ8TJNq1S1Y0ZsvR+7qNaw/238ipqYYrSa8p08g52+oJRoS5RTfa5PUKjZFT5OMIdOa+1Zfxd4rd16aSbZxN3R/Usr/NDzIio1aD5mGUtG5zVomVKBtqVqYteoV342Zdxe6p/UTPKTPha0uSJeZQHXUjD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4giZGvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4giZGvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C5D1F000E9;
	Tue, 21 Jul 2026 18:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659656;
	bh=0EH4LU7jwATAAu2NghlJqp377oWHJlPykJxu6HResFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4giZGvG5ffzHKrYLJCfiW+c0cbGNg34M3w6HXwxMG4EEYin77lxqQO46gOMKP1sg
	 vHtEsacLDdWhpxHlgdmLyCdBDSerAv8lG1WOUtEV+8dxLfiH5OQMxJx1MVl+TLK8mQ
	 YzPtO1WufcDsnrvmRxzzRXMPADgzGJ7JgsW+MCGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.18 1603/1611] perf symbol: Fix ENOENT case for filename__read_build_id
Date: Tue, 21 Jul 2026 17:28:39 +0200
Message-ID: <20260721152551.531515898@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

commit 5c5f6fe32df2edb4f72bdca62ec2b9f20b7c5ba4 upstream.

Some callers of filename__read_build_id assume the error value must be
-1, fix by making them handle all < 0 values.

If is_regular_file fails in filename__read_build_id then it could be
the file is missing (ENOENT) and it would be wrong to return
-EWOULDBLOCK in that case. Fix the logic so -EWOULDBLOCK is only
reported if other errors with stat haven't occurred.

Fixes: 834ebb5678d7 ("perf tools: Don't read build-ids from non-regular files")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-buildid-cache.c |    6 ++++--
 tools/perf/util/libbfd.c           |    4 +++-
 tools/perf/util/symbol-elf.c       |    4 +++-
 tools/perf/util/symbol-minimal.c   |    4 +++-
 4 files changed, 13 insertions(+), 5 deletions(-)

--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -276,12 +276,14 @@ static bool dso__missing_buildid_cache(s
 {
 	char filename[PATH_MAX];
 	struct build_id bid = { .size = 0, };
+	int err;
 
 	if (!dso__build_id_filename(dso, filename, sizeof(filename), false))
 		return true;
 
-	if (filename__read_build_id(filename, &bid) == -1) {
-		if (errno == ENOENT)
+	err = filename__read_build_id(filename, &bid);
+	if (err < 0) {
+		if (err == -ENOENT)
 			return false;
 
 		pr_warning("Problems with %s file, consider removing it from the cache\n",
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -426,8 +426,10 @@ int libbfd__read_build_id(const char *fi
 
 	if (!filename)
 		return -EFAULT;
+
+	errno = 0;
 	if (!is_regular_file(filename))
-		return -EWOULDBLOCK;
+		return errno == 0 ? -EWOULDBLOCK : -errno;
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0)
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -916,8 +916,10 @@ int filename__read_build_id(const char *
 
 	if (!filename)
 		return -EFAULT;
+
+	errno = 0;
 	if (!is_regular_file(filename))
-		return -EWOULDBLOCK;
+		return errno == 0 ? -EWOULDBLOCK : -errno;
 
 	err = kmod_path__parse(&m, filename);
 	if (err)
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -113,8 +113,10 @@ int filename__read_build_id(const char *
 
 	if (!filename)
 		return -EFAULT;
+
+	errno = 0;
 	if (!is_regular_file(filename))
-		return -EWOULDBLOCK;
+		return errno == 0 ? -EWOULDBLOCK : -errno;
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0)


