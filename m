Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2E12ECE95;
	Tue, 17 Jun 2025 15:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174927; cv=none; b=hQ1f3BgJxYv8nRe+LwKmNqTteyUCbcX3700gVEWrJmQ4/GjLqlfE8uvGjMms3OQY0jsuHRVQUqCSfyQzm1fHnu/GxNNx37ue6qpFvqrQW7qEU2Y0iEHqQoj2SMahtiom5rphZKZg2XPuzsE3+XrY5PYb7RzpZyM8ZmEw2jZ1PzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174927; c=relaxed/simple;
	bh=FEqDVQ8fCMjUf6KKBtHVX20W3U2birkZCCW4sRqb3x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bgh5iaFf3W5kquokocgOELBARGH5H0I8AFNcgGERbrdhCDM+sH9VKhf9n6PTfTabJ1e+Pa/k+XTRPbz/gjd4TZeR2I/Gnl/KAM+TkPnO1Z5u5ulkIyk09L7TQpHECdyHWrpgsiUTjR5bkYLbX2qCVsObHnvlrNwJ4tyQpbNpk6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejIA51ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejIA51ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74277C4CEF0;
	Tue, 17 Jun 2025 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174926;
	bh=FEqDVQ8fCMjUf6KKBtHVX20W3U2birkZCCW4sRqb3x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejIA51iapFSi6GPF3KbVaxDvucSqzD2bhncqAnLkHa8l46IwT0nc9KOLIt9g5AOVQ
	 tGwUDQ6VhsVWhr2B8C7GC7K5I2LLWrBNkDdPGhlmtDEp1gWT/bsyAjXmsvxYxZyT6Q
	 O4Eq9g4fAnN/AlS96PLoCJHxx+GZOaveIKTRaOhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/356] bpf: Fix uninitialized values in BPF_{CORE,PROBE}_READ
Date: Tue, 17 Jun 2025 17:23:44 +0200
Message-ID: <20250617152342.605506986@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 41d4ce6df3f4945341ec509a840cc002a413b6cc ]

With the latest LLVM bpf selftests build will fail with
the following error message:

    progs/profiler.inc.h:710:31: error: default initialization of an object of type 'typeof ((parent_task)->real_cred->uid.val)' (aka 'const unsigned int') leaves the object uninitialized and is incompatible with C++ [-Werror,-Wdefault-const-init-unsafe]
      710 |         proc_exec_data->parent_uid = BPF_CORE_READ(parent_task, real_cred, uid.val);
          |                                      ^
    tools/testing/selftests/bpf/tools/include/bpf/bpf_core_read.h:520:35: note: expanded from macro 'BPF_CORE_READ'
      520 |         ___type((src), a, ##__VA_ARGS__) __r;                               \
          |                                          ^

This happens because BPF_CORE_READ (and other macro) declare the
variable __r using the ___type macro which can inherit const modifier
from intermediate types.

Fix this by using __typeof_unqual__, when supported. (And when it
is not supported, the problem shouldn't appear, as older compilers
haven't complained.)

Fixes: 792001f4f7aa ("libbpf: Add user-space variants of BPF_CORE_READ() family of macros")
Fixes: a4b09a9ef945 ("libbpf: Add non-CO-RE variants of BPF_CORE_READ() macro family")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250502193031.3522715-1-a.s.protopopov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_core_read.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index e2b9e8415c044..b3fc384595a9f 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -312,7 +312,13 @@ enum bpf_enum_value_kind {
 #define ___arrow10(a, b, c, d, e, f, g, h, i, j) a->b->c->d->e->f->g->h->i->j
 #define ___arrow(...) ___apply(___arrow, ___narg(__VA_ARGS__))(__VA_ARGS__)
 
+#if defined(__clang__) && (__clang_major__ >= 19)
+#define ___type(...) __typeof_unqual__(___arrow(__VA_ARGS__))
+#elif defined(__GNUC__) && (__GNUC__ >= 14)
+#define ___type(...) __typeof_unqual__(___arrow(__VA_ARGS__))
+#else
 #define ___type(...) typeof(___arrow(__VA_ARGS__))
+#endif
 
 #define ___read(read_fn, dst, src_type, src, accessor)			    \
 	read_fn((void *)(dst), sizeof(*(dst)), &((src_type)(src))->accessor)
-- 
2.39.5



