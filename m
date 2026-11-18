Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048214;
	b=oGJfNmbGvNJ8Q4Ba5AEx1hjbtj42NCQE7fjM7aQAS1U7T1X1faUYAeJ9eumvrr58uMzN
	 Ki/Gpd5zS6PDtJVU6yVwpQW5siWpnVzW2e2NUi0fwzPa3RvQG/ROLe/rSpOmq1rxhM22Y
	 0g4xGVhfOFph44Z0v76xzAiuuErMNLHNwT1QDYgJsRG8N0xZutsjz/4HeNBxBJuUApHmy
	 dLtTcb2w99KmTUEm5V+sA5ODpJc5H5rNlimTiTHo6u4KJ2PbjewyaxzdQHy1nHEmQ9DGe
	 7ZgWSm0w9zq7XLPNuLLduS497fyE+amuFCsDzznPAeiZxU7XS9+5vDac0GmNfH3gs2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYx7vlyDFiLXWHR2INUW504bl+Zgdguy3DnIZK32ZTc=;
	b=lLczKifH8FcKkF5XkqjGoXg8wypo8T8seO7F6FvKPDsvhIquWLBra6ubmXsDC0OeVcfD
	 nBH2wz1GwSko5Tr9MtRP/+sU2Xb6MtEzXbKwiC6ioHzUEahop9W8ckRI/zuWLcq4OTxTO
	 ls9d/mGIwJInFdiwbAtSlDnuilV/+QLD4okESFD3phkXyQ6OekZhhHdB0wHvzKUTeUDCi
	 HjsadrbT3r7UgzvARmXRQxJOdbotIQ1630j27m4TCa044iq+ku1FAg2o2C/iVk3t0M7+I
	 YJ9w5bi6PH/3axmzgLKKBK8BWDo7C7VJEsPLeUww896CnwKIau216LS95RIAIuqur0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iY9Jr3LO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F3160A2607;
	Thu, 19 Nov 2026 00:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iY9Jr3LO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04081F000CA;
	Thu, 19 Nov 2026 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048214;
	bh=tYx7vlyDFiLXWHR2INUW504bl+Zgdguy3DnIZK32ZTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iY9Jr3LOiAz/RzRABMVG8gqERJgzYS/zEmk8S1uYYk/581f31TT9dPoPkZgw4JFIm
	 XGqWVRWZPKg45d79lNhApdVszN2LRJn1j8kJ934miTa5vUSXcDI0wro24VvutD1iRL
	 OSSXJXcJfTSVnzf0AXPtvKIQ5ftM7eTq+/C8UNi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1916/2857] perf header: Fix potential memory corruption in cpu_cache_level__read
Date: Wed, 18 Nov 2026 15:49:10 +0100
Message-ID: <20261118150310.202536878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2b0293567f07..421bf05e00f6a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1178,7 +1178,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1187,7 +1191,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1197,7 +1205,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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



