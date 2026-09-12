Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA4A356744;
	Sat, 12 Sep 2026 11:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211307; cv=none; b=DXiQZ0PqzFhGYElqh5jG20jdHJBKffUF8aHIJMI24mAFaXfSdRcmte7UQeY/2JRUUQy5sE/ZAFdBX1J7XFzolfM2QCy8BPwKddCdrNEDV/tArhAGi3hjq4DQzTK13ifdp63hJZpnDukd8o3t1ExUahny9kSDaT14QEP8DYbG/JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211307; c=relaxed/simple;
	bh=gxF4B4rYsFbTKDzwMhSlV6/G4scBfmnps8xgdiX5h6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rvXv1ZHCwyeDoUu4Gh5y0XdUcpQtGowblXtGlMgBq7miQmTKlxqsV+tBa/UdfMLOb6q/OoiAe9kZaNizmWmrzEcoEEq+sPmaiIuMvDWo1jnJE2WuHa+ggiN6t8nmtCc5Y7L87l9O15pFl/pCi1kyuQkw6jAFKCTa9cDRH1g5jsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT4j/0DA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT4j/0DA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3586B1F000FF;
	Sat, 12 Sep 2026 11:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211306;
	bh=QhgUM7qtm4Y8nVp3SDndIMLXgXMnn98VknpSLd/XLdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fT4j/0DAxFhp7eJySWr1agL5P+hZYPkt2EvKAkXP4JRk1+tuppGgfQNndbZzhkvpv
	 IXfdmJzuOCupwb+L1E3g+O6IBwrlp+3jT4p63GjPRh2eABc/QN6cCnR/wFQCIWX4so
	 rA/apFUkUltKrMYcdc1Cro8l/QWcaahkdKURc4aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1205/1518] perf dso: Use stored fd error instead of stale errno in file_read() and file_size()
Date: Sat, 12 Sep 2026 08:56:14 +0200
Message-ID: <20260912065650.746761846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 075d2c32353ded0fe5f3b62f4aa4e98dccb3fb29 ]

file_read() and file_size() use ret = -errno when
dso__data(dso)->fd is negative after try_to_open_dso() fails.  By this
point errno has been through mutex_lock(), nsinfo__mountns_enter(), and
multiple open() attempts inside try_to_open_dso() — it no longer
reflects the actual open failure.  If errno happens to be 0, ret = 0
looks like EOF rather than an error, and file_size() callers like
dso__data_size() would then report a zero-sized file instead of
failing.

dso__data(dso)->fd is always negative on failure — -errno from
__open_dso() when no filename could be built (e.g. -EINVAL, -ENOENT),
or -1 when do_open() itself failed — and never 0, so use it directly
instead of reading the stale global errno.

No assert() or comment is needed after the assignment: the enclosing
if (dso__data(dso)->fd < 0) already guarantees ret < 0
[Namhyung Kim review].

Fixes: 33bdedcea2d7 ("perf tools: Protect dso cache fd with a mutex")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 5e6f7eccb92f5..c58c3b345debe 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1037,7 +1037,7 @@ static ssize_t file_read(struct dso *dso, struct machine *machine,
 
 	if (dso__data(dso)->fd < 0) {
 		dso__data(dso)->status = DSO_DATA_STATUS_ERROR;
-		ret = -errno;
+		ret = dso__data(dso)->fd;
 		goto out;
 	}
 
@@ -1159,8 +1159,8 @@ static int file_size(struct dso *dso, struct machine *machine)
 	try_to_open_dso(dso, machine);
 
 	if (dso__data(dso)->fd < 0) {
-		ret = -errno;
 		dso__data(dso)->status = DSO_DATA_STATUS_ERROR;
+		ret = dso__data(dso)->fd;
 		goto out;
 	}
 
-- 
2.53.0



