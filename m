Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039710;
	b=dItq6IZ99GG2qkD2/vqABU25SrBk7XlqPwWrFaBScRsukwTydDWk04QNuA4S/OtkgQRV
	 We4/BgkAW1Sp7+XzNCowFMnFMHj3+MbXmQlj3qWTg6pxNXaYSLqKToY8//d2LhqftrU5U
	 yjCF1OAdIjU44A5hoZPmaSJCakH0qGhdPHssx/AVrX2mw3UDK6yY/YeMxmS1AQsvvXYJu
	 3NOjonkanwP1a66RooeBliBp2wfDro1+8OUCDA3MMmj9jJqleNhDrOb9Kia56drDeLxS2
	 icRlcEuFjPUQf4wPei5USHNFp/2xqn90j/LUpwwRGmib1MidvsCAIJuYqTH36eQ0yMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hV7c5lDfpRsvdrDeJh+5w7ALiy2b8VWX7whD0v0o5Ek=;
	b=tNL6bD65ljzDMTUrT87IPOQamYUc/1KctP0d1gyVj+pjtJAN6qKslfLxmkvbTFYtP5yS
	 HDs32haG+/ljBShQD64uibrMADnP5fc+F9SWIxpH+2qpJ7VuddbeuR0tK3Pj5YQb0+vI9
	 gKr61u8rYOrnxx3Kh0FmDcVmN4vjLxDiQ+HK+2PfVdlv7raFkzdm/KFaQYPjpPAnpFY1T
	 Ux2gNnJ8n6W1f931GmEceE4EcHk1iwne6qzyGF3hlREfkeq6RLJKvWUWyrR2m1ramPVSF
	 bYR9aQpe7KG05l1cLTReDSxTHJ4X5NuNC9l+naDC+kRv0MDWEcvNoLjMuEbQHDcMUzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQGOkUpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C75606A31C;
	Wed, 18 Nov 2026 22:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQGOkUpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154161F000C4;
	Wed, 18 Nov 2026 22:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039709;
	bh=hV7c5lDfpRsvdrDeJh+5w7ALiy2b8VWX7whD0v0o5Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQGOkUpTUdOMjIYTELq7EGoVCZ6hjmz8m1F5wKUx7AAH/eLeLO32PVZDaNRsmrZ2/
	 4y+YoC7Qrb7xKfnPLNYuod6F/RQHS1F041Gx3zAtxhItbPrEAkj/2mA7J7whtCFFbB
	 VVSARH9Ov2y94bkOKiEouRikUh+GLp7IFeX0Ltow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2198/3318] perf header: Fix potential memory corruption in cpu_cache_level__read
Date: Wed, 18 Nov 2026 15:47:00 +0100
Message-ID: <20261118150427.876978512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b44176826bfd..19ae2ce699e69 100644
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



