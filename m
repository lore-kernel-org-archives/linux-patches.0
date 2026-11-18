Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029542;
	b=rjwj3vZEOQGALGjM7pOI1hQp2nrCnv2EB85Sa6JMgM+1rKRY+RMX8w6ZaqOysD3cLC+Z
	 KshSzj0pahHeI1u72j2NB4w1lMDjtm/CexWnNUH1kefOTINl3sRw5aTQKat7Djtias6lh
	 YBg9WysJsd8xMOsuEpKKJ12uS/W+mm+8HYiD9vvBwhmLyIlEfAb98S0oxo/A4LGCwfrZ8
	 3b7iO+itVmC+Us9SHZzy0iU0EJUw1TKeyANWVB4+HInfYV3poY0fsB6/ntFvHfdmUrdB7
	 79PNxPY7Js0Gsl3gHIfhcvct37R3Vhu7tDmeCiIszQXNFcOrSTx3WRYyeAP3VC3fcuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fXti3HnmpBEDJopym9En98x1GTtxoPfCHbwwyTmmbbA=;
	b=w8w7z6Fm+35doKNxVdFQNGhaDyR0nYfZQIEStEzOHX5jeJPtjIUxu8L3Xv0x7S+nOjhx
	 9PoRXY/q/m5/4b3g6obO4seeHWFCgMRsvmDPJjvmv9n3Ddc+7B5w0GOsfZdyHJrM0QBMF
	 9dMTt6+om9NCv/K6JRP1gbOCXGG5TBjexnUsgzNIELKzTRSLZ1zLIVgXQYTley3017Atr
	 458AWf7RjlG0W2FxsEYGR/B7PDFAKhNkeT0J3oIsBd8f6mwVMb4wZNCh+dlCw7UrLmK8V
	 Gv8pjmEY0Oxump+KeCetYlfWGA7qJfg129PkHnU72/S6U//0sk1r++B+JAQbvy6KWow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V9poecO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B029606A325;
	Wed, 18 Nov 2026 19:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V9poecO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD9F1F000C4;
	Wed, 18 Nov 2026 19:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029542;
	bh=fXti3HnmpBEDJopym9En98x1GTtxoPfCHbwwyTmmbbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9poecO/T3W/AsUhEkgQZCtdSnTdFJc6D+jd12tDWZviCBu7XnAjiyY05jmpDB3Ye
	 05hotQyr8HlzXaMDgjzJvek7pVPnZFFxu4cMy9qdi0XPpR7yl4p/KYljonmUMBTCOU
	 NZj5Y6gWncWaNosNtaHCxGACnMyjEl1p3NiaKNMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0388/1756] perf header: Fix potential memory corruption in cpu_cache_level__read
Date: Wed, 18 Nov 2026 15:41:55 +0100
Message-ID: <20261118150024.096002682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d964ffba01f5d0935dd6bc850029958a62c74491 ]

strim() may advance the pointer assigned to cache->size which causes
later frees to crash.

Fix by performing the strim and then memmove-ing the potentially shifted
string back over the original string.

The bug was introduced by the transition from rtrim() to strim(), as
rtrim() wouldn't move on the left.

Fixes: 13c230ab6e56c6ae ("perf tools: Ditch rtrim(), use strim() from tools/lib")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7b99f58f7bf26..3653696018a90 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1182,7 +1182,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
 		return -1;
 
 	cache->type[len] = 0;
-	cache->type = strim(cache->type);
+	{
+		char *trimmed = strim(cache->type);
+
+		memmove(cache->type, trimmed, strlen(trimmed) + 1);
+	}
 
 	scnprintf(file, PATH_MAX, "%s/size", path);
 	if (sysfs__read_str(file, &cache->size, &len)) {
@@ -1191,7 +1195,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
 	}
 
 	cache->size[len] = 0;
-	cache->size = strim(cache->size);
+	{
+		char *trimmed = strim(cache->size);
+
+		memmove(cache->size, trimmed, strlen(trimmed) + 1);
+	}
 
 	scnprintf(file, PATH_MAX, "%s/shared_cpu_list", path);
 	if (sysfs__read_str(file, &cache->map, &len)) {
@@ -1201,7 +1209,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
 	}
 
 	cache->map[len] = 0;
-	cache->map = strim(cache->map);
+	{
+		char *trimmed = strim(cache->map);
+
+		memmove(cache->map, trimmed, strlen(trimmed) + 1);
+	}
 	return 0;
 }
 
-- 
2.53.0



