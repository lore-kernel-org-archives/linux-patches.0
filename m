Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054768;
	b=DCLYnJTRd5VWsXH1ZsSi0UUU3AF3oeeNqdJWm8/8BxRhHhtE8/yuh5O7MnLbpBj/qn5I
	 ulrGiGk77sfD8/2B8FqXLInvQyiaKizSyt6xDgUDV1b2zP+8pjGIF8STdlbpxGiYwzobw
	 WqMQO/r8kROa41dQnqBvA8t725dGKceoy4rJxchQVKZi09vZb3nWUrrLPdQuN03ZOkRgJ
	 U7AB5GB2NQ8u2wvKC2zN/seAnjUS3IgUSt7hQ80Uy3zGBEoKUN6J2IjEow2HDKAkgzvUK
	 SccIxtJKkaoO/yBDi+j07V2iSZimdKUlAYwJW77Jl9lacLVGkTF2Dfhcgfnag70xCRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m96ornZEnHXGWTsUHSwk6ExbbRh2eRtbArhypG1twN8=;
	b=odHm77JOZuAZGOmUTyR5+pwP3t4fV8Ge15bUKB8b2ddYJScL7k+nv83ntqKjSI0MDr5S
	 Gg6zYMGI1p2WWBISKd54Nc0FHLXxOMZQZ3nzEYC+NFxk8qfU5YGKZOCuy7ukMUatfALjB
	 IaZv0A8iND0rJrQ5iBoiSYPa38oIw9Egqf0z1KT3jBFb2C/TLtjS8V/sp1kE5D72MEmA2
	 ErgsQKtNJYehcPgbP8w+dC3GCuuok8buVCT7Mf2p7LWLS+Yu9WDyAKteuqMvII+tyJl6P
	 GaVEEA34uY3vu70/mWprx/YFxG9X00MsLBixf5mTwznqnLRt77Yyt0O4zFQX2VCjh3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWwyrC9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14886606A325;
	Thu, 19 Nov 2026 02:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWwyrC9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D091F000C4;
	Thu, 19 Nov 2026 02:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054767;
	bh=m96ornZEnHXGWTsUHSwk6ExbbRh2eRtbArhypG1twN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWwyrC9VeZerwzfPGG5C0D/nz77qs4l7dwGGd9KPLVKPcUt2kK6qD7tDQPI9awjk7
	 NESCnY198n8dKDAm830MvR/60nq9JAzyzcUBTljwdlgFFNrlk8K54JhgloQ2sDvVVF
	 WjyHuNRAdojB/rcXtWoY/fthdS3njyB5i6le2u8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <michael@ellerman.id.au>,
	Namhyung Kim <namhyung@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1393/2214] perf evsel: Add bitfield_swap() to handle branch_stack endian issue
Date: Wed, 18 Nov 2026 15:51:09 +0100
Message-ID: <20261118150107.038987095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit 63c12ae2f246dcdc30895ec7c980365a5133433d ]

The branch_stack struct has bit field definition which produces
different bit ordering for big/little endian.

Because of this, when branch_stack sample is collected in a BE system
and viewed/reported in a LE system, bit fields of the branch stack are
not presented properly.

To address this issue, a evsel__bitfield_swap_branch_stack() is defined
and introduced in evsel__parse_sample.

Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20211028113714.600549-1-maddy@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 02f6847e1822 ("perf evsel: Validate RAW sample before byte swapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 77 +++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evsel.h | 13 +++++++
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a9cb1aede476e..3c9637a991971 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2241,6 +2241,54 @@ void __weak arch_perf_parse_sample_weight(struct perf_sample *data,
 	data->weight = *array;
 }
 
+u64 evsel__bitfield_swap_branch_flags(u64 value)
+{
+	u64 new_val = 0;
+
+	/*
+	 * branch_flags
+	 * union {
+	 * 	u64 values;
+	 * 	struct {
+	 * 		mispred:1	//target mispredicted
+	 * 		predicted:1	//target predicted
+	 * 		in_tx:1		//in transaction
+	 * 		abort:1		//transaction abort
+	 * 		cycles:16	//cycle count to last branch
+	 * 		type:4		//branch type
+	 * 		reserved:40
+	 * 	}
+	 * }
+	 *
+	 * Avoid bswap64() the entire branch_flag.value,
+	 * as it has variable bit-field sizes. Instead the
+	 * macro takes the bit-field position/size,
+	 * swaps it based on the host endianness.
+	 *
+	 * tep_is_bigendian() is used here instead of
+	 * bigendian() to avoid python test fails.
+	 */
+	if (tep_is_bigendian()) {
+		new_val = bitfield_swap(value, 0, 1);
+		new_val |= bitfield_swap(value, 1, 1);
+		new_val |= bitfield_swap(value, 2, 1);
+		new_val |= bitfield_swap(value, 3, 1);
+		new_val |= bitfield_swap(value, 4, 16);
+		new_val |= bitfield_swap(value, 20, 4);
+		new_val |= bitfield_swap(value, 24, 40);
+	} else {
+		new_val = bitfield_swap(value, 63, 1);
+		new_val |= bitfield_swap(value, 62, 1);
+		new_val |= bitfield_swap(value, 61, 1);
+		new_val |= bitfield_swap(value, 60, 1);
+		new_val |= bitfield_swap(value, 44, 16);
+		new_val |= bitfield_swap(value, 40, 4);
+		new_val |= bitfield_swap(value, 0, 40);
+	}
+
+	return new_val;
+}
+
 int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 			struct perf_sample *data)
 {
@@ -2427,6 +2475,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
 		const u64 max_branch_nr = UINT64_MAX /
 					  sizeof(struct branch_entry);
+		struct branch_entry *e;
+		unsigned int i;
 
 		OVERFLOW_CHECK_u64(array);
 		data->branch_stack = (struct branch_stack *)array++;
@@ -2435,10 +2485,33 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 			return -EFAULT;
 
 		sz = data->branch_stack->nr * sizeof(struct branch_entry);
-		if (evsel__has_branch_hw_idx(evsel))
+		if (evsel__has_branch_hw_idx(evsel)) {
 			sz += sizeof(u64);
-		else
+			e = &data->branch_stack->entries[0];
+		} else {
 			data->no_hw_idx = true;
+			/*
+			 * if the PERF_SAMPLE_BRANCH_HW_INDEX is not applied,
+			 * only nr and entries[] will be output by kernel.
+			 */
+			e = (struct branch_entry *)&data->branch_stack->hw_idx;
+		}
+
+		if (swapped) {
+			/*
+			 * struct branch_flag does not have endian
+			 * specific bit field definition. And bswap
+			 * will not resolve the issue, since these
+			 * are bit fields.
+			 *
+			 * evsel__bitfield_swap_branch_flags() uses a
+			 * bitfield_swap macro to swap the bit position
+			 * based on the host endians.
+			 */
+			for (i = 0; i < data->branch_stack->nr; i++, e++)
+				e->flags.value = evsel__bitfield_swap_branch_flags(e->flags.value);
+		}
+
 		OVERFLOW_CHECK(array, sz, max_size);
 		array = (void *)array + sz;
 	}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index d39d8aab37698..a3bfb17cbb6b1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -488,4 +488,17 @@ struct evsel *evsel__leader(struct evsel *evsel);
 bool evsel__has_leader(struct evsel *evsel, struct evsel *leader);
 bool evsel__is_leader(struct evsel *evsel);
 void evsel__set_leader(struct evsel *evsel, struct evsel *leader);
+
+/*
+ * Macro to swap the bit-field postition and size.
+ * Used when,
+ * - dont need to swap the entire u64 &&
+ * - when u64 has variable bit-field sizes &&
+ * - when presented in a host endian which is different
+ *   than the source endian of the perf.data file
+ */
+#define bitfield_swap(src, pos, size)	\
+	((((src) >> (pos)) & ((1ull << (size)) - 1)) << (63 - ((pos) + (size) - 1)))
+
+u64 evsel__bitfield_swap_branch_flags(u64 value);
 #endif /* __PERF_EVSEL_H */
-- 
2.53.0



