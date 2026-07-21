Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9144946EC9B;
	Tue, 21 Jul 2026 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660523; cv=none; b=WnUl3kvGUVl3FJh3antBWVsKBWNuNciEQTFhu6imhy+lFFvTcfpTe/AAmO4lCJpkKXwMOmQSSL2Q3PImNvpRVrA9UkMzBDRH+FCRYwQOqJxgezCSTBhtCSe8Jt+icLGz4JUCaQrUtg81jsVAIG91vaHylk/L/sTLurXZEXtsrO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660523; c=relaxed/simple;
	bh=ERlScBrfrEg5//qeKVfmoUCQP11+M0lhYn0ZwSzE70g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWBDwmoQEdBinDvhFtljLQLmgFHYZvBCpAq27USm3iP6FoxifHCqurmQx0DqO6DXelEYHOkT6IqOm353l7lu/h539XxDhD04KGBkcxOCPZR3Ybf0tqGzOcuH8BTMozXjbTCQz5rpKvfilhuOUd+nmtf+NqOBEyOGkGkBeIWFNY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO17nJrF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO17nJrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD611F000E9;
	Tue, 21 Jul 2026 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660520;
	bh=gsCvMAtHYLUeWI2ymABZ+wEmsUReXAB4pGgiWqDpQ7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tO17nJrF+0e55gyE9lxpjfJFlesYNAczjpcVP8XhPLTgwMky05nxh0K9But2TEN1x
	 XUuqqusdL/QFq4P/4jqrfvuh1m+eM+B99L3yKf4NJo4W/a5rCP3NBTAndIR/SFvudo
	 yyvdQ+SbC/3g5BOfeKU1qvJ3MbOCBcn4JCGfzBjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1009/2077] perf tools: Use mkostemp() for O_CLOEXEC on temporary files
Date: Tue, 21 Jul 2026 17:11:22 +0200
Message-ID: <20260721152616.614653274@linuxfoundation.org>
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

[ Upstream commit b8acc68f1382a3f380a0e7320a95d328ac5e9027 ]

mkstemp() creates file descriptors without the close-on-exec flag.
These fds leak to child processes spawned during symbol resolution
(addr2line, objdump), wasting descriptors and potentially exposing
temporary file contents.

Replace mkstemp() with mkostemp(tmpbuf, O_CLOEXEC) at all three
call sites:

  - filename__decompress() in dso.c
  - read_gnu_debugdata() in symbol-elf.c
  - kcore__init() in symbol-elf.c

Fixes: 42b3fa670825983f ("perf tools: Introduce dso__decompress_kmodule_{fd,path}")
Fixes: b10f74308e130527 ("perf symbol: Support .gnu_debugdata for symbols")
Fixes: afba19d9dc8eba66 ("perf symbols: Workaround objdump difficulties with kcore")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c        | 2 +-
 tools/perf/util/symbol-elf.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 511e91843fbd8e..d878c46de52a79 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -346,7 +346,7 @@ int filename__decompress(const char *name, char *pathname,
 	if (!compressions[comp].is_compressed(name))
 		return open(name, O_RDONLY | O_CLOEXEC);
 
-	fd = mkstemp(tmpbuf);
+	fd = mkostemp(tmpbuf, O_CLOEXEC);
 	if (fd < 0) {
 		*err = errno;
 		return -1;
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3b2e31367196c2..c415670453bed9 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1118,9 +1118,9 @@ static Elf *read_gnu_debugdata(struct dso *dso, Elf *elf, const char *name, int
 		return NULL;
 	}
 
-	temp_fd = mkstemp(temp_filename);
+	temp_fd = mkostemp(temp_filename, O_CLOEXEC);
 	if (temp_fd < 0) {
-		pr_debug("%s: mkstemp: %m\n", __func__);
+		pr_debug("%s: mkostemp: %m\n", __func__);
 		*dso__load_errno(dso) = -errno;
 		fclose(wrapped);
 		return NULL;
@@ -1986,7 +1986,7 @@ static int kcore__init(struct kcore *kcore, char *filename, int elfclass,
 	kcore->elfclass = elfclass;
 
 	if (temp)
-		kcore->fd = mkstemp(filename);
+		kcore->fd = mkostemp(filename, O_CLOEXEC);
 	else
 		kcore->fd = open(filename, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0400);
 	if (kcore->fd == -1)
-- 
2.53.0



