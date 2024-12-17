Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458D71F76A9;
	Tue, 17 Dec 2024 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456610; cv=none; b=dLPOtfvlEjWtBiseksd4vi2Dh8fHVVPShc1teLB2Jt5+Z2bQBf28w71gM2gLVQNn0oVUrJLQ0A0WTC3Euf/pOYx2g23EjMkwAMLbSE9QxXDceri+74cZJkH7SZNTPbtf6048yVP5H0b3s0R1T+I7qFZcgfpDj8koMsVB0XzgKPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456610; c=relaxed/simple;
	bh=hM5ygfvErfAFKo2X4nJd+y1l+MIB2FltWmk6kpz2opk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jd5LwzocXmPpC+ybSimgFUbzNyIz5bOxh1PtIzyoxWGACWmlFoB26jm5OctyAGbzZC6O5lC+dTZSLFCSg9MsyuUC6aBvjxvOUwCe9u5jauE62PdKI06uBDTzncrj1ZfZsLwSFpqmmmJvTq235O+23xf/W75TzvpMmHoNrayfe9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuK/r92t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuK/r92t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836C8C4CED3;
	Tue, 17 Dec 2024 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456610;
	bh=hM5ygfvErfAFKo2X4nJd+y1l+MIB2FltWmk6kpz2opk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuK/r92t2x9mMVbsspdoTRcl8jx7hw9dTRk/OHTojhYRiscUn51MQ+3qyyv0QGZCY
	 L+22+XGu2GQKgrGS9A8Uk4OM8xtgRWv3z++OTIXiSyUryRxOQ35BkWBVwqFecJYHIA
	 uP8tJQvOVKedk0LNMm1RXbv9hbGpZq5baYNH4O0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/172] perf tools: Fix build-id event recording
Date: Tue, 17 Dec 2024 18:07:18 +0100
Message-ID: <20241217170549.689222381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 23c44f6c83257923b179461694edcf62749bedd5 ]

The build-id events written at the end of the record session are broken
due to unexpected data.  The write_buildid() writes the fixed length
event first and then variable length filename.

But a recent change made it write more data in the padding area
accidentally.  So readers of the event see zero-filled data for the
next entry and treat it incorrectly.  This resulted in wrong kernel
symbols because the kernel DSO loaded a random vmlinux image in the
path as it didn't have a valid build-id.

Fixes: ae39ba16554e ("perf inject: Fix build ID injection")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/Z0aRFFW9xMh3mqKB@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/build-id.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 8982f68e7230..e763e8d99a43 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -277,7 +277,7 @@ static int write_buildid(const char *name, size_t name_len, struct build_id *bid
 	struct perf_record_header_build_id b;
 	size_t len;
 
-	len = sizeof(b) + name_len + 1;
+	len = name_len + 1;
 	len = PERF_ALIGN(len, sizeof(u64));
 
 	memset(&b, 0, sizeof(b));
@@ -286,7 +286,7 @@ static int write_buildid(const char *name, size_t name_len, struct build_id *bid
 	misc |= PERF_RECORD_MISC_BUILD_ID_SIZE;
 	b.pid = pid;
 	b.header.misc = misc;
-	b.header.size = len;
+	b.header.size = sizeof(b) + len;
 
 	err = do_write(fd, &b, sizeof(b));
 	if (err < 0)
-- 
2.39.5



