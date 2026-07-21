Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9EA43F4AF;
	Tue, 21 Jul 2026 22:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673833; cv=none; b=mLYBjMvgscrwwjuRktuifnvev99orj/bV2no0WSP208wXJCO44HB0dDyvVqImUQhSjL0Q1o+hP4D8e1EG/OG68OIFJGr03pi7/lY+kCVVIQi4NKOtYOfLv5biGx0hqsLhm7GCbrh+SHh9jtn97acojSzLkqJxwuGj4pYNd9UNtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673833; c=relaxed/simple;
	bh=0fTO7bgPeUhVsAV5ywGmT/bRoZ+7endBj/TJpE26S5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoO7XacbmRu+5Yh2pmuXI/18ZWOjmQke57tfv75xRiJIJE9IEykWVGP8xFjDudNlt+XLaX7bD4tVbZ0b6Ls4eZWGq52JcoMwqDPr93dSgc7qZVD+7CkCDGQf/n6++8lTa1YkC384A4NDRAawGxXI/3st8M0Og/rD9TctpfZIdV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWPMlGX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWPMlGX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E77C1F00A3D;
	Tue, 21 Jul 2026 22:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673832;
	bh=4yMrCF0WA11HILWZ7DMZZMPPpc/dqqMjvtyMKPsxvwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWPMlGX3crAOZp7YHeZgTk7sLSNCnSnRJ+6I1pybx1CZqur4RtlwoEDNBKMnkQbB/
	 RCD3t32p+LE71+uWLveBwqIrxuirXi9dDcb8o+AGgtmhBQMwKjH6XFEzXZZoBV1qYk
	 gL2/P8qD46wmUOlOkXBUJCwtrP+ahNeyVywJllbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Song Liu <song@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/699] perf bpf: Use scnprintf() in snprintf_hex() and synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:21:09 +0200
Message-ID: <20260721152402.689840903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cab3a9331ed0b3f884dd61c8a25b3cf123705982 ]

Both functions accumulate formatted output via ret += snprintf(buf + ret,
size - ret, ...).  If the buffer is too small and snprintf() returns more
than the remaining space, ret exceeds size and the next 'size - ret'
underflows, causing snprintf() to write past the buffer end.

Switch to scnprintf() which returns the actual number of bytes written,
making the accumulation safe.

Fixes: 7b612e291a5affb1 ("perf tools: Synthesize PERF_RECORD_* for loaded BPF programs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Song Liu <song@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index c4de19eba3880b..67295ca1d14b86 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -29,7 +29,7 @@ static int snprintf_hex(char *buf, size_t size, unsigned char *data, size_t len)
 	size_t i;
 
 	for (i = 0; i < len; i++)
-		ret += snprintf(buf + ret, size - ret, "%02x", data[i]);
+		ret += scnprintf(buf + ret, size - ret, "%02x", data[i]);
 	return ret;
 }
 
@@ -130,7 +130,7 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 	const struct btf_type *t;
 	int name_len;
 
-	name_len = snprintf(buf, size, "bpf_prog_");
+	name_len = scnprintf(buf, size, "bpf_prog_");
 	name_len += snprintf_hex(buf + name_len, size - name_len,
 				 prog_tags[sub_id], BPF_TAG_SIZE);
 	if (btf) {
@@ -143,9 +143,10 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 			short_name = info->name;
 	} else
 		short_name = "F";
-	if (short_name)
-		name_len += snprintf(buf + name_len, size - name_len,
-				     "_%s", short_name);
+	if (short_name) {
+		name_len += scnprintf(buf + name_len, size - name_len,
+				      "_%s", short_name);
+	}
 	return name_len;
 }
 
-- 
2.53.0



