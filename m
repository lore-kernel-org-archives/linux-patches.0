Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054627;
	b=azAlpYeNrY6p/F2qj5EL3PgR+OAy8CoF1IWMrT/dsgwhANnWaqej+A2SnLtHewjyJdhc
	 0x9A2pzc+foQXRxx2+cM6xwMJlYLKo/1eY9fEyZTa6QixOxrf2uGpGMd55viNMl1xSKCN
	 4dqzL0cVtLT+FgCLjCLRzJRnRheL41ztxfkOODvNwsYUUiTszedjoeZhTilJlj7IQBliM
	 Isw8byIIYR/A5w6gEBzq9UchNKebiCcpf8qPjs0hLPnF9jdZkAfmW3tiHBHNvg2ykWqR6
	 bzr3qucHDDo8EI5MnKDw2YILaOP5lJOwQQbkeBo0pBK7l3vp1Li42yxZiHZJtoW/OrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=sEefcr+wDXvfZq1PzuDK+KV9AISIMhQUUKggR4tTIPk=;
	b=VUnS/4ZKRSdhb6zeXS6poRktKmvxp57otoThpdvRoxSFTHvZM09TYaKTBcMF1Z0+9FC7
	 aPOOg8rvILlXosSL+HjEDR9XRqUanY7rls0w4iLjDfT2WxwvMhS5tQJAPu6yOAL5txkU5
	 WutyHHEvnu4UDCmBTZ/xjl76rCAlwoFiznHpgkeE7cHVfXnfaczeYS2hrqQr7YwX44L4n
	 rw4uGSQmVha/oS3Vsh+dPNOgn6TKDQV8pVob3V4IM6HWVS50fWW/AdQ7AdgnpkkyZEutd
	 Hb12Wn3scOAlTol+dOi01ukM6jL2K7fWriGE+zf+2+2lTzxbNhHI275Py1iD6k/U4NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JnE5NtOZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683F7606A325;
	Thu, 19 Nov 2026 02:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JnE5NtOZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF841F000C4;
	Thu, 19 Nov 2026 02:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054627;
	bh=sEefcr+wDXvfZq1PzuDK+KV9AISIMhQUUKggR4tTIPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnE5NtOZfcIQ+4JNkW5b0oi9BO2VfQR3h9K5GzUuNcyC/E5qJk15Kxya+wGHCZElN
	 tZ7djVtR5Dv4nObpYt04Vj8zMxHcOFqHqy0S8Iu56tePRDWhS9Mk8i0NneV9lOFVEH
	 gHX3oXSqL1KQmZxeqftlXOy03p7U4naEZGdXI4ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1343/2214] perf jitdump: Fix debug_data and unwinding_data leaks
Date: Wed, 18 Nov 2026 15:50:19 +0100
Message-ID: <20261118150105.163406884@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 051a29c29fb81..8157d0c295cf6 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -123,6 +123,8 @@ jit_close(struct jit_buf_desc *jd)
 	funlockfile(jd->in);
 	fclose(jd->in);
 	jd->in = NULL;
+	zfree(&jd->debug_data);
+	zfree(&jd->unwinding_data);
 }
 
 static int
@@ -649,6 +651,7 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	memcpy(data, &jr->info.entries, sz);
 
+	zfree(&jd->debug_data);
 	jd->debug_data       = data;
 
 	/*
-- 
2.53.0



