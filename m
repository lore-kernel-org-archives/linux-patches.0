Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039172;
	b=PpvlSjolywgJaX3LlIcQ1RsPlkf1NPLRRfSspLBpxvVpsapEeplSB0LCe4Vy4h9gr+kO
	 o5wiFu9YkdrvijgV/jhNn+Dgp0DF1NyvOM6QdA5J33Ev8fGWNAFScHPokVN4mWTsGXzHT
	 VU0I9JO5CSSKZiJMgEwoO3ZyyuoJYICRsQ29XOrLYBsGW+yKEXjdMjPnttAQpQnzTjl3M
	 X4rx58CzU+GLnVUPgJLvPj73V3Ke2kxbzy7jXXCFTod5D2kB1FPDPPhMWbbly34qKBeSY
	 63mBmyiRW4QD2SjrKiZWSH5mIFSKD8wub2c3oyqiYGTHJEyF0REnggQgYZWknM3QkJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cF27tF+0/RpBE9qPGq2xMAuchneI/elK5bQZ8JgEN4g=;
	b=P+nak5F7gzX03f1eUtY0iDWQ1gaQqJjdYzUEQsIr94wjzkq6MkH1wOThiCi47L+HKYHP
	 sx+8usG+KmSo7bqdLzRLZAf1rxeruo8q7h9soLXcSYALXIG42XjhuDc1lrbuyadx+Mk9+
	 pI+0XTwQMgb3joyhgZHbxT280oYCEZmINFtow+otbQPFAs3nfhqpndoJq5bEesI8XdRGv
	 anKB5096TClcByksIlp0lUFQnbRBz8JnS5UahreeMBOOQHvB4wiu8yRgQ5xLxbHz4+Vah
	 NrU5eND0CcXe0nHG5mi6dCRirzz4CP8vmXCBy+7FFtfa5ZSM86dI2uDrmXONgV2HMyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fArv5EtK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CE860A260A;
	Wed, 18 Nov 2026 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fArv5EtK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EDF1F000C9;
	Wed, 18 Nov 2026 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039172;
	bh=cF27tF+0/RpBE9qPGq2xMAuchneI/elK5bQZ8JgEN4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fArv5EtKaUrJs+qEoLCaOmIBUnutyxtH1LUMKFDTzfOT5RVuL/nnOVrotUx7HcvzU
	 VA8bJw3w8GcxRRAwK2jZuCb2IVZ8w/GX05p4vkRgnMLSheY2Qfco4HSVDIjmzW2eXv
	 puflDKx5ydGIcb3vOxfkHXwJWDq65FD/0GEwC3yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2003/3318] perf jitdump: Fix debug_data and unwinding_data leaks
Date: Wed, 18 Nov 2026 15:43:45 +0100
Message-ID: <20261118150422.139056360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7be1501c8c918..a6bb6aa00c7bd 100644
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
@@ -646,6 +648,7 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	memcpy(data, &jr->info.entries, sz);
 
+	zfree(&jd->debug_data);
 	jd->debug_data       = data;
 
 	/*
-- 
2.53.0



