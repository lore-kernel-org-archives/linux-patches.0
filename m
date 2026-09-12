Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB47299920;
	Sat, 12 Sep 2026 09:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203748; cv=none; b=H/1V09VWODKkOTmtrN2sSJ4s46FQIt0h9aqZzlcHhBU0CPcYPSxvlbSRedmd5VqUrEqcuyD6OS/xE0L6EpIvKmPDalMYswmOObBJh57HEIF3IXi/cgoJZvySrHPWZW724qq6MF0PpS9fijME5OwPVSHIFhVKE43emijeHkhr4Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203748; c=relaxed/simple;
	bh=XMXA21z5TxNJmY5AgsI8UoLm1secUDRPV8OvJ/k6Scw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tj0LbTaKRh+UeViTS5HNAGv1aOEx8L8ypD8UyNRQV2xAb/2MyM11+4moxqifoSfwsRAVNj7aiId4oQaudcYm67MBd08F70tiJYbYlo4bw9gGBeZ9/2PbOKVL7bSovQp7tTiDASNUcyzBLj5MCDtuDLi5fqlmGynyaEKtrTN6mc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVvvWdqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVvvWdqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81D41F000FF;
	Sat, 12 Sep 2026 09:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203747;
	bh=hHJvxijNCtStS06NITTpRWre7aOoyI4h3izg0W0RSkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVvvWdqisTG3JTtrzQtG2l8fyjvTKXyCfyMho2PunEnxVdR9biRD/cID7BChfiuj1
	 W/E2bpxsllgb0gk2tvbPzpaOKpUaDM526a4fa17rUeaM/AGeogtj9z+Ew/rKQ1Ns/V
	 gmcdsINr4fj3px+EmIAulOYTS3xxQIKwzsBf41Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1472/1815] perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()
Date: Sat, 12 Sep 2026 08:53:42 +0200
Message-ID: <20260912065723.566710264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b86969dc6e81e..41bbc8f994e41 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -395,7 +395,9 @@ int dso__decompress_kmodule_path(struct dso *dso, const char *name,
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



