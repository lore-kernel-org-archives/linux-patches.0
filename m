Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D713DD51A;
	Sat, 12 Sep 2026 11:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211302; cv=none; b=kFCRVyfzGnJ7JEwhcmhHA7DUY96nYAO3Btnye2ZO9paze4W/zMsHjk+h3KX/cr2nnVrBHNl8UgfTvaXu0Ds/NZuz/8Kq7+N4gvkbaGhERxF4kncQzMfbwMRdeBhaJ/QdVXRGShpS9Gw0+mY6B2l1m2l5rgdroj4UsfSFbCgIzLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211302; c=relaxed/simple;
	bh=4/L8i8JJBV2kH6gHVl5xfRmptsCDEydoveSWS0WQnYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HpsVf3Hk6vlTY6SPeQWk1yuECB3a0ZgInSf+m/JbSvOmoEF3TmAcWv/SSTOukodAwWySdNXHtNrspD2QPaCGnVJ1RZzt2O3Q+9SYI12jysCq/ldSgxElE9gvosdgNNpziCdnc8zwQESpeESbDyubpMQvgfXVqZbKjjOiaeDOEWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVt8e3bw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVt8e3bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CD61F000FF;
	Sat, 12 Sep 2026 11:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211301;
	bh=wCDraJ9H8u8hOajBv0VUzMfxePvinLYLTe7i2bSs1l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVt8e3bwBo2vQT+2yMeN/tbptg6tqwhOo0h+7DHdAkMmj1ayhlmpIjvKsYEzT9Pbl
	 xZE+yuOB/AOF/ygJ6TCtkbULww3GgVVjSOMsxXnwto/hW17zXbg0kuXObIOlwbgOh8
	 bZ/WPpi82fraKBnokqc0a8N9qMjxWIWFrFEQ8H0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1204/1518] perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()
Date: Sat, 12 Sep 2026 08:56:13 +0200
Message-ID: <20260912065650.722381782@linuxfoundation.org>
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
index 6bff8be805ce5..5e6f7eccb92f5 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -394,7 +394,9 @@ int dso__decompress_kmodule_path(struct dso *dso, const char *name,
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



