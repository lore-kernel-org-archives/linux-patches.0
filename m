Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8F0399036;
	Tue, 21 Jul 2026 19:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660699; cv=none; b=af9qKXM/0a2iOvwWi1FpHsXrjiW86VuQML5iymQ4eI5eferVGBhjIp/mKYy5v9y+//HOoGW0k7aAEe5w1jONxLf0+pX8nlP4qbKMGWOF4BSny8ocZvExdmXxGilDaJvUP2y+O81SZY6tW2TRVBVQjE5pJfR+pUIfgrqCa3jw1s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660699; c=relaxed/simple;
	bh=N3qsgZYuVlyvWXYUpK2oLao2jNADQxnejwcXABsBsHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIQRIN9YxcFiS273Lm2tsalPszVcJvrnz6Nj8QTzpdRoYVOmk494DR05qHmYJe0s6B9AVdzMrfh3Z5BAb3lPksmfhW/j1esUPzBWn0Qrs4vm8wF8+mpM69aE/oEBut1Aak7jxddqjTiOU4qZy7Zz7GdcPSQxOvjkY8cIq+Vqyd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcOibPnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcOibPnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E451F000E9;
	Tue, 21 Jul 2026 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660697;
	bh=1NxDl1X7IrYA+ePeuGWO2IfzM0WutzFjiN+J7PmnCJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcOibPnwyY9QVjHKFhL33J+rUMDAMsk9svrhY6P28BbKg1690742KVBhaopOWLBVB
	 QiWEuBbOkg+zQUY19PHVJVXWDBWQIRHAumrPvhysY2r8N97uCibEVusEAFOxzwKcdz
	 xgWQMlkyd6xofqyXdwTrPHvxm5TfxxjrtQXgJBZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Blake Jones <blakejones@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1078/2077] perf bpf: Reject oversized BPF metadata events that truncate header.size
Date: Tue, 21 Jul 2026 17:12:31 +0200
Message-ID: <20260721152618.248888175@linuxfoundation.org>
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

[ Upstream commit 2d6ea0875093da9033fcb62c09a9e2f1de49fe91 ]

bpf_metadata_alloc() computes event_size from the number of BPF metadata
variables and stores it in header.size, which is __u16.  With 204 or
more .rodata variables prefixed "bpf_metadata_", event_size exceeds
65535 and silently truncates.

The truncated header.size causes synthesize_perf_record_bpf_metadata()
to allocate a buffer sized by the truncated value, then memcpy the full
event data into it — a heap buffer overflow.

Add a check that event_size fits in __u16 before proceeding.  BPF
programs with that many metadata variables are exotic enough that
silently dropping the metadata is acceptable.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: ab38e84ba9a80581 ("perf record: collect BPF metadata from existing BPF programs")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Blake Jones <blakejones@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index fe6fbca508c513..57d53ba848359e 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -369,6 +369,15 @@ static struct bpf_metadata *bpf_metadata_alloc(__u32 nr_prog_tags,
 
 	event_size = sizeof(metadata->event->bpf_metadata) +
 	    nr_variables * sizeof(metadata->event->bpf_metadata.entries[0]);
+	/*
+	 * header.size is __u16.  synthesize_perf_record_bpf_metadata()
+	 * adds machine->id_hdr_size (up to ~64 bytes) after this, so
+	 * leave headroom to prevent the final size from wrapping.
+	 */
+	if (event_size > UINT16_MAX - 256) {
+		bpf_metadata_free(metadata);
+		return NULL;
+	}
 	metadata->event = zalloc(event_size);
 	if (!metadata->event) {
 		bpf_metadata_free(metadata);
-- 
2.53.0



