Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911603B42EF;
	Tue, 21 Jul 2026 20:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666399; cv=none; b=W7tIjSarAMzUfplqNmGLgjM9w3xp8hKwRv7MlK/LUgJfT4Cu24BTOF+NXH2/qEXszhauIzkKmGejk7HvfE6+nlVFyD2/+pQtueO97JyWCitcEZc5RZ+DVLBSc9CQrfz6XVLITMUyjcvdpY4lK/azAq/FuxDqI5ysbr9mPXZwAUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666399; c=relaxed/simple;
	bh=Z43c5xK16206bdmfmzjJf3zGlogyJHaSJPEkYdvN7ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pY+mxQ9DTEb/vZHt9NWMjG3Nf1sw8TIKQoC6x9pUbnkAwptFsZ3YFfuzMBQ3W2mNeEFbGUC5ItYf+txgBiWsz6hT9hakLulq/xLkzvEUt/Q/uxnJ6xixJtf4g1hbPVUsf44mCCJTuyVh+3cGslGjCIEFsXJCwwBOBfmp4iFTUr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TH7tFyuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TH7tFyuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FD41F000E9;
	Tue, 21 Jul 2026 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666398;
	bh=8krbEmE/llquaOB7M9p9kUrI8JP0KtVqbDM3jK5Gf34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TH7tFyuha01jMhHypx3PkitKYAqjdlwn910hATMj4/5511MNtPpJYoV4pXK4YfPGI
	 86FTK8FydQcgsfBvSeURQLeh5hf3v/IZwHWa8o8g3re/AcwTnJJiqu5/Oljp+A6yHj
	 Dt9HkjPi/sSjKPYdeAHmjQOXpd3HhKhjT6xap7ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Song Liu <song@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0668/1266] perf bpf: Use scnprintf() in snprintf_hex() and synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:18:25 +0200
Message-ID: <20260721152456.807958549@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1573d6b6478d28..2a9b90aa181fc7 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -28,7 +28,7 @@ static int snprintf_hex(char *buf, size_t size, unsigned char *data, size_t len)
 	size_t i;
 
 	for (i = 0; i < len; i++)
-		ret += snprintf(buf + ret, size - ret, "%02x", data[i]);
+		ret += scnprintf(buf + ret, size - ret, "%02x", data[i]);
 	return ret;
 }
 
@@ -131,7 +131,7 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 	const struct btf_type *t;
 	int name_len;
 
-	name_len = snprintf(buf, size, "bpf_prog_");
+	name_len = scnprintf(buf, size, "bpf_prog_");
 	name_len += snprintf_hex(buf + name_len, size - name_len,
 				 prog_tags[sub_id], BPF_TAG_SIZE);
 	if (btf) {
@@ -144,9 +144,10 @@ static int synthesize_bpf_prog_name(char *buf, int size,
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



