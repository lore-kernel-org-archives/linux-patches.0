Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016208;
	b=J7o5/gqZkkfw/nQwhRO8s04tMUBY1BOyjrOCX2Y3A10X/lMzmPhL+zO2dFe2CpXrILbf
	 y21Z+HeiA1H/xQe39lrI1b0OgouXCMb5W9tZHMl8rFY9h8P52UqxXMmPcEq1B80KTwpby
	 p8jTWIf+68nTEmU22mHejB12fv+bq8hRmdgFzTf8EnGmJtLCjd2gzW1vYQFezBUMgOaq9
	 tw0G4H5iTOQ9bBBsEq+zz6wyCaeJ40kgp8HhjCt8BSOPBq6ZFSFnX03wdSykwHfKUfnwN
	 Yb5sLP+pHE3PYnXmG0hSrKlvxpYTNoin8OmpSf4NLvn+QQ9lhrW1GxUC4a6bZiGqQbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yRQxLKyK4CQmqAtIlOT2HHHeOECien5nZLUd1ehxLBs=;
	b=NCzHPmXbqzYCfd5O5KfjrFKhthppdyAyy8PgXT2YgAWnkdX3UNVhGVHBxW6XwXdpoWS1
	 n1ldRJ4Bz/QS6bitnFVcCUlB1o0DVCMoPRMNvmWY8ih0AoQL+XvzDOODJZ95XyIpAsfy8
	 8qfmQe4MLKPgYS9Z6zdwpBdJAP3NfTYDVJB8kY8hwdzNubHEVIYwKQCJNVk37riMvG788
	 TZOSojbGqisJ0wjUh9YKhLh8bRmuw5kMcE8MBfabRTlmV8RoBWylvK6Ibod/FUyIzwCU9
	 oToAcBK17TswEJD7haMdOXoN/34CnWNeTL2RYwaNcfJmGvXJNEM1TwytS7dQfW9oXCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCBxlyEa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424AE606A320;
	Wed, 18 Nov 2026 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCBxlyEa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8D01F000C4;
	Wed, 18 Nov 2026 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016208;
	bh=yRQxLKyK4CQmqAtIlOT2HHHeOECien5nZLUd1ehxLBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCBxlyEadlXryjDzD+6M3LC48tZ817VDZdfURJLo4SteMx3VMBLvgeM5fdA5tUvGf
	 qgUsB7k/03ESeESMk1c+rXWRBtoSV07ek3XbQ7TXLmA2/xlfzYt5PHVLHm+5dZQyM2
	 hgErtDOTjMsB+NJYYcYrcZip3xGOLqUcpENCUexI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0447/2651] perf header: Fix potential memory corruption in cpu_cache_level__read
Date: Wed, 18 Nov 2026 15:28:07 +0100
Message-ID: <20261118150303.904908315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7db7da090a1e0..128aff15fbbe6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1264,7 +1264,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1273,7 +1277,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1283,7 +1291,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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



