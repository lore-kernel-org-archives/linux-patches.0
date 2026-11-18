Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039313;
	b=Gf8kq90llCZr1NpYhWrRS2IIP+KnAcYAq/KhJH7A6g15daUJ67rhSvpgDuzCV4fckYxV
	 hLhRgzJsItkUdLp4Uhz0T5WHQHZJ8NFiMHyWfavQaEArgyzLy45dAv3rKPNkSAyIzrU33
	 5KaRpzdIcZqPUIiNbL9IX3AHpkndW5TXDMb9VmpnDYh6HHz9SbaUgLpE1M7UCJZ8APYam
	 tIhAVVvZnLwlXM9rOwf1DOPhE+y97d1i0UXp/nSPD3xGFNFtomKQcqOETS5IqjXdrZ7if
	 +zWP09k6JcxyrQCYeoJ3PyqDnaao5cXV/yLh8UTRNxwlfihuzXrO5EH+uz7M6C6KZ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UCqLJkB7pB6DkXYEc1i0NTIym++V4ANXOY17ZbDf/SU=;
	b=QpUDX5CpSvaDsWzh0dWaPZEVWBSDaQswNg+dq2jvmmBq9WOt0nVhbyJNcoUX1pJoJsJR
	 MAwMiTYMldTYjRzI5zxZxymkZqtjT/53J5uz0nzb85TveMDe4OrHMwwA/4RY/vghSAatg
	 0h0uhOtoixI77cNpb/pGM7oPo1xnwC8uYIi6j0v4ShvnW3Y2yB2LWThGZjOQqCeFfLbBF
	 CaiKO7ly846rWeAVkq4OCMJRLqURnxwGh5LPEny759lo2r68I0SxPfmDOjXhR1guu3Zjl
	 Ear5e3jTnZJdmuay8LfsTFUTRDBI+ZPgU+AmBpqHbj2ICdgo+FaBvUL6t+e+KKJSXEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHEKYlLJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC8D606A31C;
	Wed, 18 Nov 2026 22:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHEKYlLJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9281F000C4;
	Wed, 18 Nov 2026 22:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039313;
	bh=UCqLJkB7pB6DkXYEc1i0NTIym++V4ANXOY17ZbDf/SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHEKYlLJyMjmG6DYnNtCsehNJ+WfWJz/bSVWLw0wjDwc4D3EqvCT02Rw32euAliR4
	 csWBwxunBdXh2y8IkESEBpB6CqjfM6kQn8ps+G5+sHjhR49z2dmM8goNNPwxyub6PW
	 mi55EFiEOLFtEv/BH23yOlzYPM+vtEGauOIuVcy0=
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
Subject: [PATCH 6.6 2005/3318] perf jitdump: Prevent integer underflow in debug info size calculation
Date: Wed, 18 Nov 2026 15:43:47 +0100
Message-ID: <20261118150422.201048472@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ed306582388fa..3fe38e754d3a2 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -652,6 +652,10 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->info))
+		return -1;
+
 	sz  = jr->prefix.total_size - sizeof(jr->info);
 	data = malloc(sz);
 	if (!data)
@@ -680,6 +684,10 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



