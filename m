Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BC333A9FC;
	Tue, 21 Jul 2026 19:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660683; cv=none; b=V6I5nxq0C40Ag+KpqlGHvR9h5hUodl9icIL5Zk8YlJDTzTsoz4MLcUYwz2BBXehLKqOQoxvNqGaq4yqHIHksGfnG+JpQxo1Drmo2txyxqhrmI6R7zMDhRMsxokjVTelhBPB6/HDeknmBfn3fwdrpajlliFvr980pFiXm4/Ui3zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660683; c=relaxed/simple;
	bh=mnH026B41gFGsTai6wDpIwhSPmUDIfYyJ9XdKZiDHnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FCRu4rCSGnLjtyYfVRwukssXfarpAdTE1gxSjODOarYjgrZGuU/B8NMlqOHcz05aRldDE2NL2BlsPp4dXcY/Q1Cx99Nrz9Bl9wuMoKmg0gWiEO3Gy/3rHH3DABXYwONW8SsiI6xKJMhSYx77OllPZ+2bX2UfnW3CBYb6bii4yL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPzjtxn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPzjtxn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656701F00A3A;
	Tue, 21 Jul 2026 19:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660681;
	bh=SsJoHKkzz0DKiTOwC0h7Gc7f1nTQm2GCHs9r6yAjnuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPzjtxn0qRG9n7v8u7S6k5BkBgqMTT/SvOuv9DrzRo8KGI/nE01os4riDIth0m6Gm
	 uulfVKhLnSEYJ+49/zmaUrN7n0xlQt7LV2Hwz/4JdyZ7KOQdAFyRwgf1q1XZss7qq1
	 25tX3ev18rcu17uOLOQqsIlgknqnPEFwwLdazX5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1073/2077] perf dso: Set error code when open() fails on uncompressed fallback path
Date: Tue, 21 Jul 2026 17:12:26 +0200
Message-ID: <20260721152618.131441197@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit d2c6069d68ee9d53b05fe38bc2049cc4286fbb16 ]

filename__decompress() has an early return for files that are not
actually compressed, where it calls open() directly.  When open()
fails, the function returns -1 but never sets *err.  The caller chain
(decompress_kmodule → dso__decompress_kmodule_path → dso__get_filename)
then reads *dso__load_errno(dso) to set errno, but that field was never
populated, so errno gets a stale or zero value.

With errno=0, __open_dso() computes fd = -errno = 0, which is non-
negative, so callers treat fd 0 (stdin) as a valid DSO file descriptor.

Set *err = errno when open() fails on the uncompressed path, matching
the error handling on the compressed path at line 354.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 8b42b7e5e8b5692b ("perf tools: Add is_compressed callback to compressions array")
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index e896e6da81e96c..233c313bf3311a 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -344,9 +344,12 @@ int filename__decompress(const char *name, char *pathname,
 	 * descriptor to the uncompressed file.
 	 */
 	if (!compressions[comp].is_compressed(name)) {
+		fd = open(name, O_RDONLY | O_CLOEXEC);
+		if (fd < 0)
+			*err = errno;
 		if (pathname && len > 0)
 			pathname[0] = '\0';
-		return open(name, O_RDONLY | O_CLOEXEC);
+		return fd;
 	}
 
 	fd = mkostemp(tmpbuf, O_CLOEXEC);
-- 
2.53.0



