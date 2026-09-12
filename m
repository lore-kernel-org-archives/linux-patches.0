Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ACD47F2C3;
	Sat, 12 Sep 2026 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218421; cv=none; b=p4SkfjYo7BgHwlK2uwBEWp6YN2i8Iuqr3JfJ6l3J8eNwTqkd8ZqlATpAOVRZHXeJY5N0o/yP1sk73WWDna1t5EZIbdJnmyBBtew6svl312FWz7DPuWwW5T+8nGEk0l5f7D5pVz7arm4yb9qfaCWBzbfia9Q8F60zxk5KACzxWWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218421; c=relaxed/simple;
	bh=G5yl87FhKBp/lfhi7QCf6arbMtPLza/MLszTvPrl3oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FCi3lc5PO616Batck4qxZ2IBswBFLH84SC8kvhl74Dk7cpVurLnoeXhG/SVqvE6l6v8rOXcqlScY7kceKtO/VqyNCl5EzTiVGb8CqB5aiVmyBpomDR0HKlsVD3qtVQ4mxoAswDz9rsWa+WwTdh/Mlf9gmTI5kDIFLccsPDdnAG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYXCNkdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYXCNkdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7261F000FF;
	Sat, 12 Sep 2026 13:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218419;
	bh=SZ3JNawQm514tz5eRUOxUFtbz6CY5CP9ybNJ27mD4is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYXCNkdJFbSJhKKbtyzWsNfRbjPjRJY3sco1XpZ7Da3qN+O0k2oSZW6SyupRLjo/+
	 hO4Fkz90nUXaTAMow+NKJNSiXgNqIOV989/FQ7+x4LXTU9MG2QGyfZySH5RGyHRp6+
	 60P7oLFU9i5nwM7fyt2RQAj/SLWJ0yloHeBx6V4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1140/1376] perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()
Date: Sat, 12 Sep 2026 08:59:26 +0200
Message-ID: <20260912065632.966148466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5c6e85fdae0de..654a233326848 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -385,7 +385,9 @@ int dso__decompress_kmodule_path(struct dso *dso, const char *name,
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



