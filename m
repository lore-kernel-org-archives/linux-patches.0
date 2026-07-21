Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7713B1EFC;
	Tue, 21 Jul 2026 20:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666510; cv=none; b=mDr2BHjcezylO9rMcKxANlcQYHuR5IW84rsZTvq2mcK3N4pORnxxQ+3jkBDObD+iPdobtPx+QZ19/hjnJ1wEGMyETnwLuzKUNtJSA4vNQDCm/sjGs4WivUIp8NMtG4s7QEu7MmQfeJuBoE2udXy7UzSe1/3ktj8SnecHqfB1fnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666510; c=relaxed/simple;
	bh=iIXLeXV48/KioOirZuyZC4G5Cl77sHJM1mA4bGzfrOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ekpxj464BFi35z+GfCV88AAZvsocaZtab6yeWsqYWBc5w3QOQ3G0/4bNI7haHlNNyqDB8u9wVH4Y+3vHM2fI/pa9o6g0z/Od8r39jGCOex+jXQpvH2W780O3uWH2/5sLpEsWe+4sxUNJ54PHMtxPUd9UD/OezfbVbSMazBSqy2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm648tC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm648tC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D253C1F000E9;
	Tue, 21 Jul 2026 20:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666509;
	bh=oP818f4DSFidxxprLYZOerZc7FE+779ah4hz+dyN/TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm648tC5dJKNXSBXmzSxCDUAMjKByH0XZJ36TCsd3K6J1Pj6ZBQ/wwOknGt7UKgXA
	 iOIQqXV43t4xORycRDjsExL3NWLWGhGcLHTXkxOBtyM7DBOxT1CK5UY4+eWlJbIOYC
	 wgIGVdVuUL4zVaPQgMoz/N8g51Mb5xqn+DRPwG5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0710/1266] perf bpf: Bounds-check array offsets in bpil_offs_to_addr()
Date: Tue, 21 Jul 2026 17:19:07 +0200
Message-ID: <20260721152457.752651624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 033e85edfbf271f92979d2a39aeaf40f8472a795 ]

bpil_offs_to_addr() converts offsets stored in perf.data's
bpf_prog_info_linear structure into heap pointers by adding the offset
to the data allocation base.  The offsets come from untrusted file input
and are not validated against data_len.

If an offset exceeds data_len, the computed address points outside the
allocated data buffer.  Callers like synthesize_bpf_prog_name() then
dereference prog_tags[sub_id] or func_info pointers, reading arbitrary
heap memory.

Add a bounds check: when an offset exceeds data_len, zero the field
and skip the conversion.  This prevents out-of-bounds pointer
construction from crafted perf.data files.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 6ac22d036f86c4e2 ("perf bpf: Pull in bpf_program__get_prog_info_linear()")
Cc: Dave Marchevsky <davemarchevsky@fb.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-utils.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/util/bpf-utils.c b/tools/perf/util/bpf-utils.c
index 80b1d2b3729ba4..a20ed281bcaf80 100644
--- a/tools/perf/util/bpf-utils.c
+++ b/tools/perf/util/bpf-utils.c
@@ -246,6 +246,7 @@ void bpil_offs_to_addr(struct perf_bpil *info_linear)
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
 		struct bpil_array_desc *desc;
 		__u64 addr, offs;
+		__u32 count, size;
 
 		if ((info_linear->arrays & (1UL << i)) == 0)
 			continue;
@@ -253,6 +254,21 @@ void bpil_offs_to_addr(struct perf_bpil *info_linear)
 		desc = bpil_array_desc + i;
 		offs = bpf_prog_info_read_offset_u64(&info_linear->info,
 						     desc->array_offset);
+		count = bpf_prog_info_read_offset_u32(&info_linear->info,
+						      desc->count_offset);
+		size = bpf_prog_info_read_offset_u32(&info_linear->info,
+						     desc->size_offset);
+		/* offset and extent from perf.data are untrusted — keep within data[] */
+		if (offs >= info_linear->data_len ||
+		    (u64)count * size > info_linear->data_len - offs) {
+			bpf_prog_info_set_offset_u64(&info_linear->info,
+						     desc->array_offset, 0);
+			bpf_prog_info_set_offset_u32(&info_linear->info,
+						     desc->count_offset, 0);
+			/* clear the bit so bpil_addr_to_offs() won't reverse a zeroed address */
+			info_linear->arrays &= ~(1UL << i);
+			continue;
+		}
 		addr = offs + ptr_to_u64(info_linear->data);
 		bpf_prog_info_set_offset_u64(&info_linear->info,
 					     desc->array_offset, addr);
-- 
2.53.0



