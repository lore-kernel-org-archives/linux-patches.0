Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9D81A6195;
	Tue, 30 Jul 2024 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358461; cv=none; b=iVZ0+szz/Mj4hh6iUUcfgqZ/6qa7Bk1GoffGNtDz/PP+TD9jjdtCchB801M6iN5j7Z6TKH5W8YfeNmEccckL4hCkNCqNHT7NooOSUpA4v7KkZlcJT1+B2d0bud/4CT1mwAKcxRsdU1o2MlPBVRlgIejf0GhpQdPl0Edgf8zNwp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358461; c=relaxed/simple;
	bh=I9/Y2RZsDBz6SZudIVtCamDaEr+5w5+qXokiWilC4h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWsRMUyFX0qXbyZMrsUhzFDzvVDGSbcPhAmEmxS/GoRGdxNPE8YrziojnLtmI+/DzLsQSEDs7RykkJ9z4sFPCFOYS30M6Ywvvt7k1Ta38Bx63tBLZcIYVhMSDxqSGUflgReEK/J6W759N4bNTabqO2QkWbwjsGZPkTQgq02wdC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYxZL7pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYxZL7pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B824AC32782;
	Tue, 30 Jul 2024 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358461;
	bh=I9/Y2RZsDBz6SZudIVtCamDaEr+5w5+qXokiWilC4h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYxZL7pgQk7XCMG9Roh7iGF2GokVbYaPXVJWqrQsM3TViApmUKgWoTcAp2r2LEgyL
	 kdDK3J/udrne771erfLmAMvWL2buwK536zZVcYpA8v2NJvU+lAei06ysZ1WWxN4k1p
	 C4xvlsZ4zqh0dEmh+7Nyh16t6r/JtDEwVtWVF6kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 361/809] perf stat: Fix a segfault with --per-cluster --metric-only
Date: Tue, 30 Jul 2024 17:43:57 +0200
Message-ID: <20240730151738.908006621@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit caa463bb79a82ac5fce05a0dcf7893d94c84fc5e ]

The new --per-cluster option was added recently but it forgot to update
the aggr_header fields which are used for --metric-only option.  And it
resulted in a segfault due to NULL string in fputs().

Fixes: cbc917a1b03b ("perf stat: Support per-cluster aggregation")
Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Tested-by: Yicong Yang <yangyicong@hisilicon.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20240628000604.1296808-1-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 91d2f7f65df74..186305fd2d0ef 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -38,6 +38,7 @@
 static int aggr_header_lens[] = {
 	[AGGR_CORE] 	= 18,
 	[AGGR_CACHE]	= 22,
+	[AGGR_CLUSTER]	= 20,
 	[AGGR_DIE] 	= 12,
 	[AGGR_SOCKET] 	= 6,
 	[AGGR_NODE] 	= 6,
@@ -49,6 +50,7 @@ static int aggr_header_lens[] = {
 static const char *aggr_header_csv[] = {
 	[AGGR_CORE] 	= 	"core,cpus,",
 	[AGGR_CACHE]	= 	"cache,cpus,",
+	[AGGR_CLUSTER]	= 	"cluster,cpus,",
 	[AGGR_DIE] 	= 	"die,cpus,",
 	[AGGR_SOCKET] 	= 	"socket,cpus,",
 	[AGGR_NONE] 	= 	"cpu,",
@@ -60,6 +62,7 @@ static const char *aggr_header_csv[] = {
 static const char *aggr_header_std[] = {
 	[AGGR_CORE] 	= 	"core",
 	[AGGR_CACHE] 	= 	"cache",
+	[AGGR_CLUSTER]	= 	"cluster",
 	[AGGR_DIE] 	= 	"die",
 	[AGGR_SOCKET] 	= 	"socket",
 	[AGGR_NONE] 	= 	"cpu",
-- 
2.43.0



