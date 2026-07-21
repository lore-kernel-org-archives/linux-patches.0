Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D031644AB73;
	Tue, 21 Jul 2026 22:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671947; cv=none; b=KoYL+Bg7vXbwWKNu4NYON8w7un5++vBwueJkg3rjZAawAzYAXnU9MraCIpooOIP5poHudVtDjCioouWLyh864UjHNin5s5gEnnfv+d068zrMCdQ8LQy9f+Kl42wfNuwoL8CmR2Yld4JX7ASg5XS/hFAZmFQUYRKSs1Ju7/kTveE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671947; c=relaxed/simple;
	bh=UDSH0God/fIpQxJHoN5N3JVV+BOxeq8g8kWscdh0PW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDFN3B/e+TXPvULaKF+j9ZP2vFGTUFmPWwq2A1HC/KapB/RAR6AWekUUUaXR+to7tXvUest12ZoOdsonUiny3qcGkx4opA4NQd8qwlM4YS27/hAhML8LngC8D6TtysJawBHzvdW4lh8A1oCKu+eNz9oczewwK7Ao2CSTcrQJ4oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLsjDoMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLsjDoMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AB11F000E9;
	Tue, 21 Jul 2026 22:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671946;
	bh=1edcxcy6K9C9IR70R3LJdpviYmFuxgmJYgyxvD4rkKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLsjDoMfvAE6YZTA+0gJLqzxVuTEkZzkT5VLqQuM9hgAJLy1ITVphrlrNnYSwlVf6
	 VGI1h4tMOsgYg1GYq2pivT+StdEBlI1fp7MMIUh9y6dhQDyeDOw1xdzffMH2xKO7Dk
	 32fXyEER+AIj5AWYN3c5QIfpHVPEDg2t1kh+utpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/843] perf bpf: Validate func_info_rec_size and sub_id in synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:21:13 +0200
Message-ID: <20260721152415.885196811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 10b3c3d63ecc17c6acb855bac5f40367f1115765 ]

synthesize_bpf_prog_name() computes a pointer into the func_info array
using sub_id * info->func_info_rec_size without validating either value.
Both come from perf.data and are untrusted:

- A func_info_rec_size smaller than sizeof(struct bpf_func_info) means
  the finfo pointer would reference a truncated entry, reading past it
  into adjacent data.

- A sub_id >= nr_func_info computes an offset past the func_info buffer,
  causing an out-of-bounds read.

Add bounds checks for both values before computing the pointer offset.
When validation fails, fall through to the non-BTF name path instead
of reading garbage.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 7b612e291a5affb1 ("perf tools: Synthesize PERF_RECORD_* for loaded BPF programs")
Cc: Song Liu <songliubraving@fb.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 1c597ac08ae926..ff2ee6b0e3342a 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -146,7 +146,9 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 	name_len = scnprintf(buf, size, "bpf_prog_");
 	name_len += snprintf_hex(buf + name_len, size - name_len,
 				 prog_tags[sub_id], BPF_TAG_SIZE);
-	if (btf) {
+	if (btf &&
+	    info->func_info_rec_size >= sizeof(*finfo) &&
+	    sub_id < info->nr_func_info) {
 		finfo = func_infos + sub_id * info->func_info_rec_size;
 		t = btf__type_by_id(btf, finfo->type_id);
 		if (t)
-- 
2.53.0



