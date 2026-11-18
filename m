Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047738;
	b=Bqw8ekSsjuCY2irvXTB5peEDhclARWmMmNK9fbfQp6+tyc521n+GX9+pWAGdeWxYliNj
	 SkQ/S5ccMpGla/GU54wy9H6ZMHbUCLWDc9YOoIdJcMgJSpIIQOFn8JMdLQSmEaJlVgGPl
	 NdSXOYq5R2K0mIWz5hT+cNPCY66rfAfAvkaJu7swgpuk2bsgbwr3i0ztOWTWTgBJunQVC
	 7oTG7QWvFmMMvpty0KmkPGFbzZ37IOsFeAsJ6uaCOTEhb5rDVse5LyizSKiHNnHqBb3O7
	 8TBoPqRVWcsL/ivFNhtTCRKgRXZCciWWJ7iUjr1fPGyWCBQS9hMVr2dL68TPRSRZePQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Axt79r2/J5JvdhrIhcTAUerc67SmxJBrY31HNNMOkPs=;
	b=rHA2kUjNKKapCeus/4TYu6r+E9/ydABPMNKRK4ITDWcFvkTwCCzvLEJrh45652TZ+w1c
	 9yONtnHZDqnEya0HAUGX9Swopbe1FpRa2wKgIGQBV6C/vOmIUuUT+olBi64HYvTvhO7MW
	 5xPzeEuW/oe8dHp2CJ4i1JzObrGS7aa0+firXxyZ7xx6IWVnhZguOLyT7AANACqEg4hUW
	 35ux03a61BLzxwvTrWn9xFp/D0UESq/J+5PulU4bSuDwaz1wyo84H6XjBd4mD6jtFcCqL
	 jPlTJA3gZ28C1/wJwoEIK2iiJEtrt1zi55V7J4VW4/0rTZtq977Oa4T3y/pB6BZW8Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VgBr8zf6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3600F606A31C;
	Thu, 19 Nov 2026 00:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VgBr8zf6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874EA1F000C4;
	Thu, 19 Nov 2026 00:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047738;
	bh=Axt79r2/J5JvdhrIhcTAUerc67SmxJBrY31HNNMOkPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VgBr8zf65zQHERJoIDasHbYdjAiOm9lxUTtyd78jDyAsygugEPV5WJBj3X46TfMbT
	 ppMAklakCQISTzEkddYIcAbSROEgezSbL9V/OKoxwtdLyU9Af17JCk6Xuqd5xND7f6
	 9wFsG/ULGQNHvCzXPUQAkiHRo7haE+V3MtNiLj7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1746/2857] perf jitdump: Fix debug_data and unwinding_data leaks
Date: Wed, 18 Nov 2026 15:46:20 +0100
Message-ID: <20261118150304.165949053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 2bd967f3adcba1d3e54f10b0d8b25f950e4f03fd ]

jit_repipe_debug_info() overwrites jd->debug_data without freeing the
previous allocation.  If two consecutive JIT_CODE_DEBUG_INFO records
appear without an intervening LOAD record consuming the data, the first
allocation leaks.

The sibling jit_repipe_unwinding_info() already frees the old
jd->unwinding_data before reassignment — add the same pattern to
jit_repipe_debug_info() using zfree().

Also add cleanup of both buffers in jit_close() so they are freed when
the jitdump session ends, even if no LOAD record consumed them.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 00c435d1a4175..fc90ec12a53b6 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -116,6 +116,8 @@ jit_close(struct jit_buf_desc *jd)
 	funlockfile(jd->in);
 	fclose(jd->in);
 	jd->in = NULL;
+	zfree(&jd->debug_data);
+	zfree(&jd->unwinding_data);
 }
 
 static int
@@ -642,6 +644,7 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	memcpy(data, &jr->info.entries, sz);
 
+	zfree(&jd->debug_data);
 	jd->debug_data       = data;
 
 	/*
-- 
2.53.0



