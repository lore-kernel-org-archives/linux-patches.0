Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997E238910F;
	Tue, 21 Jul 2026 18:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660330; cv=none; b=MYRGYBs/C+18DUZEnVZonaPureeWnG8Y5xVMaI/rk4MCFJxeUd123oHmQV1hVGbSSaU/joFmcHUsWU3nK+j96vHOmqX9rANBFbYP4dkWJu72UL6zOSyMBDZiBD7s3B4TcAtSixdiDnyliBhfwCJe4FTeH4wee6n5M5TbNWVBsxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660330; c=relaxed/simple;
	bh=b1ZqWk9cHU5DtvrhxsWsCzyzfWlt1t4MxmEC3JUZl5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igDpVloYVKELjcOpi9ridW8gceNuEFFZJ2g2AivBv8SsOxNtpWNSK+zh1r9+AwW/cQRy4Ckt2RELNxEm9N6ZPBx4qNZGzShA9Jte8/vhTtn8US0wwtlbdVNsxCLTLZ5IROacLZIinjTBAoGgFLg3/Obz8xZJWNNktHBfXBRX++s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVUT+2Xa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVUT+2Xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA6A1F000E9;
	Tue, 21 Jul 2026 18:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660329;
	bh=QZMVUxrI3cME7pC8Zdb23iCcI+jr1Rc4J9VL/eSAYsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVUT+2XahnCBfsxQM3pSktge58W/MR1WCSOsJBuIig8L8RDLGxiqmY+QIGElCqKFq
	 yt9cXo2zJpOHppgdVlhqmgOJms7Kl6DfRx/Wih8cbY/OmZpXVN225sBAOBsCcSyKVG
	 LAF9GmePmyY/NvDIpInTMfYNpGIBn498yXbi0E0c=
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
Subject: [PATCH 7.1 0939/2077] perf mmap: Guard cpu__get_node() return in aio_bind()
Date: Tue, 21 Jul 2026 17:10:12 +0200
Message-ID: <20260721152614.964669941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b69f926d314b14..4404a99eee45f9 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -104,9 +104,15 @@ static int perf_mmap__aio_bind(struct mmap *map, int idx, struct perf_cpu cpu, i
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



