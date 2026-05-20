Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2403F20E9;
	Wed, 20 May 2026 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296158; cv=none; b=SNpmH7YSDCt0KrQiqyuCjzBvP54B4YF8kRfAKzei+XxFwMSx33NL1yjPSDeKeD+skWQyB/XmnEI4MTNwMMJlvIeLfIUCRcW/rXnHEZEeKvOFmHNFxMnJly3Abza1300HDcfKrOc36tU9SQDCPKqSV5F00tRU+TXkgbauKdZezmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296158; c=relaxed/simple;
	bh=VQ/yWj25s34jqfaKBfy5M31mt9UDuS+PQi8oZUcD97k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQP3FIYyf3iVCG2OLm/kt9QGN18/XCNFAQg4vvAhAC/NRIQQTa/2yt5AVnkTkqoZEG3ruoea/gY4e0fDwB3c9nmHc2wjoOVrKZQy2YG71IdhfAcNPINpSvuM/J7zXEBUvLwp/ZINNm6MA9b0lbemfi4g2u1pSWqbAVGi4eK3q0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxZCm5ON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxZCm5ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6821F000E9;
	Wed, 20 May 2026 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296157;
	bh=sLL3y69e6BUvkfVrIUhn0hpNmkOsBrYEzMJxNvhHYAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxZCm5ONmav/bTl4c8UnOBVpz00G9H0NEhSzSV+e03mocGDaQ6YihnhF/wa3IckTb
	 /A1jZs63TlOXuHH3FEplZTah2ovFzNN0GlYVjpKl8a3cHZQBQj5WzHFjfGsGmgv2gt
	 y2vz2zNlQ4/fU0srFc/Omj9mJVcpaf1cfG2lcxE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0653/1146] perf maps: Fix fixup_overlap_and_insert that can break sorted by name order
Date: Wed, 20 May 2026 18:15:03 +0200
Message-ID: <20260520162202.963384485@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c4f3ff3289380437d26177e8f2fe4b7507816ee3 ]

When an entry in the address array is replaced, the corresponding name
entry is replaced. The entries names may sort differently and so it is
important that the sorted by name property be cleared on the maps.

Fixes: 0d11fab32714 ("perf maps: Fixup maps_by_name when modifying maps_by_address")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index 4092211cff62b..c8b8081b7b31a 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -956,6 +956,7 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 			if (maps_by_name) {
 				map__put(maps_by_name[ni]);
 				maps_by_name[ni] = map__get(new);
+				maps__set_maps_by_name_sorted(maps, false);
 			}
 
 			err = __maps__insert_sorted(maps, i + 1, after, NULL);
@@ -982,6 +983,7 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 				if (maps_by_name) {
 					map__put(maps_by_name[ni]);
 					maps_by_name[ni] = map__get(new);
+					maps__set_maps_by_name_sorted(maps, false);
 				}
 
 				check_invariants(maps);
-- 
2.53.0



