Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583B643C7D7;
	Tue, 21 Jul 2026 22:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671826; cv=none; b=JSTifT9+0wYba5P7oOlcDVt71vcuI7TWMKG7S1REICQ/y12w88r2k5n5hem7g59w0aQRL2v7Utie1J6ahuYHjmYyc36cBl7r9cpTMR7FNpwPJTUJS2vmJQcAC3eBGl4oAmibeMz4RJ5738ManlTPyur1z2uwhJBYAF6lGlWIZ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671826; c=relaxed/simple;
	bh=9BnKbvv9E3swcNxtxGRLYuJ+OBEpDwpre1V4ta8bxF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvwxNkBdFliDkfAhBuLcEnSkxT+BLMrGG2oEgzZGyiXEjUd17+sNjkseNXCPDU+h+A8B/AVHt9x1zCwdbaJZ7aRnCTSRbHqDjoG6hgyUxiAZ5aYNJs/2VjapcZ8Y3MuCKoeyBTCmRWnvPqkzmW3cXIJuL5mknrMnXHeq99/M1Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMwneLZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMwneLZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DF01F000E9;
	Tue, 21 Jul 2026 22:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671825;
	bh=zfwQhcfe8GPREwUitAeF9M075TZ1/vchUG3jTEYntAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMwneLZ7BMchMLA8salGPW8gNndUa+P5m7pzjgr/uhLf4UBWDre/tchwGYkQDv8UU
	 K7TDcNa8BJIcYNAdehB+jlLnq4/VX4TaOS3nutGU7bebcZcxioafPSvbAYpsRH9bSr
	 9Xp5sVmIvKdsfFfPG9TPqHSx93D4mPmcTSVcbs14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/843] perf mmap: Guard cpu__get_node() return in aio_bind()
Date: Tue, 21 Jul 2026 17:20:27 +0200
Message-ID: <20260721152414.859377267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit f32dc302a090f48893477ef297a888db109ec0bd ]

perf_mmap__aio_bind() passes the cpu__get_node() return value directly
to an unsigned long variable (node_index).  When cpu__get_node() returns
-1 for an unknown CPU, the implicit int-to-unsigned-long conversion
sign-extends it to ULONG_MAX.

This causes bitmap_zalloc(ULONG_MAX + 1) which wraps to
bitmap_zalloc(0), returning a zero-sized allocation.  The subsequent
__set_bit(ULONG_MAX, node_mask) then writes massively out of bounds.

Check the return value in a signed temporary before assigning to
node_index, and skip the NUMA binding when the node is unknown.

Fixes: c44a8b44ca9f ("perf record: Bind the AIO user space buffers to nodes")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/mmap.c b/tools/perf/util/mmap.c
index 512dc8b9c1685c..f642018a8926c0 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -103,9 +103,15 @@ static int perf_mmap__aio_bind(struct mmap *map, int idx, int cpu, int affinity)
 	int err = 0;
 
 	if (affinity != PERF_AFFINITY_SYS && cpu__max_node() > 1) {
+		int node;
+
 		data = map->aio.data[idx];
 		mmap_len = mmap__mmap_len(map);
-		node_index = cpu__get_node(cpu);
+		node = cpu__get_node(cpu);
+		/* -1 sign-extends to ULONG_MAX, wrapping bitmap_zalloc(0) and OOB __set_bit */
+		if (node < 0)
+			return 0;
+		node_index = node;
 		node_mask = bitmap_zalloc(node_index + 1);
 		if (!node_mask) {
 			pr_err("Failed to allocate node mask for mbind: error %m\n");
-- 
2.53.0



