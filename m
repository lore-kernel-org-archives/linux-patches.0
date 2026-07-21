Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294F275801;
	Tue, 21 Jul 2026 18:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657485; cv=none; b=o5UsV44//V3qSFJZn8nQ5P0XeS8Yc5MCVq5GGu2vd5jfAQ6MFHNKj7Irl92cofFAke+M1Qf7LAK+LNKJvuDOL9sBxiDFF7v+Y8dM7FsdP4Z5pYhM6db8EKjRqp4KA58MRo7tHHbNjsSPS4Dq63VHr01je+xgp9nnTUPfn2pFv+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657485; c=relaxed/simple;
	bh=yoWEuaV9mhS2Qc3Tu6T1HL9TAzb8sFUVilqJ+A2E0qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7Z1a+FuPQ4fbzu4CK2IRJ3oSzxloGGEJlqfT1ufmHRHBp3TLvYNZdfEUi7fO7MzLeQPlQbbB2jlK5X5rtzaSggxEhZXMAZiN1xEnq5k0Gs2stKU9IxaVr9kr3TT10Gc0tqoXI6Qli2biFptU/VM02mPzXMWXNj3RXBXQhLRh2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCXtbaBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCXtbaBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7FA1F000E9;
	Tue, 21 Jul 2026 18:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657484;
	bh=SC955M4cGRUWx7W+BK7Vp1TGlGJxlQ2ca5nT292SLME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCXtbaByrGh5Kro1S5raBc32HxH/DM4oDfmCcBRy+2KdYM6ca+j12gjRzc2GZDLuj
	 GFmDtPVscv6Dw3qwFQbueAaBIB2k+3Y0nNApMhkV+jomogbz0PmkMc6RAx8s3C8QRX
	 QrrJjgw8vy0mQWA2QYAnx/flqmuBVIlikepLpCqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Blake Jones <blakejones@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0781/1611] perf bpf: Reject oversized BPF metadata events that truncate header.size
Date: Tue, 21 Jul 2026 17:14:57 +0200
Message-ID: <20260721152532.952256363@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d5ae6a157ac62b..579742afe2221f 100644
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



