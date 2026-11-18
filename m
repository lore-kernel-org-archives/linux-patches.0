Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060689;
	b=PksIZABeSTWymMR5HuLC5EMVOWC9oYivs8grGd1fF0pL/G4E9VwvKxN/aLAUbNm5MiQo
	 8A8WvnQ9Dskd1pZwrnIEAfNKkn6DmhrggtgYbyQXgEjxV0WcycY/2USzTfvljDlyDbyEG
	 obkONn2i3EiteKeu9TenxA1HQBv0gIhPivBZzLb7r0NNSk0XcOh+nlJB80kGrhwBOSFqG
	 ZPruWKfEITHusK20USoNB8vxZXtVqr06aH006OYXZB2OiMn8c54bJDqKZOSBIG6grHwX+
	 M4RmHXIE1V3Rh2g7wcXwNU3VJUTOG8QlRjd1nz3KA7Q/MpuvmgA7nfT9UTSXQrLnvlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kvrwsV1EG9Yj0hVQxOgmE/ljWIoRI4Ct0FYVHRKZsXk=;
	b=3ZpgMgDzbiJHFllmke3RY5k6gG8CCTDyKX0Br7rSU7QVlMWOFjoiWZGi3saVrwzCQ7AB
	 JzSArKQXgwOwlt+2ipWXIuDisxdOEIKOvFZWnJYfi3go9g+Pk/w2gY2spQaKX937Th2os
	 QFbaIOGgb+bZbB1QTPjTnCe8VYz8FuaACUrJqbhNqT3576pU8tnyUrxRzg11EEafoW2xn
	 RrivZe9pK0hGp3+kHfdLGmnoGlGBnJKJALXTPrQVjCgRd50RG4YrYfZKaq8HyPAQdteRo
	 kJjRaBbOV1Tuul928epZojjk7tjH2W07UMdg12vngHBMxvQN9yNOQ8joXXjQpsqUu5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1a+77Dp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB001606A325;
	Thu, 19 Nov 2026 03:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1a+77Dp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C84C1F000C5;
	Thu, 19 Nov 2026 03:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060689;
	bh=kvrwsV1EG9Yj0hVQxOgmE/ljWIoRI4Ct0FYVHRKZsXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1a+77DpDLmgSgJsMNVZbkcJHAqm+stLogYVv8ZzExKAaR7kiTm5CnKf/+XHSTzUT
	 wGn4BACPYcO68ejLw/xXyVetSa91CpY44yPQruh3I1k0q7oC2dbSUIJidtscXl4Pny
	 0DWg0pz99ZyeDVgbv/kevSCvNvdDghhGgtj42xLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1247/1848] perf header: Fix potential memory corruption in cpu_cache_level__read
Date: Wed, 18 Nov 2026 15:54:45 +0100
Message-ID: <20261118150012.010101354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 94b9c96c29d58..d2a2e526ddb07 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1091,7 +1091,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1100,7 +1104,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1110,7 +1118,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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



