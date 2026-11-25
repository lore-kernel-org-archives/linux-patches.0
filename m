Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622505;
	b=ZTohe/WXBX0Z9299cNUmylQ6xni/BRPJOMJf55TMPJnife1VbdNIRymwMoLhTj79Cm7d
	 5ibdGPBp+7ygtk41vidhARBe7wspUIW5MuV04v2Lq6vnxCOkeJLzWYLqhePqVK7bSdh5d
	 2rXflaMXrlTKP3Yd7OhNUGes/2SIja+EV8xYFwafM1IIWTBv6oR/dvAIYl08ImmtMZoLm
	 dwhyaZnxd0ejR79dSj7FS68INy56NoP1/fiJCKEqs2ePhFZDWDH6b4WXHf00+heyGZ7fW
	 wwoE8z/IQcA20Xe3+OEMiO7+qEijdtahFD9nXxcjGQuUAlqsih5DviTS2dy8Wa6z4VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6jmYeSSj4YtT0LcOBag0g7ZZyfHvS8SULisJV81c0wU=;
	b=GBNIwKCEUrLhQC2s4ejKPpMfVaHeui2U7laEXgPQMtgW5GssGqLYMbqvw9EPdTA9b/IN
	 c8rxtXey0bOIZzmzbgKT4XhfuorU298/PQZmfp99YGclWDfZcLJkH69lm2x/MTS6pGukx
	 pASoLXyuSp9dH+rVySAf2+uTHfWqgf7+MNkudn90nD+UoE3q3hLespskKcJFXX7h4BpsZ
	 1kWuocPu/nh5BBlsskkH0xVinz3UZXP86z+Y9g8NlwIMGaY80vLRxZfmM7h4jwo8Egjhm
	 xSYDMUfR+6laQJf4qLgQY+eDstkUl72kBJ17taPB1ppbjIumWquacZN4BDb6T+sbuCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wNW/onFO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E60B606A327;
	Wed, 25 Nov 2026 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNW/onFO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A97F1F000D4;
	Wed, 25 Nov 2026 16:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622504;
	bh=6jmYeSSj4YtT0LcOBag0g7ZZyfHvS8SULisJV81c0wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNW/onFOwS059nEPDaJZMf47wCGGf+6iY2yR5qnAUbyfZlFvfVJJg6KLh/VzhDQr3
	 ivQaKqzNgtLtoO7pFuIhPixAWw831grqXyDvdUZhnVT7+nrrIDmhHEBaWWYwKt+JbV
	 boRKbAMmwfVQr+ib3oO3oCMG6YvIrnLjTKbFBHB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 560/990] perf evsel: Clamp sample_id size for ksymbol, bpf, and text_poke events
Date: Wed, 25 Nov 2026 15:32:07 +0100
Message-ID: <20261125143835.214784560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 7c89ea1bd4c612eb5cc2e6c01f77ebfc21d5c95d ]

On kernels without the fix ("perf/core: Restore header fields in
sideband output callbacks") to restore event_id.header.size in
perf_event_ksymbol_output(), perf_event_bpf_output(), and
perf_event_text_poke_output(), concurrent perf sessions cause those
sideband records to be emitted with header.size inflated by multiple
id_header_size increments while the single id_sample is written
immediately after the event payload. Indexing backwards from
event->header.size reads uninitialized ring-buffer bytes at the end of
the record, causing evlist__event2evsel() to fail with -EFAULT.

Add evsel__event_size() to clamp the effective size used to locate the
trailing id_sample for PERF_RECORD_KSYMBOL, PERF_RECORD_BPF_EVENT, and
PERF_RECORD_TEXT_POKE to payload + id_hdr_size while leaving
event->header.size intact for advancing the ring-buffer/file stream.

Fixes: 9aa0bfa370b278a5 ("perf tools: Handle PERF_RECORD_KSYMBOL")
Fixes: 45178a928a4b7c60 ("perf tools: Handle PERF_RECORD_BPF_EVENT")
Fixes: 246eba8e9041c477 ("perf tools: Add support for PERF_RECORD_TEXT_POKE")
Link: https://lore.kernel.org/r/20260929014206.4175245-1-irogers@google.com
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: Replaced evlist__id_pos()/evlist__is_pos() accessors with direct evlist->id_pos/is_pos field reads, and adapted perf_evsel__parse_id_sample() to the pointer-walk array form instead of an index. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.c |  6 ++--
 tools/perf/util/evsel.c  | 59 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/evsel.h  |  1 +
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 314393a430a37..67d1ad8a6ee16 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -648,13 +648,15 @@ static int evlist__event2id(struct evlist *evlist, union perf_event *event, u64
 	const __u64 *array = event->sample.array;
 	ssize_t n;
 
-	n = (event->header.size - sizeof(event->header)) >> 3;
-
 	if (event->header.type == PERF_RECORD_SAMPLE) {
+		n = (event->header.size - sizeof(event->header)) >> 3;
 		if (evlist->id_pos >= n)
 			return -1;
 		*id = array[evlist->id_pos];
 	} else {
+		u16 size = evsel__event_size(evlist__first(evlist), event);
+
+		n = (size - sizeof(event->header)) >> 3;
 		if (evlist->is_pos > n)
 			return -1;
 		n -= evlist->is_pos;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a0db385b9bec5..a6d91af538dc4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2888,7 +2888,7 @@ static int perf_evsel__parse_id_sample(const struct evsel *evsel,
 	bool swapped = evsel->needs_swap;
 	union u64_swap u;
 
-	array += ((event->header.size -
+	array += ((evsel__event_size(evsel, event) -
 		   sizeof(event->header)) / sizeof(u64)) - 1;
 
 	if (type & PERF_SAMPLE_IDENTIFIER) {
@@ -3512,6 +3512,63 @@ u16 evsel__id_hdr_size(const struct evsel *evsel)
 	return size;
 }
 
+/*
+ * Prior to kernel fix, perf_event_ksymbol_output(), perf_event_bpf_output(),
+ * and perf_event_text_poke_output() in kernel/events/core.c did not save and
+ * restore event_id.header.size across perf_iterate_sb() iterations. When
+ * multiple perf_events had attr.ksymbol, attr.bpf_event, or attr.text_poke
+ * enabled, header.size was incremented by id_header_size for each matching
+ * event while only a single id_sample was written immediately after the event
+ * payload. Clamp the effective size used to locate the trailing id_sample to
+ * payload + id_hdr_size so events recorded on unpatched kernels can be parsed
+ * without reading uninitialized ring-buffer bytes.
+ */
+u16 evsel__event_size(const struct evsel *evsel, const union perf_event *event)
+{
+	u16 size = event->header.size;
+	u16 id_hdr_size;
+	size_t payload;
+
+	if (!evsel->core.attr.sample_id_all)
+		return size;
+
+	switch (event->header.type) {
+	case PERF_RECORD_KSYMBOL: {
+		const char *name = event->ksymbol.name;
+		size_t fixed = offsetof(struct perf_record_ksymbol, name);
+		size_t max_len, len;
+
+		if (size <= fixed)
+			return size;
+		max_len = size - fixed;
+		len = strnlen(name, max_len);
+		if (len == max_len)
+			return size;
+		payload = fixed + PERF_ALIGN(len + 1, sizeof(u64));
+		break;
+	}
+	case PERF_RECORD_BPF_EVENT:
+		payload = sizeof(struct perf_record_bpf_event);
+		break;
+	case PERF_RECORD_TEXT_POKE: {
+		size_t fixed = offsetof(struct perf_record_text_poke_event, bytes);
+
+		if (size < fixed)
+			return size;
+		payload = PERF_ALIGN(fixed + (size_t)event->text_poke.old_len +
+				     event->text_poke.new_len, sizeof(u64));
+		break;
+	}
+	default:
+		return size;
+	}
+
+	id_hdr_size = evsel__id_hdr_size(evsel);
+	if (payload + id_hdr_size < size)
+		return payload + id_hdr_size;
+	return size;
+}
+
 #ifdef HAVE_LIBTRACEEVENT
 struct tep_format_field *evsel__field(struct evsel *evsel, const char *name)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f8de0f9a719b0..664bcc8712c2f 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -425,6 +425,7 @@ int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
 				  u64 *timestamp);
 
 u16 evsel__id_hdr_size(const struct evsel *evsel);
+u16 evsel__event_size(const struct evsel *evsel, const union perf_event *event);
 
 static inline struct evsel *evsel__next(struct evsel *evsel)
 {
-- 
2.53.0



