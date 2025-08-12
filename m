Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338B63F9D2;
	Tue, 12 Aug 2025 18:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022692; cv=none; b=pq2DfbKzTIXlxuQo6o/XjmlDPC58g7ceNTq5LkyWGbHgBFQF/2cEb0risYJFj2P2tBdFLA5uo1pe82DFw/KFhFJfZIz6KGO5HuAMuV8VH94+l+XbwfZLoGRkGw5fTA59P74as8QT0YTvnWa6M3OYovKvP0k0HCTIzV2bFASz4eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022692; c=relaxed/simple;
	bh=goNJhPvU/I8qF85q+G70MeZUK937GjcEa5QIEUwIYB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwejB4fifPhBRmBu2MnAOYy1g53Tm5EN1fJkW2AoOvexJ4U/s3OvITjBBU0ZnxAx5eCtl06/PCusM12WdMYAnXWhl/GXfQ0JBef+jL39GH0xRDugb/nWpAbOxHCNboxv3zYDvkbdPjkjGA0y7DuSLneWQMSX7EZ0lQEZ0xQB3EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tov1jPFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tov1jPFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940E2C4CEF0;
	Tue, 12 Aug 2025 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022692;
	bh=goNJhPvU/I8qF85q+G70MeZUK937GjcEa5QIEUwIYB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tov1jPFuZUIY5/N+4uWkJQogJXC4SGnrYweoDci7VbV33SVVx3XWhCuDwP8gydwlV
	 eT1l1R8OFIQg4Si3GL01ujeiTe8m0aZhnhkqyyOWpgSgIxjct3h0qHI8SR710xGVkH
	 hs9M99DirEo/OKl7oi+mk7fQhMWQ1d4gJUa6/Hc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/369] perf record: Cache build-ID of hit DSOs only
Date: Tue, 12 Aug 2025 19:28:47 +0200
Message-ID: <20250812173023.426227452@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 6235ce77749f45cac27f630337e2fdf04e8a6c73 ]

It post-processes samples to find which DSO has samples.  Based on that
info, it can save used DSOs in the build-ID cache directory.  But for
some reason, it saves all DSOs without checking the hit mark.  Skipping
unused DSOs can give some speedup especially with --buildid-mmap being
default.

On my idle machine, `time perf record -a sleep 1` goes down from 3 sec
to 1.5 sec with this change.

Fixes: e29386c8f7d71fa5 ("perf record: Add --buildid-mmap option to enable PERF_RECORD_MMAP2's build id")
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250731070330.57116-1-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/build-id.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index e763e8d99a43..ee00313d5d7e 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -864,7 +864,7 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 	char *allocated_name = NULL;
 	int ret = 0;
 
-	if (!dso__has_build_id(dso))
+	if (!dso__has_build_id(dso) || !dso__hit(dso))
 		return 0;
 
 	if (dso__is_kcore(dso)) {
-- 
2.39.5



