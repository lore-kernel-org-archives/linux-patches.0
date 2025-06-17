Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E502DFF1E;
	Tue, 17 Jun 2025 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176921; cv=none; b=B6MpZRqzNOUS8s3qwn1B+Z0URTe9qx7tynQamx/6AlVQGSIPOHS/3qAKx+7v/pBYK0FK7skLEU7iBX/vt/ZkcVOOvFKrX7QQZuE/YvfVlk6c7sFWIaRQfbsSFTSqUoWOuiFpCcAxsNO+aywhOLEzPvKdD4iLE4RXUKMdd1guYSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176921; c=relaxed/simple;
	bh=NaoTl38UPs6FM7lzuBtIK+UfXMvE6uMWEI0ct7lJ9r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHbBObK25SbtWJlZz95nPjHWEaybhxiKHo1d/nDbweVJSlnCcsVf2032DmLFvg75pPqyxRWitMNJICcOrKj+g0DUHBJx6hA0FF6S0py8c8qhj0pXVVHBMug9HcFCfjwHJyGp23meZkTXhcps54ogwjAbvm8UqH/KyjyUxfG1YIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQBXCKCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQBXCKCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246B3C4CEE3;
	Tue, 17 Jun 2025 16:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176921;
	bh=NaoTl38UPs6FM7lzuBtIK+UfXMvE6uMWEI0ct7lJ9r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQBXCKCJaiuxjj2a5G/04sI+Fg6FL8sZSxEp6kdGmW5QpYKP9E+cVLkdIX52k+shG
	 OBbCswNY6/XzKgxjaHI1emFhUtKToCw5Z5IUNw+3WHIiV71jirnP+n6UjriH0bWIbW
	 +vag/v9h7kPxYHhzZ5KfEGGlH3+tz5mXJCcdU2EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 240/780] bpf: Fix uninitialized values in BPF_{CORE,PROBE}_READ
Date: Tue, 17 Jun 2025 17:19:08 +0200
Message-ID: <20250617152501.229761930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c0e13cdf96607..b997c68bd9453 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -388,7 +388,13 @@ extern void *bpf_rdonly_cast(const void *obj, __u32 btf_id) __ksym __weak;
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



