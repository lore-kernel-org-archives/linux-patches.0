Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A95335C6B6;
	Tue, 21 Jul 2026 21:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669315; cv=none; b=JnQ+s3oH5Wg4kY6LQO64B2poE2ChUTZRsrdzAKKquAuegP1Qo+0UYqTyXueQDwZlpyIdH4wYXbo3ndsyq8RVdTdrXWyJTtBo+bpuLixTER9h/A4jJhlgTHhNbowpIz73u7UZmK1EL1zl66quMrSMvO3cyn7wRqZOW3RzcWQrdIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669315; c=relaxed/simple;
	bh=AKxeSE9Iazha9vUNCbXThIx3g/SuQy4uOREbSiXL6Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCSVtBlGLxvcu5Mptaf7zgWWe2Y6Kj1+Ddt4s7maVInGMZmKAxhrzxX7bEFzDc49yPZKAIRno3ERhN+Jmbd8xu2BVHzTZVJC37qDVv7qUx448cJAD2NvgUWK5iGLPewOkYNlk1EisXpovbBzKWJVH+3WPZ0ia5tPQyEiBPNy7aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyRl1cIu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyRl1cIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB121F00A3E;
	Tue, 21 Jul 2026 21:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669305;
	bh=W53zA09iYatYXBF7M9+dbzrNIV4JE+vLU/pAx7K7zCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyRl1cIuqXvE47UDzuvu3HYl8+zFMHDqwSW8nhnBwbGml8UL65GaPHb8sgjNPk+9E
	 Ln5HG3Z40iY6m9ajUVWHSbnTwC4eS7ciQ/Y98TC2oD/6GUCyypQaUj+Qw9EpbZTxYC
	 /JBI/n129h8Ge3EZifOIdPhd495RE6p677ZlpZJ8=
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
Subject: [PATCH 6.1 0504/1067] perf mmap: Guard cpu__get_node() return in aio_bind()
Date: Tue, 21 Jul 2026 17:18:25 +0200
Message-ID: <20260721152435.890019043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a4dff881be39b6..63d8a05e60544a 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -103,9 +103,15 @@ static int perf_mmap__aio_bind(struct mmap *map, int idx, struct perf_cpu cpu, i
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



