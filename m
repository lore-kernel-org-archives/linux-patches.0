Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA02A399036;
	Tue, 21 Jul 2026 19:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660701; cv=none; b=o0Gy7M7raMG6tZHseCl0EqfTUwhnJeToersmoSsIR4jFjuFwhP4joxN1MGgnNJ9fvXDyP8+ytDiEpZEXajp+5DuEK8vPq4y6mXuwnTVA2KLPJJ6bwh/w2ghALBB1x0QwswxBhNkUJQXEcNmKB2iE4miCKZx9brtDa0qB6X1RGvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660701; c=relaxed/simple;
	bh=AyCBDbyXINfua3prctf6+qDpLWGbBFo5HSnrmMLqWo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RtcbOLnkcli1I9L7CDWVpON/MW9mvw+n/4erjHj+Rt499gj5e8WGZQe4PbjI/svOHKIGswwCxt5KkaUgODxTQvquKwpobJuR8gz+hoGLxoN71knZHkiNoygcq29wrPp3Ol4qFKVdeKL0SzJYRlhS2SF1gJkQGyAEF3YJDKMp7nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl7LPqnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl7LPqnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7D51F000E9;
	Tue, 21 Jul 2026 19:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660700;
	bh=KosoUNum5BApG4Oxi8hxbbhzEJGPe1mdWGrG4BherRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xl7LPqnWoVlelD3/eCtqnwK9M5r00jQcca+p1NQaWVZkC0TU45m8RT4qkLYBESLyR
	 ltr/EF821TP6SbEgjJuD2CZivMM8/FjPROTQoEqRnNqs7keQxuxfp+SHYGRl28FzLR
	 co0EGtxG0AMllorsV5sRqqLILNNFeykjcmqIHChE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1079/2077] perf bpf: Bounds-check array offsets in bpil_offs_to_addr()
Date: Tue, 21 Jul 2026 17:12:32 +0200
Message-ID: <20260721152618.271642065@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d6d2c9c190f7af..69148197b1ef9e 100644
--- a/tools/perf/util/bpf-utils.c
+++ b/tools/perf/util/bpf-utils.c
@@ -264,12 +264,28 @@ void bpil_offs_to_addr(struct perf_bpil *info_linear)
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
 		const struct bpil_array_desc *desc = &bpil_array_desc[i];
 		__u64 addr, offs;
+		__u32 count, size;
 
 		if ((info_linear->arrays & (1UL << i)) == 0)
 			continue;
 
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



