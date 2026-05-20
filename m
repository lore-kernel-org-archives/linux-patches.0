Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9423DD504;
	Wed, 20 May 2026 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298662; cv=none; b=W8SHXLKGu9a/BQsd4U4/15+0uO+Y//meSgm6Fb95+zien5k8b92NdXiKbYeGacHEV1IwZTbDjetlScU0L/DjhNVEBBNDHw+lRhNs9V6ZYwHz9gzEOBtV4EjgyKIpIiOrsKkSsHmgSoQG1gDBX39gZlU2PgOE6xdaKbSf/36E2Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298662; c=relaxed/simple;
	bh=onGJtGgq0GZpxbE0eSTDgv3ehYs4PEiWrA27isNNRMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkVydww8KJuhqF49De+Kh+ail3OYCppQKGkPFhcZytBPgMJwiUR+kGyZ6l2WWAsu9FcJu8BEUWGKL6YYQOLACpIaK04YODAUpsc6W4Z1W+bfawUFUh70B8PGSDeXX3fjBNDVI+Ck7cwYEmmA4TrkryjpDkiF0RXuGttg41forpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKlA2mkl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKlA2mkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D91C1F000E9;
	Wed, 20 May 2026 17:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298661;
	bh=yzGZCfiTu7IGFz0FjadZjH6bxx9GlvXkx4c17ndZP4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKlA2mklldQHcmCxp5MWgJEZlo10uwJ8XDQga+8xohGUaa+1NEGvGr0GJGCTgTD53
	 pqrBJCHhKzTirC/Zt1hczok/BqojuN4xExt2cafuVL2NRFfMVIDm9qacJsN6wv/Pfy
	 7hw2+72uRxIQDWQ3O+VLy6odpXwGqgvHZs5CyLNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangguangju <wangguangju@hygon.cn>,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 497/957] perf trace: Fix IS_ERR() vs NULL check bug
Date: Wed, 20 May 2026 18:16:20 +0200
Message-ID: <20260520162145.303790945@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangguangju <wangguangju@hygon.cn>

[ Upstream commit 96f202eab8133f94479b14a32902c636e9bdf6af ]

The alloc_syscall_stats() function always returns an error pointer
(ERR_PTR) on failure.

So replace NULL check with IS_ERR() check after calling
delete_syscall_stats() function.

Fixes: ef2da619b132c6f74 ("perf trace: Convert syscall_stats to hashmap")
Signed-off-by: wangguangju <wangguangju@hygon.cn>
Reviewed-by: Howard Chu <howardchu95@gmail.com>
Acked-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c607f39b8c8bb..1f0b9ba3cdc15 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1573,7 +1573,7 @@ static void delete_syscall_stats(struct hashmap *syscall_stats)
 	struct hashmap_entry *pos;
 	size_t bkt;
 
-	if (syscall_stats == NULL)
+	if (IS_ERR(syscall_stats))
 		return;
 
 	hashmap__for_each_entry(syscall_stats, pos, bkt)
-- 
2.53.0



