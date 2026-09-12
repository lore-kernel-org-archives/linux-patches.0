Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFC334752E;
	Sat, 12 Sep 2026 07:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199947; cv=none; b=G3Ehpn0rKFz12i8nWBz9BGdiWzMZyAwYmBkLNhcN7RA8lsNRHL1mLiRzdM6KkpkROccpjBz0w48uns8js4BXV6/1cJmC6yK6LNL3+NsAl0YBlQ6bC9Ota0fla6Q1SFIMJFpSZzy/tE1YgdcIiRW+rIqbXyBkZ+EOUoKcQA/6G4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199947; c=relaxed/simple;
	bh=oAD9j1imhk1bBzYmrVacG02tWOJoQbCmPp6QL4vov9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcDFoqIwiKCLkbE3Nm8akBNdtVTBi4M6dv3TS4D31Ni3FCT52JJmJ9dv3tjOZz8A3ZGTcS+2Gp2FZVokEmtsql2atK8T0kGw0/FHcY0ELVdusTNg2M//vvPSAfXQ/DTVGuqtFilm8FkRIKA1h3ULHk1quemkHLx+nvyLgg7HK1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzoMWarL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzoMWarL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C040D1F000FF;
	Sat, 12 Sep 2026 07:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199946;
	bh=xNxl09NadjnWLFSF9NFeZR7Kz7FHQwmAybZYod1TATY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzoMWarLcY90oFvqGozTVD1hYY7hMOxOTTlfwMcxVg8Vm6LaPMnQUDPPcBFESBN4v
	 1xsuJYpDIO+GefBOkHswLWceM8QBjxy4hry+oYfVN3vBLP7pGQjeo5SWGn0Ar3balb
	 ABmtv6poApFL4NITPw4BuAwjzUSVWFp7p0jGcswk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0636/1815] perf trace: Correct default cpumask formatting to hexadecimal
Date: Sat, 12 Sep 2026 08:39:46 +0200
Message-ID: <20260912065703.810099391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit 89493fe58c81db19efc16ec220e6fce512ec1cf7 ]

Currently, dynamic non-array fields such as 'cpumask_t' are mishandled in
'perf trace', causing the raw length and offset descriptors to be interpreted
and displayed as a literal integer (e.g., "cpumask: 524320" instead of the
actual mask data).

Correct the parsing of dynamic fields that do not have the
TEP_FIELD_IS_ARRAY flag set by introducing helper functions
format_field__get_raw_data() and format_field__get_cpumask().
Using these helpers, resolve the pointer to the raw bits within the
payload and format the cpumask as a zero-padded hexadecimal string by default.

Fixes: c5e006cdbd27 ("perf trace: Support tracepoint dynamic char arrays")
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 71 +++++++++++++++++++++++++----
 tools/perf/util/evsel.c    | 91 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h    |  6 +++
 3 files changed, 159 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b605bd7e519e1..0418808dbc4d2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3207,6 +3207,22 @@ static void bpf_output__fprintf(struct trace *trace,
 	++trace->nr_events_printed;
 }
 
+static unsigned char bitmap_byte(const unsigned long *mask, int byte_idx)
+{
+	unsigned char b_val = 0;
+	int bit_in_byte;
+
+	for (bit_in_byte = 0; bit_in_byte < 8; bit_in_byte++) {
+		int b_idx = byte_idx * 8 + bit_in_byte;
+		int host_w_idx = b_idx / BITS_PER_LONG;
+		int host_bit_in_word = b_idx % BITS_PER_LONG;
+
+		if (mask[host_w_idx] & (1UL << host_bit_in_word))
+			b_val |= (1 << bit_in_byte);
+	}
+	return b_val;
+}
+
 static size_t trace__fprintf_tp_fields(struct trace *trace, struct perf_sample *sample,
 				       struct thread *thread, void *augmented_args, int augmented_args_size)
 {
@@ -3238,17 +3254,54 @@ static size_t trace__fprintf_tp_fields(struct trace *trace, struct perf_sample *
 		syscall_arg.len = 0;
 		syscall_arg.fmt = arg;
 		if (field->flags & TEP_FIELD_IS_ARRAY) {
-			int offset = field->offset;
-
-			if (field->flags & TEP_FIELD_IS_DYNAMIC) {
-				offset = format_field__intval(field, sample, evsel->needs_swap);
-				syscall_arg.len = offset >> 16;
-				offset &= 0xffff;
-				if (tep_field_is_relative(field->flags))
-					offset += field->offset + field->size;
+			void *ptr = format_field__get_raw_data(field, sample,
+							       evsel->needs_swap,
+							       &syscall_arg.len);
+
+			if (!ptr) {
+				pr_err("Problem processing %s field, skipping...\n", field->name);
+				continue;
+			}
+			val = (uintptr_t)ptr;
+		} else if ((field->flags & TEP_FIELD_IS_DYNAMIC) &&
+			   strstr(field->type, "cpumask")) {
+			unsigned long *mask = format_field__get_cpumask(field, sample,
+									evsel->needs_swap,
+									&syscall_arg.len);
+
+			if (!mask) {
+				pr_err("Problem processing %s field, skipping...\n", field->name);
+				continue;
 			}
 
-			val = (uintptr_t)(sample->raw_data + offset);
+			printed += scnprintf(bf + printed, size - printed, "%s", printed ? ", " : "");
+			if (trace->show_arg_names)
+				printed += scnprintf(bf + printed, size - printed, "%s: ", field->name);
+
+			if (syscall_arg.len == 0) {
+				printed += scnprintf(bf + printed, size - printed, "0");
+			} else {
+				int i;
+				bool skip_zero = true;
+
+				printed += scnprintf(bf + printed, size - printed, "0x");
+				/* Print bytes from most significant to least significant */
+				for (i = syscall_arg.len - 1; i >= 0; i--) {
+					unsigned char b_val = bitmap_byte(mask, i);
+
+					if (skip_zero && b_val == 0 && i > 0)
+						continue;
+
+					if (skip_zero) {
+						printed += scnprintf(bf + printed, size - printed, "%x", b_val);
+						skip_zero = false;
+					} else {
+						printed += scnprintf(bf + printed, size - printed, "%02x", b_val);
+					}
+				}
+			}
+			free(mask);
+			continue;
 		} else
 			val = format_field__intval(field, sample, evsel->needs_swap);
 		/*
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a8119f56100a3..968cd74a9cde9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -16,9 +16,11 @@
 #include <errno.h>
 #include <inttypes.h>
 #include <stdlib.h>
+#include <string.h>
 
 #include <dirent.h>
 #include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/compiler.h>
 #include <linux/ctype.h>
 #include <linux/err.h>
@@ -3949,6 +3951,95 @@ void *perf_sample__rawptr(struct perf_sample *sample, const char *name)
 	return sample->raw_data + offset;
 }
 
+void *format_field__get_raw_data(struct tep_format_field *field, struct
+				 perf_sample *sample, bool needs_swap,
+				 u16 *len_out)
+{
+	int offset = field->offset;
+	int size = field->size;
+
+	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
+		unsigned int dynamic_data;
+
+		if (out_of_bounds(field, field->offset, field->size, sample->raw_size))
+			return NULL;
+
+		dynamic_data = format_field__intval(field, sample, needs_swap);
+
+		offset = dynamic_data & 0xffff;
+		size = (dynamic_data >> 16) & 0xffff;
+
+		if (tep_field_is_relative(field->flags))
+			offset += field->offset + field->size;
+	}
+
+	if (out_of_bounds(field, offset, size, sample->raw_size))
+		return NULL;
+
+	*len_out = size;
+	return sample->raw_data + offset;
+}
+
+unsigned long *format_field__get_cpumask(struct tep_format_field *field,
+					 struct perf_sample *sample,
+					 bool needs_swap, u16 *len_out)
+{
+	u16 len;
+	void *ptr = format_field__get_raw_data(field, sample, needs_swap, &len);
+	unsigned long *mask;
+	struct perf_env *env;
+	bool target_is_64;
+	int target_word_size;
+	int nr_words;
+	int bit_idx;
+	int nbits;
+
+	if (!ptr)
+		return NULL;
+
+	nbits = len * 8;
+	mask = bitmap_zalloc(nbits ?: 1);
+	if (!mask)
+		return NULL;
+
+	env = evsel__env(sample->evsel);
+	target_is_64 = env ? perf_env__kernel_is_64_bit(env) : (sizeof(void *) == 8);
+	target_word_size = target_is_64 ? 8 : 4;
+	nr_words = len / target_word_size;
+
+	for (bit_idx = 0; bit_idx < nbits; bit_idx++) {
+		int w_idx = bit_idx / (target_word_size * 8);
+		int bit_in_word = bit_idx % (target_word_size * 8);
+		bool set = false;
+
+		if (w_idx >= nr_words)
+			break;
+
+		if (target_is_64) {
+			u64 word;
+			memcpy(&word, (unsigned char *)ptr + w_idx * 8, 8);
+			if (needs_swap)
+				word = bswap_64(word);
+			set = (word & (1ULL << bit_in_word)) != 0;
+		} else {
+			u32 word32;
+			memcpy(&word32, (unsigned char *)ptr + w_idx * 4, 4);
+			if (needs_swap)
+				word32 = bswap_32(word32);
+			set = (word32 & (1U << bit_in_word)) != 0;
+		}
+
+		if (set) {
+			int host_w_idx = bit_idx / BITS_PER_LONG;
+			int host_bit_in_word = bit_idx % BITS_PER_LONG;
+			mask[host_w_idx] |= (1UL << host_bit_in_word);
+		}
+	}
+
+	*len_out = len;
+	return mask;
+}
+
 u64 format_field__intval(struct tep_format_field *field, struct perf_sample *sample,
 			 bool needs_swap)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index e4776fdeb4c29..ba567e3b65c93 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -401,6 +401,12 @@ static inline char *perf_sample__strval(struct perf_sample *sample, const char *
 
 struct tep_format_field;
 
+void *format_field__get_raw_data(struct tep_format_field *field,
+				 struct perf_sample *sample,
+				 bool needs_swap, u16 *len_out);
+unsigned long *format_field__get_cpumask(struct tep_format_field *field,
+					 struct perf_sample *sample,
+					 bool needs_swap, u16 *len_out);
 u64 format_field__intval(struct tep_format_field *field, struct perf_sample *sample, bool needs_swap);
 
 #ifdef HAVE_LIBTRACEEVENT
-- 
2.53.0



