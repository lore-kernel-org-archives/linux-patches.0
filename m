Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054633;
	b=1VETfTcTjCLN/lPOZLlmiWRB13G7WiDBNeeJ3vzSWnciCyL8LSsoY49Cs3MjJat36ruV
	 WBmvi2YixhAtrF7eXQRa6nZ5wm7MZ4PkpPXtWgXKd8QkA0qpFQhyd4Bq5uXQ1htA5HcOx
	 2ermyvBHNfgsh2BeTBA58IRjKfwpQxUQ01RV8De4t8NQ70ujwdV+iW574e6JjcZqUM8vI
	 ruPnmt55a8tlUYocJ2IVWNHdUkZmk0oqHzc1r40vAY9ypuVl5XJLs2P7xnoxJX541m0ri
	 ilLZU9swo1nlzrx0Sne3OOniSnvIchQ2oGsNBtJ4P8yTgcuGxj5RY63ER11UiOMvZMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJDWI4NzfrNd5+WGQ8n4eZRrGro6RrfG3Ra3ntXx1eg=;
	b=hKvUfLCkXU4iglyiZLXdltMBkowc1Bq82jdW6cxX8TcNHDHZm21UxIDx72WXotyDngpi
	 KMMBuZKtk/fy5K3tVkIt3gSgN+CTZDJj7pWduvQrl+0vJcUFw7stJ6u2YQm7B6vUkD/ph
	 Zmln5ssu+kxBGJrPHpWRHfOXRNsefxQmcoDB8SNxVTcBRoo8aw9Ah5VpyjP+NTRoUuqgT
	 boCFzgIHR/osWqnqS2pkbdIxv0V6wnGw7HH4xz/Z6o7X41wB9fLzPUnRyiuvCVCQs1maX
	 JGacxQlUqYvuuLCVfjSAtvZzIzsW2vo11tJ3/i9PcUEbLhDuQs3liqXqai70RcsGfQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpzxfQuF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F4C606A325;
	Thu, 19 Nov 2026 02:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpzxfQuF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B95A1F000C4;
	Thu, 19 Nov 2026 02:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054633;
	bh=TJDWI4NzfrNd5+WGQ8n4eZRrGro6RrfG3Ra3ntXx1eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpzxfQuF+NYzkLbOtr4ZljyYVKiCpIfsL9fsweN6piJx3Re6BRV53PgIlTMdOtfP/
	 ORoRKropfQ8D/shabuym3O6HSZ9uDcTaOprJPqPLjITdpsDN+Jspl/WHzgAqQ2/CK/
	 uFG79sYSJTHmQj7akQMtD6X2lcg+LJLFEo3gPa1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Stefano Sanfilippo <ssanfilippo@chromium.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1345/2214] perf jitdump: Prevent integer underflow in debug info size calculation
Date: Wed, 18 Nov 2026 15:50:21 +0100
Message-ID: <20261118150105.265506939@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit dfe8fe96efca3c32979dc0859f88e15b677d25f1 ]

jit_repipe_debug_info() and jit_repipe_unwinding_info() compute payload
sizes by subtracting the fixed header size from total_size:

  sz = jr->prefix.total_size - sizeof(jr->info);

When total_size is smaller than the header struct (from a truncated or
corrupted jitdump record), the subtraction underflows to a massive
value, causing an oversized allocation followed by an OOB memcpy.

Validate that total_size covers at least the fixed header before the
subtraction in both functions.

Fixes: 598b7c6919c7 ("perf jit: add source line info support")
Fixes: 0284fecd13b6 ("perf jit: Add unwinding support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stefano Sanfilippo <ssanfilippo@chromium.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 4ba0a87f5facd..e15cf845fa86d 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -655,6 +655,10 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->info))
+		return -1;
+
 	sz  = jr->prefix.total_size - sizeof(jr->info);
 	data = malloc(sz);
 	if (!data)
@@ -683,6 +687,10 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->unwinding))
+		return -1;
+
 	unwinding_data_size  = jr->prefix.total_size - sizeof(jr->unwinding);
 	unwinding_data = malloc(unwinding_data_size);
 	if (!unwinding_data)
-- 
2.53.0



