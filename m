Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023681;
	b=yzSSpjOLgIeRn+RcutIdC4dRFbFpeeogpJ2Fuds3fAM4N3nOwhBSn6VKgBQGY29NlB4S
	 73ZAVn08q6wncgA7e72i/fExw4DFhmk2YPiLtPDA2ffTlND8l9w9I8Rp/9gT8FaNfQrx3
	 ZcL6vFQNYEE7O35Mzz7K7FJ5vJBZDhO2Nm02zrfhW+uMLDhz/KaklFmAJCDtsVRn9GQz7
	 NbMWcOrtt7cZu663wpFmNmSdR/pjameyGwFmm083GtwuqukfM/TODS2V7e+1EQsqdo7SR
	 0DHBbQBLw40R85OqYkwSRm9avAs/20zE241flMJHOONFq+1cN1H+xcZhpAc8P7+q9BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0sbUwo+dGVFAntlVQnj7216+ss9s33OiWc/f169PYFc=;
	b=uKLyj52HSPnQTEFpfaJqp2oBlPV8Qx/yDJkB5wve+EsepUtJHeCvC1iqY2hExIn2PrW3
	 pkmVvJBCtu4Z1JHQt5UjBNB4sLJ3j3f7cZROZKBlbu1fhkxWZzTntA4GocxoCbSvT3oGR
	 CsVG4kT7rTQIhWYCzR40c7u4bbc3EnerFtTzdt6RIsy4HiH039MdGAV5IXyRGa1M/xxoj
	 HInNlpF6pIzjukv0ErvqWvpL86+NLzpPkcvDla4x/NDNZxYIvLLN+buHbWYkiJbtEZEIX
	 DgT191MmuHq0skUTmYE137Dr1vhElQo+VIp2t7R1Xt1UpC2oHac1cVQzbnGuD9uY6aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vo8dGHoZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6FC606A320;
	Wed, 18 Nov 2026 17:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vo8dGHoZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2541F000C4;
	Wed, 18 Nov 2026 17:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023681;
	bh=0sbUwo+dGVFAntlVQnj7216+ss9s33OiWc/f169PYFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vo8dGHoZOiIOga9ckkouCbUtW3oYsmyMgAySLlUKHI1cTGM/nWpXWA03kRztFE09E
	 VlpbbmMBqBLb5iGK+P0UUapUcxVn5r663aJVSTorev9oosXpn7dQvWF1JLrleHgh5h
	 xh3nWsVJEXm2YSu+D4lM/+wgc76a/nfFcHYt1mec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0429/2151] perf header: Fix potential memory corruption in cpu_cache_level__read
Date: Wed, 18 Nov 2026 15:36:04 +0100
Message-ID: <20261118150137.675352266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9cb1d54b2452d..5bf826911cf3a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1155,7 +1155,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1164,7 +1168,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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
@@ -1174,7 +1182,11 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
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



