Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E604C3E6385;
	Wed, 20 May 2026 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298728; cv=none; b=p19DcOFB97BAIVBXM6LFAPfj1V7fG0ncR5ltxPRSk7HqhS7+qp9GPHNO793kyCkxJWyaDLe6Nby6olBx6IYHtsF6/VT9grwJRsozWISZROk/Bp22MdoW69zTq4bcaEZUOV4yXNH+/LOXTQ3q1l6uC1+0RF0XEJkvkRtzByUBEMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298728; c=relaxed/simple;
	bh=LrxR+M/kLJdyVoDkGq8VLJ9xQLiLiLXg8D+H+g7br/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MobBO6k1eoEO1d4GJ9y8hB3+lqya/VkhOL+ZiMRNMjvRzT6LuGwAkHUFR4jzZaxz+bl33vP6ohMRhB3GpCS4NDIOjAI9ttkAs17GH8IGx9hxF/ZTm7fRziAJGG/oMt2v6nSAgBPPTCvMNj7VecA5Nly2e6H2CapmX35FeZCAkCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF+F5FCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF+F5FCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC1D1F000E9;
	Wed, 20 May 2026 17:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298727;
	bh=fdFcFRpmYZjRnJYHjfNZCzz79pNKIPQe2NcbJiqPR6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vF+F5FCNrqCkfsmMuffjRbhHcmTQIgIreJNStGeGVUD6bVT1TQGZe5g9igaxRij1J
	 KLc9bEUqjoNdq61FVc7vvchU8YL0mmlfbV7qk7ZpFVa8n5gJ8B6yhq/lWwTVIXb/WV
	 WtHGsK4aYChz0xRkY12hZMPxtPT1whN63SEw2WP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 520/957] perf maps: Fix fixup_overlap_and_insert that can break sorted by name order
Date: Wed, 20 May 2026 18:16:43 +0200
Message-ID: <20260520162145.810731919@linuxfoundation.org>
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
index c51ec159ac769..ff82d1d937b2f 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -924,6 +924,7 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 			if (maps_by_name) {
 				map__put(maps_by_name[ni]);
 				maps_by_name[ni] = map__get(new);
+				maps__set_maps_by_name_sorted(maps, false);
 			}
 
 			err = __maps__insert_sorted(maps, i + 1, after, NULL);
@@ -949,6 +950,7 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 				if (maps_by_name) {
 					map__put(maps_by_name[ni]);
 					maps_by_name[ni] = map__get(new);
+					maps__set_maps_by_name_sorted(maps, false);
 				}
 
 				check_invariants(maps);
-- 
2.53.0



