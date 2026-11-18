Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047743;
	b=brxKhfaHeuBWLieans/GWg92lWskGqPy25dGM9Cow+ifpsxzVGuNCm7ACoNNaVLp5T2q
	 8sqyxgjoXn/JQFcZsY4xxu+5KrC0Ky1Gmo8vcUrPjXUx3t+yalrfJ779WN3tTAfLloB2n
	 IBIiqxRXTbS3po0AVx10suR+MjYsfLA/bFvUW5YCe/vM7sw+NkBBy1+jPkLmYCSkCm2CT
	 uVcp50QxorvyS9xD16VwcLlXBFnaJ6fluzDB7g6X06LMUQGzT1U+eZYlFeA3IMuvcmtwG
	 Kb47Z+6GFQqkEh/KVfHr4IZwjKFQXdARTOemvL/szQ1NiGKPB56xGrVA0v6iHy0xJyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=77EOq2qGHKyfGswFSedSvkiXmf+zZx+tDLz/G0tdsxw=;
	b=UnkpmUDObmHUPO7MR9qVvb0jn99yo76QYsD/9VN1gCOW2H78B0fC8++CJxn9EyEJNZZ3
	 5E02Ufv66ujpEAeB4Ryo4jlJA6H63ohLE+Dtal6qyGw8/cHTFsMAZAMpvFIQFXovbXYJR
	 F5WqzR1YOQNINkS66ExjroMxpN1+MUHf+bRwQqIkQzZCraHUTXWaYCIFoaoMNBpZ4QxD+
	 jw3NQFrvMyW1aa42M5PRZGh/KIEj8kSSJnCgxbBeISMVta7o3LfHwLwHXQ3qej71obT8s
	 Rc0dXxbDZCDP7OC67krWkJViGAPmBDYLiVm4RAQp13Atw5NLLi1ImTtk2KRoBtJkVWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaLGKUtc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6D0606A31C;
	Thu, 19 Nov 2026 00:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaLGKUtc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA3B1F000C4;
	Thu, 19 Nov 2026 00:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047743;
	bh=77EOq2qGHKyfGswFSedSvkiXmf+zZx+tDLz/G0tdsxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaLGKUtc9huZgJlulyKltTVePed0B7G6uZYuZjT539laACRWqKu8ovLvlrbtqvSSq
	 W1ZH8tXxk6CkEOeJr33I685J15WJBApuQ9OPvV6DiVY+EuQt+bco28pJITq3tRcvIm
	 nzaD1MZ8xeu1qzXs4/UxZnZSl4pe8keM74jE5n0c=
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
Subject: [PATCH 6.1 1748/2857] perf jitdump: Prevent integer underflow in debug info size calculation
Date: Wed, 18 Nov 2026 15:46:22 +0100
Message-ID: <20261118150304.234321485@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e10b16625a20e..9a7cc81f371af 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -648,6 +648,10 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->info))
+		return -1;
+
 	sz  = jr->prefix.total_size - sizeof(jr->info);
 	data = malloc(sz);
 	if (!data)
@@ -676,6 +680,10 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



