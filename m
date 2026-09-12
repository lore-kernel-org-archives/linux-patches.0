Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C9C20ED;
	Sat, 12 Sep 2026 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225581; cv=none; b=FzOsDxHUPdEseRtMueZk9gqjD6+Uk+n0Urij+AgusNOKTUB1F58PVJ2obOI6EZfp9o0MA1/viw7qDW/KY4TdUD4vFLsiwh5FYikROh0v6RGeoGHe9LQ/HnCO7zkJ6lWeA4PlPh+4j0qJxIheJnt/Vk8eLol+zPxCtRh0ueFcjfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225581; c=relaxed/simple;
	bh=ogYj6ZKl9u5ZOGOKS+dXn4NrG28frt48ZBftsYW2YRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LUhwlJJyyXRhbEQWf9lRxGSbKZ+0mh5E3JQWCtW+D2wrNHtCrf+WGtoUzgfU3dXztvrzuAPZWWp6pNgSh9Ij8tH/PwyJygQ9oee3I2xSyBAL1RJ6jhlEnBV6MFZSIE97WVH05YWcpvRGddOXpD53qThxBiMIhTVlHK/d5+Syaz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWUnT4Yj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWUnT4Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD961F000FF;
	Sat, 12 Sep 2026 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225579;
	bh=QTnGY2aEusDOkSnW3aVmT3T5P/7JC2ADQ8dgq0E4ick=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWUnT4Yjf9RKfgYdwTzx8u5gSB8UU6UJEUXM6RqKq6ChC0WPtGXBH2WW28vsEcY7K
	 8LpHg/QrW/nh6DNHYQE52GwDjWpW1fZvRS3T7cpdVUl37Mt/tFk0GSvPEn7XT8Baho
	 g3afEXbJjyBfE8hwOE1TW6PKJnXd9rY1d72WQ59s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1225/1424] perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()
Date: Sat, 12 Sep 2026 09:00:57 +0200
Message-ID: <20260912065634.717129402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bdfead36b83a3..49af48a5deddd 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -379,7 +379,9 @@ int dso__decompress_kmodule_path(struct dso *dso, const char *name,
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



