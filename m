Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16044377A9F;
	Sat, 12 Sep 2026 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231699; cv=none; b=RJJK11IuaChnBXEDnS8oWP03SRGN4WuzbEyDK8ADbu8BCxHwvg4CAKzSo1E3XUgNdZjZf8B+djWGrw527D1W1zQM8AMnlAm6xcFtfmJMdKtWVy5uPW/doPvdyUgKDkAlzDdhJcB/Y6jvDYEeX86xGoHXB2paKmW5EvslPx1sQkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231699; c=relaxed/simple;
	bh=gsRwEEJFOSc1RRcpV1LCuYQeRDnElMjgcim9qATiPk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oi3HifXqGh61dCTmhV8Ae1fHDR8QU/FrUqEnPkcCKkItSsvKEZ6CA/pH8//HAsxNngYu4X9obvH434v3MIx7rmHqoxv8IGHc7fEzLtw4pFJArmNdk5/nDqQLltgGkpPfTPj8Dk0G29pckyoYrZ2uPToq2iYnnL8iagcruh65D3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vP68ANGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vP68ANGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0111F000FF;
	Sat, 12 Sep 2026 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231697;
	bh=W8Cdg9m9s7jI1BHP+JAu5slbHbDfqWwpwobI4eE7sdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vP68ANGYSfzR0IwWz5jXLYKqfKXCMuR8JsMsZokKLRkc49FD+mLVVGnIF2BTdn/TF
	 vggqT2lnk6FjSZdvBBS8uhLQWr4Xf+o7/yGcVBsVAjLSzzxXHTBWUJ5Oenpl/SvlOT
	 IfwkC4zX2WXC2rO2iPtEXjIBh7PPIE+EtWu8oi5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1015/1191] perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()
Date: Sat, 12 Sep 2026 09:02:23 +0200
Message-ID: <20260912065610.989748800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f1a14c0ad26d5..6b08278a4b7bd 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -346,7 +346,9 @@ int dso__decompress_kmodule_path(struct dso *dso, const char *name,
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



