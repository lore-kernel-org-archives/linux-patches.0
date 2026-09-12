Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FB14921AC;
	Sat, 12 Sep 2026 19:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240242; cv=none; b=t72nspGu4/GAjbU+uAAuvm+zqP6+by8RufdEaqcPbj4Y1/00riiJd7aha8IGPgGZjLB1Cuaha7477IajT+nvEimOCLB3qEdFe6qjghoPkvnz5/0u5RcCxK9pc0/vtpGEF0nqRAPM+XgNpwDmECxTR8uCVMYM2xRzELypvJHLOuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240242; c=relaxed/simple;
	bh=o/VN6Fz+FotI6zCEKj7mNMx5ITN4cYTduyJOowa4zQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O071IJw/zj4nU3f3pzZmXsGIDmIHZmcCJM2Xi8hAWaOHlFd3BC/V5yqp9n+7yrDA/B7nSFLe5n9o5809eRoWsfklLqaEQJxNOo8kjsrFI7l94/pX5XRdH23EYVkMrH/CAgXHZ0PVrDC8/dDmG2Ml1+crNh4UTUsskCy4eOsZqug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mde5rXUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mde5rXUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0297E1F000FF;
	Sat, 12 Sep 2026 19:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240239;
	bh=uM57r5a+zPP2TkF2h/LHIPwhyhR0RAiPtZIrr1VHFPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mde5rXUpQkfExiwcLJHQqseH/3kScQCgkGjVZQg72hAw+11OgFe4RxhRzlc3hyWFj
	 760CTlA1cjsaPbcZ/K1T2uj+h/oSOQABTHe0RrWPfl0SeFvCmqQFGPux2Clc9RHLX4
	 GoUvrHtQoG+6X9ax78k7k+7QDF9VZQDvPVn6nXvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 829/935] perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()
Date: Sat, 12 Sep 2026 09:04:19 +0200
Message-ID: <20260912065545.838944587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 10f452dc2de401be76ae8e7395c9663313df8b53 ]

dso__decompress_kmodule_path() unconditionally calls close(fd) on the
return value of decompress_kmodule().  When decompression fails or the
DSO is not compressed, decompress_kmodule() returns -1.  close(-1)
fails with EBADF and clobbers errno, which callers up the chain
(dso__get_filename → __open_dso) depend on for error propagation.

Guard the close() call with fd >= 0 so only valid file descriptors are
closed.

Fixes: 42b3fa670825 ("perf tools: Introduce dso__decompress_kmodule_{fd,path}")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 9ed9a5676d352..dc48f3441650a 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -345,7 +345,9 @@ int dso__decompress_kmodule_path(struct dso *dso, const char *name,
 {
 	int fd = decompress_kmodule(dso, name, pathname, len);
 
-	close(fd);
+	/* decompress_kmodule() returns -1 on failure, don't close(-1) */
+	if (fd >= 0)
+		close(fd);
 	return fd >= 0 ? 0 : -1;
 }
 
-- 
2.53.0



