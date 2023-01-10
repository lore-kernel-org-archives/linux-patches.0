Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8477A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F4BC433EF;
	Tue, 10 Jan 2023 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374581;
	bh=+Lit4qXqjTU8SXzTxs+LdrnFmU+EcXSJrDMEiB6WfCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evNfgRYDsNPLiDxwSOwyyBN+PZsweDoUfGtCCa4+iRNeetT2GoEhMkyCzC8cX9BHu
	 4x273fXq8+7z05uSxn4WHQRhJhwWLDmN9ruRA6Tu/mXyB4JiSan/xnHWix3aDrdmNa
	 B8N3Fh26X+7CrJV1cJ7g7zVqxz1QMFA5rqN1mxRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	bpf@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/159] bpf: Always use maximal size for copy_array()
Date: Tue, 10 Jan 2023 19:03:31 +0100
Message-Id: <20230110180020.309474655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 45435d8da71f9f3e6860e6e6ea9667b6ec17ec64 ]

Instead of counting on prior allocations to have sized allocations to
the next kmalloc bucket size, always perform a krealloc that is at least
ksize(dst) in size (which is a no-op), so the size can be correctly
tracked by all the various allocation size trackers (KASAN,
__alloc_size, etc).

Reported-by: Hyunwoo Kim <v4bel@theori.io>
Link: https://lore.kernel.org/bpf/20221223094551.GA1439509@ubuntu
Fixes: ceb35b666d42 ("bpf/verifier: Use kmalloc_size_roundup() to match ksize() usage")
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: bpf@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221223182836.never.866-kees@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 242fe307032f..b4d5b343c191 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1000,6 +1000,8 @@ static void print_insn_state(struct bpf_verifier_env *env,
  */
 static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t flags)
 {
+	size_t alloc_bytes;
+	void *orig = dst;
 	size_t bytes;
 
 	if (ZERO_OR_NULL_PTR(src))
@@ -1008,11 +1010,11 @@ static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 
-	if (ksize(dst) < ksize(src)) {
-		kfree(dst);
-		dst = kmalloc_track_caller(kmalloc_size_roundup(bytes), flags);
-		if (!dst)
-			return NULL;
+	alloc_bytes = max(ksize(orig), kmalloc_size_roundup(bytes));
+	dst = krealloc(orig, alloc_bytes, flags);
+	if (!dst) {
+		kfree(orig);
+		return NULL;
 	}
 
 	memcpy(dst, src, bytes);
-- 
2.35.1



