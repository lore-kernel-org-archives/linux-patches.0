Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB15471253;
	Tue, 21 Jul 2026 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657328; cv=none; b=upFDynB1zfI5QTd3jEk9oMRZCjzWnrQk1J44CDCHUYZcGcBa4S3PFprKmYaDctaXkiJAKVu40/Xh9wvDcR6/iZUglxQUCgr0coiI98G9+JUBFywDATBSgWeu+z/sTjLmKCLZYPBliNNMP6+KjZb10gZDrDPMV/Oh+vKfxJX/Igk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657328; c=relaxed/simple;
	bh=akrzvzmEC7w+2QwkTdX8Pj1E5hxgEgZynNRN1KJw4ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtudWQWcD+Mk3dayi94YzKEnlhxjLliYvbMZFyuoAPstxjPcWBTIxl6bHtfxBtkKrbzZSZ20z1RXP+NubJbAxmNJ1d5TiAVpm+N0AdP84JgxeAvjfNqA3qsmtO/Cs/8NJ2YhTafEUPuWQCGJoBeWz96QJ8g1nPi0iIbfGsX8lM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfyQQhjT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfyQQhjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393881F000E9;
	Tue, 21 Jul 2026 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657327;
	bh=v64yHbqA71twFoswMqZ01k2TLZODbn7+pVBwN3i3pfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfyQQhjTV2bTvR33sNX9K6p/LcbqJsV2ilcbeNxXRK+Tiw6ClIyyhybilA/oCfy+2
	 HJJSBIIYtb8ojqzvLRjNmNrOTSx9NJCTpTEt6OVX+TrHZO20Yrx8o1yuJurQ8QR2z4
	 hzxyzGehQY1Ogy6cNBMnXutirhnEdcXYr2F6Awo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Blake Jones <blakejones@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0723/1611] perf bpf: Fix map data leak in bpf_metadata_create() on alloc failure
Date: Tue, 21 Jul 2026 17:13:59 +0200
Message-ID: <20260721152531.642781574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit aece2b8966fc8de5be46ee9287d0f60d6690c300 ]

bpf_metadata_create() calls bpf_metadata_read_map_data() which
allocates map.btf and map.rodata.  If the subsequent
bpf_metadata_alloc() fails, the code does 'continue' which skips
bpf_metadata_free_map_data(), permanently leaking both allocations.

Fix by calling bpf_metadata_free_map_data() before continue.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: ab38e84ba9a80581 ("perf record: collect BPF metadata from existing BPF programs")
Cc: Blake Jones <blakejones@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 149b7f28a25eef..bfaf1c7b7352c9 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -395,8 +395,10 @@ static struct bpf_metadata *bpf_metadata_create(struct bpf_prog_info *info)
 			continue;
 
 		metadata = bpf_metadata_alloc(info->nr_prog_tags, map.num_vars);
-		if (!metadata)
+		if (!metadata) {
+			bpf_metadata_free_map_data(&map);
 			continue;
+		}
 
 		bpf_metadata_fill_event(&map, &metadata->event->bpf_metadata);
 
-- 
2.53.0



