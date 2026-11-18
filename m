Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055059;
	b=ZqDl2LxaJUmnU9yCm8LVxgTYkC1pmBFHi8gYwwODx57sDRdgpG51sJjdnO2IjeQLjG12
	 L9rQ3Rynngp7KaqZZdzi53nFv9BPjAablhropLyjNdBhO5UCaezVqT0pP/lh5GluuzoqH
	 SKO1ptKDOPK0zSnnrFZoAQcWPX7mCOJAD68PyMskrk3X24VIt19yiwWwRks9ZT9yiTHSQ
	 1jBEpapB1ybodT6CX2xqYNZI5RRSeA7ONmxzJg8omGCWjCpM+PR7WQHVE9HQO6tbIfhe0
	 riv7Xvp138eQBiV8SMS45YCbJiHijB4i9FL/4OeCZNYrcLGlrIcaBA0tUDar4qlx4+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8lmWfmNqxjOTXQXTgKCzrmFi/Ueg5MF5TLdP10BCDaQ=;
	b=eL4o1xdyKs/4rmew9VxTbdPx8mx7vd8LFL9q0ulH8A9FEPfmqSRx1uyqf3Qk5BrARRsw
	 d4xJGRXhMCSVawgYz+DCtLCRdGKmJj3pMjZ2pxoQv+wZm1hZnUmM5qC72DXdqpaDGHg6O
	 IfEHfG9xJ1eLJ6JrO03rPj/wcDWA4MBaBtM5CO2qrwvBq0ucpd93UKeLm8cg8WnvIttqt
	 UJz4E3NGr9RIyump1B0vid/xRcSbo2JX7xIijLtk5wpEtTLrsEuSeT3tWDYXlzr/ihB+y
	 spj5CXD5FJlUM/0MaTUaz0+im0FO3aGkARgzD0s/pnCXWdEPwyx9J2sovgpYiHM77OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HwkXWbgl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B3F606A325;
	Thu, 19 Nov 2026 02:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HwkXWbgl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B05B1F000C4;
	Thu, 19 Nov 2026 02:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055059;
	bh=8lmWfmNqxjOTXQXTgKCzrmFi/Ueg5MF5TLdP10BCDaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwkXWbglUhc3+5FjdUOQgs1HWte6M4cRH19g1oI09zpXyr6t43HJGZH1TjOmm3wYB
	 8Itw/bdmJ9LnYi/rjjQpZuNsSi3KfkXWRhlRPb2pRLr4Pxhm74ONK0AKKOFk0aPina
	 nvqAipHBJXWWt0+TsLTHjA07vRZe3srqcZpBqRI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1495/2214] perf header: Fix potential memory corruption in cpu_cache_level__read
Date: Wed, 18 Nov 2026 15:52:51 +0100
Message-ID: <20261118150111.349096179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3e18acb719324..2875552767a9f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1126,7 +1126,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1135,7 +1139,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1145,7 +1153,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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



